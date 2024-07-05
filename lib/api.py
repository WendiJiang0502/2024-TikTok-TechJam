from flask import Flask, request, jsonify
import json
from recommender import recommend_songs

app = Flask(__name__)

# Load song data from JSON files
with open('assets/songs.json', 'r') as f:
    songs_data = json.load(f)

# Load user data from JSON file
with open('me.json', 'r') as f:
    user_data = json.load(f)

@app.route('/recommendations', methods=['GET'])
def get_recommendations():
    recommendations = recommend_songs(user_data, songs_data)
    recommendation_titles = [song['Title'] for song in recommendations]
    return jsonify(recommendation_titles)

if __name__ == "__main__":
    app.run(debug=True)
