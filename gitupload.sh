#!/bin/bash

#git init
#git remote add origin https://github.com/yangangchen/Data_Science_Specialization_Projects.git
git branch gh-pages
git remote show origin
git add .
git commit -m 'Final version!'
git push -u origin master
git push -u origin gh-pages
