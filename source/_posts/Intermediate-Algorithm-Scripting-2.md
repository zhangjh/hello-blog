title: freecodecamp算法题解系列（三）--中级算法（11-21）
show: true
date: 2016-03-23 11:19:29
tags: [javascript,算法，字符串,freecodecamp]
categories: [技术人生]
---

#### Intermediate Algorithm
承接[上篇](/2016/03/23/Intermediate-Algorithm-Scripting/)，本篇继续总结freecodecamp中级算法的第11-21题。

###### 11. [Convert HTML Entities](https://www.freecodecamp.com/challenges/convert-html-entities)
> Convert the characters &, <, >, " (double quote), and ' (apostrophe), in a string to their corresponding HTML entities.
将HTML的特殊字符转义

```js
function convert(str) {
    // &colon;&rpar;
    return str.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\"/g,"&quot;").replace(/\'/g,"&apos;");
}

convert("Hamburgers < Pizza < Tacos");

```

<!--more-->

###### 12. [Spinal Tap Case](https://www.freecodecamp.com/challenges/spinal-tap-case)
> Convert a string to spinal case. Spinal case is all-lowercase-words-joined-by-dashes.

字符串格式变换，将给定的字符串用"-"连接起来。

```js
function spinalCase(str) {
    // "It's such a fine line between stupid, and clever."
    // --David St. Hubbins
    //return str.toLowerCase().replace(/[^a-zA-Z]/g," ").replace(/\s/g,'-');
    if(!/[^a-zA-Z]/.test(str) && str.indexOf(" ") === -1){
        var res = "";
        for(var i=0,len=str.length;i<len;i++){
            if(/[A-Z]/.test(str[i])){
                var tmp = " " + str[i];
                res += tmp;
            }else {
                res += str[i];
            }
        }
        str = res;
    }
      
    return str.toLowerCase().replace(/[^a-zA-Z]/g," ").replace(/\s/g,'-');
}

spinalCase('This Is Spinal Tap');
spinalCase("thisIsSpinalTap") ;
spinalCase("The_Andy_Griffith_Show");
```

###### 13. [Sum All Odd Fibonacci Numbers](https://www.freecodecamp.com/challenges/sum-all-odd-fibonacci-numbers)
> Return the sum of all odd Fibonacci numbers up to and including the passed number if it is a Fibonacci number.

求和给定参数内的所有奇Fibonacci数的和。Fibonacci数是后一个数字等于前两个数字和的形式的数列。

```js
/* 递归方式
 * function fibNums(num){
       //返回所有小于num的fib数
       if(num <= 2){
           return 1;
       }else {
           return fibNums(num-2) + fibNums(num-1);
       }
 }*/
 function fibNums(num){
       //非递归方式
       var tmp = [1,1];
       if(num <=2){
           return 1;
       }
       for(var i=3;i<=num;i++){
           var t = tmp[0] + tmp[1];
           tmp[1] = tmp[0];
           tmp[0] = t;
       }
       return tmp[0];
 }

 //求小于num的fibnacci数
 function sumFibs(num){
     var sum = 0;
     for(var i=1;fibN = fibNums(i), fibN <= num;i++){
         if(fibN %2){
             sum += fibN;
         }
     }
     return sum;
 }



 sumFibs(1000);

```

###### 14. [Sum All Primes](https://www.freecodecamp.com/challenges/sum-all-primes)
> Sum all the prime numbers up to and including the provided number.

求和给定参数内的所有素数。

```js
function isPrime(num){
      var sum = 0;
      for(var i=2;i<=Math.sqrt(num);i++){
          sum += i;
          if(num % i === 0){
                return false;
          }
      }
      return true;
}

//后续算法改进
function sumPrimes(num) {
      var sum = 0;
      for(var i=2;i<=num;i++){
          if(isPrime(i)){
              sum += i;
          }
      }
      return sum;
}


sumPrimes(10);

```

###### 15. [Smallest Common Multiple](https://www.freecodecamp.com/challenges/smallest-common-multiple)
> Find the smallest common multiple of the provided parameters that can be evenly divided by both, as well as by all sequential numbers in the range between these parameters.

给定一个参数数组，返回数组序列内所有数字的最小公倍数。如给定[1,5]，则需要返回"1,2,3,4,5"的最小公倍数。

```js
function smallestCommon(m,n){
      var max = m > n ? m : n;
      for(var i=max;;i+=max){
          if((i%m === 0) && (i%n === 0)){
                return i;
          }
      }
}

//分治给出数组的最小公倍数
function divide2solve(arr){
      if(arr.length === 1 ){
          return smallestCommon(1,arr[0]);
      }
      var mid = arr.length / 2;
      var left = arr.slice(0,mid);
      var right = arr.slice(mid);
      var leftCommon = divide2solve(left);
      var rightCommon = divide2solve(right);
      return smallestCommon(leftCommon,rightCommon);
}

function smallestCommons(arr) {
      var res = [];
      var start = arr[0] < arr[1] ? arr[0] : arr[1],
          end = arr[0] < arr[1] ? arr[1] : arr[0];
      for(;start <= end;start++){
          res.push(start);
      }
      return divide2solve(res);
}

smallestCommons([1,5]);

```

###### 16. [Finders Keepers](https://www.freecodecamp.com/challenges/finders-keepers)
> Create a function that looks through an array (first argument) and returns the first element in the array that passes a truth test (second argument).

给定两个参数，第一个参数是一个数组，第二个参数是一个测试函数，算法需要返回满足该测试函数的第一个数组元素。

```js
function find(arr, func) {
      var res = arr.filter(func);
      if(res.length){
          return res[0];
      }
      return undefined;
}


find([1, 2, 3, 4], function(num){ return num % 2 === 0; });
find([1, 3, 5, 8, 9, 10], function(num) { return num % 2 === 0; });

```

###### 17. [Drop it](https://www.freecodecamp.com/challenges/drop-it)
> Drop the elements of an array (first argument), starting from the front, until the predicate (second argument) returns true.

给定两个参数，第一个参数是一个数组，第二个参数是一个测试函数，算法需要以数组形式弹出满足测试函数的数组元素。

```js
function drop(arr, func) {
      // Drop them elements.
      var tmp;
      var res = [];
      for(var i=0,len=arr.length;i<len;i++){
          tmp = arr.shift();
          if(func(tmp)){
            //需要置回弹出的元素
            arr.unshift(tmp);
            break;
          }
      }
      
      return arr;
}

drop([1, 2, 3], function(n) {return n < 3; });
drop([1, 2, 3, 5], function(n) {return n > 5;});
```

###### 18. [Steamroller](https://www.freecodecamp.com/challenges/steamroller)
> Flatten a nested array. You must account for varying levels of nesting.

"Steamroller",压路机，很形象，将一个嵌套多层的数组扁平化，亦即接受多层嵌套的数组，输出无嵌套数组，且输出数组的元素为输入嵌套的数组元素。

```js
function steamroller(arr, flatArr) {
  if (!flatArr)    flatArr = [];

  for (var i in arr) {
    if(!Array.isArray(arr[i])){
      flatArr.push(arr[i]);
    }else {
      steamroller(arr[i],flatArr);
    }
   
  }

  return flatArr;
}

steamroller([1, [2], [3, [[4]]]]);
```

###### 19. [Binary Agents](https://www.freecodecamp.com/challenges/binary-agents)
> Return an English translated sentence of the passed binary string.

翻译给定的二进制串，给定一串01串，输出表示的句子。

```js
function trans(str){
  var sum =0;
  for(var i=0,len=str.length;i<len;i++){
    (function (index){
        sum += str[index] * Math.ceil(str[index] * Math.pow(2,len-1-index));
    })(i);
  }
  return sum;
}


function binaryAgent(str) {
  var res = "";
  var arr = str.split(" ");
  for(var i in arr){
    var ret = trans(arr[i]);
    res += String.fromCharCode(ret);
  }
  return res;
}

binaryAgent("01000001 01110010 01100101 01101110 00100111 01110100 00100000 01100010 01101111 01101110 01100110 01101001 01110010 01100101 01110011 00100000 01100110 01110101 01101110 00100001 00111111");
//binaryAgent("01000001");
```

###### 20. [Everything Be True](https://www.freecodecamp.com/challenges/everything-be-true)
> Check if the predicate (second argument) is truthy on all elements of a collection (first argument).

给定两个参数，第一个参数是一个对象数组，第二个参数是一个字符串，算法需要判断参数1的对象数组是否都有参数2对应的key且对应的value值为true。

```js
function every(collection,pre){
  for(var i in collection){
    if(!collection[i][pre]){
      return false;
    }
  }
  return true;
}

//every([{"user": "Tinky-Winky", "sex": "male"}, {"user": "Dipsy", "sex": "male"}, {"user": "Laa-Laa", "sex": "female"}, {"user": "Po", "sex": "female"}], "sex");
every([{"user": "Tinky-Winky", "sex": "male", "age": 0}, {"user": "Dipsy", "sex": "male", "age": 3}, {"user": "Laa-Laa", "sex": "female", "age": 5}, {"user": "Po", "sex": "female", "age": 4}], "age");
```

###### 21. [Arguments Optional](https://www.freecodecamp.com/challenges/arguments-optional)
> Create a function that sums two arguments together. If only one argument is provided, then return a function that expects one argument and returns the sum.

js可选参数问题，题干要求求和给定的两个参数，如果只给定了一个参数，则返回一个可以再接收一个参数进行求和的函数。

```js
function isNum(val){
  return typeof val === "number";
}

function add(x) {
  if(arguments.length == 1){
    if(!isNum(x)){
      return undefined;
    }
    return function(y){
      if(!isNum(y)){
        return undefined;
      }
      return x + y;
    };
  }
  if(!isNum(arguments[1])){
    return undefined;
  }
  return arguments[0] + arguments[1];
}

add(2)([3]);

```
