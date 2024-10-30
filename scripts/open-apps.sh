#!/bin/bash

for i in {0..19}  # Adjusted to start from 0, as array indices in the plist usually start from 0
do
  echo "Opening app $i"

  # Extract the bundle identifier for the app at index $i in the dock's persistent apps section
  BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "print :persistent-apps:$i:tile-data:bundle-identifier" ~/Library/Preferences/com.apple.dock.plist 2>/dev/null)

  if [ -n "$BUNDLE_ID" ]; then
    echo "Opening app with bundle identifier: $BUNDLE_ID"
    open -b "$BUNDLE_ID"
  else
    echo "No bundle identifier found for index $i."
  fi
done

# Source chatGPT