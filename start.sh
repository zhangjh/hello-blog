#!/bin/bash
source ~/.bash_profile

function build(){
	hexo3 generate #&& hexo2 o
	sed -i 's/\&/\%26/g' public/sitemap.xml
}

function sync(){
	dst=$1
	rsync -arzv public/* ${dst}
}

function upload(){
	dst=$1
	msg=$2
	if [ "${msg}" == "" ];then
		msg="add new page"
	fi
	cd ${dst}
	git add .
	git commit -a -m "${msg}"
	git push
	cd -
}

build
sync myblog
sync JHspider
upload myblog $1
upload JHspider $1
