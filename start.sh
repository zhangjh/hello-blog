#!/bin/bash
#source ~/.bash_profile

function build(){
	hexo g 
	sed -i 's/\&/\%26/g' public/sitemap.xml
    ##gulp 压缩
    gulp  
    if [ $? -ne 0 ];then
        echo "gulp压缩失败"
        exit 1
    fi
}

function sync(){
	dst=$1
    ##gulp压缩的替换
    cp -r dst/* public/
	rsync -arzv --delete public/* ${dst}
}

function upload(){
	dst=$1
	msg=$2
	if [ "${msg}" == "" ];then
		msg="add new page"
	fi
	cd ${dst}
	git add -A
	git commit -a -m "${msg}"
	git push
	cd -
}

build
sync myblog
#sync JHspider
upload myblog $1
#upload JHspider $1

## 提交项目自身
git status | grep -q "working directory clean"
if [ $? -ne 0 ];then
    git add -A
    git commit -a -m "add new pages"
    git push
fi
