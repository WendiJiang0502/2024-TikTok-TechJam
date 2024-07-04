import 'package:flutter/material.dart';
import 'dart:convert'; // Import JSON handling
import 'package:flutter/services.dart' show rootBundle;
import 'genre_page.dart'; // Import the genre songs page
import 'package:temp_flutter/search_result.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<String> songNames = ["Song 1", "Song 2", "Song 3", "Song 4"];
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
  List<Map<String, String>> latestMusic = [];

  bool showGridView = true;
  bool isLoading = false;
  bool _isGenreTabSelected = true;

  @override
  void initState() {
    super.initState();
    loadSongs();
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

      allSongs.sort((a, b) => b["public_time"]!.compareTo(a["public_time"]!));
      setState(() {
        songs = allSongs;
        latestMusic = allSongs.take(10).toList();
        isLoading = false;
      });
      print(songs);
      // Debugging: Print loaded songs
      print("Loaded songs:");
      latestMusic.forEach((song) {
        print(song);
      });
    } catch (error) {
      print("Error loading songs: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToGenreSongs(String genre) {
    List<Map<String, String>> genreSongs =
        songs.where((song) => song['Genre'] == genre).toList();
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
            ...songNames.map((song) {
              return ListTile(
                title: Text(song),
                onTap: () {
                  // Handle song item tap
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
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(latestMusic[index]['title']!),
                    subtitle: Text('${latestMusic[index]['Creator']!}'),
                    onTap: () {
                      // Handle latest music item tap
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
