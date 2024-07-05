import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temp_flutter/objects/video.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map<String, dynamic> profileInfo = {};

  void getUserInfo() async {
    final String jsonString = await rootBundle.loadString("lib/me.json");
    final Map<String, dynamic> data = json.decode(jsonString);
    setState(() {
      profileInfo = data;
    });
    
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profileInfo["profile_picture"]),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '@'+profileInfo["username"],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                profileInfo["verified"]?Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 22,
                ):Container(),
              ],
            ),
            SizedBox(height: 4),
            Text(
              profileInfo["Independent Musicians"]? 'Individual artist':"",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      profileInfo["following"].toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Following',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 24),
                Column(
                  children: [
                    Text(
                      profileInfo["followers"].toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 24),
                Column(
                  children: [
                    Text(
                      profileInfo["likes"].toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Likes',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1,
              ),
              itemCount: 9, // Number of videos
              itemBuilder: (context, index) {
                return Container(
                  color:
                      Colors.grey[300], // Replace with actual video thumbnail
                  child: Center(
                    child:
                        Icon(Icons.play_arrow, color: Colors.white, size: 50),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
