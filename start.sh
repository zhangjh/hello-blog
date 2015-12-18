#!/bin/bash
source ~/.bash_profile

hexo3 generate && hexo2 o
#cp -r public/* myblog
sed -i 's/\&/\%26/g' public/sitemap.xml
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
