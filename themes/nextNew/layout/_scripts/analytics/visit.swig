<script src="/vendors/firebase/firebase.js"></script>
<script>
    var firebase = new Firebase("https://zhangjh.firebaseio.com/");
    //将反斜杠替换成下划线,并将中文decode
    var curUrl = decodeURI(window.location.pathname.replace(new RegExp('\\/|\\.', 'g'),"_"));
    //总数
    firebase.child("sum").on("value",function(data){
        var curCnt = data.val();
        if(curCnt > 1){
            if($("#totalCnt").length){
                $("#totalCnt").remove();
            }
            $("span.author").append(" | <span id='totalCnt'>自2016.4.12起总访问量：" + curCnt + "次")
        }
    });

    //page明细
    firebase.child("page/" + curUrl).on("value",function(data){
        var pageCnt = data.val();
        if(pageCnt > 1){
            $("#detail_cnt").text(pageCnt);
        }
    });

    firebase.child("sum").transaction(function(curCnt){
        return (curCnt || 0) + 1;
    });

    firebase.child("page/" + curUrl).transaction(function(curCnt){
        return (curCnt || 0) + 1;
    });
</script>
