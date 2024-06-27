import 'package:flutter/material.dart';
// import 'package:temp_flutter/add_screen.dart';
// import 'package:temp_flutter/search_page.dart'; // Import the search page
// import 'package:temp_flutter/profile_page.dart'; // Import the profile page
import 'package:temp_flutter/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Search Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
