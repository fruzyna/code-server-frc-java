#!/bin/bash

read -p "What year's robot code would you like? " year
git clone git@github.com:wildstang/${year}_robot_software
code-server --reuse-window ${year}_robot_software
