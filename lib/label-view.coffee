{View} = require 'atom'

module.exports =
class LabelView extends View
  @content: ->
    @div class: 'label label-default'

  initialize: (tag, position) ->
    @text tag
    @css position

  destroy: -> @remove()
