import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Minimal in-memory WebRTC signaling relay.
///
/// Three message types are relayed between peers sharing a `roomId`:
///   - 'offer'       : SDP offer
///   - 'answer'      : SDP answer
///   - 'ice'         : ICE candidate
///
/// Clients `subscribe(roomId)` to receive a stream of messages, and call
/// `send(roomId, type, payload)` to broadcast. Peer identity is the session
/// id — no authn wired here; secure via Serverpod's auth before prod use.
///
/// NOTE(webrtc): this is a skeleton — for production we'd persist messages
/// to Postgres with TTL, enforce peer allow-lists, and add TURN credentials.
class WebrtcSignalingEndpoint extends Endpoint {
  // roomId → list of active listener sinks.
  static final Map<String, List<_Listener>> _rooms = {};

  /// Stream of signaling messages for a room. Sends are broadcast to all
  /// other listeners in the same room (not back to the sender).
  Stream<Map<String, dynamic>> subscribe(Session session, String roomId) async* {
    final listener = _Listener('${session.sessionId}');
    _rooms.putIfAbsent(roomId, () => []).add(listener);
    try {
      await for (final msg in listener.controller.stream) {
        yield msg;
      }
    } finally {
      _rooms[roomId]?.remove(listener);
      if (_rooms[roomId]?.isEmpty ?? false) _rooms.remove(roomId);
      await listener.controller.close();
    }
  }

  /// Broadcast a signaling message to peers in [roomId] (excluding sender).
  Future<void> send(
    Session session,
    String roomId,
    String type,
    String payload,
  ) async {
    final msg = <String, dynamic>{
      'type': type,
      'payload': payload,
      'from': '${session.sessionId}',
      'ts': DateTime.now().toIso8601String(),
    };
    final listeners = _rooms[roomId] ?? const <_Listener>[];
    for (final l in listeners) {
      if (l.sessionId == '${session.sessionId}') continue;
      if (!l.controller.isClosed) l.controller.add(msg);
    }
  }
}

class _Listener {
  final String sessionId;
  final controller = StreamController<Map<String, dynamic>>.broadcast();
  _Listener(this.sessionId);
}
