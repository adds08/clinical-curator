import 'package:equatable/equatable.dart';

import 'user_role.dart';

class RoleState extends Equatable {
  final UserRole activeRole;
  final bool isToggling;

  const RoleState({
    this.activeRole = UserRole.patient,
    this.isToggling = false,
  });

  RoleState copyWith({
    UserRole? activeRole,
    bool? isToggling,
  }) {
    return RoleState(
      activeRole: activeRole ?? this.activeRole,
      isToggling: isToggling ?? this.isToggling,
    );
  }

  @override
  List<Object?> get props => [activeRole, isToggling];
}
