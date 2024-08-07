import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp_flutter/constants.dart';
import 'package:temp_flutter/music_select_page.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AddVideo extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  AddVideo({super.key});

  void showOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Video Source'),
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(context, ImageSource.gallery),
            child: const Row(
              children: [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(context, ImageSource.camera),
            child: const Row(
              children: [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Row(
              children: [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pickVideo(BuildContext context, ImageSource source) async {
    // final XFile? video = await _picker.pickVideo(source: source);
    // if (video != null) {
    //   Navigator.of(context).pop();  // Close the dialog after selection
    //   final musicPath = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => MusicSelectionScreen(videoPath: video.path),
    //     ),
    //   );
    //   if (musicPath != null) {
    //     // Now you have both the video path and the selected music path
    //     print("Video path: ${video.path}, Music path: $musicPath");
    //     // Proceed to overlay music on video here
    //   }
    // }
    final XFile? video = await _picker.pickVideo(source: source);
    if (video != null) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String newVideoPath = '$appDocPath/${video.name}';
      await File(video.path).copy(newVideoPath);

      Navigator.of(context).pop(); // Close the dialog after selection
      final musicPath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MusicSelectionScreen(videoPath: newVideoPath),
        ),
      );
      if (musicPath != null) {
        // Now you have both the video path and the selected music path
        print("Video path: $newVideoPath, Music path: $musicPath");
        // Proceed to overlay music on video here
      }
    }
  }


  void showMusicSelection(BuildContext context, String videoPath) {
    // Navigate to your music selection screen or handle it within a dialog
    // This function needs to be defined according to how you plan to implement the feature
    print("Video path: $videoPath");
    // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => MusicSelectionScreen(videoPath: videoPath)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showOptions(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: buttonColor),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
