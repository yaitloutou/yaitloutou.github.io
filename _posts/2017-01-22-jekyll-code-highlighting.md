---
title: Jekyll code highlighing
---

```javascript
function order(words){
  var array = words.split(' ');
  var result = array.slice();

  for (word in array) {
    for (var i = 0; i < array[word].length; i++) {
       if (!isNaN(array[word][i])) {
         result[array[word][i] - 1] = array[word]
       }
     }
   }return result.join(' ');
}
```
