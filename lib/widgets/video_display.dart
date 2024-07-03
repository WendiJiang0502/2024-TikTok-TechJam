import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  // final String video_path = "assets/songs/Broken_Mirrors.mp3";
  final String video_path;
  const VideoDisplay({
    Key? key,
    required this.video_path,
  }) : super(key: key);

  // const VideoDisplay({super.key});

  @override
  State<VideoDisplay> createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    // videoPlayerController = VideoPlayerController.asset("lib/assets/songs/Broken_Mirrors.mp3")
    videoPlayerController = VideoPlayerController.asset(widget.video_path)
      // ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value){
      setState(() {});
      videoPlayerController.play();
      videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
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
      child: VideoPlayer(videoPlayerController),
    );
  }
}