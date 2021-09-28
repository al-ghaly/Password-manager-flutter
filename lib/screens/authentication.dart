import 'package:backend/model/user.dart';
import 'package:backend/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_page.dart';
import 'package:backend/utilities/app_brain.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() {
    //TODO:Convert the curly brackets into =>
    print("We are inside AUTHENTICATION CREATE STATE PHASE");
    return  _AuthenticationState();}
}

class _AuthenticationState extends State<Authentication> {
  // First we will initialize the needed controllers in the screen
  late GlobalKey<FormState>? _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late ScrollController _scrollController;
  // This bool to keep track of the state of password fields even
  // to show or hide the password
  late bool showPassword;
  // Shared preferences object
  late SharedPreferences prefs;
  // This will help us keep track of if the user decided to go with the
  // dark mode in his last session
  bool darkMode = false;
  // The last logged in username
  String? username;
  // This bool tell us in which mode we are (login or signup)
  bool register = false;
  // Database object
  late DbHelper _helper;
  Brain? appBrain;

  @override
  void initState() {
    print("We are inside AUTHENTICATION INIT STATE");
    _helper = DbHelper();
    _helper.openDB();
    print("We have opened the database");
    _formKey = GlobalKey();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _scrollController = ScrollController();
    showPassword = false;
    // Set the mode to the user preference and the username to
    // last logged in user
    initializeSharedPreferences().then((value) {
      print("We have opened the shared preferences");
      prefs = value;
      username = prefs.getString('username');
      setState(() {
        darkMode = prefs.getBool('mode') ?? false;
        _emailController.text = username ?? "";
      });
      print("We have fetched and used the data from shared preferences");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("We are inside the authentication build");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      title: "Authentication Phase",
      home: Scaffold(
        backgroundColor: darkMode ? Colors.white24 : null,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dark Mode ',
                        style: TextStyle(
                            fontSize: 15,
                            color: darkMode ? Colors.white : Colors.black),
                      ),
                      Switch(
                          inactiveThumbColor: Colors.blue,
                          value: darkMode,
                          onChanged: (value) {
                            setState(() {
                              darkMode = value;
                            });
                            prefs.setBool("mode", value);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 30.0,
                        color: darkMode ? Colors.white70 : Colors.black,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Welcome to application name!',
                          ),
                          TypewriterAnimatedText(
                            'The only way to stay safe!!',
                          ),
                          TypewriterAnimatedText(
                            'Please have a seat',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your username",
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: !showPassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText: "Enter Your Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        register
                            ? TextFormField(
                                obscureText: !showPassword,
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Confirm the Username",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              )
                            : const Text(""),
                        const SizedBox(height: 40),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: darkMode
                                  ? MaterialStateProperty.all(
                                      const Color(0xff597FCA),
                                    )
                                  : null,
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 18),
                              ),
                            ),
                            onPressed: register ? signUp : logIn,
                            child: Text(
                              register ? "SignUp" : 'Login',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: darkMode
                                  ? MaterialStateProperty.all(
                                      const Color(0xff6088BB),
                                    )
                                  : null,
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 18),
                              ),
                            ),
                            onPressed: togglePages,
                            child: Text(
                              register ? 'Back to login' : "Register",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<SharedPreferences> initializeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void togglePages() {
    print("We are toggling screens in the authentication screen");
    // A function to toggle between signup and login pages
    // We will reset the state of the application then toggle the page
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      showPassword = false;
      register = !register;
    });
  }

  void logIn() {
    print("We are inside the login method from authentication");
    User user = User(
        name: _emailController.text,
        password: _passwordController.text,
        darkMode: darkMode);
    print("We have initialized the user ${user.toString()}");
    // We will try to get the username from the database if all is good we
    // will just check the password otherwise let the user know that he provided
    // an invalid username
    _helper.getUser(_emailController.text).then((value) {
      print("We have fetched the user from the database ${user.toString()}");
      appBrain = Brain(key: value.key!);
      print("We have initialized the app brain with the user key");
      String encryptedPassword = sha1
          .convert(utf8.encode(appBrain!.encrypt(_passwordController.text)))
          .toString();
      print("We have encrypted the user typed pass");
      if (value.password == encryptedPassword) {
        print("The user typed the right password");
        prefs.setString("username", _emailController.text);
        user.key = value.key;
        print("we have setted the last logged in user in SP and set the user key");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(
                user: user, helper: _helper, prefs: prefs, appBrain: appBrain!),
          ),
        );
      } else {
        print("The user typed a wrong password");
        Fluttertoast.showToast(
          msg: "Wrong Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
        );
      }
    }).catchError((error, stackTrace) {
      print("No user found with this username");
      Fluttertoast.showToast(
        msg: "Invalid username!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
      );
    });
  }

  void signUp() {
    print("We are in the signup method from authentication");
    // If the passwords don't match let the user know
    if (_emailController.text == "" || _passwordController.text == "") {
      print("The user didn't fill the required fields");
      Fluttertoast.showToast(
        msg: "You must provide username & password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
      );
    } else if (_passwordController.text != _confirmPasswordController.text) {
      print("passwords don't match");
      Fluttertoast.showToast(
        msg: "Passwords don't match!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
      );
    } else {
      print("This data is valid");
      // If the passwords match assert that the username doesn't exist
      // then add the user to the database
      //If the user existed insert will throw an exception
      User user = User(
        name: _emailController.text,
        password: _passwordController.text,
        darkMode: darkMode,
      );
      print("we have initialized the user: ${user.toString()}");
      String passHash = sha1
          .convert(utf8.encode(_passwordController.text))
          .toString();
      print("we have hashed the user first given password");
      String key = Brain.generateKey(
          user.name, passHash.substring(7, 22), user.darkMode);
      print('Using part of this hash and the username and dark mode for the '
          'user we have generated a unique key');
      user.key = key;
      appBrain = Brain(key: key);
      print("We have initialized an app brain with this key");
      String encryptedPassword = sha1
          .convert(utf8.encode(appBrain!.encrypt(_passwordController.text)))
          .toString();
      print("we have double encrypted the password");
      user.password = encryptedPassword;
      _helper.insertUser(user).then((value) {
        print("We have saved the data into the database");
        user.password = _passwordController.text;
        prefs.setString("username", _emailController.text);
        print("We have updated the last logged in field in SP");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(
                user: user, helper: _helper, prefs: prefs, appBrain: appBrain!),
          ),
        );
      }).catchError((error, stackTrace) {
        print("This user name is used");
        Fluttertoast.showToast(
          msg: "This username is used!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
        );
      });
    }
  }
}
