/*! jQuery Barcode Input - v0.4.0 - 2014-04-24
* https://github.com/customink/barcode_input
* Copyright (c) 2014 Derek Lindahl; Licensed MIT, GPL */

(function() {
  var $, buffer, change, clear, debounce, doc, hasCorrectFocus, isBarcodeInput, jwerty, load, notify, parse, rate_limit, reset, selector,
    __slice = [].slice;

  doc = this.document;

  jwerty = this.jwerty;

  $ = this.jQuery;

  selector = '[data-barcode-input]';

  rate_limit = 50;

  buffer = [];

  debounce = function(func, threshold, execAsap) {
    var timeout;
    timeout = null;
    return function() {
      var args, delayed, obj;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      obj = this;
      delayed = function() {
        if (!execAsap) {
          func.apply(obj, args);
        }
        return timeout = null;
      };
      if (timeout) {
        clearTimeout(timeout);
      } else if (execAsap) {
        func.apply(obj, args);
      }
      return timeout = setTimeout(delayed, threshold || 100);
    };
  };

  isBarcodeInput = function(el) {
    return el.hasAttribute && el.hasAttribute('data-barcode-input');
  };

  hasCorrectFocus = function(e) {
    var editable, target;
    target = e.target;
    if ($(target).is(':input:not(button)')) {
      return false;
    }
    if (editable = typeof target.getAttribute === "function" ? target.getAttribute('contenteditable') : void 0) {
      if (editable.toLowerCase() === 'true') {
        return false;
      }
    }
    return true;
  };

  notify = debounce(function(eventType, code) {
    return $(selector).trigger("" + eventType + ".barcode", code);
  }, rate_limit);

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
