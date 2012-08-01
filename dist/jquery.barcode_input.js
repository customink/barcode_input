/*! jQuery Barcode Input - v0.1.4.alpha.2 - 2012-08-01
* https://github.com/customink/barcode_input
* Copyright (c) 2012 Derek Lindahl; Licensed MIT, GPL */

(function() {
  var $, buffer, change, clear, debounce, doc, hasCorrectFocus, isBarcodeInput, jwerty, load, notify, parse, rate_limit, reset, selector;

  doc = this.document;

  jwerty = this.jwerty;

  $ = this.jQuery;

  debounce = this.Cowboy || $.debounce;

  selector = '[data-barcode-input]';

  rate_limit = 50;

  buffer = [];

  isBarcodeInput = function(el) {
    return el.hasAttribute && el.hasAttribute('data-barcode-input');
  };

  hasCorrectFocus = function(e) {
    var target;
    target = e.target;
    if (target === doc) {
      return true;
    }
    if (target === doc.body) {
      return true;
    }
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
    buffer = [];
    return $(selector).val('');
  };

  clear = function(e) {
    if ((hasCorrectFocus(e) || isBarcodeInput(e.target)) && buffer.length > 0) {
      reset();
      return notify('cleared', buffer.join(''));
    }
  };

  load = function(e) {
    var code;
    if (hasCorrectFocus(e) || isBarcodeInput(e.target)) {
      if (buffer.length === 0) {
        buffer = e.target.value.split('');
      }
      if (buffer.length > 0) {
        e.preventDefault();
        code = buffer.join('').replace(/\W/g, '');
        notify('entered', code);
        return reset();
      }
    }
  };

  change = function(e) {
    buffer = e.target.value.split('');
    if (buffer.length > 0) {
      return notify('input', buffer.join(''));
    }
  };

  jwerty.key('[0-9]/[num-0-num-9]', parse);

  jwerty.key('esc', clear);

  jwerty.key('enter', load);

  $(document).on('keyup', selector, change);

}).call(this);
