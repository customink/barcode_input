fs        = require('fs')
jsdom     = require('jsdom')
jQueryLib = require('jQuery')

####
# Event Spying form https://github.com/jandudulski/jasmine-jquery/blob/master/lib/jasmine-jquery.js

addEventSpies = (namespace) ->
  data = {
    spiedEvents: {},
    handlers:    []
  };

  namespace.events = {
    spyOn: (selector, eventName) ->
      handler = (args...) -> data.spiedEvents[[ $(selector), eventName]] = args

      $(selector).one eventName, handler
      data.handlers.push handler
    ,
    wasTriggered: (selector, eventName) -> !!(data.spiedEvents[[selector, eventName]])
    ,
    cleanUp: ->
      data.spiedEvents = {}
      data.handlers    = []

  }
addEventSpies(jasmine)

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

# Adds a SCRIPT tag to the document fixture
addScript = (document, path) ->
  data   = fs.readFileSync(path).toString()
  txt    = document.createTextNode data
  script = document.createElement 'script'
  script.appendChild txt
  document.head.appendChild script

press_key = (key, options = {} ) ->
  ret = document.createEvent('Event')

  # Numpad keys
  key = key.replace('num-','').charCodeAt() + 48 if /num-\d/.test(key)

  keyCode = if (typeof key) == 'number' then key else key.charCodeAt()
  keyCode = 27 if key == 'esc'
  keyCode = 13 if key == 'enter'

  ret.initEvent 'keydown', true, true
  ret.keyCode  = keyCode       || 65
  ret.shiftKey = options.shift || false
  ret.ctrlKey  = options.ctrl  || false
  ret.altKey   = options.alt   || false
  ret.metaKey  = options.meta  || false
  dom          = options.on    || document

  dom.dispatchEvent( ret )

html     = fs.readFileSync('./spec/fixtures/browser.html').toString()
window   = document = $ = null
reload_browser = ->
  document  = jsdom.jsdom(html)
  window    = document.createWindow()
  $         = jQueryLib.create(window)

  # Provide JSDom with access to the console.
  window.console = console

  addScript document, './node_modules/jwerty/jwerty.js'
  addScript document, './vendor/jquery-throttle-debounce/jquery.ba-throttle-debounce.min.js'
  addScript document, './lib/jquery.barcode_input.js'

# Selector used to find the element we want to listen to.
bc_input = '#input'

describe 'Barcode Input', ->
  beforeEach -> reload_browser() and jasmine.events.cleanUp()

  describe 'Keypresses', ->
    beforeEach ->
      @event = 'input.barcode'

    describe 'triggered on the barcode input', ->
      beforeEach ->
        spyOnEvent bc_input, @event
        press_key '0', on:document.getElementById( bc_input )

      it 'should detect them', -> expect( @event ).toHaveBeenTriggeredOn( bc_input )
        
    describe 'triggered on the document', ->
      beforeEach ->
        spyOnEvent bc_input, @event
        press_key '0'

      it 'should detect them', -> expect( @event ).toHaveBeenTriggeredOn( bc_input )

    describe 'triggered on the body', ->
      beforeEach ->
        spyOnEvent bc_input, @event
        press_key '0', on:document.body

      it 'should detect them', -> expect( @event ).toHaveBeenTriggeredOn( bc_input )

    # TODO: This test cause later tests to pass when they should fail...
    # describe 'triggered on non-barcode inputs', ->
    #   beforeEach ->
    #     spyOnEvent @input, @event

    #     press_key '0', on:document.getElementById('nonInput')

    #   it 'should not detect them', -> expect( @event ).not.toHaveBeenTriggeredOn( @input )

    # TODO: This test cause later tests to pass when they should fail...
    # describe 'triggered on non-barcode textareas', ->
    #   beforeEach ->
    #     spyOnEvent @input, @event

    #     press_key '0', on:document.getElementById('textarea')

    #   it 'should not detect them', -> expect( @event ).not.toHaveBeenTriggeredOn( @input )



  describe 'ESC', ->
    beforeEach ->
      spyOnEvent bc_input, 'cleared.barcode'
      press_key 'esc'

    it 'should clear the buffer', -> expect( 'cleared.barcode' ).toHaveBeenTriggeredOn( bc_input )



  describe 'ENTER', ->
    beforeEach ->
      spyOnEvent bc_input, 'entered.barcode'
      press_key 'enter'

    it 'should trigger an entry event', -> expect( 'entered.barcode' ).toHaveBeenTriggeredOn( bc_input )



  describe 'Number Keys', ->
    beforeEach ->
      spyOnEvent bc_input, 'input.barcode'
      press_key '9'

    it 'should trigger an input event', -> expect( 'input.barcode' ).toHaveBeenTriggeredOn( bc_input )



  # If made to fail, this test can pass if the previous not.toHaveBeenTriggered tests are enabled...
  describe 'Number Pad Keys', ->
    beforeEach ->
      spyOnEvent bc_input, 'input.barcode'
      press_key 'num-5'

    it 'should trigger an input event', -> expect( 'input.barcode' ).toHaveBeenTriggeredOn( bc_input )




  # Simulate a manual entry by a human
  describe 'Entering a barcode slowly', -> 
    beforeEach ->
      @counter = 0
      @data    = []
      @handler = (e, data) =>
        @counter = @counter + 1
        @data.push data

      $(bc_input).on 'input.barcode', @handler

      spyOnEvent bc_input, 'input.barcode'

      press_key '1'
      waits 100
      press_key '2'
      waits 100
      press_key '3'
      waits 100

    it 'should trigger multiple input events', ->
      expect( 'input.barcode' ).toHaveBeenTriggeredOn( bc_input )
      expect( @counter ).toEqual(3)

    it 'should concat the inputs as they are entered', ->
      expect( @data ).toEqual([ '1','12','123' ])

