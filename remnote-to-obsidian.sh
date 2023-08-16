#! /bin/bash

# START
echo -e "RemNote to Obsidian shell scritp starts\n"

# 1. Rename Daily Documents to daily
mv "/Users/user/Downloads/RemNoteExport/Daily Document" "/Users/user/Downloads/RemNoteExport/daily"

# 2. Move all .html files to ~ folder
mkdir "/Users/user/Downloads/RemNoteExport/~"
mv /Users/user/Downloads/RemNoteExport/*.html /Users/user/Downloads/RemNoteExport/~/

# 3. Remove all folders excep 'daily' and '~'
find /Users/user/Downloads/RemNoteExport/*  -type d  \( -path /Users/user/Downloads/RemNoteExport/daily -o -path /Users/user/Downloads/RemNoteExport/~ \) -prune -o -iname "*" -exec rm -rf {} \;
# Remove RemNote inner files
# rm -r "/Users/user/Downloads/RemNoteExport/~/~.md" "/Users/user/Downloads/RemNoteExport/~/Website.md" "/Users/user/Downloads/RemNoteExport/~/Automatically Sort.md" "/Users/user/Downloads/RemNoteExport/~/Automatically Add Template.md" "/Users/user/Downloads/RemNoteExport/~/Document.md" "/Users/user/Downloads/RemNoteExport/~/Extra Card Detail.md"

# 4. Convert html to md
find /Users/user/Downloads/RemNoteExport -iname "*.html" -type f -exec sh -c 'pandoc --from html --to markdown "${0}" -o "${0%.html}.md" --wrap=preserve' {} \;
find /Users/user/Downloads/RemNoteExport -iname "*.html" -type f -exec sh -c 'rm "${0}"' {} \;

# 5. Remove \, # heading 1, {isremreference="true"}, {isinlinelink="true"}, ?isPin=false blank lines; Using gnu-sed
# Remove '# Heading 1'
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i '0,/^#.*/s/^#.*//' {} \;
# Remove '\'
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i '0,/\\/s/\\//' {} \;
# Remove {isremreference="true"}
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/{isremreference="true"}//g' {} \;
# Remove {isinlinelink="true"}
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/{isinlinelink="true"}//g' {} \;
# Remove ?isPin=False
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/?isPin=false//g' {} \;
# Remove first 4 lines (because of manipulations above)
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i '1,4d' {} \;

# 6. Fix code blocks
# Replace capture group '...-   ```' with double capture group
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/\(.*-\s\s\s```\)/\1\n\1/g' {} \;
# Replace first '- ```' with - '- code__\n'
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/-\s\s\s```$/- code__\n/g' {} \;
# Replace second '- ```' with '   ```'
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/-\s\s\s```/    ```/g' {} \;

# 7. Replace .html with .md; local:///Users/user/remnote/remnote-60d0a8d64cff290034528346/files with /assets
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/\.html/\.md/g' {} \;
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/local:.*files/\/assets/g' {} \;

# 8. Spaced repetition replace →|↔|↓ with >>
# Disable cards in Dictionary.md
# gsed -i 's/→\|↔\|↓/ -> /g' /Users/user/Downloads/RemNoteExport/~/Dictionary.md
# Set flashcards global
find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/→\|↔\|↓/ >> /g' {} \;
# Set custom review. On review day results corresponds to: hard 1.1m, good 11.1m, easy 2.2y;
# find /Users/user/Downloads/RemNoteExport -iname "*.md" -type f -exec gsed -i 's/\(>>.*\)/\1 <!--SR:!2024-03-01,30,310-->/g' {} \;

# 9. Copy assets and configs
cp -r /Users/user/remnote/remnote-60d0a8d64cff290034528346/files /Users/user/Downloads/RemNoteExport/ && mv /Users/user/Downloads/RemNoteExport/files/ /Users/user/Downloads/RemNoteExport/assets

cp -r "/Users/user/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/Logseq-graph-iCloud/logseq" /Users/user/Downloads/RemNoteExport/logseq
rm -r /Users/user/Downloads/RemNoteExport/logseq/bak

cp -r "/Users/user/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/Logseq-graph-iCloud/.obsidian" /Users/user/Downloads/RemNoteExport/.obsidian

cp -r "/Users/user/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/Logseq-graph-iCloud/whiteboards" /Users/user/Downloads/RemNoteExport/whiteboards

# 10. Misc
# mv "/Users/user/Downloads/RemNoteExport/~/⚡ Aims.md" "/Users/user/Downloads/RemNoteExport/⚡ Aims.md"
# mv "/Users/user/Downloads/RemNoteExport/~/✅ TODO.md" "/Users/user/Downloads/RemNoteExport/✅ TODO.md"
# mv "/Users/user/Downloads/RemNoteExport/~/🗃️ Categories.md" "/Users/user/Downloads/RemNoteExport/🗃️ Categories.md"

# FINISH
echo -e "\nRemNote to Obsidian shell scritp finish OK"
