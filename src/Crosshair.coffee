cg = require 'cg'

class Crosshair extends cg.SpriteActor
  constructor: (properties) ->
    super properties
    @texture = 'crosshair'
    @anchorX = 0.5
    @anchorY = 0.5
    @boat = cg('#boat')

  update: ->
    super
    if @boat.spearCount > 0
      @alpha = 1
    else
      @alpha = 0.5
    t = @boat.turbulence()
    m = (new cg.math.Vector2).set(@boat).add(@boat.vecToMouse())
    l = @boat.vecToMouse().len()
    @x = m.x + t*35*(l/100) * Math.sin @boat.t * 2
    @y = m.y + t*38*(l/100) * Math.cos @boat.t * 2.5

module.exports = Crosshair
