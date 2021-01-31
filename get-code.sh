#!/bin/bash

read -p "What year's robot code would you like? " year
echo "Fetching $year robot code."
echo "Answer \"yes\" if it asks if you would like to continue connecting."
git clone git@github.com:wildstang/${year}_robot_software
code-server --reuse-window ${year}_robot_software