from flask import Flask, request, jsonify
import json
from recommender import recommend_songs
import os
from bgm_recommender import extract_keywords, bgm_recommendation
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def pull_file_from_device(device_path, local_path):
    os.system(f'adb pull {device_path} {local_path}')

@app.route('/recommendations', methods=['GET'])
def get_recommendations():
    device_path = '/storage/emulated/0/Android/data/com.example.temp_flutter/files/me.json'
    local_path = 'me.json'
    pull_file_from_device(device_path, local_path)

    # Load song data from JSON files
    with open('assets/songs.json', 'r') as f:
        songs_data = json.load(f)

    # Load user data from JSON file
    with open(local_path, 'r') as f:
        user_data = json.load(f)

    recommendations = recommend_songs(user_data, songs_data)
    recommendation_titles = [song['Title'] for song in recommendations]
    return jsonify(recommendation_titles)

@app.route('/extract_keywords', methods=['GET'])
def keywords():
    video_path = request.args.get('video_path')
    keywords = extract_keywords(video_path)
    return jsonify(keywords)

@app.route('/bgm_recommendations', methods=['GET'])
def bgm_recommendations():
    video_path = request.args.get('video_path')
    keywords = extract_keywords(video_path)
    recommendations = bgm_recommendation(keywords)
    recommendation_titles = [song['Title'] for song in recommendations]
    return jsonify(recommendation_titles)


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)
    # app.run(debug=True, host="192.168.0.19", port=5000)

