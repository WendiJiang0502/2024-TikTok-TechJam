import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';

class MusicSelectionScreen extends StatefulWidget {
  final String videoPath;

  MusicSelectionScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  _MusicSelectionScreenState createState() => _MusicSelectionScreenState();
}

class _MusicSelectionScreenState extends State<MusicSelectionScreen> {
  final VideoController _videoController = Get.find<VideoController>();
  AudioPlayer audioPlayer = AudioPlayer();
  int? selectedMusicIndex;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playMusic(String filePath) async {
    await audioPlayer.play(UrlSource(filePath));
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
        bgm_path: _videoController.bgmList[selectedMusicIndex!].song_path, // Selected BGM path
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
      body: ListView.builder(
        itemCount: _videoController.bgmList.length,
        itemBuilder: (context, index) {
          final bgm = _videoController.bgmList[index];
          return ListTile(
            leading: Icon(selectedMusicIndex == index ? Icons.music_note : Icons.music_video),
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
      floatingActionButton: FloatingActionButton(
        onPressed: uploadVideoWithMusic,
        child: Icon(Icons.upload),
        tooltip: 'Upload Video',
      ),
    );
  }
}
