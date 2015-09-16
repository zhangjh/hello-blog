#!/bin/bash
source ~/.bash_profile
hexo3 generate && hexo2 o
cp -r public/* myblog
cd myblog
git add .
git commit -a -m "add new"
git push
