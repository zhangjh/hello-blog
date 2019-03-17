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
        //let r = Math.random();
        //let img = "//wx2.sinaimg.cn/mw690/62d95157ly1fwvvhwbv9fj20ku0xck27.jpg";
        //if(r > 0.5){
            img = "//wx3.sinaimg.cn/mw690/62d95157gy1fm3p9us3vcj20pt11vnf0.jpg";
        //}
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

// 鼠标点击特效（2019.3.17）
// 网上瞎逛的时候看到一个"牢记社会主义核心价值观的鼠标特效"，于是借鉴来了，源出：http://www.bianxiaofeng.com
(function loadSpecialEffects() {
    var a_idx = 0;
    jQuery(document).ready(function ($) {
        $("body").click(function (e) {
            var a = ["富强", "民主", "文明", "和谐", "自由", "平等", "公正", "法治", "爱国", "敬业", "诚信", "友善"];
			var ele = "<span>" + a[a.a_idx] + "</span>";
            a_idx = (a_idx + 1) % a.length;
            var x = e.pageX, y = e.pageY;
            $(ele).css({
                "z-index": 100000000,
                "top": y - 20,
                "left": x,
                "position": "absolute",
                "font-weight": "bold",
                "color": "#ff6651"
            });
            $("body").append($(ele));
            $(ele).animate({"top": y - 180, "opacity": 0}, 1500, function () {
                $(ele).remove();
            });
        });
    });

    !function (e, t, a) {
        function r() {
            for (var e = 0; e < s.length; e++) {
				s[e].alpha <= 0 ? (t.body.removeChild(s[e].el), s.splice(e, 1)) : (s[e].y--, s[e].scale += .004, s[e].alpha -= .013;
				s[e].el.style.cssText = "left:" + s[e].x + "px;top:" + s[e].y + "px;opacity:" + s[e].alpha + ";transform:scale(" + s[e].scale + "," + s[e].scale + ") rotate(45deg);background:" + s[e].color + ";z-index:99999");
            	requestAnimationFrame(r);
			}
        }

        function n() {
            var t = "function" == typeof e.onclick && e.onclick;
            e.onclick = function (e) {
                t && t(), o(e)
            }
        }

        function o(e) {
            var a = t.createElement("div");
            a.className = "heart", s.push({
                el: a,
                x: e.clientX - 5,
                y: e.clientY - 5,
                scale: 1,
                alpha: 1,
                color: c()
            }), t.body.appendChild(a)
        }

        function i(e) {
            var a = t.createElement("style");
            a.type = "text/css";
            try {
                a.appendChild(t.createTextNode(e))
            } catch (t) {
                a.styleSheet.cssText = e
            }
            t.getElementsByTagName("head")[0].appendChild(a)
        }

        function c() {
            return "rgb(" + ~~(255 * Math.random()) + "," + ~~(255 * Math.random()) + "," + ~~(255 * Math.random()) + ")"
        }

        var s = [];
        e.requestAnimationFrame = e.requestAnimationFrame || e.webkitRequestAnimationFrame || e.mozRequestAnimationFrame || e.oRequestAnimationFrame || e.msRequestAnimationFrame || function (e) {
            setTimeout(e, 1e3 / 60)
        }, i(".heart{width: 10px;height: 10px;position: fixed;background: #f00;transform: rotate(45deg);-webkit-transform: rotate(45deg);-moz-transform: rotate(45deg);}.heart:after,.heart:before{content: '';width: inherit;height: inherit;background: inherit;border-radius: 50%;-webkit-border-radius: 50%;-moz-border-radius: 50%;position: fixed;}.heart:after{top: -5px;}.heart:before{left: -5px;}"), n(), r()
    }(window, document);
})();
