import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class ShortVideoDisplay extends StatefulWidget {
  // final String video_path = "assets/songs/Broken_Mirrors.mp3";
  final String video_path;
  final String bgmPath;
  const ShortVideoDisplay({
    Key? key,
    required this.video_path,
    required this.bgmPath,
  }) : super(key: key);

  // const VideoDisplay({super.key});

  @override
  State<ShortVideoDisplay> createState() => _ShortVideoDisplayState();
}

class _ShortVideoDisplayState extends State<ShortVideoDisplay> {
  late VideoPlayerController videoPlayerController;
  late VideoPlayerController bgmPlayerController;
  // AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    // initializeVideo();
    // videoPlayerController = VideoPlayerController.asset("lib/assets/songs/Broken_Mirrors.mp3")
    videoPlayerController = VideoPlayerController.asset(widget.video_path, videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ),)
      // ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) {
        setState(() {});
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
    bgmPlayerController = VideoPlayerController.asset(widget.bgmPath, videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ),)
      ..setLooping(true)
      ..initialize().then((value) {
        setState(() {
          // if (widget.bgmPath != null) {
          //   // Mute the video's original audio if BGM is provided
          //   videoPlayerController.setVolume(0);
          //   // _audioPlayer = AudioPlayer();
          //   // playBackgroundMusic(widget.bgmPath);
          //   bgmPlayerController.setVolume(1);
          // }
        });
        bgmPlayerController.setVolume(1);
        bgmPlayerController.play();
      });
  }

  void initializeVideo() {
    print(
        "===================================print widget.bgmPath==================================");
    print(widget.bgmPath);
    videoPlayerController = VideoPlayerController.asset(widget.video_path)
      ..setLooping(true)
      ..initialize().then((value) {
        setState(() {
          if (widget.bgmPath != null) {
            // Mute the video's original audio if BGM is provided
            videoPlayerController.setVolume(0);
            bgmPlayerController = VideoPlayerController.asset(widget.bgmPath)
              ..setLooping(true)
              ..initialize().then((value) {
                setState(() {
                  if (widget.bgmPath != null) {
                    // Mute the video's original audio if BGM is provided
                    videoPlayerController.setVolume(0);
                    // _audioPlayer = AudioPlayer();
                    // playBackgroundMusic(widget.bgmPath);
                    bgmPlayerController.setVolume(1);
                  }
                });
                bgmPlayerController.play();
              });
            // _audioPlayer = AudioPlayer();
            // playBackgroundMusic(widget.bgmPath);
          } else {
            // Play video with its original sound
            videoPlayerController.setVolume(1);
          }
        });
        videoPlayerController.play();
      });
  }

  // void playBackgroundMusic(String bgmPath) async {
  //   print(
  //       "===================================print at play background music function==================================");
  //   print(bgmPath);
  //   await _audioPlayer!.play(UrlSource(bgmPath),
  //       volume: 1.0); // Ensure the volume is set to audible level
  // }

  @override
  void dispose() {
    videoPlayerController.dispose();
    bgmPlayerController.dispose();
    super.dispose();
    // _audioPlayer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          children: [
            VideoPlayer(bgmPlayerController),
            VideoPlayer(videoPlayerController),
          ],
        ));
  }
}
