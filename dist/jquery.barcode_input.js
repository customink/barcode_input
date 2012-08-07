/*! jQuery Barcode Input - v0.2.0 - 2012-08-03
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
    var editable, target;
    target = e.target;
    if ($(target).is(':input')) {
      return false;
    }
    if (editable = typeof target.getAttribute === "function" ? target.getAttribute('contenteditable') : void 0) {
      if (editable.toLowerCase() === 'true') {
        return false;
      }
    }
    return true;
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
      return notify('insert', buffer.join(''));
    }
  };

  reset = function() {
    buffer = [];
    return $(selector).val('');
  };

  clear = function(e) {
    var elCanClear;
    elCanClear = hasCorrectFocus(e) || isBarcodeInput(e.target);
    if (buffer.length > 0 && elCanClear) {
      reset();
      return notify('cleared', buffer.join(''));
    }
  };

  load = function(e) {
    var code, value;
    if (hasCorrectFocus(e) || isBarcodeInput(e.target)) {
      if (buffer.length === 0) {
        value = e.target.value;
        if (value) {
          buffer = value.split('');
        }
      }
      if (buffer.length > 0) {
        e.preventDefault();
        code = buffer.join('').replace(/\D/g, '');
        notify('entered', code);
        return reset();
      }
    }
  };

  change = function(e) {
    if (jwerty.is('enter/esc', e)) {
      return;
    }
    buffer = e.target.value.split('');
    if (buffer.length > 0) {
      return notify('insert', buffer.join(''));
    }
  };

  jwerty.key('[0-9]/[num-0-num-9]', parse);

  jwerty.key('esc', clear);

  jwerty.key('enter', load);

  $(document).on('keyup', selector, change);

}).call(this);
