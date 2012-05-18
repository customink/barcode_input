/*! jQuery Barcode Input - v0.1.0 - 2012-05-17
* https://github.com/dlindahl/barcode_input
* Copyright (c) 2012 Derek Lindahl; Licensed MIT, GPL */

(function() {
  var $, buffer, clear, debounce, doc, hasCorrectFocus, jwerty, load, notify, parse, rate_limit, reset, selector;

  doc = this.document;

  jwerty = this.jwerty;

  $ = this.jQuery;

  debounce = this.Cowboy || $.debounce;

  selector = '[data-barcode-input]';

  rate_limit = 50;

  buffer = [];

  hasCorrectFocus = function(e) {
    var isBody, isInput, isWindow, target;
    target = e.target;
    isWindow = target === doc;
    isBody = target === doc.body;
    isInput = target.getAttribute && target.getAttribute('data-barcode-input');
    return isWindow || isBody || isInput;
  };

  notify = debounce(rate_limit, function(eventType, code) {
    return $(selector).trigger("" + eventType + ".barcode", code);
  });

  parse = function(e) {
    var char, keyCode;
    if (hasCorrectFocus(e)) {
      keyCode = e.keyCode;
      if (keyCode >= 96 && keyCode <= 105) {
        keyCode = keyCode - 48;
      }
      char = String.fromCharCode(keyCode);
      buffer.push(char);
      return notify('input', buffer.join(''));
    }
  };

  reset = function() {
    return buffer = [];
  };

  clear = function(e) {
    if (hasCorrectFocus(e) && buffer.length > 0) {
      reset();
      return notify('cleared', buffer.join(''));
    }
  };

  load = function(e) {
    if (hasCorrectFocus(e) && buffer.length > 0) {
      notify('entered', buffer.join(''));
      return reset();
    }
  };

  jwerty.key('[0-9]/[num-0-num-9]', parse);

  jwerty.key('esc', clear);

  jwerty.key('enter', load);

}).call(this);
