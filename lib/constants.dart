import 'package:flutter/material.dart';
// import 'package:temp_flutter/home.dart';
import 'package:temp_flutter/profile_page.dart';
import 'package:temp_flutter/add_screen.dart';
import 'package:temp_flutter/home_page.dart';

List pages = [
  HomePage(),
  const AddVideo(),
  ProfilePage(),
];

const backgroundColor = Colors.black;
var buttonColor = const Color.fromARGB(255, 225, 123, 243);
const borderColor = Colors.grey;