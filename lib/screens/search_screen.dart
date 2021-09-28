import 'package:backend/model/account.dart';
import 'package:backend/model/user.dart';
import 'package:backend/services/database_helper.dart';
import 'package:backend/utilities/app_brain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  const Search(
      {required this.helper,
      required this.appBrain,
      required this.user,
      required this.searchController,
      required this.favoritePage,
      Key? key})
      : super(key: key);
  final DbHelper helper;
  final User user;
  final TextEditingController searchController;
  final Brain appBrain;
  final bool favoritePage;

  @override
  _SearchState createState() {
    print("We are in the SEARCH SCREEN CREATE STATE METHOD");
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  GlobalKey<FormState>? _formKey;
  late DbHelper helper;
  late Brain appBrain;
  late User user;
  late bool favoritePage = widget.favoritePage;
  late List<Account> accounts;
  @override
  void initState() {
    print("We are in the SEARCH SCREEN INIT STATE");
    helper = widget.helper;
    appBrain = widget.appBrain;
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favoritePage = widget.favoritePage;
    accounts = widget.favoritePage
        ? user.accounts
            .where((element) => element.loved)
            .where((element) =>
                element.name.contains(widget.searchController.text))
            .toList()
        : user.accounts
            .where((element) =>
                element.name.contains(widget.searchController.text))
            .toList();
    print("We are in the SEARCH SCREEN BUILD METHOD");
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
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Accounts',
                    labelStyle: const TextStyle(color: Colors.grey),
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
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.all(5),
                      onPressed: () {
                        widget.searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
            onTap: favoritePage
                ? () {
                    clearFavorites(accounts);
                  }
                : () {
                    clearAccounts(accounts);
                  },
            child: const Text(
              "Clear all",
              style: TextStyle(color: Colors.red),
            )),
        accounts.isEmpty
            ? Expanded(
                child: Center(
                  child: favoritePage
                      ? const Text("You have no favorite accounts")
                      : const Text("Your Vault is Empty My Friend!"),
                ),
              )
            : Expanded(
                child: accountsView(accounts),
              )
      ],
    );
  }

  Widget accountsView(List<Account> accounts) {
    return accounts.isEmpty
        ? const Center(
            child: Text("You have no accounts with this name"),
          )
        : ListView(
            children: List.generate(
              accounts.length,
              (index) => card(accounts[index]),
            ),
          );
  }

  Widget card(Account account) {
    print("We are in the search page building a card for an account");
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 8,
        shadowColor: Colors.white24,
        child: Slidable(
          key: Key(account.name),
          controller: SlidableController(),
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(5),
            onTap: () {
              Clipboard.setData(ClipboardData(text: account.password));
            },
            horizontalTitleGap: 10,
            minVerticalPadding: 15,
            leading: CircleAvatar(
              radius: 34,
              child: Text(
                account.name.substring(0, 1).toUpperCase(),
                style:
                    const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              account.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: account.email));
              },
              child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(account.email.isEmpty ? " " : account.email)),
            ),
            trailing: IconButton(
              icon: Icon(
                account.loved ? Icons.favorite : Icons.favorite_border,
                color: Colors.lightBlueAccent,
              ),
              onPressed: () {
                setState(() {
                  account.changeHeart();
                  favoritePage ? accounts.remove(account) : null;
                });
                helper.editAccount(
                    username: user.name,
                    accountName: account.name,
                    data: {"loved": account.loved.toString()});
              },
            ),
          ),
          actions: [
            IconSlideAction(
              closeOnTap: false,
              caption: 'Copy',
              color: Colors.blue,
              icon: Icons.vpn_key_outlined,
              onTap: () {
                Clipboard.setData(ClipboardData(text: account.password));
              },
            ),
            IconSlideAction(
              closeOnTap: false,
              caption: 'Copy',
              color: Colors.indigo,
              icon: Icons.email,
              onTap: () {
                Clipboard.setData(ClipboardData(text: account.email));
              },
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blueGrey,
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

  deleteAccount(Account account) {
    print("In the search screen delete account method");
    showDialog(
        context: context,
        builder: (context) => Center(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: AlertDialog(
                    elevation: 10,
                    title: Text(
                        "Are you sure you want to delete ${account.name} account! "),
                    content:
                        const Text("This account will be deleted permanently."),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  user.accounts.remove(account);
                                });
                                Navigator.pop(context);
                                helper
                                    .deleteAccount(
                                        accountName: account.name,
                                        username: user.name)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                    msg: "Account deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                  );
                                }).catchError((error, stackTrace) {
                                  Fluttertoast.showToast(
                                    msg: "An error happened!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor: Colors.red,
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
              ),
            ),
        barrierDismissible: false);
  }

  void clearAccounts(List<Account> accountsToClear) {
    print("We are in the search screen clear accounts method");
    TextEditingController controller = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: AlertDialog(
              elevation: 10,
              title: const Text(
                  "Are you sure you want to delete all this accounts!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("These accounts will be deleted permanently."),
                  const SizedBox(height: 20),
                  const Text("We will need your password for that:"),
                  const SizedBox(height: 30),
                  TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: "your password"),
                  )
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (controller.text == user.password) {
                            setState(() {
                              user.accounts.removeWhere((element) =>
                                  accountsToClear.contains(element));
                            });
                            Navigator.pop(
                              context,
                            );
                            helper
                                .clearAccounts(
                                    user.name,
                                    accountsToClear
                                        .map((e) => "'${e.name}'")
                                        .toList())
                                .then((value) {
                              Fluttertoast.showToast(
                                msg: "Done",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                              );
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: "Wrong password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                            );
                          }
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
        ),
      ),
    );
  }

  void clearFavorites(List<Account> accountsToClear) {
    print("We are in the search screen clear favorites method");
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: AlertDialog(
              elevation: 10,
              title: const Text(
                  "Are you sure you want to remove all this accounts from your favorite list!"),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            for (Account account in accountsToClear) {
                              account.changeHeart();
                            }
                          });
                          Navigator.pop(
                            context,
                          );
                          helper
                              .clearFavorites(
                                  user.name,
                                  accountsToClear
                                      .map((e) => "'${e.name}'")
                                      .toList())
                              .then((value) {
                            Fluttertoast.showToast(
                              msg: "Done",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
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
        ),
      ),
    );
  }

  editAccount(Account account) {
    print("we are in the search screen edit account method");
    final GlobalKey<FormState>? _formKey = GlobalKey();
    final TextEditingController _nameController =
        TextEditingController(text: account.name);
    final TextEditingController _emailController =
        TextEditingController(text: account.email);
    final TextEditingController _passwordController =
        TextEditingController(text: account.password);
    final TextEditingController _typeController =
        TextEditingController(text: account.type);

    showDialog(
        context: context,
        builder: (context) => Center(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: AlertDialog(
                    elevation: 10,
                    titlePadding: EdgeInsets.zero,
                    title: Container(
                      color: Colors.lightBlueAccent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                        child: Text(
                          account.name,
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
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
                            validator: (value) => value!.isEmpty
                                ? 'This field is required'
                                : null,
                            decoration: const InputDecoration(hintText: "Name"),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(hintText: "Email"),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) => value!.isEmpty
                                ? 'This field is required'
                                : null,
                            decoration:
                                const InputDecoration(hintText: "Password"),
                          ),
                          TextFormField(
                            controller: _typeController,
                            decoration:
                                const InputDecoration(hintText: "Category"),
                          ),
                        ],
                      ),
                    ),
                    // contentTextStyle: const TextStyle(),
                    // titleTextStyle: const TextStyle(),
                    actions: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OutlinedButton(
                            onPressed: () => _passwordController.text =
                                appBrain.generatePassword(),
                            child: const Text(
                              'generate password',
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (_formKey!.currentState!.validate()) {
                                      String oldName = account.name;
                                      setState(() {
                                        account.name = _nameController.text;
                                        account.email = _emailController.text;
                                        account.password =
                                            _passwordController.text;
                                        account.type = _typeController.text;
                                      });
                                      Navigator.pop(context);
                                      helper.editAccount(
                                          username: user.name,
                                          accountName: oldName,
                                          data: {
                                            'account_name': account.name,
                                            "password": appBrain
                                                .encrypt(account.password),
                                            "type": account.type,
                                            "email": account.email,
                                          });
                                    }
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
                          ),
                        ],
                      )
                    ]),
              ),
            ),
        barrierDismissible: false);
  }
}
