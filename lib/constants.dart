import 'search_screen.dart';
import 'package:flutter/material.dart';

const Map<String, Widget> kScreens = {
  "Search": Search(tempAccounts),
  "Add": Text(
    "TODO: Implement The Add Screen",
  ),
  "Favorite":Search(tempFavs),
  "Settings": Text(
    "TODO: Implement The Settings Screen",
  ),
};

const String kLogo = 'temp logo.png';
const tempAccounts = [
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
  {"Name": "alghaly", 'Email': "alghaly_m@yahoo.com", "Password": "123456"},
];
const tempFavs = [
  {"Name": "fav 1 ", 'Email': "fa_m@yahoo.com", "Password": "123456"},
  {"Name": "fav 2", 'Email': "da_m@yahoo.com", "Password": "123456"},
  
];
