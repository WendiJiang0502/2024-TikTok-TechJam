import 'package:flutter/material.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:temp_flutter/pop_player.dart';

class GenreSongsPage extends StatefulWidget {
  final String genre;
  final List<Video> songs;

  GenreSongsPage({required this.genre, required this.songs});

  @override
  State<GenreSongsPage> createState() => _GenreSongsPageState();
}

class _GenreSongsPageState extends State<GenreSongsPage> {
  void openPlayer(Video song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopPlayer(song: song),
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
        title: Text(
          widget.genre,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.songs.length,
        itemBuilder:((context, index) => ListTile(
                title: Text(
                  widget.songs[index].name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      widget.songs[index].creator,
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
                      widget.songs[index].genre,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 61, 61, 61),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                
                leading: Image.asset(widget.songs[index].cover_path),
                onTap: () {
                  openPlayer(widget.songs[index]);
                },
              )),
      ),
    );
  }
}
