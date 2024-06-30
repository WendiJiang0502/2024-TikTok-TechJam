import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<String> songNames = ["Song 1", "Song 2", "Song 3", "Song 4"];
  List<String> musicGenres = ["Pop", "Rock", "Jazz", "Hip Hop", "Classical", "Country", "Electronic", "Reggae"];
  List<Map<String, String>> latestMusic = [];

  bool showGridView = true;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      final String response = await rootBundle.loadString('lib/assets/songs.json');
      final Map<String, dynamic> data = json.decode(response);
      List<Map<String, String>> songs = [];

      data.forEach((key, value) {
        Map<String, String> song = {
          "title": key,
          "public_time": value["public_time"],
          "Creator": value["Creator"],
          "Genre": value["Genre"],
          "path": value["path"],
          "album_cover": value["album cover"]
        };
        songs.add(song);
      });

      songs.sort((a, b) => b["public_time"]!.compareTo(a["public_time"]!));
      setState(() {
        latestMusic = songs.take(10).toList();
      });

      // Debugging: Print loaded songs
      print("Loaded songs:");
      latestMusic.forEach((song) {
        print(song);
      });
    } catch (error) {
      print("Error loading songs: $error");
    }
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
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
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
                      });
                    },
                    child: Text(
                      "Music by Genre",
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showGridView = false;
                      });
                    },
                    child: Text(
                      "Latest Music",
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
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
                      // Handle genre item tap
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
              latestMusic.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: latestMusic.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(latestMusic[index]['album_cover']!),
                    title: Text(latestMusic[index]['title']!),
                    subtitle: Text('Published on: ${latestMusic[index]['public_time']}'),
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
