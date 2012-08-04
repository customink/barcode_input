describe 'ESC to clear', ->
  describe 'with no numbers entered', ->
    it 'should not fire an event', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'cleared.barcode', -> called = true

        @press_key( 'esc' )
        .then ->
          expect( called ).to.equal false

          done()



  describe 'with numbers entered', ->
    it 'should clear the buffer', (done) ->
      new Sandbox().ready ->
        @$input.one 'cleared.barcode', (e, code) =>
          expect( code ).to.equal ''

          done()

        @press_key '1'
        @press_key 'esc'



  describe 'with numbers entered on the input', ->
    it 'should clear the buffer', (done) ->
      new Sandbox().ready ->
        @$input.one 'cleared.barcode', (e, code) =>
          expect( code ).to.equal ''

          done()

        @press_key '1',   on:@input
        @press_key 'esc', on:@input
