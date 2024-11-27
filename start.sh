#!/bin/bash

# Iniciar o Flask (website.py) em segundo plano
python /app/youtubeviewer/website.py &

# Iniciar o worker do youtube_viewer.py
python /app/youtube_viewer.py