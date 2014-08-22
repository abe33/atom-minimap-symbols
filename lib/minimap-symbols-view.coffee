{View} = require 'atom'
LabelView = require './label-view'
TagGenerator = null

module.exports =
class MinimapSymbolsView extends View
  @content: ->
    @div class: 'minimap-symbols'

  initialize: (@minimapView) ->
    @views = []
    @generateTags()

  attach: ->
    @minimapView.miniOverlayer.append(this)

  destroy: ->
    @detach()

  createViews: (tags) ->
    for {name, position} in tags
      screenPosition = @minimapView.editor.screenPositionForBufferPosition(position)
      screenPosition = @minimapView.pixelPositionForScreenPosition(position)

      view = new LabelView(name, top: screenPosition.top + 'px')
      console.log this
      @append(view)

  removeViews: ->
    view.destroy() for view in @views
    @views = []

  generateTags: ->
    unless TagGenerator?
      symbolsPath = atom.packages.getLoadedPackage('symbols-view')?.path
      TagGenerator = require "#{symbolsPath}/lib/tag-generator" if symbolsPath?

    new TagGenerator(@getPath(), @getScopeName()).generate().done (tags) =>
      @removeViews()
      @createViews(tags)

  getPath: -> @minimapView.editor.getPath()

  getScopeName: -> @minimapView.editor.getGrammar()?.scopeName
