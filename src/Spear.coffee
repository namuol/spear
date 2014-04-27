cg = require 'cg'
Splash = require 'Splash'
Physical = require 'plugins/physics/Physical'

class Spear extends cg.SpriteActor
  @plugin Physical
  constructor: (properties) ->
    super properties
    @texture = 'spear'
    @anchor.x = 0.5
    @anchor.y = 0.5
    @aiming = true
    @addClass 'spear'
    @crosshair = cg('#crosshair')
    @boat = cg('#boat')

    @once cg.input, 'mouseUp', ->
      m = (new cg.math.Vector2).set(@crosshair)
      @aiming = false
      marker = cg('#main').addChild new cg.SpriteActor
        texture: 'crosshair'
        x: @crosshair.x
        y: @crosshair.y
        anchor:
          x: 0.5
          y: 0.5

      marker.tween 'rotation', Math.PI * 2, 1000, 'linear'

      @tween
        duration: (@vecTo(m).len()/100) * 250
        values:
          x: m.x
          y: m.y
          anchorX: 1
        easeFunc: 'back.in'
      .then ->
        cg.stage.addChild new Splash
          x: m.x
          y: m.y
        @tween
          duration: 250
          values:
            anchorX: 0.5
            scaleX: 1
            x: '-8'
          easeFunc: 'quad.out'
      .then ->
        # @destroy()
        @floating = true
        @floatY = @y
        @body.width = @width
        @body.height = @height*3
        @pivot.x = -@width/2
        @pivot.y = -@height/2
        marker.destroy()
    @t = 0

  update: ->
    super
    @t += cg.dt_seconds
    if @aiming
      @rotation = @vecTo(@crosshair).angle()
      @scale.x = 0.6666 + 0.3333 * Math.abs Math.cos @rotation
      @x = @boat.x + 6
      @y = @boat.y - 9 + @boat.sprite.y
    else if @floating
      @rotation = 0.1 * Math.sin @t * 2
      @y = @floatY + 3*Math.cos @t * 2

      if @touches @boat
        @destroy()
        ++@boat.spearCount
module.exports = Spear
