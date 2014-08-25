MinimapSymbolsView = require './minimap-symbols-view'

module.exports =
  active: false
  views: {}

  configDefaults:
    grammars: [
      'source.coffee'
      'source.javascript'
      'source.ruby'
      'source.python'
    ]
    preventOverlappingLabels: true

  isActive: -> @active

  activate: (state) ->
    minimapPackage = atom.packages.getLoadedPackage('minimap')
    return @deactivate() unless minimapPackage?

    @minimap = require minimapPackage.path
    return @deactivate() unless @minimap.versionMatch('2.x')

    @minimap.registerPlugin 'symbols', this

  deactivate: ->
    @minimap.unregisterPlugin 'symbols'
    @minimap = null

  activatePlugin: ->
    return if @active

    @active = true

    @subscription = @minimap.eachMinimapView ({view}) =>
      pluginView = new MinimapSymbolsView(view)
      @views[view.editor.id] = pluginView

      pluginView.attach()

      view.editor.once 'destroyed', =>
        pluginView.destroy()
        delete @views[view.editor.id]

  deactivatePlugin: ->
    return unless @active

    @active = false
    @destroyViews()
    @subscription.off()

  destroyViews: ->
    view.destroy() for id,view of @views
    @views = {}
