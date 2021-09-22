import 'add_screen.dart';
import 'search_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget> kScreens = {
  "Search": Search(tempAccounts),
  "Add":  AddScreen(tempAccounts),
  "Favorite": Search(tempFavs),
  "Settings": const Text(
    "TODO: Implement The Settings Screen",
  ),
};

const String kLogo = 'temp logo.png';
List<Map<String, dynamic>> tempAccounts = [
  {"Name": "alghaly1", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly2", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly3", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly4", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly5", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly6", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly7", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly8", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly9", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly10", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly11", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly12", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
];
List<Map<String, dynamic>> tempFavs = [
  {"Name": "fav 1 ", 'Email': "fa_m@yahoo.com", "Password": "123456"},
  {"Name": "fav 2", 'Email': "da_m@yahoo.com", "Password": "123456"},
];
