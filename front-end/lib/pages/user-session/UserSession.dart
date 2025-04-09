// 1. First, let's modify UserSession.dart to include persistence functionality
// front-end/lib/pages/user-session/UserSession.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  static final UserSession _singleton = UserSession._internal();
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  String? userId;
  String? displayName;
  String? email;

  factory UserSession() {
    return _singleton;
  }

  UserSession._internal();

  // Save user data to secure storage
  Future<void> saveUserData() async {
    if (userId != null) await _storage.write(key: 'userId', value: userId);
    if (displayName != null) await _storage.write(key: 'displayName', value: displayName);
    if (email != null) await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'isLoggedIn', value: 'true');
  }

  // Load user data from secure storage
  Future<bool> loadUserData() async {
    final isLoggedIn = await _storage.read(key: 'isLoggedIn');

    if (isLoggedIn == 'true') {
      userId = await _storage.read(key: 'userId');
      displayName = await _storage.read(key: 'displayName');
      email = await _storage.read(key: 'email');
      return true;
    }
    return false;
  }

  // Clear user data from secure storage (logout)
  Future<void> clearUserData() async {
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'displayName');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'isLoggedIn');

    // Clear the in-memory data too
    userId = null;
    displayName = null;
    email = null;
  }
}