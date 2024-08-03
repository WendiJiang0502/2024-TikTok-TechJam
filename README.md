# TikTune - 2024 TikTok TechJam
## ✍️ Team Biography
👩🏻‍💻 Jingwen Huang: Year 1 Master's student in CS at USC. Women in STEM. In charge of the backend, ML, frontend, UI, design.

🙋🏻‍♀️ Wendi Jiang: Year 1 Master's student in CS at USC. Women in STEM. In charge of backend, ML, frontend, UI, design, and video editing.

## 💛 Introducing TikTune 💛
😵‍💫 🎸 As an independent musician, do you struggle to break through the noise and gain more exposure to your original music on TikTok?

💭 As a fan, do you wonder if your favorite musician can actually see your comments? Do you wish for more engaging ways to interact with other fans and the musician? Would you like to share your thoughts on specific parts of their music directly?

📱 As a user, do you find yourself frustrated with only seeing the same type of music on TikTok, unable to discover a wider variety of genres, or exploring new types of music due to lack of information? Do you want timely updates on the latest music releases and access to newly published tracks?

🌟 **Introducing to you TikTune, where musicians gain more exposure, users discover diverse content, and fans and artists connect and engage like never before!**
## 👍What it does
### App Summary 💡

The app is a TikTok-based music discovery platform designed to enhance the experience for both artists and users. It features a recommendation system that prioritizes music created by independent musicians and highly-rated songs. The app also offers a genre grid, the latest music list, and a personalized "You May Like" section. Additionally, the app includes a rolling comments feature (Danmaku, Japanese: 弾幕だんまく, a subtitle system in online video platforms that originates from Japan) that allows users to leave and view comments tied to specific timestamps in songs, adding an interactive element to the media player and contributing to the artist/fan community.

### Problem Statement
Many talented music artists struggle to gain visibility and exposure for their music on TikTok due to various limitations in the platform's current features and functionalities. Despite the platform's immense user base, the challenge persists for both emerging and independent musicians to break through the noise and reach a wider audience. This lack of visibility not only inhibits the discovery of new music but also hampers the platform’s ability to diversify its content offerings and cater to the varied tastes of its audience. There is a pressing need to explore innovative strategies and tools to enhance music discoverability on TikTok, empowering both emerging and established artists to reach wider audiences and fostering a more vibrant and inclusive musical ecosystem on the platform.

### How the App Satisfies the Desired Outcomes / Fills Existing Gaps

#### 1. Enhanced Exposure:

- **Recommendation System:** The app's recommendation script prioritizes music created by independent musicians and highly-rated songs, which increases the visibility of emerging and independent artists on the platform. This leads to greater recognition and potential career opportunities for these musicians.

#### 2. Diverse Content Discovery:

- **Genre Grid:** The app features a genre grid that allows users to explore a wide range of music genres. This ensures that users have access to various styles and artists, promoting diverse content consumption.
- **Latest Music List:** The latest music list helps users discover new releases across different genres, keeping the content fresh and diverse.
- **You May Like Section:** This personalized section suggests songs based on the user's recently clicked genre and search history, providing personalized content and further enhancing the diversity of content available to users.

#### 3. Engagement and Interaction:

- **Rolling Comments:** The rolling comments feature allows users to leave and view comments tied to specific parts or timestamps in songs. This encourages active engagement and interaction between artists and their audiences, fostering a sense of community and connection within the platform.

### Supporting the Artist/Fan Community

The app's music discovery feature supports increased exposure and content diversity. The enhanced recommendation system and interactive rolling comments contribute to building a strong artist/fan community, promoting greater engagement and interaction within the platform.


## 🔨 How We Built It
### Technologies & Tools Used
- Python
- Dart
- Flutter
- VS Code
- Android Studio
- Suno AI
- Pixlr-X (Photo Editing)

### 👀 Database Assets
- Suno AI
    - Generate music database, including AI-generated music and cover pictures.

## 🪐Libraries and Frameworks

### Front end - Flutter
- Flutter related packages
    - flutter/material
    - flutter/services
    - path_provider
    - ns_danmaku [pub dev link](https://pub.dev/packages/ns_danmaku)
        - Flutter package for creating rolling comments (Danmark).
    - video_player

### 💻Backend- Python Flask App
- nltk
- sklearn
- TfidfVectorizer
    - Python package used to convert text data into numerical feature vectors to calculate TF-IDF scores for words in preparation for recommendation algorithm.
- cosine_similarity
    - Python package to find similarities in high-dimensional spaces in the database to generate the base of the recommendation algorithm.

## Backend Architecture

Our backend-to-frontend architecture is in the form of RESTful API calls. The backend framework is a deployable microservice, interacting with the frontend using the app's user information (me.json) saved in the mobile storage.

### Backend Routes
| Route                               | Method  | Parameters                                                | Expected Data Format |
|-------------------------------------|---------|-----------------------------------------------------------|----------------------|
| /recommendations          | GET    |                                        | List                 |

## 📲Installation and How To Run It
To use this TikTok: TikTune, follow these steps:

1. Clone the repository or download the source code.
2. Open the project in your preferred code editor (Android Studio is highly recommended).
3. Install the necessary packages:
    - From the terminal: Run `flutter pub get`.
    - From VS Code: Click "Get Packages" located on the right side of the action ribbon at the top of `pubspec.yaml`, indicated by the download icon.
    - From Android Studio/IntelliJ: Click "Pub get" in the action ribbon at the top of `pubspec.yaml`.
4. Open `api.py` in `lib` folder, and change line 31 `app.run(debug=True, host="192.168.1.111", port=5000)` to use your local host address. For example, for a local host, use `app.run(debug=True, host="127.0.0.1", port=5000)`. If you want to use your IP address to host the Flask backend, then use `app.run(debug=True, host="[IPv4 address]", port=5000)`
5. Run it on an emulator. If using Android Studio, click the run button to run on the installed emulator in Android Studio or on a connected device.

## 🤩Demo
A demo video of the TikTok: TikTune is available [here](https://youtu.be/-arIrXyAq-I).

## 🚀 What's Next
- User Feedback Loop
    - Implement a feedback mechanism where users can rate recommendations, allowing the algorithm to learn and adapt to their preferences.
- Monetization for Artists
    - Enable features like direct donations, merchandise sales, or exclusive content access to support independent musicians financially.
- Subscription Model
    - Offer a premium subscription for features like ad-free listening, offline downloads, and exclusive content like customized rolling comments.


## 🌟Conclusion

TikTune has significant potential to create a unique and engaging music discovery experience. By focusing on personalized recommendations, supporting independent musicians, fostering community interaction, and offering scalable features, the app can attract and retain a diverse user base. The potential for monetization through promoted content and premium features further enhances its viability as a comprehensive music platform.
