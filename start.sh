#!/bin/bash
source ~/.bash_profile

hexo3 clean && hexo3 generate && hexo2 o
#cp -r public/* myblog
rsync -arzv public/* myblog
cd myblog
git add .
git commit -a -m "add new"
git push
