import 'dart:convert';
import 'package:flutter/services.dart';
class Video{
  String name;
  String genre;
  String creator;
  bool by_Independent_Musicians;
  int views;
  int likes;
  int commentCount;
  String song_path;
  String cover_path;
  String public_time;
  String bgm_path;

  Video({
    required this.name,
    required this.genre,
    required this.creator,
    required this.by_Independent_Musicians,
    required this.views,
    required this.likes,
    required this.commentCount,
    required this.song_path,
    required this.cover_path,
    required this.public_time,
    this.bgm_path = '',
  });

  Map<String, dynamic> toJson() => {
    name: {
      "Genre": genre,
      "Creator": creator,
      "Independent Musicians": by_Independent_Musicians,
      "Views": views,
      "Likes": likes,
      "Comments": commentCount,
      "path": song_path,
      "album cover": cover_path,
      "public_time": public_time
    }
  };

  static Future<Video> fromJson(String path, String name) async {
    final String jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final data = jsonMap[name];
    return Video(
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
    );
  }


}