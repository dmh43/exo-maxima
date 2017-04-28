document.addEventListener("DOMContentLoaded", function(event) {
  document.onkeyup = function (event) {
    if (event.keyCode === 13) { submit(); }
  }
})

function submit () {
  var expression = document.getElementById('maxima-expression').value,
      xhr = new XMLHttpRequest(),
      displayElem = document.getElementById('result-display');
  xhr.open("POST", '/maxima', true);
  xhr.setRequestHeader("Content-type", "application/json");
  xhr.onreadystatechange = function() {
    if(xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
      displayElem.value = xhr.responseText;
    }
  }
  xhr.send('{"expression": "' + expression + '"}');
}
