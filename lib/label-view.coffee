{View} = require 'atom'

module.exports =
class LabelView extends View
  @content: ->
    @div class: 'label highlight-info'

  initialize: (@tag, @position) ->

  attach:(view) ->
    view.append(this)
    @text @tag
    @css top: (@position.top - @height()) + 'px'

  destroy: -> @remove()
