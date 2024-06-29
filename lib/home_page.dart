import 'package:flutter/material.dart';
import 'package:temp_flutter/search_page.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:video_player/video_player.dart';
import 'package:temp_flutter/widgets/video_display.dart';

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
          )
        ),
      body: PageView.builder(
        itemCount: 1,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index){
          return Stack(
            children: [
              VideoDisplay(),
            ],
          );
      }),
    );
  }
}
