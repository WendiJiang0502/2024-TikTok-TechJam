import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'genre_page.dart';
import 'package:temp_flutter/search_result.dart';
import 'package:http/http.dart' as http;
import 'package:temp_flutter/Add_Genres.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:get/get.dart';
import 'package:temp_flutter/pop_player.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  static List<Video> songsInDB = Get.put(VideoController()).videoList;
  List<String> songNames = [];
  List<String> musicGenres = [
    "Pop",
    "Rock",
    "Jazz",
    "Hip Hop",
    "Classical",
    "Country",
    "Electronic",
    "Reggae"
  ];
  List<Map<String, String>> songs = [];
  List<Video> displayedLatestMusic = [];
  List<Map<String, String>> latestMusic = [];

  bool showGridView = true;
  bool isLoading = false;
  bool _isGenreTabSelected = true;

  final AddGenres _AddGenres = AddGenres();

  @override
  void initState() {
    super.initState();
    loadSongs();
    fetchRecommendations();
  }
  void openPlayer(Video song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopPlayer(song: song),
      ),
    );
  }

  Future<void> loadSongs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String response =
          await rootBundle.loadString('lib/assets/songs.json');
      final Map<String, dynamic> data = json.decode(response);
      List<Map<String, String>> allSongs = [];

      data.forEach((key, value) {
        Map<String, String> song = {
          "title": key,
          "public_time": value["public_time"],
          "Creator": value["Creator"],
          "Genre": value["Genre"],
        };
        allSongs.add(song);
      });
      songsInDB.sort((a, b)=>b.public_time.compareTo(a.public_time));
      allSongs.sort((a, b) => b["public_time"]!.compareTo(a["public_time"]!));
      setState(() {
        songs = allSongs;
        latestMusic = allSongs.take(10).toList();
        displayedLatestMusic = songsInDB.take(10).toList();
        isLoading = false;
      });
    } catch (error) {
      print("Error loading songs: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchRecommendations() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/recommendations')
        // Uri.parse('http://10.0.2.2:5000/recommendations')
        // Uri.parse('http://192.168.1.111:5000/recommendations')
        );

    if (response.statusCode == 200) {
      final List<String> recommendations =
          List<String>.from(json.decode(response.body));
      print('Recommendations fetched: $recommendations');
      setState(() {
        songNames = recommendations;
        isLoading = false;
      });
    } else {
      print('Failed to load recommendations');
      throw Exception('Failed to load recommendations');
    }
  }

  List<Video> genreSongs = List.from(songsInDB);
  void navigateToGenreSongs(String genre) async {
    await _AddGenres.addGenreToPreferred(genre);
    List<Video> genreSongs = songsInDB
        .where((element) =>
            (element.genre.toLowerCase().contains(genre.toLowerCase())))
        .toList();
    // songs.where((song) => song['Genre'] == genre).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenreSongsPage(genre: genre, songs: genreSongs),
      ),
    );
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResultPage()),
                  );
                },
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      songNames.add(value);
                      searchController.clear();
                    });
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () {
                if (searchController.text.isNotEmpty) {
                  setState(() {
                    songNames.add(searchController.text);
                    searchController.clear();
                  });
                }
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "You May Like",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (songNames.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No recommendations available",
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              ...songNames.take(5).map((song) {
                Video re_result =songsInDB.where((element) => (element.name.toLowerCase().contains(song.toLowerCase()))).toList()[0];

                return ListTile(
                  title: Text(song),
                  onTap: () {
                    openPlayer(re_result);
                  },
                );
              }).toList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showGridView = true;
                        _isGenreTabSelected = true;
                      });
                    },
                    child: Text(
                      "Music by Genre",
                      style: TextStyle(
                        color: _isGenreTabSelected
                            ? Colors.red
                            : Color.fromARGB(158, 244, 67, 54),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: _isGenreTabSelected
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: _isGenreTabSelected
                            ? Colors.red
                            : Color.fromARGB(158, 244, 67, 54),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showGridView = false;
                        _isGenreTabSelected = false;
                      });
                    },
                    child: Text(
                      "Latest Music",
                      style: TextStyle(
                        color: !_isGenreTabSelected
                            ? Colors.red
                            : Color.fromARGB(158, 244, 67, 54),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: !_isGenreTabSelected
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: !_isGenreTabSelected
                            ? Colors.red
                            : Color.fromARGB(158, 244, 67, 54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showGridView)
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3,
                ),
                itemCount: musicGenres.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      navigateToGenreSongs(musicGenres[index]);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(musicGenres[index]),
                    ),
                  );
                },
              )
            else
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: latestMusic.length,
                itemBuilder: ((context, index) => ListTile(
                title: Text(
                  // latestMusic[index]['Creator']!,
                  displayedLatestMusic[index].name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      displayedLatestMusic[index].creator,
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
                      displayedLatestMusic[index].genre,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 61, 61, 61),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                
                leading: Image.asset(displayedLatestMusic[index].cover_path),
                onTap: () {
                  openPlayer(displayedLatestMusic[index]);
                },
              )),
              ),
          ],
        ),
      ),
    );
  }
}
