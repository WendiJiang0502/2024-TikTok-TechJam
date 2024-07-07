import 'package:flutter/material.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:temp_flutter/widgets/circle_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:temp_flutter/widgets/video_display.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/widgets/danmaku_icon.dart';

class PopPlayer extends StatelessWidget {
  PopPlayer({required this.song});

  Video song;

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

  void showDanmakuInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _danmakuController = TextEditingController();
        return AlertDialog(
          title: Text('Enter your comment'),
          content: TextField(
            controller: _danmakuController,
            decoration: InputDecoration(hintText: "Type your comment here"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Send'),
              onPressed: () {
                // Handle the comment submission
                String comment = _danmakuController.text;
                print('Danmaku comment: $comment');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            song.name,
            style: TextStyle(color: Colors.white, fontSize: 22),
          )),
      body: Stack(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      margin: EdgeInsets.only(top: size.height / 3),
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
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDanmakuInputDialog(context);
                                },
                                child: RollingCommentIcon(),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
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
      ),
    );
  }
}
