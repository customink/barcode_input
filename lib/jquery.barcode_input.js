/*global jwerty */
;(function(win, jwerty) {
  // TODO: Detect jwerty and debounce
  var debounce = win.Cowboy || win.jQuery.debounce,
      $ = win.jQuery,
      selector = 'input[data-barcode-input]';

  var hasCorrectFocus = function(e) {
    var target   = e.target,
        isWindow = target === win.document,
        isBody   = target === win.document.body,
        isInput  = target.getAttribute && target.getAttribute('data-barcode-input');

    // Don't register the keystroke for other focusable elements.
    return ( isWindow || isBody || isInput );
  };

  var notify = function(eventType) {
    $(selector).trigger( eventType + '.barcode' );
  };

  // build string
  var concat = function(e) {
    if( hasCorrectFocus(e) ) {
      notify('input');
    }
  };

  var clear = function(e) {
    if( hasCorrectFocus(e) ) {
      notify('cleared');
    }
  };

  var load = function(e) {
    if( hasCorrectFocus(e) ) {
      notify('entered');
    }
  };

  jwerty.key('[0-9]/[num-0-num-9]', concat);
  jwerty.key('esc',   clear);
  jwerty.key('enter', load);

}(window, jwerty));