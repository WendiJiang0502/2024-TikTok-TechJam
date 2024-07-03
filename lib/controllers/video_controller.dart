import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:temp_flutter/objects/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    loadVideos();
  }

  void loadVideos() async {
    final String jsonString = await rootBundle.loadString('lib/assets/songs.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    List<Video> retVal = [];
    jsonMap.forEach((name, data) {
      retVal.add(Video(
        name: name,
        genre: data["Genre"],
        creator: data["Creator"],
        by_Independent_Musicians: data["Independent Musicians"],
        views: data["Views"],
        likes: data["Likes"],
        commentCount: data["Comments"],
        song_path: data["path"],
        cover_path: data["album cover"],
        public_time: data["public_time"]
      ));
    });
    _videoList.value = retVal;
  }

  // void likeVideo(String name) {
  //   Video? video = _videoList.value.firstWhere((video) => video.name == name);
  //   if (video != null) {
  //     // Simulate the process of liking/unliking a video
  //     // For simplicity, this implementation does not persist the like status
  //     if (video.likes > 0) {
  //       video.likes--;
  //     } else {
  //       video.likes++;
  //     }
  //     // Update the video list with the modified video
  //     _videoList.value = List<Video>.from(_videoList.value);
  //   }
  // }
}
