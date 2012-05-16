fs       = require('fs')
jsdom    = require('jsdom')
html     = fs.readFileSync('./spec/fixtures/browser.html').toString()
document = jsdom.jsdom(html)
window   = document.createWindow()
$        = require('jQuery').create(window)

# Adds a SCRIPT tag to the document fixture
addScript = (path) ->
  data   = fs.readFileSync(path).toString()
  txt    = document.createTextNode data
  script = document.createElement 'script'
  script.appendChild txt
  document.head.appendChild script


addScript './lib/jquery.barcode_input.js'
addScript './node_modules/jwerty/jwerty.js'
addScript './vendor/jquery-throttle-debounce/jquery.ba-throttle-debounce.min.js'

describe 'Barcode Input', ->
  it 'should load', -> expect( window.BC ).toBeTruthy()
  it 'should load jwerty', -> expect( window.jwerty ).toBeTruthy()
  it 'should load Debounce', -> expect( window.jQuery.debounce ).toBeTruthy()
