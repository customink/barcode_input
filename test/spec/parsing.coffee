describe 'Parsing', ->
  describe 'Number Keys', ->
    it 'should trigger an insert event', (done) ->
      new Sandbox().ready ->
        @$input.one 'insert.barcode', (e, code) ->
          expect( code ).to.equal '9'

          done()

        @press_key '9'


  describe 'Number Pad Keys', ->
    it 'should trigger an input event', (done) ->
      new Sandbox().ready ->
        @$input.one 'insert.barcode', (e, code) ->
          expect( code ).to.equal '5'

          done()

        @press_key 'num-5'