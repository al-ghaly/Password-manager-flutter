class Account {
  Account(
      {required this.name,
      required this.password,
      required this.username,
      required this.email,
      required this.type,
      this.loved = false});
  String name;
  String username;
  String password;
  String type;
  String email;
  bool loved;

  void changeHeart() {
    print("We are in the account's change heart method");
    loved = !loved;
  }

  Map<String, dynamic> toMap() => {
        'account_name': name,
        'username': username,
        "password": password,
        "type": type,
        "email": email,
        'loved': loved.toString()
      };
  static Account fromMap(Map<String, dynamic> user) => Account(
      name: user['account_name'],
      password: user['password'],
      username: user['username'],
      email: user['email'],
      type: user['type'],
      loved: user['loved'] == 'true' ? true : false);
}
