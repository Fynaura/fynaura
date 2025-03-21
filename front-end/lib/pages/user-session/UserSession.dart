class UserSession {
  static final UserSession _singleton = UserSession._internal();

  String? userId;

  factory UserSession() {
    return _singleton;
  }

  UserSession._internal();
}
