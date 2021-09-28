import 'package:backend/model/account.dart';
import 'package:backend/model/user.dart';
import 'package:backend/services/database_helper.dart';
import 'package:backend/utilities/app_brain.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddScreen extends StatefulWidget {
  const AddScreen(
      {required this.helper,
      required this.appBrain,
      required this.user,
      required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.categoryController,
      required this.confirmPasswordController,
      Key? key})
      : super(key: key);
  final User user;
  final TextEditingController nameController,
      emailController,
      passwordController,
      confirmPasswordController,
      categoryController;
  final DbHelper helper;
  final Brain appBrain;

  @override
  _AddScreenState createState(){
    //TODO:Convert the curly brackets into =>
    print("We are inside the ADDSCREEN CREATE STATE");
    return _AddScreenState();}
}

class _AddScreenState extends State<AddScreen> {
  late DbHelper helper;
  final GlobalKey<FormState>? _formKey = GlobalKey();
  late TextEditingController nameController,
      emailController,
      passwordController,
      confirmPasswordController,
      categoryController;
  late Brain appBrain;

  @override
  void initState() {
    print("We are in the ADD SCREEN INIT STATE");
    helper = widget.helper;
    appBrain = widget.appBrain;
    nameController = widget.nameController;
    emailController = widget.emailController;
    passwordController = widget.passwordController;
    confirmPasswordController = widget.confirmPasswordController;
    categoryController = widget.categoryController;
    print("We have initialized the helper and the brain");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("We are inside the build method for add screen");
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                BeautifulField(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(gapPadding: 0),
                        hintText: "Account name",
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.grey),
                        errorStyle:
                            TextStyle(color: Colors.blueGrey, fontSize: 15),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: emailController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(gapPadding: 0),
                        hintText: "Email or Username(Optional)",
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.grey),
                        errorStyle:
                            TextStyle(color: Colors.blueGrey, fontSize: 15),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.grey),
                        errorStyle:
                            TextStyle(color: Colors.blueGrey, fontSize: 15),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      } else if (value != passwordController.text) {
                        return "Passwords don't match!";
                      }
                    },
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(gapPadding: 0),
                        hintText: "confirm Password",
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.grey),
                        errorStyle:
                            TextStyle(color: Colors.blueGrey, fontSize: 15),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: categoryController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(gapPadding: 0),
                        hintText: "Account category(Optional)",
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.grey),
                        errorStyle:
                            TextStyle(color: Colors.blueGrey, fontSize: 15),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xff6088BB),
                              ),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 18),
                              ),
                            ),
                            onPressed: generatePassword,
                            child: const Text('Generate Password',
                                style: TextStyle()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xff6088BB),
                              ),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 18),
                              ),
                            ),
                            onPressed: save,
                            child: const Text(
                              'Save',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xff6088BB),
                              ),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 18),
                              ),
                            ),
                            onPressed: reset,
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void reset() {
    print("We are inside the add screen reset method");
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    categoryController.clear();
  }

  void generatePassword() {
    print("We are inside the add screen generate password method");
    String password = appBrain.generatePassword();
    passwordController.text = password;
    confirmPasswordController.text = password;
  }

  void save() {
    print("We are inside the add screen save method");
    if (_formKey!.currentState!.validate()) {
      print("the form is valid");
      String type =
          categoryController.text == "" ? 'others' : categoryController.text;
      Account account = Account(
          name: nameController.text,
          password: passwordController.text,
          username: widget.user.name,
          email: emailController.text,
          type: type);
      print("we have initialized the account");
      account.password = appBrain.encrypt(account.password);
      helper.insertAccount(account).then((value) {
        print("We have inserted the account to the database with the password"
            "encrypted");
        account.password = passwordController.text;
        widget.user.accounts.add(account);
        print("We have added the account to the user's accounts");
        reset();
      }).catchError((error, stackTrace) {
        print("Duplicated name for the account");
        Fluttertoast.showToast(
          msg: "Invalid or used name!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
        );
      });
    }
  }
}

class BeautifulField extends StatelessWidget {
  const BeautifulField({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 22),
      child: child,
    );
  }
}
