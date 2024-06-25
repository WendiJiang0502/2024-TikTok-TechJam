import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
              backgroundImage: NetworkImage('https://www.example.com/profile_image.jpg'), // Replace with actual image URL
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '@userhandle',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 22,
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Individual artist',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '100',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      '200',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      '300',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  color: Colors.grey[300], // Replace with actual video thumbnail
                  child: Center(
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 50),
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
