from flask import Flask, request, jsonify
import json
from recommender import recommend_songs
import os

app = Flask(__name__)


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

if __name__ == "__main__":
    app.run(debug=True, host="", port=5000)
