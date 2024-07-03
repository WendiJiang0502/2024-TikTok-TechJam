import json
import nltk
from nltk.stem.porter import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import pickle


with open('lib/me.json', 'r') as f:
    user_data = json.load(f)

with open('lib/assets/songs.json', 'r') as f:
    songs_data = json.load(f)

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

    return recommended_songs

def preprocess_songs(songs_data):
    stemmer = PorterStemmer()
    
    def tokenization(txt):
        tokens = nltk.word_tokenize(txt)
        stemming = [stemmer.stem(w) for w in tokens]
        return " ".join(stemming)
    
    df = pd.DataFrame([
        {"song": song, "text": f"{song} {details['Creator']}"}
        for song, details in songs_data.items()
    ])
    
    df['text'] = df['text'].apply(lambda x: tokenization(x))
    
    return df

# Train the similarity model
def train_similarity_model(df):
    tfidvector = TfidfVectorizer(analyzer='word', stop_words='english')
    matrix = tfidvector.fit_transform(df['text'])
    similarity = cosine_similarity(matrix)
    
    return similarity

def get_song_recommendations(song_title, df, similarity):
    idx = df[df['song'] == song_title].index[0]
    distances = sorted(list(enumerate(similarity[idx])), reverse=True, key=lambda x: x[1])
    
    recommended_songs = []
    for m_id in distances[1:21]:
        recommended_songs.append(df.iloc[m_id[0]].song)
        
    return recommended_songs


def main():
    initial_recommendations = recommend_songs(user_data, songs_data)
    df = preprocess_songs(songs_data)

    similarity = train_similarity_model(df)
    
    with open('similarity.pkl', 'wb') as f:
        pickle.dump(similarity, f)
    with open('df.pkl', 'wb') as f:
        pickle.dump(df, f)

    if initial_recommendations:
        additional_recommendations = get_song_recommendations(initial_recommendations[0]['Title'], df, similarity)
        print(f"Additional recommendations based on the song '{initial_recommendations[0]['Title']}':")
        print(additional_recommendations)
    
    combined_recommendations = initial_recommendations + [{"Title": song} for song in additional_recommendations]

    recommendation_titles = [song['Title'] for song in combined_recommendations]
    return recommendation_titles

if __name__ == "__main__":
    recommendations = main()
    print("Recommended Songs List:")
    print(recommendations)
