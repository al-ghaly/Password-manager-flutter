import 'package:backend/model/account.dart';
import 'package:backend/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // A single tone class to manage the database
  static DbHelper? _helper;
  late Database _database;

  Future openDB() async {
    print("We are inside the helper: open db method");
    // Open the database if existed otherwise configure the new database scheme
    String dbPath = await _getDbPath();
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) => _create(db),
    );
  }

  DbHelper._getInstance();

  factory DbHelper() {
    print("We are inside the helper: initializer method");
    _helper ??= DbHelper._getInstance();
    return _helper!;
  }

  Future<String> _getDbPath() async {
    print("We are inside the helper: get path method");
    // Returns the path for the database
    String path = await getDatabasesPath();
    String databasePath = join(path, "password_manager6.db");
    return databasePath;
  }

  _create(Database db) {
    print("We are inside the helper: crete  method");
    try {
      String sql =
          'create table users (name text primary key not null, password text not null, darkMode string not null, key text not null)';
      db.execute(sql);
      String sql1 =
          'create table accounts (account_id integer primary key autoincrement, account_name text not null,username text not null, email text not null, password text not null, type text not null, loved text not null)';
      db.execute(sql1);
    } catch (e) {
      print(e.toString());
    }
  }

  Future insertUser(User user) async {
    print("We are inside the helper: insert user method");
    await _database.insert("users", user.toMap());
  }

  Future<List<Account>> getAllAccounts(String username) async {
    print("We are inside the helper: get user accounts method");
    List<Map<String, dynamic>> mapList = await _database
        .rawQuery("SELECT * FROM accounts WHERE username = '$username'");
    return mapList.map((e) => Account.fromMap(e)).toList();
  }

  Future<User> getUser(String username) async {
    print("We are inside the helper: get user method");
    List<Map<String, dynamic>> mapList = await _database
        .rawQuery("SELECT * FROM users WHERE name = '$username'");
    assert(mapList.length == 1);
    return User.fromMap(mapList[0]);
  }

  Future closeDb() async {
    print("We are inside the helper: close db method");
    await _database.close();
  }

  Future deleteUser(String username) async {
    print("We are inside the helper: delete user method");
    await _database.delete('users', where: 'name = ?', whereArgs: [username]);
    await _database
        .delete('accounts', where: 'username = ?', whereArgs: [username]);
  }

  Future editUser(User user, {String? username, String? password}) async {
    print("We are inside the helper: edit user method");
    assert(username != "");
    if (username != null) {
      await _database.update('users', {'name': username},
          where: 'name = ?', whereArgs: [user.name]);
      await _database.update('accounts', {'username': username},
          where: 'username = ?', whereArgs: [user.name]);
    } else {
      await _database.update(
          'users',
          {
            "password": password,
          },
          where: 'name = ?',
          whereArgs: [user.name]);
    }
  }

  Future insertAccount(
    Account account,
  ) async {
    print("We are inside the helper: insert account method");
    List<Map<String, dynamic>> mapList = await _database.rawQuery(
        "SELECT * FROM accounts WHERE account_name = '${account.name}' and username = '${account.username}'");
    assert(mapList.isEmpty);
    await _database.insert("accounts", account.toMap());
  }

  Future editAccount(
      {required String username,
      required String accountName,
      required Map<String, dynamic> data}) async {
    await _database.update('accounts', data,
        where: 'account_name = ? and username = ?',
        whereArgs: [accountName, username]);
  }

  Future deleteAccount(
      {required String accountName, required String username}) async {
    await _database.delete('accounts',
        where: 'account_name = ? and username = ?',
        whereArgs: [accountName, username]);
  }

  Future clearAccounts(String username, List<String> accounts) async {
    String accountsNames = accounts.join(',');
    String sql =
        "delete from accounts where username = '$username' and account_name in ($accountsNames)";
    await _database.rawDelete(sql);
  }

  Future clearFavorites(String username, List<String> accounts) async {
    String accountsNames = accounts.join(',');
    String sql =
        "update accounts set loved='false' where username = '$username' and account_name in ($accountsNames)";
    await _database.rawUpdate(sql);
  }
}
