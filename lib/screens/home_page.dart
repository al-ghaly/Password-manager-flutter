import 'dart:convert';
import 'package:backend/model/account.dart';
import 'package:backend/model/user.dart';
import 'package:backend/screens/authentication.dart';
import 'package:backend/services/database_helper.dart';
import 'package:backend/utilities/app_brain.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:backend/screens/search_screen.dart';
import 'package:backend/screens/add_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
 // The starter point for my app
  const MyApp(
      {required this.user,
      required this.helper,
      required this.prefs,
      required this.appBrain,
      Key? key})
      : super(key: key);
  final User user;
  final DbHelper helper;
  final SharedPreferences prefs;
  final Brain appBrain;

  @override
  Widget build(BuildContext context) {
    print("We are in the build method for the stateless starter point for The"
        "app");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: user.darkMode ? ThemeData.dark() : ThemeData.light(),
      title: "Launch Point for the app",
      home: MyHomePage(
          user: user, helper: helper, prefs: prefs, appBrain: appBrain),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {required this.user,
      required this.helper,
      required this.prefs,
      required this.appBrain,
      Key? key})
      : super(key: key);
  final User user;
  final DbHelper helper;
  final SharedPreferences prefs;
  final Brain appBrain;

  @override
  _MyHomePageState createState() {
    //TODO:Convert the curly brackets into =>
    print("We are in the create method for the home page");
    return _MyHomePageState();}
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late User user;
  late DbHelper helper;
  late SharedPreferences prefs;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _categoryController;
  late TextEditingController _homeSearch;
  late TextEditingController _favoriteSearch;
  late Brain appBrain;

  @override
  void initState() {
    print("We are inside the HOME PAGE INIT STATE");
    // First we initiate the values for the database helper and the user
    // then we initialize all the controllers over the home page widgets
    // to have all a non changing state(The state of the controller won't reset
    // when navigating between widgets)
    user = widget.user;
    helper = widget.helper;
    appBrain = widget.appBrain;
    print("we have initialized the database-user-and the brain");
    helper.getAllAccounts(widget.user.name).then((value) {
      print("We have fetched the user accounts from the database");
      for (Account account in value) {
        account.password = appBrain.decrypt(account.password);
      }
      print("We have decrypted all the passwords");
      setState(() {
        user.setAccounts(value);
      });
      print("We have updated the user accounts to the data fetched from"
          " the database");
    });
    prefs = widget.prefs;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _categoryController = TextEditingController();
    _homeSearch = TextEditingController();
    _favoriteSearch = TextEditingController();
    print("We have initialized the SP and the controllers");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("We are in the build for home page");
    return Scaffold(
      drawerEdgeDragWidth: 30,
      endDrawer: sideDrawer(),
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.grey,
        titleSpacing: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/images/temp logo.png",
            width: 30,
            height: 30,
          ),
          onPressed: () {
            print("Logo pressed");
            setState(() {
              _selectedIndex = 0;
            });
          },
        ),
        title: const Text("Password Manager"),
      ),
      body: SafeArea(
        child: navigatorScreens(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 22,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline_rounded,
              ),
              label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          print("The navigator index have changed");
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }

  Widget sideDrawer() {
    print("We are inside the build method for drawer");
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  child: Image.asset(
                    'assets/images/temp logo.png',
                    width: 120,
                    height: 120,
                  ),
                  radius: 60,
                  backgroundColor: Colors.lightBlueAccent,
                ),
                Center(child: Text(user.name))
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Edit Image'),
                    onTap: editImage,
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle_rounded),
                    title: const Text('Edit Username'),
                    onTap: editUsername,
                  ),
                  ListTile(
                    leading: const Icon(Icons.vpn_key_outlined),
                    title: const Text('Edit Password'),
                    onTap: editPassword,
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home Page'),
                    onTap: () => closeDrawer(0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline_rounded),
                    title: const Text('Add New Account'),
                    onTap: () => closeDrawer(1),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Favorite Accounts'),
                    onTap: () => closeDrawer(2),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Sittings'),
                    onTap: () => closeDrawer(3),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('LogOut'),
                    onTap: logOut,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                    subtitle: const Text(
                      "Warning",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    onTap: deleteAccount,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void closeDrawer(int index) {
    print("We are in the close drawer method in home page");
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  Widget navigatorScreens(
    int selectedIndex,
  ) {
    print("We are inside the navigator screens method to set the widget to"
        "navigate to");
    switch (selectedIndex) {
      case 0:
        {
          print("The selected index is 0 so  its search screen");
          print("User accounts inside the h=home page are ${user.accounts}");
          return Search(
            helper: helper,
            appBrain: appBrain,
            user: user,
            searchController: _homeSearch,
            favoritePage: false,
          );
        }
      case 1:
        {
          print("The selected index is 1 so  its add screen");
          return AddScreen(
            helper: helper,
            user: user,
            appBrain: appBrain,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            categoryController: _categoryController,
          );
        }
      case 2:
        {
          print("The selected index is 2 so  its search screen again");
          print("User accounts inside the homepage are ${user.accounts}");
          return Search(
            helper: helper,
            appBrain: appBrain,
            user:user,
            searchController: _favoriteSearch,
            favoritePage: true,
          );
        }
      case 3:
        {
          print("The selected index is 3 so  its settings screen");
          return const Text("Settings Screen");
        }
      default:
        {
          print("The selected index is not 0-3 so  its an error");
          return const Text("Error");
        }
    }
  }

  void logOut() {
    print('We are in the logout method in the home age');
    helper.closeDb().then((value) {
      print("We have closed the database");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Authentication(),
        ),
      );
    });
  }

  void deleteAccount() {
    print("We are inside the delete account method in the home page");
    TextEditingController controller = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: AlertDialog(
              elevation: 10,
              title: const Text("Are you sure you want to delete your account!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("These accounts will be deleted permanently."),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("We will need your password for that:"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "your password",
                    ),
                  )
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          print("The user has chosen to delete");
                          user.password == controller.text
                              ? helper.deleteUser(user.name).then((value) {
                                print("The user typed the right password");
                                  prefs.setString("username", "");
                                  print("we have deleted his name from SP");
                                  Navigator.pop(context);
                                  logOut();
                                }).catchError((error, stackTrace) {
                                  print("An error happened trying to delete the user");
                                  Fluttertoast.showToast(
                                    msg: "An error happened!!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor: Colors.red,
                                  );
                                })
                              : Fluttertoast.showToast(
                                  msg: "Wrong password!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.red,
                                );
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void editUsername() {
    print("We are in the edit username method in the home page");
    TextEditingController controller = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: AlertDialog(
              elevation: 10,
              title: const Text("Edit your username"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("type in the new username"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: "Username"),
                  )
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          helper
                              .editUser(
                            user,
                            username: controller.text,
                          )
                              .then((value) {
                                print("The username is edited in the database");
                            setState(() {
                              user.name = controller.text;
                            });
                            prefs.setString("username", controller.text);
                            print("The username is edited in SP");
                            Fluttertoast.showToast(
                              msg: "Done!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            Navigator.pop(context);
                          }).catchError((error, stackTrace) {
                            print("The username is invalid");
                            Fluttertoast.showToast(
                              msg: "used username!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                            );
                          });
                        },
                        child: const Text('Save',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void editPassword() {
    print("We are in the edit password method in the home page");
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: AlertDialog(
              elevation: 10,
              title: const Text("Edit your password"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    controller: oldPasswordController,
                    decoration: const InputDecoration(
                      hintText: "Old password",
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    controller: newPasswordController,
                    decoration: const InputDecoration(hintText: "new password"),
                  ),
                  TextField(
                    obscureText: true,
                    controller: confirmController,
                    decoration: const InputDecoration(hintText: "confirm password"),
                  )
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (oldPasswordController.text == user.password &&
                              newPasswordController.text ==
                                  confirmController.text) {
                            helper
                                .editUser(
                              user,
                              password: sha1
                                  .convert(utf8.encode(
                                      appBrain.encrypt(newPasswordController.text)))
                                  .toString(),
                            )
                                .then((value) {
                                  print("We have edited the password in the database");
                                user.password = newPasswordController.text;
                              Fluttertoast.showToast(
                                msg: "Done!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              Navigator.pop(context);
                            }).catchError((error, stackTrace) {
                              print("An error happened trying to update the database");
                              Fluttertoast.showToast(
                                msg: "An error happened!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.red,
                              );
                            });
                          } else if (oldPasswordController.text != user.password) {
                            print("Wrong password");
                            Fluttertoast.showToast(
                              msg: "Wrong password!!!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                            );
                          } else {
                            print("Passwords don't match");
                            Fluttertoast.showToast(
                              msg: "passwords don't match!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        child: const Text('Save',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void editImage() {
    print("We are in the edit image method in the home page");
  }
}


