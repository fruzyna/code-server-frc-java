#!/bin/bash

echo "Use this tool to setup coder with GitHub"
echo "Press Ctrl + C at anytime to cancel"

read -p "Enter your name: " name
git config --global user.name $name

read -p "Enter your email: " email
git config --global user.email $email
ssh-keygen -t ed25519 -C $email -f /config/.ssh/id_ed25519 -P ""

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Copy and paste the following text to https://github.com/settings/ssh/new"
echo ""
cat ~/.ssh/id_ed25519.pub
