cg = require 'cg'
Physical = require 'plugins/physics/Physical'

class Splash extends cg.SpriteActor
  @plugin Physical

  constructor: (properties) ->
    super properties
    @texture = 'splash'
    @width = 10
    @height = 10
    @alpha = 1
    @body.gravityScale = 0
    @body.offset.x = -4
    @body.offset.y = -4
    @body.width = @width
    @body.height = @height
    @body.bounded = false
    @delay 20, ->
      @destroy()
  update: ->
    super
    if shadow = @touches cg('shadow')
      shadow.destroy()

module.exports = Splash
