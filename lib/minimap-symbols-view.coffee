_ = require 'underscore-plus'
{View} = require 'atom'
LabelView = require './label-view'
TagGenerator = null


module.exports =
class MinimapSymbolsView extends View
  @content: ->
    @div class: 'minimap-symbols'

  initialize: (@minimapView) ->
    @views = []

    @subscribe @minimapView.editor, 'path-changed grammar-changed', =>
      @subscribeToBuffer()
    @subscribe atom.config.observe 'editor.fontSize', callNow: false, =>
      @subscribeToBuffer()
    @subscribe atom.config.observe 'minimap-symbols.grammars', callNow: false, =>
      @subscribeToBuffer()

    @subscribeToBuffer()

  attach: ->
    @minimapView.miniOverlayer.append(this)

  destroy: ->
    @detach()

  unsubscribeFromBuffer: ->
    @destroyViews()
    if @buffer?
      @unsubscribe(@buffer)
      @buffer = null

  subscribeToBuffer: ->
    @unsubscribeFromBuffer()

    if @symbolizeCurrentGrammar()
      @buffer = @minimapView.editor.getBuffer()
      @subscribe @buffer, 'saved', =>
        @updateViews()

      @updateViews()

  createViews: (tags) ->
    for {name, position} in tags
      screenPosition = @minimapView.editor.screenPositionForBufferPosition(position)
      screenPosition = @minimapView.pixelPositionForScreenPosition(position)

      view = new LabelView(name, screenPosition)
      view.attach(this)
      @views.push(view)

  destroyViews: ->
    view.destroy() for view in @views
    @views = []

  updateViews: ->
    @destroyViews()
    @generateTags().then (tags) =>
      @createViews(tags)

  generateTags: ->
    new Promise (resolve, reject) =>
      unless TagGenerator?
        symbolsPath = atom.packages.getLoadedPackage('symbols-view')?.path
        TagGenerator = require "#{symbolsPath}/lib/tag-generator" if symbolsPath?

      new TagGenerator(@getPath(), @getScopeName()).generate().done (tags) =>
        resolve(tags)

  symbolizeCurrentGrammar: ->
    grammar = @getScopeName()
    console.log atom.config.get('minimap-symbols.grammars'), grammar
    _.contains(atom.config.get('minimap-symbols.grammars'), grammar)

  getPath: -> @minimapView.editor.getPath()

  getScopeName: -> @minimapView.editor.getGrammar().scopeName
