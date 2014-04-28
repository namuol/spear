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
      dur = (@vecTo(m).len()/100) * 250
      @delay dur*0.5, -> cg.sounds.shoot.play()
      @tween
        duration: dur
        values:
          x: m.x
          y: m.y
          anchorX: 1
        easeFunc: 'back.in'
      .then ->
        cg.stage.addChild new Splash
          spear: @
          x: m.x
          y: m.y
        @tween
          duration: 250
          values:
            anchorX: 0.5
            scaleX: 1
          easeFunc: 'quad.out'
      .then ->
        # @destroy()
        @floating = true
        @floatY = @y
        @body.width = 32
        @body.height = 32
        @pivot.x = -@width/2
        @pivot.y = -@height
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
        @floating = false
        @anchorX = 0.5
        @anchorY = 0.5
        @tween
          duration: 200
          values:
            scaleX: 0
            scaleY: 0
            anchorX: 0.5
            anchorY: 0.5
            x: @boat.x
            y: @boat.y
          easeFunc: 'back.in'
        .then ->
          @destroy()
        totScore = 0
        for fish in @children
          cg.log fish.score
          totScore += fish.score
        if totScore != 0
          mult = @children.length
          cg('#main').score += totScore * mult

          cg('#main').addChild(new cg.Text ''+totScore + 'x' + mult,
            x: @boat.x
            y: @boat.y - 20
          ).delay 500, ->
            @tween 'alpha', 0
            .then ->
              @destroy()

        cg.sounds.pickup.play()

        ++@boat.spearCount

module.exports = Spear
