#!/bin/bash

# Define the file path for saving the screenshot
FILENAME="$HOME/Pictures/screenshot_$(date +%Y-%m-%d_%H-%M-%S).jpg"

# Take a screenshot interactively (-i) and save it to a file
screencapture -t jpg -i "$FILENAME"

# Use AppleScript to copy the image to the clipboard
osascript <<EOF
set the clipboard to (read (POSIX file "$FILENAME") as JPEG picture)
EOF

# Generated with chatGPT 25.12.2024