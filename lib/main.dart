import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(
    const PasswordManager(),
  );
}

class PasswordManager extends StatelessWidget {
  const PasswordManager({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Walter Turncoat',
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
