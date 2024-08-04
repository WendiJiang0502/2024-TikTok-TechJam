from IPython.display import display, Image, Audio

import cv2  # We're using OpenCV to read video, to install !pip install opencv-python
import base64
import time
from openai import OpenAI
import os
import requests

client = OpenAI()

def extract_keywords(path):
    video = cv2.VideoCapture(path)
    base64Frames = []
    frame_count = 0
    while video.isOpened():
        success, frame = video.read()
        if not success:
            break
        if frame_count % 10 == 0:
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
                "These are frames from a video that I want to upload. Describe the content of the video with five keywords.",
                *map(lambda x: {"image": x, "resize": 768}, base64Frames[0::50]),
            ],
        },
    ]
    params = {
        "model": "gpt-4o",
        "messages": PROMPT_MESSAGES,
        "max_tokens": 200,
    }

    result = client.chat.completions.create(**params)
    # return result.choices[0].message.content.split()
    keywords_with_numbers = result.choices[0].message.content.split()
    keywords = [keywords_with_numbers[i] for i in range(len(keywords_with_numbers)) if i % 2 != 0]
    return keywords

def bgm_recommendation():
    return []

