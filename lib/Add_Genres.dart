import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AddGenres {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _meJsonFile async {
    final path = await _localPath;
    return File('$path/me.json');
  }

  Future<Map<String, dynamic>> readUserData() async {
    try {
      final file = await _meJsonFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return json.decode(contents);
      } else {
        final contents = await rootBundle.loadString('lib/me.json');
        final newFile = await file.writeAsString(contents);
        return json.decode(newFile.readAsStringSync());
      }
    } catch (e) {
      print("Error reading me.json: $e");
      return {};
    }
  }

  Future<void> writeUserData(Map<String, dynamic> data) async {
    final file = await _meJsonFile;
    await file.writeAsString(json.encode(data));
  }

  Future<void> addGenreToPreferred(String genre) async {
    final userData = await readUserData();
    if (userData.containsKey('preferred_genres')) {
      List<String> preferredGenres = List<String>.from(userData['preferred_genres']);
      if (!preferredGenres.contains(genre)) {
        if (preferredGenres.length >= 2) {
          preferredGenres.removeAt(0);  // Remove the oldest genre
        }
        preferredGenres.add(genre);
        userData['preferred_genres'] = preferredGenres;
        await writeUserData(userData);
      }
    } else {
      userData['preferred_genres'] = [genre];
      await writeUserData(userData);
    }
  }
}
