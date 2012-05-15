fs       = require('fs')
jsdom    = require('jsdom')
html     = fs.readFileSync('./spec/fixtures/browser.html').toString()
document = jsdom.jsdom(html)
window   = document.createWindow()
$        = require('jQuery').create(window)

# Adds a SCRIPT tag to the document fixture
addScript = (path) ->
  s = document.createElement 'script'
  s.innerHTML = fs.readFileSync(path).toString()
  document.head.appendChild s


addScript './lib/jquery.barcode_input.js'
# addScript('./vendor/debounce')

describe 'Barcode Input', ->
  it 'should load', -> expect( window.BC ).toBeTruthy()
