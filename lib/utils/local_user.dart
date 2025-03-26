import 'package:auditoria/models/user_model.dart';

class LocalUser {
  static UserModel? user;

  static UserModel get getUser => user!;

  static void setUser(UserModel newUser) {
    user = newUser;
  }
}
