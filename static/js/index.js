document.addEventListener("DOMContentLoaded", function(event) {
  document.onkeyup = function (event) {
    if (event.keyCode === 13) { submit(); }
  }
})

function formatParams (params) {
  return "?" + Object
    .keys(params)
    .map(function(key){
      return key+"="+encodeURIComponent(params[key])
    })
    .join("&")
}

function symbolicRoute (symbolic) {
  if (symbolic) return '/symbolic'
  else return ''
}

function submit () {
  var expression = document.getElementById('maxima-expression').value,
      symbolic = document.getElementById('symbolic').checked,
      xhr = new XMLHttpRequest(),
      displayElem = document.getElementById('result-display'),
      endpoint = '/maxima' + symbolicRoute(symbolic) + formatParams({expression: expression});
  xhr.open("GET", endpoint, true);
  xhr.onload = function() {
    if(xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
      displayElem.value = xhr.responseText;
    }
  }
  xhr.send();
}
