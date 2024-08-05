import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';


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
  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();

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
      // Create a new video entry with the BGM path but don't merge files
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

      // Assuming addVideoToForYou method handles setting up the video for playback
      _videoController.addVideoToForYou(newVideo);
      Navigator.pop(context); // Optionally navigate back or to a success page
    } else {
      // Show alert that no music was selected
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


  Future<bool> mergeVideoAndAudio(String videoPath, String audioPath, String outputPath) async {
    String command = "-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental -shortest $outputPath";
    int rc = await _ffmpeg.execute(command);
    if (rc == 0) {
      print("Video merged successfully");
      return true;  // Return true if merging was successful
    } else {
      print("Failed to merge video");
      return false; // Return false if merging failed
    }
  }

  void handleUpload() async {
    if (selectedMusicIndex != null) {
      String bgmPath = _videoController.bgmList[selectedMusicIndex!].song_path;
      String outputPath = "/lib/assets"; // Define the output path

      await mergeVideoAndAudio(widget.videoPath, bgmPath, outputPath);

      // Assuming you have some mechanism to refresh or update your UI
      // Add the video to the 'For You' list or whatever is appropriate
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
