/*global jwerty */
;(function(win, jwerty) {
  // TODO: Detect jwerty and debounce
  var debounce = win.Cowboy || win.jQuery.debounce;
  var $ = win.jQuery;
  var input = $('[data-barcode-input]');

  var notify = function(eventType) {
    $(input).trigger( eventType + '.barcode' );
  };

  var concat = function(e) {
    // build string

    var target = e.target;
    var isInput = e.target.getAttribute && e.target.getAttribute('data-barcode-input');

    // Don't register the keystroke for other focusable elements.
    if( e.target === win.document || isInput ) {
      notify('input');
    }
  };

  jwerty.key('[0-9]/[num-0-num-9]', concat);

}(window, jwerty));