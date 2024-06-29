class Video{
  String name;
  String genre;
  String creator;
  String uid;
  bool by_Independent_Musicians;
  int views;
  int likes;
  int commentCount;
  String cover;
  String profilePhoto;
  String song_path;
  String cover_path;

  Video({
    required this.name,
    required this.genre,
    required this.creator,
    required this.uid,
    required this.by_Independent_Musicians,
    required this.views,
    required this.likes,
    required this.commentCount,
    required this.cover,
    required this.profilePhoto,
    required this.song_path,
    required this.cover_path,
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
      "album cover": cover_path
    }
  };


}