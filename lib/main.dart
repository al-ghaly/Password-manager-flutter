import 'package:backend/screens/authentication.dart';
import 'package:flutter/material.dart';

// The entry point for my application:
// where we first ask the user to login to access his account
// and to register a new account for the case of new users.
void main() {
  //TODO:Convert the curly brackets into =>
  print("We are inside the main function");
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Launch Point for authentication phase",
      home: Authentication(),
    ),
  );
}