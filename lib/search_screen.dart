import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search(this.accounts, {Key? key}) : super(key: key);
  final List<Map<String, String>> accounts;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  GlobalKey<FormState>? _formKey;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double acceptedWidth = screenWidth < 470 ? screenWidth : 500;
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
            onTap: () {},
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
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: List.generate(
                      widget.accounts.length,
                      (index) => AccountCard(widget.accounts[index]),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard(this.account, {Key? key}) : super(key: key);
  final Map<String, String> account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 12,
        shadowColor: Colors.lightBlueAccent,
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          onTap: () {},
          onLongPress: () {},
          horizontalTitleGap: 10,
          minVerticalPadding: 15,
          leading: CircleAvatar(
            radius: 34,
            child: Text(
              account['Name']!.substring(0, 1),
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            account['Name']!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(account['Email']!)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.favorite_border,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.edit,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
