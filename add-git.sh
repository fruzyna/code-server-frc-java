#!/bin/bash

echo "Use this tool to setup coder with GitHub"
echo "Press Ctrl + C at anytime to cancel"

# add name to git
read -p "Enter your name: " name
git config --global user.name $name

read -p "Enter your email: " email

# remove existing key if it exists
rm ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub

# add email to git
git config --global user.email $email

# create SSH key
ssh-keygen -t ed25519 -C $email -f /config/.ssh/id_ed25519 -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# walk through adding it to Github
code-server ~/.ssh/id_ed25519.pub
echo "A new file (id_ed25519.pub) will open."
echo "1. Copy the entire text of the file."
echo "2. Open https://github.com/settings/ssh/new and sign in if necessary."
echo "3. Put \"code server\" into the small \"Title\" text box."
echo "4. Paste the copied text into the large \"Key\" text box."
echo "5. Press \"Add SSH key\", then you are done."
#cat ~/.ssh/id_ed25519.pub