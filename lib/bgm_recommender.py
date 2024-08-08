from IPython.display import display, Image, Audio

import cv2  # We're using OpenCV to read video, to install !pip install opencv-python
import base64
from openai import OpenAI
import os
import requests
import json

client = OpenAI()

def extract_keywords(path):
    video = cv2.VideoCapture(path)
    base64Frames = []
    frame_count = 0
    while video.isOpened():
        success, frame = video.read()
        if not success:
            break
        if frame_count % 20 == 0:
            _, buffer = cv2.imencode(".jpg", frame)
            base64Frames.append(base64.b64encode(buffer).decode("utf-8"))
        frame_count += 1

    video.release()
    print(len(base64Frames), "frames read.")

    # Create prompt with the first few frames
    PROMPT_MESSAGES = [
        {
            "role": "user",
            "content": [
                "These are frames from a video that I want to upload. Give me 10 keywords (10 single words) to describe the content of the video.",
                *map(lambda x: {"image": x, "resize": 768}, base64Frames[0::50]),
            ],
        },
    ]
    params = {
        "model": "gpt-4o",
        "messages": PROMPT_MESSAGES,
        "max_tokens": 400,
    }

    result = client.chat.completions.create(**params)
    # return result.choices[0].message.content.split()
    keywords_with_numbers = result.choices[0].message.content.split()
    keywords = [keywords_with_numbers[i] for i in range(len(keywords_with_numbers)) if i % 2 != 0]
    return keywords[:6]

with open('assets/bgm.json', 'r') as f:
    songs_data = json.load(f)
def bgm_recommendation(keywords):
    # print("result keyword", keywords)
    recommended_songs = []

    for song, details in songs_data.items():
        # print("song keyword", details["keyword"])

        if any(keyword in details["keyword"] for keyword in keywords):
            recommended_songs.append({"Title": song, **details})

    # print("before scoring: ", recommended_songs)

    for song in recommended_songs:
        score = 0
        if song["Independent Musicians"]:
            score += 1
        likes_views_ratio = song["Likes"] / song["Views"]
        score += likes_views_ratio

        song["score"] = score

    # Sort songs based on the score
    recommended_songs = sorted(recommended_songs, key=lambda x: x["score"], reverse=True)
    # print("at the end: ", recommended_songs)
    return recommended_songs

