import 'package:flutter/material.dart';
import 'package:untitled/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<String> shows = const [
    "Search",
    "Add",
    "Favorite",
    "Settings",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: 50,
      endDrawer: sideDrawer(),
      appBar: AppBar(
        elevation: 12,
        shadowColor: Colors.lightBlueAccent,
        titleSpacing: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/images/$kLogo",
            width: 30,
            height: 30,
          ),
          onPressed: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        ),
        title: const Text("Password Manager"),
      ),
      body: SafeArea(
        child: kScreens[shows[_selectedIndex]]!,
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
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  child: Image.asset(
                    'assets/images/$kLogo',
                    width: 120,
                    height: 120,
                  ),
                  radius: 60,
                  backgroundColor: Colors.lightBlueAccent,
                ),
                const Center(child: Text('UserName'))
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
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle_rounded),
                    title: const Text('Edit Username'),
                    onTap: () {},
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
                    onTap: () => {},
                  ),
                  ListTile(
                    subtitle: const Text(
                      "Warning",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {},
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
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }
}
