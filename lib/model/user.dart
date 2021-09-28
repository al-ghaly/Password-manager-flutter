import 'package:backend/model/account.dart';

class User {
  User(
      {required this.name,
      required this.password,
      required this.darkMode,
      this.key});
  String name;
  String password;
  bool darkMode;
  String? key;
  List<Account> accounts = [];
  Map<String, dynamic> toMap() => {
        'name': name,
        "password": password,
        "darkMode": darkMode.toString(),
        'key': key
      };
  static fromMap(Map<String, dynamic> user) => User(
      name: user['name'],
      password: user['password'],
      darkMode: user['darkMode'] == 'true' ? true : false,
      key: user['key']);

  void setAccounts(List<Account> accounts) {
    print("We are in the user's set accounts method");
    this.accounts = accounts;
  }
}
