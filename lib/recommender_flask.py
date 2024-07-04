import json
import nltk
from nltk.stem.porter import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import pickle
from datetime import datetime, timedelta
from flask import Flask, request, jsonify

nltk.download('punkt')
app = Flask(__name__)

with open('lib/me.json', 'r') as f:
    user_data = json.load(f)
with open('lib/assets/songs.json', 'r') as f:
    songs_data = json.load(f)


# Function to recommend songs based on preferred genres, search history, and additional criteria
def recommend_songs(user_data, songs_data):
    preferred_genres = set(user_data["preferred_genres"])
    search_history = set(user_data["search_history"])

    recommended_songs = []

    for song, details in songs_data.items():
        if details["Genre"] in preferred_genres:
            recommended_songs.append({"Title": song, **details})

    for song, details in songs_data.items():
        for term in search_history:
            if term.lower() in song.lower() or term.lower() in details["Creator"].lower():
                if {"Title": song, **details} not in recommended_songs:
                    recommended_songs.append({"Title": song, **details})

    current_date = datetime.now()

    # Scoring songs based on independent musicians, likes-to-views ratio, and recent release
    for song in recommended_songs:
        score = 0
        if song["Independent Musicians"]:
            score += 1
        likes_views_ratio = song["Likes"] / song["Views"]
        score += likes_views_ratio

        # Check if the song was published within the last month
        public_time = datetime.strptime(song["public_time"], "%Y-%m-%d")
        if current_date - public_time <= timedelta(days=30):
            score += 1  # Increment score for recent songs

        song["score"] = score

    # Sort songs based on the score
    recommended_songs = sorted(recommended_songs, key=lambda x: x["score"], reverse=True)

    return recommended_songs


# Preprocess song titles and creators for the similarity model
def preprocess_songs(songs_data):
    stemmer = PorterStemmer()

    def tokenization(txt):
        tokens = nltk.word_tokenize(txt)
        stemming = [stemmer.stem(w) for w in tokens]
        return " ".join(stemming)

    # Create a DataFrame for the songs data
    df = pd.DataFrame([
        {"song": song, "text": f"{song} {details['Creator']}"}
        for song, details in songs_data.items()
    ])

    # Apply tokenization and stemming
    df['text'] = df['text'].apply(lambda x: tokenization(x))

    return df


# Train the similarity model
def train_similarity_model(df):
    tfidvector = TfidfVectorizer(analyzer='word', stop_words='english')
    matrix = tfidvector.fit_transform(df['text'])
    similarity = cosine_similarity(matrix)

    return similarity


# Get song recommendations based on similarity
def get_song_recommendations(song_title, df, similarity):
    idx = df[df['song'] == song_title].index[0]
    distances = sorted(list(enumerate(similarity[idx])), reverse=True, key=lambda x: x[1])

    recommended_songs = []
    for m_id in distances[1:21]:
        recommended_songs.append(df.iloc[m_id[0]].song)

    return recommended_songs


# Main function to run the entire recommendation system
def main():
    # Get initial recommendations based on genres and search history
    initial_recommendations = recommend_songs(user_data, songs_data)

    df = preprocess_songs(songs_data)
    similarity = train_similarity_model(df)

    with open('similarity.pkl', 'wb') as f:
        pickle.dump(similarity, f)
    with open('df.pkl', 'wb') as f:
        pickle.dump(df, f)

    if initial_recommendations:
        additional_recommendations = get_song_recommendations(initial_recommendations[0]['Title'], df, similarity)
    else:
        additional_recommendations = []

    combined_recommendations = initial_recommendations + [{"Title": song} for song in additional_recommendations]
    recommendation_titles = [song['Title'] for song in combined_recommendations]
    return jsonify(recommendation_titles)


# Run the main function
if __name__ == "__main__":
    app.run(debug=True)