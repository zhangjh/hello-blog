title: 手写SpringMVC框架
show: true
date: 2019-03-24 14:13:33
tags: [SpingMVC,Tomcat,手写框架]
categories: 技术人生
---
### 背景
[**上一篇**](https://zhangjh.me/2019/03/20/write-tomcat-in-hand/)手写了TomCat框架，基本上弄明白了Servlet的核心原理。这一篇里通过手写SpringMVC框架来了解一下我们日常开发中离不开的SpringMVC的基本原理。
我们从上一篇的TomCat框架出发，本篇手写的框架利用上一篇里手写的TomCat框架启动，为了能跟SpringMVC结合使用，上一篇里的TomCat需要进行一些修改适配，如去除xml配置，初始化增加bean实例化操作等。

### 框架概述
作为一个SpringMVC框架，我们需要提供哪些功能？
首先，我们需要提供一些注解，供配置、注入依赖、标识web接口等；
其次，我们需要提供IOC/DI的功能，以便能够反转依赖；
再者，我们需要能够根据url寻址到合适的JavaBean运行服务

<!--more-->
	
### 实现
1. 自定义注解
	从DAO层，Service层，Controller层，我们在SpringMVC中经常使用的注解有：
	Repository、Service、Controller、Autowried、RequestMapping等,在本项目中，我们主要实现以上几种注解。另外，我们仿照SpringBoot的启动类注解方式(SpringBootApplication)，增加Configuration注解，用来收集主要的配置项。
	```java
	// Configuration注解，用来配置基包路径和启动端口
	@Documented                          // 允许生成javadoc
	@Target(ElementType.TYPE)            // 可被用来注解类、接口或枚举
	@Retention(RetentionPolicy.RUNTIME)  // 生命周期为运行时(元注解具体释义不赘述)
	public @interface Configuration {
		String basePackage() ;           // 必须配置基包路径

		int port() default 8080;         // 可指定启动端口，默认8080
	}
	```
	```java
		// Repository注解，用来注解数据服务
		@Documented
		@Target(ElementType.TYPE)
		@Retention(RetentionPolicy.RUNTIME)
		public @interface Repository {
			String value() default "";
		}
	```
	```java
	// Service注解，用来声明一个Bean，属性值可选
	@Documented
	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Service {
		String value() default "";
	}
	```
	```java
	// Autowired注解用来引用一个Bean，可以指定引用Bean的名字，指定名字使用的方式类似于我们使用@Qualifier注解
	@Documented
	@Target(ElementType.FIELD)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Autowired {
		String value() default "";
	}
	```
	```java
	// Controller注解，用来标注一个Java类为Web接口
	@Documented
	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Controller {
		String value() default "";
	}
	```
	```java
	// RequestMapping注解用来声明该方法跟某个url绑定，因此属性值必填
	@Documented
	@Target({ElementType.METHOD, ElementType.TYPE})
	@Retention(RetentionPolicy.RUNTIME)
	public @interface RequestMapping {
		String value();
	}
	```
	这里自定义注解大部分的属性值都非必填，后面会看到，当不填属性值时会默认按名字来匹配。

2. 启动方法
我们从入口函数开始说起。定义一个Application类，仿照Springboot的方式，使用该类的main函数启动，在main函数中完成我们的SpringMVC框架的初始化和启动。
首先我们需要给类加上@Configuration注解，并指明需扫描的基包路径和启动端口。然后在启动之前需要把配置的配置项加载进来提供给程序初始化框架。
```java
@Configuration(basePackage = "com.test.springmvc", port = 8082)
public class Application {
    private String basePackage;
    private int port;

    /** 从配置注解获取配置 */
    private void loadConfig() {
        try {
            Class<?> clazz = Class.forName(this.getClass().getName());
            if(!clazz.isAnnotationPresent(Configuration.class)) {
                throw new RuntimeException("缺少Configuration注解");
            }
            Configuration configuration = clazz.getAnnotation(Configuration.class);
            String basePackage = configuration.basePackage();
            int port = configuration.port();
            this.basePackage = basePackage;
            this.port = port;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    {
        loadConfig();
    }

    private void run() {
        MyTomCat tomCat = new MyTomCat(basePackage, port);
        tomCat.start();
    }

    public static void main(String[] args) {

        new Application().run();
    }
}
```

3. TomCat改造
上面可以看到，从注解读取配置项后，入口方法初始化了一个TomCat。没错，这里的TomCat就是上一篇手写的TomCat框架。这里为了跟SpringMVC结合使用做了一些修改。
上一篇里的初始化方法纯粹的是加载TomCat的配置，这里结合SpringMVC初始化还需要做更多的事情，如：扫描基包路径将需要实例化的类实例化，完成依赖注入，完成url和方法的映射绑定等。

 3.1 初始化
  ```java
		 private void init() {
			// 扫描基包下所有类全限定名称
			scanBasePackage(basePackage);
			// 实例化并放入ioc容器
			instance();
			// 依赖注入
			springIoc();
			// 完成url和方法的映射绑定
			handleUrlMethodMap();
		}
```
 3.2 扫描基包路径
  扫描基包路径主要是做一件事：将路径下的所有Java类全限定类名存储以便后续使用。 
  ```java
		private void scanBasePackage(String basePackage) {
			URL url = this.getClass().getClassLoader().getResource(basePackage.replaceAll("\\.", "/"));

			if(url == null) {
				return;
			}
			File basePackageFile = new File(url.getPath());

			File[] files = basePackageFile.listFiles();
			if(files == null) {
				return;
			}
			for (File file : files) {
				if(file.isDirectory()) {
					scanBasePackage(basePackage + "." + file.getName());
				}else if(file.isFile()) {
					packageNames.add(basePackage + "." + file.getName().replaceAll(".class", "").trim());
				}
			}
		}
```
 3.3 类实例化
  实例化即将需要实例化的类实例化后存储以供后续使用，这里所有的类都已被存在上一步的扫描结果中。需要注意的是，实例化的beanName如果用户传递了名字则使用用户设定的，否则需要根据类名且将首字母小写后作为beanName，这也是跟Spring的惯例是一致的。
  ```java
		private void instance() {
			if(packageNames.size() <= 0){
				return;
			}
			try {
				for (String name : packageNames) {
					Class<?> clazz = Class.forName(name);

					String beanName = null;
					// 这个类上标注了Controller注解，将类实例化后跟controller名称绑定
					if(clazz.isAnnotationPresent(Controller.class)) {
						// 获取Controller注解的属性值
						Controller controller = clazz.getAnnotation(Controller.class);
						String controllerName = controller.value();
						beanName = getBeanName(controllerName, clazz);
					}else if (clazz.isAnnotationPresent(Service.class)) {
						Service service = clazz.getAnnotation(Service.class);
						String serviceName = service.value();
						beanName = getBeanName(serviceName, clazz);
					}else if (clazz.isAnnotationPresent(Repository.class)) {
						Repository repository = clazz.getAnnotation(Repository.class);
						String repositoryName = repository.value();
						beanName = getBeanName(repositoryName, clazz);
					}
					if(beanName != null) {
						instanceMap.put(beanName, clazz.newInstance());
						nameMap.put(name, beanName);
					}
				}
			}catch (InstantiationException | IllegalAccessException | ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
```
 3.4 依赖注入
  在这一步里，我们需要将类实例中通过注解依赖进来的其他服务Bean实例化并跟实例映射上。于是我们需要遍历实例的属性字段，发现有标注依赖注解的需要将依赖的实例关联上。类似地，这里也需要注意引用不传属性值的处理。
  ```java
		private void springIoc(){
        for (Entry<String, Object> entry : instanceMap.entrySet()) {
            // 获取所有的字段
            Field[] fields = entry.getValue().getClass().getDeclaredFields();

            try {
                for (Field field : fields) {
                    // 标注Autowired注解的字段需要注入，从IOC容器中找出对应的实例
                    if(!field.isAnnotationPresent(Autowired.class)) {
                        continue;
                    }
                    String beanName = field.getAnnotation(Autowired.class).value();

                    // 如果没有设置注解值，使用字段名去找注入的实例
                    if("".equals(beanName)) {
                        beanName = lowerFirst(field.getType().getSimpleName());
                    }

                    field.setAccessible(true);
                    field.set(entry.getValue(), instanceMap.get(beanName));
                }
            }catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
    }
	```
 3.5 RequestMapping方法映射处理
  针对标注上@Controller注解的类，我们知道它是提供Web服务的接口。它的方法如果打上@RequestMapping注解的将会对指定的url提供服务。
  在定义@RequestMapping注解的时候，我们指明了该注解可以标注在类或方法上。标注在类上的表示url的公共前缀，类方法上的属性值需要添加该前缀才能组成完整url。
  根据上述分析，我们可以把url和提供服务的方法名称做一映射。
  ```java
		private void handleUrlMethodMap() {
        if(packageNames.size() <= 0) {
            return;
        }
        try {
            for (String name : packageNames) {
                Class<?> clazz = Class.forName(name);
                if(!clazz.isAnnotationPresent(Controller.class)) {
                    continue;
                }
                Method[] methods = clazz.getMethods();
                String urlPrefix = "";
                String fullUrl;

                // 标注在类上的RequestMapping属性值表示url的公共前缀
                if(clazz.isAnnotationPresent(RequestMapping.class)) {
                    urlPrefix = clazz.getAnnotation(RequestMapping.class).value();
                }
                // 标注在方法上的RequestMapping属性值
                for (Method method : methods) {
                    if(!method.isAnnotationPresent(RequestMapping.class)) {
                        continue;
                    }
                    String url = method.getAnnotation(RequestMapping.class).value();
                    fullUrl = (urlPrefix + url).replaceAll("/+", "/");

                    urlMethodMap.put(fullUrl, method);
                    methodPackageMap.put(method, name);
                }
            }
        }catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
```
 3.6 响应方法改造
  上一篇TomCat的响应方法我们使用打印的mock方法提供。结合了Spring之后，我们可以改造其为根据请求寻找真正的服务方法执行。
  上一个步骤里，我们已经将url和服务方法做了绑定，因此响应方法在拿到请求的路径后，可以查询到提供服务的具体方法，然后借助反射执行该服务方法即可。
  ```java
		private void doPost(Request request, Response response) {

        String url = request.getUrl();

        // 从映射中找出要处理的method
        Method method = urlMethodMap.get(url);
        if(method != null) {
            // 通过method找到controller对象，并执行对象方法
            String packageName = methodPackageMap.get(method);
            String controllerName = nameMap.get(packageName);
            // 从实例容器中找到对应的controller实例
            Object controller = instanceMap.get(controllerName);

            method.setAccessible(true);
            try {
                method.invoke(controller, request, response);
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }else {
            response.outPrint("404");
        }
    }
```
 3.7 测试
  TomCat的其他部分，分发、多线程、请求，响应结构封装等保持不变。
  我们声明一个DAO层接口并以打印mock数据库的操作。
  ```java
		@Repository
		public class UserDaoImpl implements UserDao {
			@Override
			public void add() {
				// mock
				System.out.println("insert data to db success.");
			}

			@Override
			public void update() {
				// mock
				System.out.println("update data success");
			}
		}

  ```
  在服务层，我们声明一个依赖DAO层接口的服务：
  ```java
		@Service
		public class UserServiceImpl implements UserService {

			@Autowired
			private UserDaoImpl userDao;

			@Override
			public void add() {
				System.out.println("start to insert data");
				userDao.add();
			}

			@Override
			public void update() {
				System.out.println("start to update data");
				userDao.update();
			}
		}
  ```
  最后我们再声明一个Controller层的接口，通过调用Service提供响应：
  ```java
		@Controller
		@RequestMapping("/user")
		public class UserController {

			@Autowired
			private UserServiceImpl userService;

			@RequestMapping("/add")
			public void add(Request request, Response response) {
				System.out.println("request /add");
				userService.add();
				response.outPrint("request /add");
			}

			@RequestMapping("/update")
			public void update(Request request, Response response) {
				System.out.println("requ；st /update");
				userService.update();
				response.outPrint("request /update");
			}
		}
```
### 运行
 直接运行`Application.java`的main函数即可启动框架。
 浏览器中访问"http://localhost:8080/user/add"；即可查看效果。

 完整的项目源码可以参看[**这里***](https://github.com/zhangjh/write_tomcat_springmvc_in_hand/tree/master/springmvc)。
