import 'package:bcrypt/bcrypt.dart';
import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';
import '../utils/validators.dart';

class AuthEndpoint extends Endpoint {
  /// Login with email and password. Returns the UserAccount on success.
  Future<UserAccount?> login(
    Session session,
    String email,
    String password,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();
    final accounts = await UserAccount.db.find(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    if (accounts.isEmpty) return null;

    final account = accounts.first;

    // Support both bcrypt hashed and legacy plaintext passwords
    final storedHash = account.passwordHash;
    bool passwordValid;
    if (storedHash.startsWith('\$2')) {
      // bcrypt hash
      passwordValid = BCrypt.checkpw(password, storedHash);
    } else {
      // Legacy plaintext — validate and upgrade to bcrypt
      passwordValid = storedHash == password;
      if (passwordValid) {
        final hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        final updated = account.copyWith(
          passwordHash: hashed,
          updatedAt: DateTime.now(),
        );
        await UserAccount.db.updateRow(session, updated);
      }
    }

    if (!passwordValid) return null;

    return account;
  }

  /// Register a new patient account with bcrypt-hashed password.
  Future<UserAccount> signup(
    Session session,
    String email,
    String password,
    String displayName,
  ) async {
    Validators.validateEmail(email);
    Validators.validatePassword(password);
    Validators.validateStringLength(displayName, 'Display name');

    final normalizedEmail = email.trim().toLowerCase();

    // Check for existing account
    final existing = await UserAccount.db.find(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );
    if (existing.isNotEmpty) {
      throw ConflictException('An account with that email already exists.');
    }

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    final account = UserAccount(
      email: normalizedEmail,
      passwordHash: hashedPassword,
      displayName: displayName.trim(),
      isPractitioner: false,
      isVerified: false,
      accountType: 'patient',
      createdAt: DateTime.now(),
    );

    return await UserAccount.db.insertRow(session, account);
  }

  /// Register as a practitioner (doctor/nurse). Creates a pending verification.
  Future<UserAccount> registerPractitioner(
    Session session,
    int userAccountId,
    String practitionerType,
    String licenseNumber,
    String specialization,
  ) async {
    final account = await UserAccount.db.findById(session, userAccountId);
    if (account == null) throw NotFoundException('User not found.');

    final updated = account.copyWith(
      isPractitioner: true,
      isVerified: false,
      practitionerType: practitionerType,
      updatedAt: DateTime.now(),
    );

    return await UserAccount.db.updateRow(session, updated);
  }

  /// Get user account by email.
  Future<UserAccount?> getByEmail(Session session, String email) async {
    final accounts = await UserAccount.db.find(
      session,
      where: (t) => t.email.equals(email.trim().toLowerCase()),
    );
    return accounts.isEmpty ? null : accounts.first;
  }

  /// Get user account by ID.
  Future<UserAccount?> getById(Session session, int id) async {
    return await UserAccount.db.findById(session, id);
  }

  /// Update user profile fields.
  Future<UserAccount> updateProfile(
    Session session,
    UserAccount account,
  ) async {
    final updated = account.copyWith(updatedAt: DateTime.now());
    return await UserAccount.db.updateRow(session, updated);
  }

  /// Change password — hashes with bcrypt.
  Future<bool> changePassword(
    Session session,
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    Validators.validatePassword(newPassword);

    final account = await UserAccount.db.findById(session, userId);
    if (account == null) return false;

    // Verify current password
    final storedHash = account.passwordHash;
    bool currentValid;
    if (storedHash.startsWith('\$2')) {
      currentValid = BCrypt.checkpw(currentPassword, storedHash);
    } else {
      currentValid = storedHash == currentPassword;
    }

    if (!currentValid) return false;

    final newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    final updated = account.copyWith(
      passwordHash: newHash,
      updatedAt: DateTime.now(),
    );
    await UserAccount.db.updateRow(session, updated);
    return true;
  }
}
