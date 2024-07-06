import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:http/http.dart' as http;

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  final Rx<List<Video>> _recommendationList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  List<Video> get recommendationList => _recommendationList.value;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedVideos();
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

  void fetchRecommendedVideos() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.111:5000/recommendations')
      );

      if (response.statusCode == 200) {
        final List<String> recommendedTitles = List<String>.from(json.decode(response.body));

        final String jsonString = await rootBundle.loadString('lib/assets/songs.json');
        final Map<String, dynamic> songsData = json.decode(jsonString);

        List<Video> retVal = [];
        for (String title in recommendedTitles) {
          if (songsData.containsKey(title)) {
            final data = songsData[title];
            retVal.add(Video(
                name: title,
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
          }
        }
        _recommendationList.value = retVal;
      } else {
        print('Failed to load recommendations');
        throw Exception('Failed to load recommendations');
      }
    } catch (error) {
      print("Error fetching recommended videos: $error");
    }
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
