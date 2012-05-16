fs       = require('fs')
jsdom    = require('jsdom')
html     = fs.readFileSync('./spec/fixtures/browser.html').toString()
document = jsdom.jsdom(html)
window   = document.createWindow()
$        = require('jQuery').create(window)

# Provide JSDom with access to the console.
window.console = console

# Adds a SCRIPT tag to the document fixture
addScript = (path) ->
  data   = fs.readFileSync(path).toString()
  txt    = document.createTextNode data
  script = document.createElement 'script'
  script.appendChild txt
  document.head.appendChild script

press_key = (key, options = {} ) ->
  ret = document.createEvent('Event')

  keyCode = key.charCodeAt() unless (typeof key) == 'number'
  keyCode = 27 if key == 'esc'

  ret.initEvent 'keydown', true, true
  ret.keyCode  = keyCode       || 65
  ret.shiftKey = options.shift || false
  ret.ctrlKey  = options.ctrl  || false
  ret.altKey   = options.alt   || false
  ret.metaKey  = options.meta  || false
  dom          = options.on    || document

  dom.dispatchEvent( ret )

addScript './node_modules/jwerty/jwerty.js'
addScript './vendor/jquery-throttle-debounce/jquery.ba-throttle-debounce.min.js'
addScript './lib/jquery.barcode_input.js'

####
# Event Spying form https://github.com/jandudulski/jasmine-jquery/blob/master/lib/jasmine-jquery.js

( (namespace) ->
  data = {
    spiedEvents: {},
    handlers:    []
  };

  namespace.events = {
    spyOn: (selector, eventName) ->
      handler = (e) -> data.spiedEvents[[ $(selector), eventName]] = e

      $(selector).bind eventName, handler
      data.handlers.push handler
    ,
    wasTriggered: (selector, eventName) -> !!(data.spiedEvents[[selector, eventName]])
    ,
    cleanUp: ->
      data.spiedEvents = {}
      data.handlers    = []

  }
)(jasmine)

spyOnEvent = (selector, eventName) -> jasmine.events.spyOn selector, eventName

beforeEach ->
  this.addMatchers({
    toHaveBeenTriggeredOn: (selector) ->
      @message = ->
        [
          "Expected event #{@actual} to have been triggered on #{selector}",
          "Expected event #{@actual} not to have been triggered on #{selector}"
        ]
      jasmine.events.wasTriggered( $(selector), @actual )
  })




####


describe 'Barcode Input', ->
  beforeEach -> @input = '[data-barcode-input]'
  afterEach ->  jasmine.events.cleanUp()

  describe 'keypresses', ->
    beforeEach ->
      @event = 'input.barcode'

    describe 'triggered on the barcode input', ->
      beforeEach ->
        spyOnEvent @input, @event
        press_key '0', on:document.getElementById('input')

      it 'should detect them', -> expect( @event ).toHaveBeenTriggeredOn( @input )
        
    describe 'triggered on the document', ->
      beforeEach ->
        spyOnEvent @input, @event
        press_key '0'

      it 'should detect them', -> expect( @event ).toHaveBeenTriggeredOn( @input )

    describe 'triggered on the body', ->
      beforeEach ->
        spyOnEvent @input, @event
        press_key '0', on:document.body

      it 'should detect them', -> expect( @event ).toHaveBeenTriggeredOn( @input )

    describe 'triggered on non-barcode inputs', ->
      beforeEach ->
        spyOnEvent @input, @event

        press_key '0', on:document.getElementById('nonInput')

      it 'should not detect them', -> expect( @event ).not.toHaveBeenTriggeredOn( @input )

    describe 'triggered on non-barcode textareas', ->
      beforeEach ->
        spyOnEvent @input, @event

        press_key '0', on:document.getElementById('textarea')

      it 'should not detect them', -> expect( @event ).not.toHaveBeenTriggeredOn( @input )

  describe 'ESC', ->
    beforeEach ->
      spyOnEvent @input, 'cleared.barcode'
      press_key 'esc'

    it 'should clear the buffer', -> expect( 'cleared.barcode' ).toHaveBeenTriggeredOn( @input )
  # describe 'ENTER', ->
  #   it 'should trigger an entry event', ->
  # describe 'Number Keys', ->
  #   it 'should trigger an input event', ->
  # describe 'Number Pad Keys', ->
  #   it 'should trigger an input event', ->


