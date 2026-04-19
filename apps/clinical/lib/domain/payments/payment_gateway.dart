import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract payment gateway. Implementations: [MockGateway], [KhaltiGateway],
/// [EsewaGateway]. Concrete provider is [paymentGatewayProvider] below.
///
/// No real Khalti/eSewa SDKs are wired yet — the real implementations fail
/// fast if their public keys aren't configured via `--dart-define`. This
/// skeleton exists so billing UI can call `ref.read(paymentGatewayProvider)`
/// today and get correct behaviour across envs.
abstract class PaymentGateway {
  Future<PaymentResult> charge({
    required double amount,
    required String currency,
    required String description,
    required String patientRef,
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final String gateway;

  const PaymentResult({
    required this.success,
    required this.gateway,
    this.transactionId,
    this.errorMessage,
  });

  factory PaymentResult.ok(String gateway, String txId) =>
      PaymentResult(success: true, gateway: gateway, transactionId: txId);
  factory PaymentResult.fail(String gateway, String msg) =>
      PaymentResult(success: false, gateway: gateway, errorMessage: msg);
}

class MockGateway implements PaymentGateway {
  @override
  Future<PaymentResult> charge({
    required double amount,
    required String currency,
    required String description,
    required String patientRef,
  }) async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return PaymentResult.ok(
      'mock',
      'MOCK-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class KhaltiGateway implements PaymentGateway {
  final String publicKey;
  KhaltiGateway(this.publicKey);

  @override
  Future<PaymentResult> charge({
    required double amount,
    required String currency,
    required String description,
    required String patientRef,
  }) async {
    if (publicKey.isEmpty) {
      return PaymentResult.fail(
        'khalti',
        'Khalti public key missing. Set --dart-define=KHALTI_PUBLIC_KEY=<key>.',
      );
    }
    // TODO(payments): integrate khalti_flutter SDK. Skeleton only.
    return PaymentResult.fail('khalti', 'Khalti SDK not yet integrated.');
  }
}

class EsewaGateway implements PaymentGateway {
  final String publicKey;
  EsewaGateway(this.publicKey);

  @override
  Future<PaymentResult> charge({
    required double amount,
    required String currency,
    required String description,
    required String patientRef,
  }) async {
    if (publicKey.isEmpty) {
      return PaymentResult.fail(
        'esewa',
        'eSewa public key missing. Set --dart-define=ESEWA_PUBLIC_KEY=<key>.',
      );
    }
    // TODO(payments): integrate esewa_flutter_sdk. Skeleton only.
    return PaymentResult.fail('esewa', 'eSewa SDK not yet integrated.');
  }
}

/// Routed by ENV: mock/dev → [MockGateway]; staging/prod → Khalti primary,
/// eSewa fallback (first is currently returned — call-site can choose).
final paymentGatewayProvider = Provider<PaymentGateway>((ref) {
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  if (env == 'mock' || env == 'dev') return MockGateway();
  const khaltiKey = String.fromEnvironment('KHALTI_PUBLIC_KEY', defaultValue: '');
  return KhaltiGateway(khaltiKey);
});
