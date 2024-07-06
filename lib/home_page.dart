import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/search_page.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:temp_flutter/widgets/circle_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:temp_flutter/widgets/video_display.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final VideoController _videoController = Get.put(VideoController());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMusicSelected = true;

  @override
  void initState() {
    super.initState();
    
  }

//lib/assets/covers/Broken_Mirrors.png
  buildMusicAlbum(String coverPath) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(45),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("lib/assets/cd2.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(180),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: Image(
                image: AssetImage(coverPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 2),
              Text(
                "Music",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: _isMusicSelected ? 19 : 18,
                      color: _isMusicSelected ? Colors.white : Colors.grey,
                      decoration: _isMusicSelected
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      // decorationStyle: 
                    ),
              ),
              SizedBox(width: 2),
              Text(
                "For you",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(width: 2),
              Text(
                "Following",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 18, color: Colors.grey),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
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
      body: Obx(() {
        return PageView.builder(
            itemCount: widget._videoController.recommendationList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final song = widget._videoController.recommendationList[index];
              return Stack(
                alignment: Alignment.center,
                children: [
                  VideoDisplay(
                    video_path: song.song_path,
                  ),
                  CircleAnimation(
                    child: buildMusicAlbum(song.cover_path),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          song.creator,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (song.by_Independent_Musicians)
                                          Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                            size: 20,
                                          )
                                      ],
                                    ),
                                    Text(
                                      song.genre,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.music_note,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          song.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 95,
                              margin: EdgeInsets.only(top: size.height / 2.5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.favorite,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        song.likes.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.comment,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        song.commentCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        song.views.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            });
      }),
    );
  }
}
