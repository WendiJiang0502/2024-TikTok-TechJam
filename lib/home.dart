import 'package:flutter/material.dart';
import 'package:temp_flutter/widgets/customAddIcon.dart';
import 'package:temp_flutter/constants.dart';
import 'package:temp_flutter/profile_page.dart';
import 'package:temp_flutter/add_screen.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              pageIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: const Color.fromARGB(255, 225, 123, 243),
          unselectedItemColor: Colors.white,
          currentIndex: pageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size:30),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: CustomAddIcon(),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size:30),
              label: "Profile",
            ),
          ],
        ),
        body: pages[pageIndex],
      );
  }
}