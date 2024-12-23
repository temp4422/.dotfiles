#!/bin/bash

find_and_replace() {
  FILE=$1
  FIND=$2
  REPLACE=$3

  # Unzip, replace string, and zip back
  unzip "$FILE" -d tmp >/dev/null
  gsed -i -e "s/$FIND/$REPLACE/g" tmp/word/document.xml
  cd tmp && zip -r "../$FILE" * >/dev/null && cd ..
  rm -rf tmp
}

# Check for correct number of arguments
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 [DIRECTORY] FIND_TEXT REPLACE_TEXT"
  exit 1
fi

# Set directory, find, and replace strings
DIR=${1:-.}
FIND=$2
REPLACE=$3

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory."
  exit 1
fi

# Process each .docx file in the directory
for FILE in "$DIR"/*.docx; do
  if [ -f "$FILE" ]; then
    echo "Processing $FILE..."
    find_and_replace "$FILE" "$FIND" "$REPLACE"
  fi
done

echo "Done!"

# Source https://unix.stackexchange.com/questions/316891/how-to-replace-a-word-inside-a-docx-file-using-linux-command-line
# Source https://chatgpt.com/share/67697448-557c-8010-b8e5-43f19b2e3f55