title: freecodecamp算法题解系列（二）--中级算法（1-10）
show: true
date: 2016-03-23 10:34:08
tags: [javascript,算法，字符串,freecodecamp]
categories: [技术人生]
---

#### Intermediate Algorithm
[戳此处查看前一篇基础算法](http://www.5941740.cn/2016/02/28/freecodecamp%E7%AE%97%E6%B3%95%E9%A2%98%E8%A7%A3%E7%B3%BB%E5%88%97%EF%BC%88%E4%B8%80%EF%BC%89-Basic-Algorithm-Scripting/)

###### 1. [Sum All Numbers in a Range](https://www.freecodecamp.com/challenges/sum-all-numbers-in-a-range)
> We'll pass you an array of two numbers. Return the sum of those two numbers and all numbers between them.
The lowest number will not always come first.

求和给定数组约束范围内的所有数字

```javascript
function getMaxMin(arr,op){
  if(op === "max"){
      return Math.max.apply(null,arr);
  }else {
      return Math.min.apply(null,arr);
  }
 
}

function sumAll(arr) {
  var sum = 0;
  var min = getMaxMin(arr,"min");
  var max = getMaxMin(arr,"max");
  for(var i=min;i<=max;i++){
    sum += i;
  }
  return sum;
}

sumAll([1, 4]);
```

<!--more-->

###### 2. [Diff Two Arrays](https://www.freecodecamp.com/challenges/diff-two-arrays)
> Compare two arrays and return a new array with any items only found in one of the two given arrays, but not both. In other words, return the symmetric difference of the two arrays.

求两个给定数组的diff
```js
function diff(arr1, arr2) {
  var newArr = [];
  /*
    var tmpall = arr1.concat(arr2);
    for(var i=0,len=tmpall.length;i<len;i++){
      if(arr1.indexOf(tmpall[i]) != -1){
        //存在1里不存在2里
        if(arr2.indexOf(tmpall[i]) == -1){
          newArr.push(tmpall[i]);
        }
      }else {
        if(arr2.indexOf(tmpall[i]) != -1){
          newArr.push(tmpall[i]);
        }
      }
    }
    */
  
    arr1.filter(function(val){
        if(arr2.indexOf(val) == -1){
          newArr.push(val);
        }
    });

    arr2.filter(function(val){
        if(arr1.indexOf(val) == -1 && newArr.indexOf(val) == -1){
          newArr.push(val);
        }
    });
  return newArr;
}

diff(["andesite", "grass", "dirt", "pink wool", "dead shrub"], ["diorite", "andesite", "grass", "dirt", "dead shrub"]);
//diff([3,4,5],[3,4,5,6]);
//diff([1, 2, 3, 5], [1, 2, 3, 4, 5]);
```

###### 3. [Roman Numeral Converter](https://www.freecodecamp.com/challenges/roman-numeral-converter)
> Convert the given number into a roman numeral.

将给定数字转化为罗马数字

```js
function convert(num){
        var tmp = num;
        //按位数做罗马数字-整数的映射
        var romanNum = [["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" ],[ "", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC" ],[ "", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM" ],[ "", "M", "MM", "MMM", "", "", "", "", "", "", "" ]];
        var ret = [];
        var i = 0;
        //求总位数
        while(tmp){
                i ++;
                tmp = parseInt(tmp / 10);
        }
        var j = 0;
        while(num && j < i){
                ret.push(romanNum[j][num % 10]);
                num = parseInt(num / 10);
                j++;
        }
        return ret.reverse().join("");
}
convert(12);
```

###### 4. [Where art thou](https://www.freecodecamp.com/challenges/where-art-thou)
> Make a function that looks through an array of objects (first argument) and returns an array of all objects that have matching property and value pairs (second argument). Each property and value pair of the source object has to be present in the object from the collection if it is to be included in the returned array.

参数1给定一个若干对象构成的数组，参数2给定一个对象，算法需要从参数1中查找匹配参数2对象的所有对象并以数组形式输出。
```js
function where(collection, source) {
  var arr = [];
  // What's in a name?
  var orikey = "",
      orivalue = "";
  for(var key in source){
        orikey = key;
        orivalue = source[key];
  }
  for(var i=0,len=collection.length;i<len;i++){
        for(var key in collection[i]){
                if(key === orikey && orivalue === collection[i][key]){
                        arr.push(collection[i]);
                }
        }
  }
  return arr;
}

//where([{ first: "Romeo", last: "Montague" }, { first: "Mercutio", last: null }, { first: "Tybalt", last: "Capulet" }], { last: "Capulet" });


where([{ "a": 1 }, { "a": 1 }, { "a": 1, "b": 2 }], { "a": 1 });
```

###### 5. [Search and Replace](https://www.freecodecamp.com/challenges/search-and-replace)
> Perform a search and replace on the sentence using the arguments provided and return the new sentence.
First argument is the sentence to perform the search and replace on.
Second argument is the word that you will be replacing (before).
Third argument is what you will be replacing the second argument with (after).

执行查找和替换，将句子(参数1)中出现的词(参数2)用另一个(参数3)替换

```js
function isFirstUpper(str){
  return /^[A-Z]/.test(str);
}

function firstToUpper(str){
  return str.replace(/^[a-z]/,function(v){
    return v.toUpperCase();
  });
}

function myReplace(str, before, after) {
    //判断待替换的单词是否是首字母大写，如果是则将替换的置为首字母大写
    if(isFirstUpper(before)){
      after = firstToUpper(after);
    }
    return (str.replace(before,after));
}

myReplace("He is Sleeping on the couch", "Sleeping", "sitting"); 
//myReplace("Let us go to the store", "store", "mall");

```

###### 6. [Pig Latin](https://www.freecodecamp.com/challenges/pig-latin)
> Translate the provided string to pig latin.
将给定字符串翻译成"pig latin"形式。pig latin就是一个将单词形变的小游戏：将单词第一个字母移动到最后并添加"ay"结尾，如果单词以元音开头，则添加"way"结尾。

```js
function translate(str) {
  //遍历单词字符串，找到第一个元音字符，将其之前的字符暂存
  //然后将暂存字符搬到字符串最后并加上"ay"，如果存串为空，则直接加上"way"
        var vowel = ['a','e','i','o','u'];
        var tmp = [];
        for(var i=0,len=str.length;i<len;i++){
                if(vowel.indexOf(str[i].toLowerCase()) != -1){
                        break;
                }else {
                        tmp.push(str[i]);
                }
        }
        if(i === 0){
                return (str + "way");
        }else {
                return(str.substr(i).concat(tmp.join("")) + "ay");

        }
}

translate("alifornia");

```

###### 7. [DNA Pairing](https://www.freecodecamp.com/challenges/dna-pairing)
> The DNA strand is missing the pairing element. Take each character, get its pair, and return the results as a 2d array.

DNA配对，DNA的配对形如"AT,CG"模式，亦即出现字母"A"则给之以"T"配对，以此类推。

```js
function pair(str) {
  var map = {
    "A": "T",
    "T": "A",
    "C": "G",
    "G": "C"
  };
  var arr = [];
  for(var i=0,len=str.length;i<len;i++){
    var value = map[str[i].toUpperCase()];
    arr.push([str[i],value]);
  }
 return arr;
}

pair("GCG");
```

###### 8. [Missing letters](https://www.freecodecamp.com/challenges/missing-letters)
> Find the missing letter in the passed letter range and return it.
If all letters are present in the range, return undefined.

查找并返回给定字符序列中缺失的字母，如"bcdef"应返回"a"。
```js
function fearNotLetter(str) {
  var arr = [];
  for(var i=0,len=str.length;i<len;i++){
    //均先转为小写字母后转为数字，起始为0
    var tmp = str[i].toLowerCase().charCodeAt(0) - 97;
    arr.push(tmp);
  }
  for(var j=0,len2=arr.length,k=arr[j];j<len2;j++){
          if(k != arr[j]){
                //console.log(arr[j]);
                return String.fromCharCode(arr[j] + 97 -1 );
          }
          k++;
  }
}


fearNotLetter("bcd");
//fearNotLetter("abcdefghjklmno");
```

###### 9. [Boo who](https://www.freecodecamp.com/challenges/boo-who)
> Check if a value is classified as a boolean primitive. Return true or false.

这个不知道为什么会算到中级里来，简直简单的发指。

```js
function boo(bool) {
  // What is the new fad diet for ghost developers? The Boolean.
  return typeof bool === "boolean";
}

boo(null);

```

###### 10. [Sorted Union](https://www.freecodecamp.com/challenges/sorted-union)
> Write a function that takes two or more arrays and returns a new array of unique values in the order of the original provided arrays.
In other words, all values present from all arrays should be included in their original order, but with no duplicates in the final array.
The unique numbers should be sorted by their original order, but the final array should not be sorted in numerical order.

接收若干数组参数，返回所有不重复的数组元素并按接收参数的顺序排列。

```js
function unite() {
  if(arguments.length === 1){
    return arguments[0];
  }
  var arr = [],
      res = [];
  for(var i=0,len=arguments.length;i<len;i++){
    arr = arguments[i];
    for(var j=0;j<arr.length;j++){
      //如果结果数组中不存在该值则放入数组
      if(res.indexOf(arr[j]) === -1){
        res.push(arr[j]);
      }
    }
  }
  return res;
}

unite([1, 3, 2], [5, 2, 1, 4], [2, 1]);
```

中级算法这个系列一共有21道题，为了避免博文篇幅过长，将中级算法系列分成两篇总结，此篇总结1-10题，[下一篇总结11-21题](/2016/03/23/Intermediate-Algorithm-Scripting-2/)。
欢迎留言探讨，共同学习进步。
