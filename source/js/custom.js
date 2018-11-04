/*
 * Des：用户自定义js脚本
 * Author：njhxzhangjihong@126.com
 * Date：6/17 2016
*/
//打赏
(function(){
	$("#rewardTip").click(function(){
		$("#dsWrapper").toggle("slow");
	});
})();

(function(){
	var style = "font-size: 1.5em;color: dodgerblue";
	console.info("%c既然这么有缘，少年你想进阿里吗？",style);
	console.info("%c如果你正有此意，那么就给我发简历吧，我可以给你内推。",style);
	console.info("%c简历请发送至：jihong.zjh@alibaba-inc.com，邮件标题请注明来自Dante Notes。",style);
})();

(function () {
    $().ready(function () {
        let r = Math.random();
        let img = "//wx2.sinaimg.cn/mw690/62d95157ly1fwvvhwbv9fj20ku0xck27.jpg";
        if(r > 0.5){
            img = "//wx3.sinaimg.cn/mw690/62d95157gy1fm3p9us3vcj20pt11vnf0.jpg";
        }
        $("#alipay").attr("src",img);
        $("#alipay img").attr("src",img);
    });
})();

function getUrl(decodeStr) {
    return decodeStr.replace(new RegExp("_","g"),"/");
}

// 消息列表点击事件注册
function msgClickReg() {
    $("#modal-body > .item > a").click(function () {
        let id = $(this).attr("data-id");
        let url = $(this).attr("data-url");
        $.ajax({
            url: "https://favlink.cn/comment/update",
            data: {
                condition: {
                    _id: id
                },
                data: {
                    readed: true
                }
            }
        }).done(function (ret) {
            if(ret.status){
                // 定位到评论
                window.location.href = url + "#comment-wrap";
            }
        });
    });
}

(function msgList() {
    let url = decodeURI(window.location.pathname.replace(new RegExp('\\/|\\.', 'g'),"_"));
    let storage = window.localStorage;
    let userInfo = storage.getItem("userInfo");
    if(userInfo){
        let userInfoObj = JSON.parse(userInfo);
        let name = userInfoObj.name;
        let queryUrl = "https://favlink.cn/comment/find";
        let replyComments = [];
        $.ajax({
            url: queryUrl,
            data: {
                name: name,
		url: url,
                isDeleted: false
            }
        }).done(function (ret) {
            if(ret.status){
                // 找出用户回复过的评论，作为replyId查询被回复的评论
                let ids = [];
                for(let item of ret.data){
                    $.ajax({
                        url: queryUrl,
                        data: {
                            replyId: item["_id"],
                            readed: false,
                            isDeleted: false
                        },
                        async: false
                    }).done(function (result) {
                        if(result.status){
                            replyComments = replyComments.concat(result.data);
                        }
                    });
                }

                let total = replyComments.length;
                if(total > 0){
                    $("#msg-tip span").text(total);
                    $("#msg-tip").show();
                    let html = "";
                    for(let item of replyComments){
                        let pageUrl = item.url;
                        let name = item.name;
                        html += '<div class="item"><a data-id="' + item._id + '" data-url="' + getUrl(pageUrl) + '">' + name + '回复你</a></div>';
                    }
                    $("#modal-body").html(html);
                    msgClickReg();
                }
            }
        });

        $("#msg-tip").click(function () {
            $("#msg-modal").show();
            $(this).hide();
        });
    }
})();
