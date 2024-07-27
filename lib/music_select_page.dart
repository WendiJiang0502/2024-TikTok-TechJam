import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicSelectionScreen extends StatefulWidget {
  final String videoPath;

  MusicSelectionScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  _MusicSelectionScreenState createState() => _MusicSelectionScreenState();
}

class _MusicSelectionScreenState extends State<MusicSelectionScreen> {
  final VideoController videoController = Get.find<VideoController>();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Background Music"),
      ),
      body: Obx(() {
        final musicList = videoController.recommendationList;
        return ListView.builder(
          itemCount: musicList.length,
          itemBuilder: (context, index) {
            final music = musicList[index];
            return ListTile(
              title: Text(music.name),
              subtitle: Text(music.creator),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () => playMusic(music.song_path),
              ),
              onTap: () {
                Navigator.pop(context, music.song_path);  // Return the selected music path
              },
            );
          },
        );
      }),
    );
  }

  void playMusic(String url) async {
    await audioPlayer.play(url, isLocal: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();  // Correctly dispose the AudioPlayer
    super.dispose();
  }
}
