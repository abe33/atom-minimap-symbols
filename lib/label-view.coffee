{View} = require 'atom'

module.exports =
class LabelView extends View
  @content: ->
    @div class: 'label label-default'

  initialize: (@tag, @position) ->

  attach:(view) ->
    view.append(this)
    @text @tag
    @css top: (@position.top - @height()) + 'px'

  destroy: -> @remove()
