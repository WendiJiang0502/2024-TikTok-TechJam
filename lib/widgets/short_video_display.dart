import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class ShortVideoDisplay extends StatefulWidget {
  // final String video_path = "assets/songs/Broken_Mirrors.mp3";
  final String video_path;
  final String? bgmPath;
  const ShortVideoDisplay({
    Key? key,
    required this.video_path,
    this.bgmPath,
  }) : super(key: key);

  // const VideoDisplay({super.key});

  @override
  State<ShortVideoDisplay> createState() => _ShortVideoDisplayState();
}

class _ShortVideoDisplayState extends State<ShortVideoDisplay> {
  late VideoPlayerController videoPlayerController;
  AudioPlayer? _audioPlayer;
  late AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    initializeVideo();
    // videoPlayerController = VideoPlayerController.asset("lib/assets/songs/Broken_Mirrors.mp3")
    // videoPlayerController = VideoPlayerController.asset(widget.video_path)
    //   // ..addListener(() => setState(() {}))
    //   ..setLooping(true)
    //   ..initialize().then((value){
    //   setState(() {});
    //   videoPlayerController.play();
    //   videoPlayerController.setVolume(1);
    //   });
  }

  void initializeVideo() {
    videoPlayerController = VideoPlayerController.asset(widget.video_path, videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ),)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          videoPlayerController.play();
          if (widget.bgmPath != null) {
            // Mute the video's original audio if BGM is provided
            videoPlayerController.setVolume(0.25);
            _audioPlayer = AudioPlayer();
            _audioCache = AudioCache(prefix: "");
            playBackgroundMusic(widget.bgmPath!);
          } else {
            // Play video with its original sound
            videoPlayerController.setVolume(1);
          }
        });
      });
  }

  void playBackgroundMusic(String bgmPath) async {
    // await _audioPlayer!.play(UrlSource(bgmPath), volume: 1.0);
    final filePath = await _audioCache.load(bgmPath);
    // await _audioPlayer!.play(AssetSource(filePath), volume: 1);
    await _audioPlayer!.play(UrlSource(filePath.path), volume: 1);
    // await _audioPlayer!.play(DeviceFileSource(bgmPath));

  }


  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _audioPlayer?.dispose();
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