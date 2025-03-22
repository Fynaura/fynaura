class UserSession {
  static final UserSession _singleton = UserSession._internal();
  String? userId;
  String? displayName;
  String? email;

  factory UserSession() {
    return _singleton;
  }

  UserSession._internal();
}