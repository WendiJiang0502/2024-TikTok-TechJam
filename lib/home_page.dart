import 'package:flutter/material.dart';
import 'package:temp_flutter/search_page.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:temp_flutter/widgets/circle_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:temp_flutter/widgets/video_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMusicSelected = true;

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
            padding: EdgeInsets.all(34),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.black,
                  ],
                ),
                borderRadius: BorderRadius.circular(180)),
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
              Text(
                "  Music  ",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: _isMusicSelected ? 20 : 18,
                    color: _isMusicSelected ? Colors.white : Colors.grey),
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
      body: PageView.builder(
          itemCount: 1,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                VideoDisplay(
                    // video_path: "",
                    ),
                CircleAnimation(
                  child:
                      buildMusicAlbum('lib/assets/covers/Broken_Mirrors.png'),
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
                                  Text(
                                    "Username",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "[Description]",
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
                                        "Song Name",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      "200",
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
                                      "200",
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
                                      "200",
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
          }),
    );
  }
}
