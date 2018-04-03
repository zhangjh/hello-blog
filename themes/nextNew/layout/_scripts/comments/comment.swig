<!-- 自研评论系统 -->
{% if (theme.comment) and page.comments %}

  <div class="login-modal">
    <div class="modal-header">
      <h4>我要评论</h4>
    </div>

    <div class="modal-body">
      <div>
        <span>名  号:</span>
        <input type="text" name="name" placeholder="大侠请留名" />
      </div>
      <div>
        <span>邮  箱:</span>
        <input type="text" name="email" placeholder="邮箱必填，以便收取回复提醒" />
      </div>
      <div>
        <span>个人网址:</span>
        <input type="text" name="website" placeholder="选填，如果你也有博客，可以留个网址，以http开头" />
      </div>
    </div>

    <div class="modal-footer">
      <div style="float: right;" class="remember">
         <label>记住个人信息？</label>
         <input type="checkbox">
      </div>
      <div>
        <button class="save">保存</button>
        <button class="cancel">取消</button>
      </div>
    </div>
  </div>

	<div id="comment-wrap">
		<!--评论框-->
		<div class="comment-header">
			<div class="header-login border">登录</div>
			<div class="header-user border"></div>
		</div>
		<div class="comment-body" id="comment-text">
			<textarea class="border" placeholder="大侠说点什么吧~"></textarea>
		</div>
		<div class="comment-footer">
			<button class="commit">评论一番</button>
		</div>

		<!--评论列表-->
		<div class="comment-list">
			<div class="comment-list-header">
				<div class="comment-title">评论</div>
				<div class="comment-list-border"></div>
				<div class="comment-sum">
					<span>0</span>条评论
				</div>
			</div>

			<div class="comment-content">
			  <div class="comment-empty">
			    还没有评论，大侠坐个沙发？
			  </div>
			  <!--div class="content-item">
			    <div class="user-info">
            <span class="user">zhangjh</span>
            <span class="time">2018年4月3日 12：00</span>
          </div>
          <div class="content">test 评论</div>
          <div class="operate">回复</div>
			  </div-->
			</div>
		</div>
	</div>

  <script src="https://unpkg.com/notie"></script>

	<script>
	  let comment = {};
	  const url = decodeURI(window.location.pathname.replace(new RegExp('\\/|\\.', 'g'),"_"));
    comment.url = url;

    function parseTime(timeStr){
      const time = new Date(timeStr);
      const year = time.getFullYear();
      const month = time.getMonth() + 1;
      const day = time.getDate();
      const hour = time.getHours();
      const minute = time.getMinutes();
      return year + "年" + month + "月" + day + "日 " + hour + ":" + minute;
    }

	  function loginModalShow(){
	    $(".login-modal").show();
	  }

	  function loginModalHide(){
	    $(".login-modal").hide();
	  }

	  function loginBtnShow(){
	    $(".header-login").show();
	    $(".header-user").hide();
	  }

	  function loginBtnHide(){
      $(".header-login").hide();
      $(".header-user").show();
    }

    function commentEmptyShow(){
      $(".comment-empty").show();
    }

    function commentEmptyHide(){
      $(".comment-empty").hide();
    }

	  function check(){
	    comment.name = $(".modal-body input[name='name']").val();
	    comment.email = $(".modal-body input[name='email']").val();
	    if(!comment.name){
	      notie.alert({type: 3,text: "大侠请留名！"});
	      return;
	    }
	    if(!comment.email){
        notie.alert({type: 3,text: "邮箱必填！"});
        return;
      }
	  }

	  function saveComment(){
	    $.ajax({
	      url: "https://favlink.cn/comment/save",
	      type: "post",
	      data: comment
	    }).done(function(ret){
	      if(ret.status){
	         // 刷新评论
	         notie.alert({type: 1,text: "发表成功."});
	         getComment(comment.url);
	      }
	    });
	  }

	  function getComment(url){
	    $.ajax({
	      url: "https://favlink.cn/comment/queryList",
	      data: {
	        url: url
	      }
	    }).done(function(ret){
	      if(ret.status){
	        const total = ret.total;
	        if(total === 0){
	          commentEmptyShow();
	          return;
	        }else {
	          commentEmptyHide();
	          $(".comment-sum span").text(total);
	        }
	        const commentList = ret.data;
	        let html = "";
          for(const item of commentList){
            let contentItem = "<div class='content-item'>";
            contentItem += "<div class='user-info'><span class='user' data-website=" + item.website + ">" + item.name + "</span>"
                        + "<span class='time'>" + parseTime(item.gmtCreate) + "</span></div>";
            contentItem += "<div class='content'>" + item.content + "</div>";
            contentItem += "<div class='operate' data-id='" + item["_id"] + "' data-content='" + item.content + "' data-name='" + item.name + "'>回复</div></div>";
            html += contentItem;
          }
          $(".comment-content").html(html);
          // 注册用户名点击事件
          $(".content-item .user").click(function(){
            const website = $(this).attr("data-website");
            if(website != "undefined"){
              window.open(website);
            }
          });
          // 注册回复点击事件
          $(".content-item .operate").click(function(){
            const replyId = $(this).attr("data-id");
            const content = $(this).attr("data-content");
            const name = $(this).attr("data-name");
            comment.replyId = replyId;
            $(".comment-body textarea").val("<blockquote><pre>引用" + name + "的发言:</pre>" + content + "</blockquote>");
            window.location.href = "#comment-text";
          });
	      }
	    });
	  }

    // 获取评论
    getComment(comment.url);

	  // 获取用户信息
	  const localStorage = window.localStorage;
	  const userInfo = localStorage.getItem("userInfo");
	  if(!userInfo){
	    loginBtnShow();
	  }else {
	    // 解析用户信息
      const userInfoJson = JSON.parse(userInfo);
      comment.name = userInfoJson.name;
      comment.email = userInfoJson.email;
      comment.website = userInfoJson.website;
      //$(".modal-body input[name='name']").val(userInfoJson.name);
      //$(".modal-body input[name='email']").val(userInfoJson.email);
      //$(".modal-body input[name='website']").val(userInfoJson.website);
      $(".header-user").text(comment.name);
      loginBtnHide();
	  }
	  $(".header-login").click(loginModalShow);
	  $(".modal-footer .cancel").click(loginModalHide);
	  $(".modal-footer .save").click(function(){
      check();
      // 保存数据
      comment.website = $("modal-body input[name='website']").val();
      loginModalHide();
      $(".header-user").text(comment.name);
      loginBtnHide();
      if($(".remember input[type='checkbox']").is(":checked")){
        // 记住个人信息
        localStorage.setItem("userInfo",JSON.stringify(comment));
      }
	  });
	  $(".commit").click(function(){
	    comment.content = $(".comment-body textarea").val();
	    if(!comment.content){
	      notie.alert({type: 3,text: "大侠，一个字都不写没法发表！"});
	      return;
	    }
	    saveComment();
	  });
	</script>

{% endif %}
