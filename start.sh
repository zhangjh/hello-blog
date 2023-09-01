#!/bin/bash
#source ~/.bash_profile

function install(){
	npm i -d
}

function build(){
    npm run clean
    npm run generate
	#sed -i 's/\&/\%26/g' public/sitemap.xml
    ##gulp 压缩
    npm run gulp
    if [ $? -ne 0 ];then
        echo "gulp压缩失败"
        exit 1
    fi
}

#function sync(){
#	dst=$1
    ##gulp压缩的替换
#    cp -r dst/* public/
#	rsync -arzv --delete public/* ${dst}
#}

#function upload(){
#	dst=$1
#	msg=$2
#	if [ "${msg}" == "" ];then
#		msg="add new page"
#	fi
#	cd ${dst}
#	git add -A
#	git commit -a -m "${msg}"
#	git push
#	if [ $? -ne 0 ];then
#		echo "git push failed"
#		exit 1
#	fi 
#	cd -
#}

function run(){
	#killall hexo
	pid=`lsof -i:4000 | grep hexo | awk '{print $2}'`
	if [[ "X${pid}" != "X" ]];then 
		kill -9 ${pid}
	fi
	nohup hexo s &
}

#. ~/.bash_profile
install
build
#sync myblog
#upload myblog $1

## 提交项目自身
git status | grep -q "working directory clean"
if [ $? -ne 0 ];then
    git add -A
	msg="add new pages"
	if [ "X$1" != "X" ];then
		msg=$1
	fi
    git commit -a -m "${msg}"
    #git push
fi

run
