title: Java volatile关键字简析
show: true
date: 2017-08-26 13:26:03
tags: [Java,volatile]
categories: 技术人生
---
最近在看《Java编程思想》，记录一些觉得有必要整理的内容。本篇就简要分析一下Java并发编程中遇到的volatile关键字。

并发编程中，我们通常会遇到以下三个概念：**原子性**、**可视性**以及**有序性**。
volatile关键词正式对应可视性这个概念。

可视性是指，当多个线程访问同一个变量时，一个线程修改了这个变量的值，其他线程能够立即看到修改的值。即便使用了本地缓存，volatile修饰的域也会立即被写入到主存中，而读取操作就是发生在主存中。
而相应地，非volatile域上的原子操作不必刷新到主存中去，因此其他读取该域的任务也不必看到这个新值。

然而，要区分原子性和可视性是不同的概念。volatile关键字能保证可视性但并不能保证操作的原子性。如果一个域的值依赖于它之前的值，例如递增一个计数器，或者某个域的值收到其他域的值的限制，例如Range类的lower和upper边界就必须遵循lower<=upper的限制，那么只用volatie修饰是不起作用的。保持原子性或说同步，第一选择应该是使用`synchronized`关键字，同步也会导致向主存中刷新，因此`synchronized`防护的方法或语句块内的域就不必使用`volatile`修饰了。

<!--more-->

下面来看个例子说明下：
```
public class Counter {
    public static int count = 0;
	// 先不使用volatile
	// public volatile static int count = 0;
    public static void inc(){
        try {
            Thread.sleep(1);
        }catch (InterruptedException ignore){
        }
		// 先不使用同步块
        //synchronized (Counter.class){
            count++;
        //}
    }

    public static void main(String ...args){
        for(int i=0;i<1000;i++){
            new Thread(){
                @Override
                public void run(){
                    Counter.inc();
                }
            }.start();
        }
        try {
            Thread.sleep(2000);
        }catch (InterruptedException e){
            e.printStackTrace();
        }
        System.out.println(Counter.count);
    }
}
```
这个例子是个递增计数器，先不使用volatile修饰count，启动1000个线程去递增后打印count的值。由于线程的并发执行特性，读取到count值时，可能有另一个进程此时刚递增过count，导致值不是最新。
实际的输出比预期的1000要小。
当我们使用volatile修饰count时，按理输出应该和预期的1000一致了，然而实际运行结果显示还是小于1000。这个例子其实看不出来volatile的可视性，实际上它在这个场景能够说明的是volatile并不能保证原子性，正如上面的描述说到的，递增依赖之前的值volatile并不能正常工作。这个例子中，要想完全符合预期的工作需要使用同步代码块。

那我们再来看一个volatile可以说明可视性的例子：
```
	private /*volatile*/ static boolean flag = true;

    public static void main(String ...args){
        new Thread(){
            @Override
            public void run(){
                while (true){
                    if(Volatile.flag != Volatile.flag){
                        System.exit(0);
                    }
                }
            }
        }.start();

        try {
            Thread.sleep(1);
        }catch (InterruptedException e){}

        new Thread(){
            @Override
            public void run(){
                while (true){
                    Volatile.flag = !Volatile.flag;
                }
            }
        }.start();
    }
```
在先不用volatile修饰flag之前，程序将进入死循环，因为线程2的修改线程1看不见，当我们加上volatile之后，运行后程序立即结束。这说明线程2修改了flag之后，线程1立即就感知到了。呼，可视性的例子还真是不好举。。

总之，如果一个域可能会被多个任务同时访问，或者这些任务至少有一个是写入任务，那么就应该将该域设置为volatile。volatile会告诉编译器不要执行任何移除读取和写入操作的优化，这些操作的目的是用线程中的局部变量维护对该域的精确同步。实际上，读取和写入都会直接针对内存，没有被缓存。但volatile并不能保证原子性，对涉及原子性操作的同步第一选择总是做同步。


