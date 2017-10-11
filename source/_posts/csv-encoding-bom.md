title: JAVA导出CSV乱码问题
show: true
date: 2017-10-11 16:09:41
tags: [csv,oss,utf8,bom]
categories: 技术人生
---
# 背景
我在项目中使用阿里云OSS存储文件，导出时导出为csv格式的文件。然而打开时总是存在中文乱码。
通过网上的一番搜索，大抵是使用记事本先打开csv文件，然后再保存为ANSI格式，然后再用excel打开时就不存在乱码了。但这不是程序里的解决方式，我们不可能提供一个半成品的导出文件供用户使用。经过一番网上搜寻，发现问题的根源在于UTF8的BOM信息头。
本来UTF8是不需要BOM头的，这就不得不说到微软的可恶了。

# BOM简介
BOM中文译作"字节顺序标记"，UTF8本不需要BOM来表明字节顺序，但WINDOWS用BOM来标记文件文件的编码方式。BOM的UTF8编码是"EF BB BF"，所以如果接收者收到以"EF BB BF"开头的字节流，就知道这是UTF8编码了。WINDOWS系软件保存的UTF8编码的文件需要文件的开头保有这个BOM字符。

# 问题解决
项目中使用OSS存储文件，存储成功后返回一个签名过的文件url地址，前端再根据这个url去请求获取文件。由于前端是直接使用"window.open(url)"的方式，直接新开窗口访问链接，下载下来的文件默认是UTF8编码的，因此使用excel打开时需要BOM字符来表明是UTF8编码，否则其中的中文则会产生乱码。

因此，在OSS存储时，我们就需要额外添加BOM头一并存储。代码如下：
```
OSSClient client = new OSSClient(ossHelper.getEndPoint(), ossHelper.getAccessKeyId(),
	ossHelper.getAccessKeySecret());
ObjectMetadata objectMetadata = new ObjectMetadata();
objectMetadata.setContentType("application/vnd.ms-excel");
objectMetadata.setContentEncoding("GBK");
objectMetadata.setContentDisposition("attachment; filename=" + fileName + ".csv");

// 增加BOM头信息
String bom = new String(new byte[] { (byte) 0xEF, (byte) 0xBB,(byte) 0xBF });

client.putObject(ossHelper.getBucketName(), fileName,
new ByteArrayInputStream((bom + exportFileString).getBytes()), objectMetadata);
```
