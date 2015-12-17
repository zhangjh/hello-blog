#!/bin/bash
source ~/.bash_profile

hexo3 generate && hexo2 o
#cp -r public/* myblog
rsync -arzv public/* myblog
rsync -arzv public/* JHspider
cd myblog
git add .
git commit -a -m "add new"
git push
cd -
cd JHspider
git add .
git commit -a -m "add new"
git push
