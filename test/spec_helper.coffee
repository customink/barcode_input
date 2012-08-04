# Miliseconds to wait to account for event debouncing
rate_limit = 60

# Creates an Event for the given document, on the given element, that contains
# the given keycode.
key_event = (type, keyCode, target, doc) ->
  e = doc.createEvent 'Event'

  e.initEvent type, true, true, target, 0,0,0,0, 0, keyCode
  e.keyCode  = keyCode
  e.shiftKey = false
  e.ctrlKey  = false
  e.altKey   = false
  e.metaKey  = false

  e


# Creates a sandbox with which to run the tests against
class Sandbox
  window : null
  input  : null

  constructor : ->
    dfd = new jQuery.Deferred()

    dfd.promise @

    @ready = @done

    iframe       = document.createElement 'iframe'
    iframe.src   = 'about:blank'
    iframe.id    = +new Date()
    iframe.style.display = 'none'
    $iframe      = $(iframe)

    document.body.appendChild iframe
    @window = iframe.contentWindow

    $iframe.on 'load', =>
      @$input = iframe.contentWindow.$('#input')
      @input  = @$input[0]
      dfd.resolveWith @

    @window.document.open 'text/html', 'replace'
    @window.document.write $('#contextTmpl').val()
    @window.document.close()

  # Simulates a keyboard event
  #
  # key     - A string that represents the key to press.
  #           Supports 'esc', 'enter', and 'backspace' special characters.
  # options - An object to specificy additional config options
  #
  #           `on` - Indicates an HTMLElement to trigger the event on.
  #
  # Returns a jQuery.Deferred instance so that additional steps can be performed
  # after the event has been debounced by Barcode Input
  press_key : ( key, options = {} ) ->
    dfd    = new jQuery.Deferred()

    doc    = @window.document
    target = options.on || doc

    # Numpad keys
    key = key.replace('num-','').charCodeAt() + 48 if /num-\d/.test(key)

    keyCode = if (typeof key) == 'number' then key else key.charCodeAt()
    switch key
      when 'esc'
        keyCode = 27
        key = ''
      when 'enter'
        keyCode = 13
        key = ''
      when 'backspace'
        keyCode = 8
        key = ''

    # Resolve the promise after the debounce delay
    setTimeout (-> dfd.resolveWith(@) ), rate_limit

    evt = key_event 'keydown', keyCode, target, doc
    return dfd unless target.dispatchEvent evt

    evt = key_event 'keypress', keyCode, target, doc
    return dfd unless target.dispatchEvent evt

    unless key == ''
      if target.hasAttribute and target.hasAttribute('data-barcode-input')
        if target.tagName == 'INPUT'
          $(target).val  $(target).val() + key
        else
          $(target).html $(target).html() + key

    evt = key_event 'keyup', keyCode, target, doc
    target.dispatchEvent evt

    dfd
