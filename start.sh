#!/bin/bash
hexo g
cp -r public/* myblog
cd myblog
git add .
git commit -a -m "add new"
git push
