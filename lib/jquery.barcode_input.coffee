doc        = @document
jwerty     = @jwerty
$          = @jQuery
selector   = '[data-barcode-input]'
rate_limit = 50
buffer     = []

# From http://coffeescriptcookbook.com/chapters/functions/debounce
debounce = (func, threshold, execAsap) ->
  timeout = null
  (args...) ->
    obj = this
    delayed = ->
      func.apply(obj, args) unless execAsap
      timeout = null
    if timeout
      clearTimeout(timeout)
    else if execAsap
      func.apply(obj, args)
    timeout = setTimeout delayed, threshold || 100

isBarcodeInput = (el) -> el.hasAttribute and el.hasAttribute('data-barcode-input')

# Don't register the keystroke for other focusable elements.
hasCorrectFocus = (e) ->
  target = e.target

  # Target is a non-Barcode Input
  return false if $(target).is ':input:not(button)'

  # Target is an editable, non-input element
  if editable = target.getAttribute? 'contenteditable'
    return false if editable.toLowerCase() == 'true'

  true

# Debounced notification function
notify = debounce (eventType, code) ->
  $(selector).trigger "#{eventType}.barcode", code
, rate_limit

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
  elCanClear = hasCorrectFocus( e ) or isBarcodeInput( e.target )

  if buffer.length > 0 and elCanClear
    reset()

    notify 'cleared', buffer.join('')

# Indicates that a barcode has been entered
load = (e) ->
  if hasCorrectFocus(e) or isBarcodeInput( e.target )
    # If there is nothing in the buffer, check for an input value.
    # The user may have pasted it in.
    if buffer.length == 0
      value  = e.target.value
      buffer = value.split('') if value

    if buffer.length > 0
      e.preventDefault()

      # TODO: Add test for trimming
      code = buffer.join('').replace /\D/g, ''

      notify 'entered', code

      reset()

change = (e) ->
  # Ignore certain keys
  return if jwerty.is('enter/esc', e)

  buffer = e.target.value.split('')

  if buffer.length > 0
    notify 'insert', buffer.join('')

jwerty.key '[0-9]/[num-0-num-9]', parse
jwerty.key 'esc',   clear
jwerty.key 'enter', load

$(document).on 'keyup', selector, change
