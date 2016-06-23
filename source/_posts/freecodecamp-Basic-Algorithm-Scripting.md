title: freecodecamp算法题解系列（一）--初级算法
show: true
date: 2016-02-28 17:08:49
tags: [javascript,算法，字符串]
categories: [技术人生]
---
#### 背景
> 好记性不如烂笔头。

[freecodecamp](http://www.freecodecamp.com/)是一个开源社区项目，提供免费的在线编程学习训练，主要以前端为主。完成相应的内容还可以获得freecodecamp颁发的电子认证，该电子认证在领英上还可以像普通学历一样作为一项个人的教育经历。
不过，freecodecamp最近频繁的更新导致用户体验反而不如之前好了：现在所有你做过的题目都一股脑的放在了一起没有分类了。。以前会按照HTML、CSS、基础算法、中级算法、高级算法、后端等等分门别类一目了然。这些分类在未做题列表里还是这么分，做过的题也有标记，不过如果点进已经做过的题会发现之前的解决方案已经不再自动展现出来了。总之就是很麻烦，如果你想review的话。
如此这般就把做过的算法题作为博文梳理下吧，以便日后review巩固用法。

#### Basic Algorithm
本篇梳理基础算法，大多数都很简单，如果你有更好的方法欢迎分享，毕竟我的算法水平真的很烂。。梳理只是自己备忘，如果不幸有大神来看过，板砖轻拍。

###### 1. [Reverse a String](http://www.freecodecamp.com/challenges/reverse-a-string)
> Reverse the provided string.
You may need to turn the string into an array before you can reverse it.
Your result must be a string.

将给定字符串逆序输出
```js
function reverseString(str) {
    return str.split("").reverse().join("");
}

reverseString("hello");
```

<!--more-->

###### 2. [Factorialize a Number](http://www.freecodecamp.com/challenges/factorialize-a-number)
> Return the factorial of the provided integer.
If the integer is represented with the letter n, a factorial is the product of all positive integers less than or equal to n.
Factorials are often represented with the shorthand notation n!
For example: 5! = 1 * 2 * 3 * 4 * 5 = 120

输出给定数字的阶乘
```js
function factorialize(num) {
    if(num === 0)return 1;
    else {
        return num * factorialize(num - 1);
    }
}

factorialize(5);
```

###### 3. [Check for Palindromes](http://www.freecodecamp.com/challenges/check-for-palindromes)
> Return true if the given string is a palindrome. Otherwise, return false.
A palindrome is a word or sentence that's spelled the same way both forward and backward, ignoring punctuation, case, and spacing.

检查回文
```js
function palindrome(str) {
    var newStr1 = str.replace(/[\s\.,]/g,"").toLowerCase().replace(/[\(\)\-_:\\\/]/g,"");

    var newStr2 = str.replace(/[\s\.,]/g,"").toLowerCase().split("").reverse().join("").replace(/[\(\)\-_:\\\/]/g,"");
    return newStr1 == newStr2;
}

palindrome("eye");

```
这题需要注意的是，根据题目给出的tester case以及题干的提示，所有的非字母数字字符（标点，空格以及符号）都不影响回文串的判断。因此使用正则表达式先剔除无效字符再将每个字符逆序后与原串对比。

###### 4. [Find the Longest Word in a String](http://www.freecodecamp.com/challenges/find-the-longest-word-in-a-string)
> Return the length of the longest word in the provided sentence.

找出给定句子中最长的单词。
```js
function findLongestWord(str) {
    var tmp = str.split(" ");
    var len = 0;
    tmp.map(function(val){
        len = len < val.length ? val.length : len;
    });
    return len;
}

findLongestWord("The quick brown fox jumped over the lazy dog");
```

###### 5. [Title Case a Sentence](http://www.freecodecamp.com/challenges/title-case-a-sentence)
> Return the provided string with the first letter of each word capitalized. Make sure the rest of the word is in lower case.
For the purpose of this exercise, you should also capitalize connecting words like "the" and "of".

将给定词首字母大写，其他的小写。
```js
function titleCase(str) {
    var tmp = str.toLowerCase().split(" ");
    var res = "";
    tmp.map(function(val){
        var first = val.charAt(0);
        var preNew = val.replace(first,first.toUpperCase());
        res === undefined ? res = preNew + " " : res += preNew + " ";
    });
    return (res.replace(/\s$/,''));
}

titleCase("I'm a little tea pot");
titleCase("sHoRt AnD sToUt");
titleCase("HERE IS MY HANDLE HERE IS MY SPOUT");
```

###### 6. [Return Largest Numbers in Array](http://www.freecodecamp.com/challenges/return-largest-numbers-in-arrays)
> Return an array consisting of the largest number from each provided sub-array. For simplicity, the provided array will contain exactly 4 sub-arrays.

返回数组最大值，当然多维数组要返回数组，否则也太简单了
```js
function largestOfFour(arr) {
var ret = [];
for(var i=0,len=arr.length;i<len;i++){
    var max = arr[i][0];
    for(var j=0,len2=arr[i].length;j<len2;j++){
        if(arr[i][j] > max){
            max = arr[i][j];
        }
        if(j == len2 - 1){
            ret.push(max);
        }
    }
}
return (ret);
}

largestOfFour([[13, 27, 18, 26], [4, 5, 1, 3], [32, 35, 37, 39], [1000, 1001, 857, 1]]);
```

###### 7. [Confirm the Ending ](http://www.freecodecamp.com/challenges/confirm-the-ending)
> Check if a string (first argument) ends with the given target string (second argument).

检查给定字串是否以给定目标字串结尾
```js
function end(str, target) {
    /*
    if(new RegExp(target + "$").test(str)){
        return true;
    }else return false;
    */
    var targetLen = target.length;
    if(str.substr(-targetLen) === target){
        return true;
    }else {
        return false;
    }
}
end("He has to give me a new name", "name");

```

###### 8. [Repeat a string repeat a string ](http://www.freecodecamp.com/challenges/repeat-a-string-repeat-a-string)
> Repeat a given string (first argument) num times (second argument). Return an empty string if num is a negative number.

以给定的次数重复指定字串
```js
function repeat(str, num) {
    if(num<0){
        return "";
    }else {
        var tmp="";
        for(var i=0;i<num;i++){
            tmp = tmp + str;
        }
        return (tmp);
    }
}
repeat("abc", 3);

```

###### 9. [Truncate a string](http://www.freecodecamp.com/challenges/truncate-a-string)
> Truncate a string (first argument) if it is longer than the given maximum string length (second argument). Return the truncated string with a "..." ending.

截断字符串
```js
function truncate(str, num) {
    if(str.length <= num){
        return str;
    }else {
        if(num > 3){
            num -= 3;
        }
        var truncted = str.substr(0,num);

        return truncted + "...";
    }
}

truncate("A-tisket a-tasket A green and yellow basket", 11);
```

###### 10. [Chunky Monkey](http://www.freecodecamp.com/challenges/chunky-monkey)
> Write a function that splits an array (first argument) into groups the length of size (second argument) and returns them as a two-dimensional array.

将指定数组按给定长度分割
```js
function chunk(arr, size) {
    var res = [];
    var tmp = [];
    for(var i=0,len=arr.length;i<len;i++){
        tmp.push(arr[i]);
        if((i+1)%size === 0 || i === len - 1){
            res.push(tmp);
            tmp = [];
        }
    }
return ( res );
}

chunk(["a", "b", "c", "d"], 2);
```

###### 11. [Slasher Flick](http://www.freecodecamp.com/challenges/slasher-flick)
> Return the remaining elements of an array after chopping off n elements from the head.
The head means the beginning of the array, or the zeroth index.

返回指定数组去除某些给定元素后的结果
```js
function slasher(arr, howMany) {
    if(howMany >= arr.length){
        return arr.slice(arr.length);
    }else {
        return arr.slice(-arr.length + howMany);
    }
}

slasher([1, 2, 3], 4);
```

###### 12. [Mutations](http://www.freecodecamp.com/challenges/mutations
> Return true if the string in the first element of the array contains all of the letters of the string in the second element of the array.

判断两个给定数组的包含关系
```js
function mutation(arr) {
    var first =  arr[0].toLowerCase(),
    sec = arr[1].toLowerCase();
    var cnt = 0;
    for(var i=0,len=sec.length;i<len;i++){
        if(first.indexOf(sec[i]) != -1){
            cnt ++;
        }
    }
    if(cnt === len){
        return true;
    }else {
        return false;
    }
}

mutation(["hello", "hey"]);
```

###### 13. [Falsy Bouncer](http://www.freecodecamp.com/challenges/falsy-bouncer)
> Remove all falsy values from an array.

去除数组所有假值
```js
function bouncer(arr) {
    return arr.filter(function(val){
        return val;
    });
}

bouncer([7, "ate", "", false, 9]);
bouncer([false, null, 0, NaN, undefined, ""]);
```

###### 14. [Seek and Destroy](http://www.freecodecamp.com/challenges/seek-and-destroy)
> You will be provided with an initial array (the first argument in the destroyer function), followed by one or more arguments. Remove all elements from the initial array that are of the same value as these arguments.

去除指定数组中包含给定参数的值
```js
function destroyer(arr) {
    var tmp = arguments[0];
    var newArr = [];
    for(var i=0,len = tmp.length;i<len;i++){
        var flag = false;
        for(var j=0,len2 = arguments.length - 1;j<=len2;j++){
            if(tmp[i] == arguments[j]) {
                flag = true;
            }
        }
        if(!flag){
            newArr.push(tmp[i]);
        }
    }

    return newArr;
}

destroyer([1, 2, 3, 1, 2, 3], 2, 3);

```

###### 15. [Where do I belong](http://www.freecodecamp.com/challenges/where-do-i-belong)
> Return the lowest index at which a value (second argument) should be inserted into an array (first argument) once it has been sorted.

查找给定参数待插入指定数组的索引位置
```js
function where(arr, num) {
    // Find my place in this sorted array.
    //1，先排序
    //2.找到插入位置
    //3.注意排序规则
    //4.注意边界条件
    var arr = arr.sort(function(a,b){
        return a - b;
    });
    for(var i=0,len=arr.length;i<len;i++){
        if(arr[i] < num)continue;
        else return i;
    }
    return arr.length;
}

where([40, 60], 50);
where([5, 3, 20, 3], 5);
```

###### 16. [Caesars Cipher](http://www.freecodecamp.com/challenges/caesars-cipher)
> One of the simplest and most widely known ciphers is a Caesar cipher, also known as a shift cipher. In a shift cipher the meanings of the letters are shifted by some set amount.

不多解释，实现凯撒密码解密加密的字符串
```js
function rot13(str) { 
    /*
    var inStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    var outStr = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm";
    var ret = [];
    var i=0,j=0,len = str.length,leng = outStr.length;
    for(i=0;i<len;i++){
        for(j=0;j<leng;j++){
            if(outStr[j] === str[i]){
                ret.push(inStr[j]);
                break;
            }
        }
        if(j === leng){
            ret.push(str[i]);
        }
    }
    return ret.join("");
    */
}
// Change the inputs below to test
rot13("SERR PBQR PNZC");
```
以上方法采用了穷举密码对，看起来有点"蠢笨"，但其实是很好的一种方法。只是用了穷举映射但还是避免不了要循环查找相应地性能并没有多少提升。
按照题干提示的采用`String API`的方式，可以如下解决：
```js
function rot13(str) { // LBH QVQ VG!
    var ret = [];
    for(var i = 0,len=str.length;i<len;i++){
        if(/\w/.test(str[i])) {       
            var t = str[i].charCodeAt() + 13
            //根据题干的要求，密文的范围在大写字母内，90为"Z"的ASCII码，13为凯撒13密码的加密方法：平移13位
            t = t > 90 ? (str[i].charCodeAt() - 13 : t; 
            ret.push(String.fromCharCode(t));
        }else{
            ret.push(str[i]);
        }
    }
    return ret.join("");
}

// Change the inputs below to test
console.log(rot13("SERR PBQR PNZC"));
```

初级算法都比较简单，基本上利用String的API就解决了。
