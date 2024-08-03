

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
import 'package:temp_flutter/widgets/danmaku_icon.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final VideoController _videoController = Get.put(VideoController());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMusicSelected = true;
  late PageController _pageController;

  // Add a state variable to track the current tab
  String _selectedTab = 'Music';

  @override
  void initState() {
    widget._videoController.fetchRecommendedVideos();
    // startPlay("Lullaby of Dreams");
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_onPageChanged);
    super.initState();
  }

  void _onPageChanged() {
    final int pageIndex = _pageController.page!.round();
    if (pageIndex != null && pageIndex < widget._videoController.recommendationList.length) {
      final song = widget._videoController.recommendationList[pageIndex];
      startPlay(song.name);
    }
  }

  late DanmakuController _controller;
  // var _key = new GlobalKey<ScaffoldState>();

  // final _danmuKey = GlobalKey();

  bool _running = true;
  bool _hideTop = false;
  bool _hideBottom = false;
  bool _hideScroll = false;
  bool _strokeText = true;
  double _opacity = 1.0;
  double _duration = 8;
  double _lineHeight = 1.2;
  double _fontSize = 16;
  FontWeight _fontWeight = FontWeight.normal;

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
                String comment = _danmakuController.text;
                print('Danmaku comment: $comment');
                _controller.addItems([
                  DanmakuItem(
                    comment,
                    type: DanmakuItemType.scroll,
                    color: Colors.white,
                  ),
                ]);
                Navigator.of(context).pop();
                //add rolling comment

              },
            ),
          ],
        );
      },
    );
  }

  Timer? timer;
  int sec = 0;
  Map<int, List<DanmakuItem>> _danmuItems = {};
  void startPlay(String songName) async {
    print("execue start play");
    String data = await rootBundle.loadString('lib/assets/songs.json');
    List<DanmakuItem> _items = [];
    var jsonMap = json.decode(data);
    var song_data = jsonMap[songName];
    print("song data: \n");
    print(song_data);
    for (var item in song_data["rolling_comments"]["comments"]) {
      var p = item["p"].toString().split(',');
      var mode = int.parse(p[1]);
      DanmakuItemType type = DanmakuItemType.scroll;
      if (mode == 5) {
        type = DanmakuItemType.top;
      } else if (mode == 4) {
        type = DanmakuItemType.bottom;
      }
      var color = int.parse(p[2]).toRadixString(16).padLeft(6, "0");
      var temp_time = double.parse(p[0])/2;

      _items.add(DanmakuItem(
        item['m'],
        time: temp_time.toInt(),
        color: Color(int.parse("FF" + color, radix: 16)),
        type: type,
      ));
    }
    print("danmaku Items: \n");
    print(_items);


    _danmuItems = groupBy(_items, (DanmakuItem obj) => obj.time);
    sec = 0;
    if (timer == null) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!_controller.running) return;
        if (_danmuItems.containsKey(sec))
          _controller.addItems(_danmuItems[sec]!);
        sec++;
      });
    }

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTab = 'Music';
                });
              },
              child: Text(
                "Music",
                style: TextStyle(
                  fontSize: _selectedTab == 'Music' ? 19 : 18,
                  color: _selectedTab == 'Music' ? Colors.white : Colors.grey,
                  decoration: _selectedTab == 'Music' ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTab = 'For you';
                });
              },
              child: Text(
                "For you",
                style: TextStyle(
                  fontSize: _selectedTab == 'For you' ? 19 : 18,
                  color: _selectedTab == 'For you' ? Colors.white : Colors.grey,
                  decoration: _selectedTab == 'For you' ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTab = 'Following';
                });
              },
              child: Text(
                "Following",
                style: TextStyle(
                  fontSize: _selectedTab == 'Following' ? 19 : 18,
                  color: _selectedTab == 'Following' ? Colors.white : Colors.grey,
                  decoration: _selectedTab == 'Following' ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        return PageView.builder(
          itemCount: _selectedTab == 'For you'? widget._videoController.shortVideoList.length : widget._videoController.recommendationList.length,
          // controller: PageController(initialPage: 0, viewportFraction: 1),
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final song = _selectedTab == 'For you'?widget._videoController.shortVideoList[index] :widget._videoController.recommendationList[index];
              return Stack(
                alignment: Alignment.center,
                children: [
                  VideoDisplay(
                    video_path: song.song_path,
                  ),
                   if (_selectedTab == 'Music') CircleAnimation(
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
                              margin: EdgeInsets.only(top: size.height / 3),
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
                  ),
                  DanmakuView(
                    key: GlobalKey(),
                    createdController: (DanmakuController e) {
                      _controller = e;
                    },
                    option: DanmakuOption(
                      opacity: _opacity,
                      fontSize: _fontSize,
                      duration: _duration,
                      strokeText: _strokeText,
                      fontWeight: _fontWeight,
                    ),
                    statusChanged: (e) {
                      setState(() {
                        _running = e;
                      });
                    },
                  ),
                ],
              );
            }
        );
      }),
      // endDrawer: Drawer(
      //   child: SafeArea(
      //     child: ListView(
      //       padding: EdgeInsets.all(8),
      //       children: [
      //         Text("Opacity : $_opacity"),
      //         Slider(
      //           value: _opacity,
      //           max: 1.0,
      //           min: 0.1,
      //           divisions: 9,
      //           onChanged: (e) {
      //             setState(() {
      //               _opacity = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(opacity: e));
      //           },
      //         ),
      //         Text("FontSize : $_fontSize"),
      //         Slider(
      //           value: _fontSize,
      //           min: 8,
      //           max: 36,
      //           divisions: 14,
      //           onChanged: (e) {
      //             setState(() {
      //               _fontSize = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(fontSize: e));
      //           },
      //         ),
      //         Text("FontWidght : $_fontWeight"),
      //         Slider(
      //           value: _fontWeight.index.toDouble(),
      //           min: 0,
      //           max: 8,
      //           divisions: 8,
      //           onChanged: (e) {
      //             setState(() {
      //               _fontWeight = FontWeight.values[e.toInt()];
      //             });
      //             _controller.updateOption(
      //                 _controller.option.copyWith(fontWeight: _fontWeight));
      //           },
      //         ),
      //         Text("Duration : $_duration"),
      //         Slider(
      //           value: _duration,
      //           min: 4,
      //           max: 20,
      //           divisions: 16,
      //           onChanged: (e) {
      //             setState(() {
      //               _duration = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(duration: e));
      //           },
      //         ),
      //         Text("LineHeight : $_lineHeight"),
      //         Slider(
      //           value: _lineHeight,
      //           min: 0.5,
      //           max: 2.0,
      //           divisions: 15,
      //           onChanged: (e) {
      //             setState(() {
      //               _lineHeight = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(lineHeight: e));
      //           },
      //         ),
      //         SwitchListTile(
      //           title: Text("Stroke Text"),
      //           value: _strokeText,
      //           onChanged: (e) {
      //             setState(() {
      //               _strokeText = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(strokeText: e));
      //           },
      //         ),
      //         SwitchListTile(
      //           title: Text("Hide Top"),
      //           value: _hideTop,
      //           onChanged: (e) {
      //             setState(() {
      //               _hideTop = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(hideTop: e));
      //           },
      //         ),
      //         SwitchListTile(
      //           title: Text("Hide Bottom"),
      //           value: _hideBottom,
      //           onChanged: (e) {
      //             setState(() {
      //               _hideBottom = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(hideBottom: e));
      //           },
      //         ),
      //         SwitchListTile(
      //           title: Text("Hide Scroll"),
      //           value: _hideScroll,
      //           onChanged: (e) {
      //             setState(() {
      //               _hideScroll = e;
      //             });
      //             _controller
      //                 .updateOption(_controller.option.copyWith(hideScroll: e));
      //           },
      //         ),
      //         ListTile(
      //           title: Text("Clear"),
      //           onTap: () {
      //             _controller.clear();
      //           },
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

