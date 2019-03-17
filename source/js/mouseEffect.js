// 鼠标点击特效（2019.3.17）
// 网上瞎逛的时候看到一个"牢记社会主义核心价值观的鼠标特效"，于是借鉴来了，源出：http://www.bianxiaofeng.com
function loadSpecialEffects() {
    var a_idx = 0;
    jQuery(document).ready(function ($) {
        $("body").click(function (e) {
			var a = ["富强", "民主", "文明", "和谐", "自由", "平等", "公正", "法治", "爱国", "敬业", "诚信", "友善"];
			var ele = document.createElement("span");
			ele.innerText = a[a_idx];

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
            $("body").append(ele);
            $(ele).animate({"top": y - 180, "opacity": 0}, 1500, function () {
                $(ele).remove();
            });
        });
    });

    !function (e, t, a) {
        function r() {
			for (var e = 0; e < s.length; e++) {
				var ele = s[e];
				if(ele) {
					if(ele.alpha > 0) {
						ele.y --;
						ele.scale += 0.004;
						ele.alpha -= 0.013;
						var css = "left:" + ele.x + "px;" +
								  "top:" + ele.y + "px;" +
								  "opacity:" + ele.alpha + ";" +
								  "transform:scale(" + ele.scale + "," + ele.scale + ") rotate(45deg);" +
								  "background:" + ele.color + ";" +
								  "z-index: 99999"
						;
						ele.el.style.cssText = css;
					}else {
						
						t.body.removeChild(ele.el, s.splice(e, 1));
					}
				}
			}
			requestAnimationFrame(r);
        }

        function n() {
            var t = "function" == typeof e.onclick && e.onclick;
            e.onclick = function (e) {
                t && t(), o(e);
            };
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
            }), t.body.appendChild(a);
        }

        function i(e) {
            var a = t.createElement("style");
            a.type = "text/css";
            try {
                a.appendChild(t.createTextNode(e));
            } catch (t) {
                a.styleSheet.cssText = e;
            }
            t.getElementsByTagName("head")[0].appendChild(a);
        }

        function c() {
            return "rgb(" + ~~(255 * Math.random()) + "," + ~~(255 * Math.random()) + "," + ~~(255 * Math.random()) + ")";
        }

        var s = [];
        e.requestAnimationFrame = e.requestAnimationFrame || e.webkitRequestAnimationFrame || e.mozRequestAnimationFrame || e.oRequestAnimationFrame || e.msRequestAnimationFrame || function (e) {
            setTimeout(e, 1e3 / 60);
        }, i(".heart{width: 10px;height: 10px;position: fixed;background: #f00;transform: rotate(45deg);-webkit-transform: rotate(45deg);-moz-transform: rotate(45deg);}.heart:after,.heart:before{content: '';width: inherit;height: inherit;background: inherit;border-radius: 50%;-webkit-border-radius: 50%;-moz-border-radius: 50%;position: fixed;}.heart:after{top: -5px;}.heart:before{left: -5px;}"), n(), r();
    }(window, document);
}
