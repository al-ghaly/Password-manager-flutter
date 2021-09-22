import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:untitled/constants.dart';
import 'package:flutter/services.dart';

class Search extends StatefulWidget {
  const Search(this.accounts, {Key? key}) : super(key: key);
  final List<Map<String, dynamic>> accounts;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  GlobalKey<FormState>? _formKey;
  final TextEditingController _searchController = TextEditingController();
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double acceptedWidth = screenWidth < 470 ? screenWidth : 470;
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: acceptedWidth / 10,
              child: Material(
                borderRadius: BorderRadius.circular(acceptedWidth / 20),
                elevation: 10,
                shadowColor: Colors.lightBlueAccent,
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Accounts',
                    filled: true,
                    contentPadding: const EdgeInsets.all(0),
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(acceptedWidth / 20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(acceptedWidth / 20),
                    ),
                    prefixIcon: IconButton(
                      padding: const EdgeInsets.all(5),
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
            onTap: clearAccounts,
            child: const Text(
              "Clear all",
              style: TextStyle(color: Colors.red),
            )),
        widget.accounts.isEmpty
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: Text("Your Vault is Empty My Friend!")),
                  ],
                ),
              )
            : Expanded(
                child: ListView(
                  children: List.generate(
                    widget.accounts.length,
                    (index) => card(widget.accounts[index]),
                  ),
                ),
              )
      ],
    );
  }

  Widget card(Map<String, dynamic> account) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 12,
        shadowColor: Colors.lightBlueAccent,
        child: Slidable(
          key: Key(account['Name']!),
          controller: slidableController,
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(5),
            onTap: () {
              Clipboard.setData(ClipboardData(text: account['Password']));
            },
            horizontalTitleGap: 10,
            minVerticalPadding: 15,
            leading: CircleAvatar(
              radius: 34,
              child: Text(
                account['Name']!.substring(0, 1),
                style:
                    const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              account['Name']!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: account['Email']));
              },
              child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(account['Email']!)),
            ),
            trailing: IconButton(
              icon: Icon(
                account['Favorite'] ?? false
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.lightBlueAccent,
              ),
              onPressed: () => love(account),
            ),
          ),
          actions: [
            IconSlideAction(
              closeOnTap: false,
              caption: 'Copy',
              color: Colors.blue,
              icon: Icons.vpn_key_outlined,
              onTap: () {
                Clipboard.setData(ClipboardData(text: account['Password']));
              },
            ),
            IconSlideAction(
              closeOnTap: false,
              caption: 'Copy',
              color: Colors.indigo,
              icon: Icons.email,
              onTap: () {
                Clipboard.setData(ClipboardData(text: account['Email']));
              },
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.black45,
              icon: Icons.edit,
              onTap: () => editAccount(account),
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => deleteAccount(account),
            ),
          ],
        ),
      ),
    );
  }

  deleteAccount(account) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                elevation: 10,
                title: Text(
                    "Are you sure you want to delete ${account['Name']} account! "),
                content:
                    const Text("This account will be deleted permanently."),
                // contentTextStyle: const TextStyle(),
                // titleTextStyle: const TextStyle(),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              widget.accounts.remove(account);
                              Navigator.pop(
                                context,
                              );
                            });
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
        barrierDismissible: false);
  }

  love(Map<String, dynamic> account) {
    setState(() {
      account['Favorite'] = !(account['Favorite'] ?? false);
    });
  }

  void clearAccounts() {
    String? password;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                elevation: 10,
                title: const Text(
                    "Are you sure you want to delete all your accounts!"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("These accounts will be deleted permanently."),
                    const Text("We will need your password for that:"),
                    TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      // controller: _textFieldController,
                      decoration:
                          const InputDecoration(hintText: "your password"),
                    )
                  ],
                ),
                // contentTextStyle: const TextStyle(),
                // titleTextStyle: const TextStyle(),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              print(password);
                              widget.accounts.clear();
                              Navigator.pop(
                                context,
                              );
                            });
                          },
                          child: const Text('Clear',
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
        barrierDismissible: false);
  }

  editAccount(Map<String, dynamic> account) {
    final GlobalKey<FormState>? _formKey = GlobalKey();
    final TextEditingController _nameController =
        TextEditingController(text: account["Name"]);
    final TextEditingController _emailController =
        TextEditingController(text: account["Email"]);
    final TextEditingController _passwordController =
        TextEditingController(text: account["Password"]);

    showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              controller: ScrollController(),
              child: AlertDialog(
                  elevation: 10,
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                      child: Text(
                        account['Name'],
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) =>
                              value!.isEmpty ? 'This field is required' : null,
                          decoration: const InputDecoration(hintText: "Name"),
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) =>
                              value!.isEmpty ? 'This field is required' : null,
                          decoration: const InputDecoration(hintText: "Email"),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) =>
                              value!.isEmpty ? 'This field is required' : null,
                          decoration:
                              const InputDecoration(hintText: "Password"),
                        ),
                      ],
                    ),
                  ),
                  // contentTextStyle: const TextStyle(),
                  // titleTextStyle: const TextStyle(),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              if (_formKey!.currentState!.validate()) {
                                var name = _nameController.value.text;
                                var email = _emailController.value.text;
                                var password = _passwordController.value.text;

                                setState(() {
                                  account['Name'] = name;
                                  account['Email'] = email;
                                  account['Password'] = password;
                                });
                                Navigator.pop(context);
                              }
                              ;
                            },
                            child: const Text('Save', style: TextStyle()),
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
        barrierDismissible: false);
  }
}
