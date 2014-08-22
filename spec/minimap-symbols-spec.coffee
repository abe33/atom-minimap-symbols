path = require 'path'
{WorkspaceView} = require 'atom'
MinimapSymbols = require '../lib/minimap-symbols'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MinimapSymbols", ->
  describe 'when the grammar of the buffer match the settings', ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView
      atom.project.setPath(path.join(__dirname, 'fixtures'))
      atom.config.set 'minimap-symbols.grammars', ['text.plain.null-grammar']

      waitsForPromise -> atom.workspaceView.open('sample.coffee')

      runs ->
        atom.workspaceView.simulateDomAttachment()
        editorView = atom.workspaceView.getActiveView()
        editorView.find('.lines').css('line-height', '14px')
        editorView.height(50)

      waitsForPromise ->
        atom.packages.activatePackage('symbols-view')
        atom.packages.activatePackage('minimap')

      runs ->
        atom.workspaceView.trigger 'minimap:toggle'

      waitsForPromise ->
        atom.packages.activatePackage('minimap-symbols')

    afterEach ->
      atom.workspaceView.trigger 'minimap:toggle'

    describe "with an open editor that have a minimap", ->
      it "creates and attaches the view to the minimap", ->
        expect(atom.workspaceView.find('.minimap .minimap-symbols')).toExist()

      it "parses and creates markers for each symbol in the buffer", ->
        items = null
        waitsFor ->
          items = atom.workspaceView.find('.minimap-symbols .label')
          items.length > 0

        runs ->
          expect(items.length).toEqual(3)

  describe 'when the grammar of the buffer does not match the settings', ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView
      atom.project.setPath(path.join(__dirname, 'fixtures'))
      atom.config.set 'minimap-symbols.grammars', ['source.coffee']

      waitsForPromise -> atom.workspaceView.open('sample.coffee')

      runs ->
        atom.workspaceView.simulateDomAttachment()
        editorView = atom.workspaceView.getActiveView()
        editorView.find('.lines').css('line-height', '14px')
        editorView.height(50)

      waitsForPromise ->
        atom.packages.activatePackage('symbols-view')
        atom.packages.activatePackage('minimap')

      runs ->
        atom.workspaceView.trigger 'minimap:toggle'

      waitsForPromise ->
        atom.packages.activatePackage('minimap-symbols')

    afterEach ->
      atom.workspaceView.trigger 'minimap:toggle'

    describe "with an open editor that have a minimap", ->
      it "creates and attaches the view to the minimap", ->
        expect(atom.workspaceView.find('.minimap .minimap-symbols')).toExist()

      it "parses and creates markers for each symbol in the buffer", ->
        runs ->
          expect(atom.workspaceView.find('.minimap-symbols .label').length).toEqual(0)
