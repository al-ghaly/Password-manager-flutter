import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  AddScreen(this.accounts, {Key? key}) : super(key: key);
  List<Map<String, dynamic>> accounts;
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final GlobalKey<FormState>? _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BeautifulField(
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    decoration: const InputDecoration(hintText: "Account Name"),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    decoration:
                        const InputDecoration(hintText: "Email or Username"),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                ),
                BeautifulField(
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    decoration:
                        const InputDecoration(hintText: "confirm Password"),
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
                            onPressed: generatePassword,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child:
                                  Text('Generate Password', style: TextStyle()),
                            ),
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
                            onPressed: save,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Text(
                                'Save',
                              ),
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
                            onPressed: reset,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Text(
                                'Cancel',
                              ),
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
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void generatePassword() {
    _passwordController.text = "123";
    _confirmPasswordController.text = '123';
  }

  void save() {
    setState(() {
      widget.accounts.add({
        "Name": _nameController.text,
        "Email": _emailController.text,
        "Password": _passwordController.text
      });
    });
    reset();
  }
}

class BeautifulField extends StatelessWidget {
  const BeautifulField({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      child: Material(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffB8DFD8),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: child,
          )),
    );
  }
}
