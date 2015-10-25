// you need to load this before the document is ready for it to be available
// to the input field above
var dimLights = function(name, value) {
  $.get('/lights/dim/' + name + '/' + value);
}
