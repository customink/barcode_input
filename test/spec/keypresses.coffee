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



  describe 'triggered on focusable non-input elements', ->
    it 'should detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0', on:@window.document.getElementById 'anchor_tag'



  describe 'triggered on content editable elements', ->
    it 'should not detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> called = true

        editor = @window.document.getElementById 'editor'

        @press_key( '0', on:editor )
        .then ->
          expect( called ).to.equal false
          done()



  describe 'triggered on disabled content editable elements', ->
    it 'should detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0', on:@window.document.getElementById 'non_editor'

  describe 'triggered on button elements', ->
    it 'should detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0', on:@window.document.getElementById 'button'

  describe 'triggered on button-type input elements', ->
    it 'should detect them', (done) ->
      called = false

      new Sandbox().ready ->
        @$input.one 'insert.barcode', -> done()

        @press_key '0', on:@window.document.getElementById 'button_inputs'