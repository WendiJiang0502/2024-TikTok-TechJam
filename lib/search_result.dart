import 'package:flutter/material.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/pop_player.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  TextEditingController searchController = TextEditingController();
  static List<Video> songsInDB = Get.put(VideoController()).videoList;

  List<Video> results = List.from(songsInDB);
  List<Video> promotedsongs = [];
  //element.name.toLowerCase().contains(value.toLowerCase())

  void searchSongs(String value) {
    setState(() {
      results = songsInDB
          .where((element) =>
              (element.name.toLowerCase().contains(value.toLowerCase()) ||
                  element.creator.toLowerCase().contains(value.toLowerCase())))
          .toList();
      promotedSongs(results);

      // results.insert(0, promotedsongs[0]);
      // results.insert(1, promotedsongs[1]);
      for (var i = 0; i < promotedsongs.length; ++i) {
        results.insert(i, promotedsongs[i]);
      }
      // promotedsongs = [];
    });
  }

  void openPlayer(Video song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopPlayer(song: song),
      ),
    );
  }

  void promotedSongs(List<Video> results) {
    setState(() {
      promotedsongs = [];
      if (results.any((song) => song.by_Independent_Musicians)) {
        List<Video> independentSongs =
            songsInDB.where((song) => song.by_Independent_Musicians).toList();
        independentSongs.sort((a, b) {
          double scoreA = a.likes / a.views;
          double scoreB = b.likes / b.views;
          return scoreB.compareTo(scoreA);
        });
        if (independentSongs.length >= 2) {
          promotedsongs = independentSongs.take(2).toList();
        } else {
          promotedsongs = independentSongs.take(1).toList();
          results.removeWhere((song) => song.name == promotedsongs[0].name);
          results.sort((a, b) {
            double scoreA = a.likes / a.views;
            double scoreB = b.likes / b.views;
            return scoreB.compareTo(scoreA);
          });
          promotedsongs.add(results[0]);
          return;
        }
      } else {
        results.sort((a, b) {
          double scoreA = a.likes / a.views;
          double scoreB = b.likes / b.views;
          return scoreB.compareTo(scoreA);
        });
        promotedsongs = results.take(2).toList();
      }
      promotedsongs.forEach((promotedSong) {
        results.removeWhere((song) => song.name == promotedSong.name);
      });
    });
  }

  Map<String, dynamic> profileInfo = {};

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/me.json');
  }

  void getUserInfo() async {
    final String jsonString = await rootBundle.loadString("lib/me.json");
    final Map<String, dynamic> data = json.decode(jsonString);
    setState(() {
      profileInfo = data;
    });
  }


  Map<String, dynamic> me = {};

  void readJson() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    me = jsonDecode(contents);
    print(me);
  }

  Future<File> createUserJson() async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(json.encode(profileInfo));
  }

//   Future<void> writeJson(String filePath, Map<String, dynamic> jsonContent) async {
//   final file = File(filePath);
//   await file.writeAsString(json.encode(jsonContent), flush: true);
// }

  void writeMeJson(String keyword) async {
    List<String> searchHistory =
        List<String>.from(profileInfo['search_history'] ?? []);
    if (searchHistory.contains(keyword)){return;}
    if (searchHistory.length >= 2) {
      searchHistory.removeAt(0); // Remove the oldest search term
    }
    searchHistory.add(keyword);
    profileInfo['search_history'] = searchHistory;

    final file = await _localFile;
    file.writeAsString(json.encode(profileInfo), flush: true);
    readJson();
  }

  var keyword = "";
  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    // createUserJson();
    readJson();
    searchSongs("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.cancel, color: Colors.black),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  searchSongs(value);
                  promotedSongs(results);
                  keyword = value;
                },
                onSubmitted: (value) {
                  searchSongs(value);
                  promotedSongs(results);
                  keyword = value;
                  writeMeJson(keyword);
                },
              ),
            ),
            TextButton(
              onPressed: () {
                searchSongs(keyword);
                promotedSongs(results);
                writeMeJson(keyword);
              },
              child: Text(
                "Search",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: results.length == 0
          ? Center(
              child: Text(
                "Result Not Found",
                style: TextStyle(
                    color: Color.fromARGB(255, 79, 79, 79), fontSize: 25),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: ((context, index) => ListTile(
                          title: Text(
                            results[index].name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                results[index].creator,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 61, 61, 61),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                "•",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 61, 61, 61),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                results[index].genre,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 61, 61, 61),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          trailing: (index == 1 || index == 0)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ((results[index].likes /
                                                  results[index].views) *
                                              10)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 223, 183, 24),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      "Promoted",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 159, 71, 252),
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              : Column(),
                          leading: Image.asset(results[index].cover_path),
                          onTap: () {
                            openPlayer(results[index]);
                          },
                        )),
                  ),
                ),
              ],
            ),
    );
  }
}
