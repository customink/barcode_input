/*global jwerty */
;(function(win, jwerty) {
  // TODO: Detect jwerty and debounce
  var debounce   = win.Cowboy || win.jQuery.debounce,
      $          = win.jQuery,
      selector   = 'input[data-barcode-input]',
      rate_limit = 50,
      buffer     = [];

  var hasCorrectFocus = function(e) {
    var target   = e.target,
        isWindow = target === win.document,
        isBody   = target === win.document.body,
        isInput  = target.getAttribute && target.getAttribute('data-barcode-input');

    // Don't register the keystroke for other focusable elements.
    return ( isWindow || isBody || isInput );
  };

  var notify = debounce( rate_limit, function(eventType) {
    $(selector).trigger( eventType + '.barcode', buffer.join('') );
  });

  // build string
  var concat = function(e) {
    if( hasCorrectFocus(e) ) {
      var c,
          keyCode = e.keyCode;

      // Normalize the Numpad numeric keys
      if( keyCode >= 96 && keyCode <= 105) {
        keyCode = keyCode - 48;
      }

      c = String.fromCharCode( keyCode );

      buffer.push( c );

      notify('input');
    }
  };

  var clear = function(e) {
    if( hasCorrectFocus(e) && buffer.length > 0 ) {
      buffer = [];

      notify('cleared');
    }
  };

  var load = function(e) {
    if( hasCorrectFocus(e) && buffer.length > 0 ) {
      notify('entered');
    }
  };

  jwerty.key('[0-9]/[num-0-num-9]', concat);
  jwerty.key('esc',   clear);
  jwerty.key('enter', load);

}(window, jwerty));