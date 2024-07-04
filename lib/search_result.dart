import 'package:flutter/material.dart';
import 'package:temp_flutter/controllers/video_controller.dart';
import 'package:temp_flutter/objects/video.dart';
import 'package:get/get.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  TextEditingController searchController = TextEditingController();
  static List<Video> songsInDB = Get.put(VideoController()).videoList;

  List<Video> results = List.from(songsInDB);
  //element.name.toLowerCase().contains(value.toLowerCase())

  void searchSongs(String value) {
    setState(() {
      results = songsInDB
          .where((element) =>
              (element.name.toLowerCase().contains(value.toLowerCase()) ||
                  element.creator.toLowerCase().contains(value.toLowerCase())))
          .toList();
    });
  }

  var keyword = "";

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
                  keyword = value;
                },
                // onSubmitted: (value) {
                //   searchSongs(value);
                //   keyword = value;
                // },
              ),
            ),
            TextButton(
              onPressed: () {
                // searchSongs(keyword);
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
                          leading: Image.asset(results[index].cover_path),
                        )),
                  ),
                ),
            ],
          ),
    );
  }
}
