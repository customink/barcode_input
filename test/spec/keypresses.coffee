describe 'Keypresses', ->
  describe 'triggered on the barcode input', ->
    it 'should detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0', on:@input



  describe 'triggered on the document', ->
    it 'should detect them', (done) ->
      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0'



  describe 'triggered on the body', ->
    it 'should detect them', (done) ->
      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0', on:@window.document.body



  describe 'triggered on non-barcode inputs', ->
    it 'should not detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> called = true

        nonInput = @window.document.getElementById 'nonInput'

        @press_key( '0', on: nonInput )
        .then ->
          expect( called ).to.equal false

          done()



  describe 'triggered on non-barcode textareas', ->
    it 'should not detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> called = true

        textarea = @window.document.getElementById 'textarea'

        @press_key( '0', on:textarea )
        .then ->
          expect( called ).to.equal false
          done()

