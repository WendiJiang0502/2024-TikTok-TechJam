import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart'; // Assuming you are using GetX for state management
import 'package:temp_flutter/controllers/video_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Background Music'),
      ),
      body: ListView.builder(
        itemCount: _videoController.recommendationList.length,
        itemBuilder: (context, index) {
          final song = _videoController.recommendationList[index];
          return ListTile(
            leading: Icon(selectedMusicIndex == index ? Icons.music_note : Icons.music_video),
            title: Text(song.name),
            subtitle: Text(song.creator),
            onTap: () {
              setState(() {
                selectedMusicIndex = index;
                playMusic(song.song_path);
              });
            },
            selected: index == selectedMusicIndex,
            selectedTileColor: Colors.grey[200],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedMusicIndex != null) {
            // Proceed with your upload or next steps
            print('Uploading video with music: ${_videoController.recommendationList[selectedMusicIndex!].name}');
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('No Music Selected'),
                content: Text('Please select a music track first.'),
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
        },
        child: Icon(Icons.upload),
        tooltip: 'Upload Video',
      ),
    );
  }
}
