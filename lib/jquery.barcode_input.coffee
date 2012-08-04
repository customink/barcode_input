doc        = @document
jwerty     = @jwerty
$          = @jQuery
debounce   = @Cowboy or $.debounce
selector   = '[data-barcode-input]'
rate_limit = 50
buffer     = []

isBarcodeInput = (el) -> el.hasAttribute and el.hasAttribute('data-barcode-input')

# Don't register the keystroke for other focusable elements.
hasCorrectFocus = (e) ->
  target = e.target
  return true if target == doc      # Target is the Document
  return true if target == doc.body # Target is the Document Body

# Debounced notification function
notify = debounce( rate_limit, (eventType, code) -> $(selector).trigger "#{eventType}.barcode", code )

# Parses keypresses into a barcode
parse = (e) ->
  if hasCorrectFocus(e)
    keyCode = e.keyCode

    # Normalize the Numpad numeric keys
    keyCode = keyCode - 48 if keyCode >= 96 and keyCode <= 105

    char = String.fromCharCode keyCode

    buffer.push char

    notify 'insert', buffer.join('')

# PRIVATE: Directly resets the buffer
reset = ->
  buffer = []
  $(selector).val('')

# Clears the buffer
clear = (e) ->
  if ( hasCorrectFocus(e) or isBarcodeInput( e.target) ) and buffer.length > 0
    reset()

    notify 'cleared', buffer.join('')

# Indicates that a barcode has been entered
load = (e) ->
  if hasCorrectFocus(e) or isBarcodeInput( e.target )
    # If there is nothing in the buffer, check for an input value.
    # The user may have pasted it in.
    buffer = e.target.value.split('') if buffer.length == 0

    if buffer.length > 0
      e.preventDefault()

      # TODO: Add test for trimming
      code = buffer.join('').replace( /\W/g, '' )

      notify 'entered', code

      reset()

change = (e) ->
  buffer = e.target.value.split('')

  if buffer.length > 0
    notify 'insert', buffer.join('')

jwerty.key '[0-9]/[num-0-num-9]', parse
jwerty.key 'esc',   clear
jwerty.key 'enter', load

$(document).on 'keyup', selector, change
