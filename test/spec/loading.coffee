describe 'ENTER to load', ->
  describe 'with no numbers entered', ->
    it 'should not fire an event', ->
      called = false

      new Sandbox().ready ->
        @$input.one 'entered.barcode', -> called = true

        @press_key( 'enter' )
        .then ->
          expect( called ).to.equal false          



  describe 'with numbers entered via non-Keypress events', ->
    it 'should provide the entered value', (done) ->
      new Sandbox().ready ->
        @$input.one 'entered.barcode', (e, code) =>
          expect( code ).to.equal '123'

          done()

        @$input.val 123 # Fake a paste action.

        @press_key 'enter', on:@input



  describe 'with numbers entered', ->
    it 'should clear the value from the INPUT', (done) ->
      new Sandbox().ready ->
        @$input.one 'entered.barcode', (e, code) =>
          expect( @$input.val() ).to.equal ''

          done()

        @press_key '1',      on:@input
        @press_key 'enter',  on:@input



  describe 'with two sets of numbers entered', ->
    it 'should clear its buffer between sets', (done) ->
      new Sandbox().ready ->
        @press_key '1'
        @press_key( 'enter' )
        .then =>
          @$input.one 'entered.barcode', (e, code) =>
            expect( code ).to.equal '2'

            done()

          @press_key '2'
          @press_key 'enter'



  describe 'on an element inside a FORM', ->
    it "should prevent the FORM's submit event", (done) ->
      new Sandbox().ready ->
        @press_key '1'

        called = false
        @$input.one 'keypress', -> called = true

        @press_key( 'enter', on:@input )
        .then ->
          expect( called ).to.equal false

          done()

