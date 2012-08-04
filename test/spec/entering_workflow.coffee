describe 'Entering workflow', ->
  describe 'with a barcode scanner', ->
    it 'should trigger a single input event', (done) ->
      counter = 0
      code    = null

      new Sandbox().ready ->
        @$input.one 'insert.barcode', (e, c) ->
          counter += 1
          code     = c

        @$input.one 'entered.barcode', (e, code) ->
          expect( counter ).to.equal 1
          expect( code ).to.equal '123'

          done()

        @press_key '1'
        @press_key '2'
        @press_key( '3' )
        .then =>
          @press_key 'enter'



  # Simulate a manual entry by a human
  describe 'with a keyboard', ->
    it 'should trigger multiple input events', (done) ->
      counter  = 0
      sequence = []
  
      new Sandbox().ready ->
        @$input.on 'insert.barcode', (e, code) ->
          counter += 1
          sequence.push code

        @press_key( '1' )
        .then =>
          @press_key( '2' )
          .then =>
            @press_key( '3' )
            .then =>
              expect( counter ).to.equal 3
              expect( sequence ).to.eql ['1', '12', '123' ]
              done()



  describe 'while editing', ->
    it 'should reset the barcode based on the INPUTs value', (done) ->
      sequence = ''

      new Sandbox().ready ->
        @$input.on 'insert.barcode', (e, code) ->
          sequence = code

        @press_key( '1', on:@input )
        .then =>
          @press_key( '2', on:@input )
          .then =>
            @press_key( '3', on:@input )
            .then =>
              @$input.val 1 # Simulates the editing the input value
              @press_key( 'backspace', on:@input )
              .then =>
                expect( sequence ).to.equal '1'

                done()
