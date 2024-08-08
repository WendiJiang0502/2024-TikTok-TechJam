import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class MusicSelectionScreen extends StatefulWidget {
  final String videoPath;

  MusicSelectionScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  _MusicSelectionScreenState createState() => _MusicSelectionScreenState();
}

class _MusicSelectionScreenState extends State<MusicSelectionScreen> {
  final VideoController _videoController = Get.put(VideoController());
  static List<Video> bgmList = Get.put(VideoController()).bgmList;
  List<String> recommendedBgmNames = [];
  List<Video> matchedBgms = [];
  AudioPlayer audioPlayer = AudioPlayer();
  late AudioCache audioCache = AudioCache(prefix: "");
  int? selectedMusicIndex;

  List<String> keywords = [
  ];

  @override
  void initState() {
    getKeywords();


    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

void fetchRecommendedBgm() async {
  String uri = "http://127.0.0.1:5000/bgm_recommendations?video_path=assets/"+ path.basename(widget.videoPath);
  final response = await http.get(
        Uri.parse(uri)
        // Uri.parse('http://192.168.0.19:5000/recommendations')
        // Uri.parse('http://192.168.1.111:5000/recommendations')
        );

    if (response.statusCode == 200) {
      final List<String> recommendations =
          List<String>.from(json.decode(response.body));
      print('BGM Recommendations fetched: $recommendations');
      setState(() {
        recommendedBgmNames = recommendations;
      });
    } else {
      print('Failed to load recommendations');
      throw Exception('Failed to load recommendations');
    }

  matchedBgms = recommendedBgmNames.map((name) {
    return bgmList.firstWhere((bgm) => bgm.name.toLowerCase().contains(name.toLowerCase()));
  }).where((bgm) => bgm != null).toList();
    print("Matched bgm=====================");
    print(matchedBgms);
    // recommendedBgmNames.take(5).map((song) {Video re_result =bgmList.where((element) => (element.name.toLowerCase().contains(song.toLowerCase()))).toList()[0];
    //           }).toList();
}

  void playMusic(String bgmPath) async {
    final filePath = await audioCache.load(bgmPath);
    // await _audioPlayer!.play(AssetSource(filePath), volume: 1);
    await audioPlayer!.play(UrlSource(filePath.path), volume: 1);
  }

  Future<void> getKeywords() async {
    setState(() {
    });

    String uri = "http://127.0.0.1:5000/extract_keywords?video_path=assets/"+ path.basename(widget.videoPath);
    print(uri);

    final response = await http.get(
        Uri.parse(uri)
        // Uri.parse('http://192.168.0.19:5000/recommendations')
        // Uri.parse('http://192.168.1.111:5000/recommendations')
        );

    if (response.statusCode == 200) {
      keywords = List<String>.from(json.decode(response.body));
      print('keywords fetched: $keywords');
      setState(() {
      });
    } else {
      print('Failed to load keywords');
      throw Exception('Failed to load keywords');
    }
    fetchRecommendedBgm();
  }

  void uploadVideoWithMusic() {
    if (selectedMusicIndex != null) {
      Video newVideo = Video(
        name: "User Video",
        genre: "User Genre",
        creator: "You",
        by_Independent_Musicians: false,
        views: 0,
        likes: 0,
        commentCount: 0,
        song_path: widget.videoPath,  // Path to the user's video
        cover_path: "assets/images/default_cover.png",  // Default or selected cover image
        public_time: DateTime.now().toString(),
        bgm_path: matchedBgms[selectedMusicIndex!].song_path, // Selected BGM path
      );

      _videoController.addVideoToForYou(newVideo);
      Navigator.pop(context); // Optionally navigate back or to a success page
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Music Selected'),
          content: Text('Please select a background music track first.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Background Music'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: keywords.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 6,
                    children: keywords.map((keyword) {
                      return Row(
                        children: [
                          Icon(Icons.tag),
                          SizedBox(width: 5),
                          Expanded(child: Text(keyword, textAlign: TextAlign.left)),
                        ],
                      );
                    }).toList(),
                  ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matchedBgms.length,
              itemBuilder: (context, index) {
                final bgm = matchedBgms[index];
                return ListTile(
                  leading: Icon(
                      selectedMusicIndex == index ? Icons.music_note : Icons.music_video),
                  title: Text(bgm.name),
                  subtitle: Text(bgm.creator),
                  onTap: () {
                    setState(() {
                      selectedMusicIndex = index;

                      playMusic(bgm.song_path);
                    });
                  },
                  selected: index == selectedMusicIndex,
                  selectedTileColor: Colors.grey[200],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadVideoWithMusic,
        child: Icon(Icons.upload),
        tooltip: 'Upload Video',
      ),
    );
  }
}
