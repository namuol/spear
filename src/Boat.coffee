cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'

class Boat extends cg.SpriteActor
  @plugin Physical, Interactive

  constructor: (properties) ->
    super properties
    @texture = 'boat'
    @startY = @y
    @t = 0
    @anchorX = 0.5
    @anchorY = 0.5

  update: ->
    super
    @t += cg.dt_seconds
    @y = @startY + 5 * Math.sin @t * 3
    @rotation = 0.1 * Math.cos @t * 3

module.exports = Boat
