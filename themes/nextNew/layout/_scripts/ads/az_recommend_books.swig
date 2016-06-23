<script async>
	var books_links = [],
		books_name = [];
	books_links.push("http://www.amazon.cn/gp/product/B00S4OK1ZS/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00S4OK1ZS&linkCode=as2&tag=dante-23");
	books_links.push("http://www.amazon.cn/gp/product/B00ZWTY2JO/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00ZWTY2JO&linkCode=as2&tag=dante-23");
	books_links.push("http://www.amazon.cn/gp/product/B007ED88CI/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B007ED88CI&linkCode=as2&tag=dante-23");
	books_links.push("http://www.amazon.cn/gp/product/B0097CON2S/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B0097CON2S&linkCode=as2&tag=dante-23");
	bookis_links.push("http://www.amazon.cn/gp/product/B00NN8GJGA/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00NN8GJGA&linkCode=as2&tag=dante-23");
	
	books_name.push("三体全集");
	books_name.push("无声告白");
	books_name.push("解忧杂货店");
	books_name.push("奇思妙想:15位计算机天才及其重大发现");
	books_name.push("单页Web应用:JavaScript从前端到后端");

	var content = "";
	for(var i in books_links){
		content += "<a target='_blank' rel='nofollow' href='" + books_links[i] +  "'>" + books_name[i] +"</a>";
	}
	
	$("#recommendBooks").html(content);
</script>
