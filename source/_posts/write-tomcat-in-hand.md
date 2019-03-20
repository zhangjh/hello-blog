title: 手写Tomcat框架
show: true
date: 2019-03-20 14:18:50
tags: [Tomcat,Servlet]
categories: 技术人生
---
### 背景
TomCat是我们Java Web程序员每天都要打交道的东西，但很多应用框架的存在让我们感觉不到它的存在，"动动手配置下"，框架就帮我们把一切封装好了。
框架的使用极大地方便了我们开发，但仅仅停留在会用阶段还是不够的，做一个"API调用工程师"技术的天花板太低了，这篇博客就记录一下我在学习TomCat工作原理后手写的一个简单的demo框架。

### 思路
> The Apache Tomcat® software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies.
引用一句Tomcat官网上的话，Tomcat其实就是一个Servlet的开源实现，因此手写Tomcat也就是手写实现一个Servlet。

写之前我们理一下思路，我们的Tomcat要满足哪些需求？

首先，作为web服务，最基本的，我们请求某个URL路径后，服务要返回相应的输出内容。

要实现这个需求，我们需要利用Socket提供网络服务，其次要有请求分发的能力，将不同的请求分发到不同的服务进行处理。这在我们使用Servlet的时候通常是要配置web.xml。

作为一个框架，要有能将类实例化的能力，最终提供web服务的必然是各个不同服务的Servlet实例。

<!-- more -->

### 实现
1. 封装请求和响应
	使用Servlet，请求参数是HttpServletRequest，响应是HttpServletResponse，两个类内部都有各种请求头，响应头相关的参数设置。这里，我们简化掉其他的，只实现必须的部分。
请求类我们只关心必须的请求路径和方法类型，响应类我们只关心html文本类型的输出。

	1.1 Request的封装
	```java
public class Request {

    private String method;

    private String url;

    public Request(InputStream inputStream) throws IOException {

        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
        String line = bufferedReader.readLine();
        if(line != null) {
            String[] methodAndUrl = line.split(" ");
            this.method = methodAndUrl[0];
            this.url = methodAndUrl[1];

            System.out.println(method);
            System.out.println(url);
        }
    }
	... ...
}
```
	通过输入流解析，获取请求头里的请求方法类型和请求路径。

	1.2 Response类的封装
 	```java
public class Response {

    private OutputStream outputStream;

    /** HTTP响应头固定格式 */
    private static final String RESPONSE_HEADER =
        "HTTP/1.1 200 \n"
        + "Content-Type: text/html\n"
        + "\n";

    public Response(OutputStream outputStream) {
        this.outputStream = outputStream;
    }

    public void outPrint(String content) {
        StringBuilder response = new StringBuilder();

        response.append(RESPONSE_HEADER).append(content);

        try {
            this.outputStream.write(response.toString().getBytes("UTF8"));
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(this.outputStream != null) {
                try {
                    this.outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```
	"HTTP/1.1 200"是http请求响应的规范格式，"Content-Type: text/html"写死了返回html格式文本。响应类将输出流按UTF8格式输出为浏览器可以识别的文本。

2. Servlet初始化配置
	Servlet的配置主要是用来设定请求某个Url时分发给哪个Servlet服务类来进行处理。
	Servlet的配置可以通过xml文件也可以通过纯Java配置的方式。这里框架对两种配方式都予以说明。

	2.1 xml方式配置
	首先我们在项目中创建web.xml文件，像配置Servlet一样配置我们的Servlet
	```xml
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">

    <display-name>Welcome to Tomcat</display-name>
    <description>
        Welcome to Tomcat
    </description>

    <servlet>
        <servlet-name>Servlet1</servlet-name>
        <servlet-class>com.test.tomcat.servlet.servlet.MyServlet1</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>Servlet1</servlet-name>
        <url-pattern>/test1</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>Servlet2</servlet-name>
        <servlet-class>com.test.tomcat.servlet.servlet.MyServlet2</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>Servlet2</servlet-name>
        <url-pattern>/test2</url-pattern>
    </servlet-mapping>

</web-app>
```
	配置文件配置了两个示例Servlet，分别处理"/test1"和和"/test2"请求。
	对应的处理类下面会说到。

	使用xml配置那么必须要能够解析xml文件，这里使用dom4j。工程的pom依赖里要加上依赖项。
	```xml
 <!-- xml配置方式解析xml文件 -->
<dependency>
	<groupId>dom4j</groupId>
	<artifactId>dom4j</artifactId>
	<version>1.6.1</version>
</dependency>
```
	2.2 纯Java方式配置
	使用纯Java配置，我们首先需要建立一个配置POJO，用来保存Servlet的配置信息。
	```java
public class ServletMapping {

    private String servletName;

    private String url;

    private String clazz;

    public ServletMapping(String servletName, String url, String clazz) {
        this.servletName = servletName;
        this.url = url;
        this.clazz = clazz;
    }
	... ...
}
```
	并像xml配置一样，指明url路径分发到哪个Servlet：
	```java
public class ServletMappingConfig {

    public static final List<ServletMapping> SERVLET_MAPPINGS = new ArrayList<ServletMapping>();

    static {
        SERVLET_MAPPINGS.add(new ServletMapping(MyServlet1.class.getSimpleName(), "/test1", MyServlet1.class.getName()));
        SERVLET_MAPPINGS.add(new ServletMapping(MyServlet2.class.getSimpleName(), "/test2", MyServlet2.class.getName()));
    }
}
```

3. 定义Servlet处理类
	Servlet服务启动后，真正处理业务的方法为service方法。查看Servlet的HttpServlet类可以看到其除了主要的service方法外，还定义了很多诸如doGet，doPost，doPut，doXxx的方法去处理各类不同的请求。
	而service方法主要逻辑即根据请求方法的类型去请求对应的doXx方法。
	类似地，我们可以定义我们的Servlet处理类如下：
	```java
public abstract class BaseServlet {

    void service(Request request, Response response) {
        if("get".equalsIgnoreCase(request.getMethod())) {
            this.doGet(request, response);
        }else {
            this.doPost(request, response);
        }
    }

    public abstract void doGet(Request request, Response response);

    public abstract void doPost(Request request, Response response);
}
```
	这里定义为抽象类，主要是为了让各子类自行实现自己的doXX方法。service根据类型请求相应方法。具体的Servlet处理类主要实现doXX方法，示例为打印字符串，这里不赘述。

4. TomCat启动流程
	TomCat启动之前首先要加载上述配置的配置文件，然后开启Socket连接监听输入流，当有请求过来时，根据配置找到对应的Servlet处理类并实例化，然后调用处理类的service方法进行业务处理。
	这里为了演示两种配置方式的启动，将实例化两个TomCat，启动方式是一致的，区别只在于启动前的配置初始化。因此我们定义TomCat抽象基类如下：

	```java
abstract class BaseTomCat {
    /** 启动端口 */
    private int port;
    /** url入口和具体servlet的映射 */
    protected Map<String, String> urlServletMap;
	
	public BaseTomCat(int port) {
        this.port = port;
    }

    /** 由子类实现不同的初始化方法，支持xml和JAVA配置 */
    abstract void init();

	void dispatch(Request request, Response response) {
		String clazz = this.urlServletMap.get(request.getUrl());

        try {
            if(clazz == null) {
                response.outPrint("404:未找到对应servlet");
                return;
            }
            Class myServletClass = Class.forName(clazz);
            BaseServlet myServlet = (BaseServlet) myServletClass.newInstance();
            myServlet.service(request, response);
        }catch (Exception e) {
            e.printStackTrace();
        }	
	}

	void start() {
        this.init();
        try {
            ServerSocket serverSocket = new ServerSocket(port);
            System.out.println("Tomcat 已启动， 地址：localhost, 端口：" + port);

            // 监听，处理任务
            while (true) {
				// 开启socket等待输入流
				Socket socket = serverSocket.accept();
				// 分发请求
				Request = new Request(socket.getInputStream());
				Response = new Response(socket.getOutputStream());
				dispatch(request, response);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```
	子类只需实现自己的初始化方法即可：
	```java
// 纯java配置方式
@Override
    public void init() {
        this.urlServletMap = new HashMap<String, String>();
        try {
            System.out.println("加载配置文件开始");

            // Java class方式
            for (ServletMapping mapping : ServletMappingConfig.SERVLET_MAPPINGS) {
                this.urlServletMap.put(mapping.getUrl(), mapping.getClazz());
            }

            System.out.println("加载配置文件结束");

        }catch (Exception e) {
            e.printStackTrace();
        }
    }
```

	```java
// xml配置方式，UtilsXml封装了对xml文件的读操作
@Override
    void init() {

        this.urlServletMap = new HashMap<String, String>();
        try {
            System.out.println("加载配置文件开始");

            // web.xml方式
            UtilsXml xml = new UtilsXml(UtilsXml.class.getResource("/") + "web.xml");

            // 将servlet类存储到容器并生成对象
            List<Element> list = xml.getNodes("servlet");
            for (Element element : list) {
                SERVLET.put(element.elementText("servlet-name"), element.elementText("servlet-class"));
            }

            // 创建映射关系
            List<Element> mappings = xml.getNodes("servlet-mapping");
            for (Element mapping : mappings) {
                urlServletMap.put(mapping.elementText("url-pattern"), SERVLET.get(mapping.elementText("servlet-name")));
            }

            System.out.println("加载配置文件结束");

        }catch (Exception e) {
            e.printStackTrace();
        }
    }
```
	至此，框架已经可以运行了。编写main方法实例化TomCat启动：
	```java
public static void main(String[] args) {
	MyTomCatWithXml myTomCat = new MyTomCatWithXml(8080);

	myTomCat.start();
}
```

5. 优化
	上述的TomCat框架每个请求到来时都会新建一个线程，真实的TomCat容器是线程池机制。
	我们也可以将demo框架进行优化。
	首先我们定义一些线程池参数如下：
	```java
/** 线程池最大线程数 */
private static final int THREAD_POOL_MAX_SIZE = 200;
/** 线程池常驻线程数 */
private static final int THREAD_CORE_POOL_SIZE = 10;
/** 闲置线程存活时间 */
private static final int THREAD_KEEP_ALIVE = 30;
```
	生成线程池：
	```java
// 自定义线程名显示格式，为了使用ThreadFactoryBuilder需要依赖google.guava
ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("Tomcat-work-%d").build();
ExecutorService exec = new ThreadPoolExecutor(
	THREAD_CORE_POOL_SIZE,
	THREAD_POOL_MAX_SIZE,
	THREAD_KEEP_ALIVE,
	TimeUnit.SECONDS,
	new LinkedBlockingDeque<Runnable>(),
	threadFactory
);
```
	偷懒的话，也可以直接通过`Executors.newFixedThreadPool(100)`生成固定数目的线程池。

	线程任务也可以单独抽取成一个类，不赘述了，可以参看完整项目源码。

6. 完整项目源码可以参看[**write_tomcat_servlet_in_hand**](https://github.com/zhangjh/write_tomcat_servlet_in_hand)
