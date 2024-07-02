import 'package:flutter/material.dart';

class GenreSongsPage extends StatelessWidget {
  final String genre;
  final List<Map<String, String>> songs;

  GenreSongsPage({required this.genre, required this.songs});

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
          genre,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songs[index]['title']!),
            subtitle: Text('by ${songs[index]['Creator']!}'),
            onTap: () {
              // Handle song item tap
            },
          );
        },
      ),
    );
  }
}
