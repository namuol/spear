cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'

class Crosshair extends cg.SpriteActor
  @plugin Physical, Interactive

  constructor: (properties) ->
    super properties
    @texture = 'crosshair'
    @anchorX = 0.5
    @anchorY = 0.5

  update: ->
    super
    @x = cg.input.mouse.x
    @y = cg.input.mouse.y

module.exports = Crosshair
