import 'package:flutter/material.dart';
import 'package:temp_flutter/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    bool _isMusicSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "  Music  ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                      fontSize: _isMusicSelected ? 20 : 18, 
                      color: _isMusicSelected ? Colors.white : Colors.grey
                    ),
              ),
              Text(
                "  For you  ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 18, color: Colors.grey),
              ),
              Text(
                "  Following  ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 18, color: Colors.grey),
              ),
              IconButton(
              icon: Icon(Icons.search, color: Colors.grey,),
              onPressed: () {
                // Navigate to the search page when the icon is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            ],
          )),
    );
  }
}
