import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp_flutter/constants.dart';
import 'package:temp_flutter/music_select_page.dart';
import 'package:path/path.dart' as path;

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
            onPressed: () => showAssetOptions(context),
            child: const Row(
              children: [
                Icon(Icons.video_library),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Select from Assets',
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

  void showAssetOptions(BuildContext context) {
    final List<String> assetVideos = [
      'lib/assets/Magical_Night_Street.mp4',
      'lib/assets/food.mp4',
      'lib/assets/travel.mp4',
    ];

    showDialog(
      context: context,
      builder: (context) {
        String? selectedAsset;
        return AlertDialog(
          title: const Text('Select an Asset Video'),
          content: DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select a video'),
            value: selectedAsset,
            items: assetVideos.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(path.basename(value)),
              );
            }).toList(),
            onChanged: (value) {
              selectedAsset = value;
              Navigator.of(context).pop();
              final musicPath = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicSelectionScreen(videoPath: selectedAsset!),
                ),
              );
              if (musicPath != null) {
                print("Video path: $selectedAsset, Music path: $musicPath");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ShortVideoDisplay(
                //       videoPath: selectedAsset!,
                //       bgmPath: musicPath as String?,
                //     ),
                //   ),
                // );
              }
            },
          ),
        );
      },
    );
  }

  void pickVideo(BuildContext context, ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video != null) {
      Navigator.of(context).pop();  // Close the dialog after selection
      final musicPath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MusicSelectionScreen(videoPath: video.path),
        ),
      );
      if (musicPath != null) {
        // Now you have both the video path and the selected music path
        print("Video path: ${video.path}, Music path: $musicPath");
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
