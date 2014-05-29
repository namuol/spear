cg = require 'cg'
Splash = require 'Splash'
Fish = require 'Fish'
Physical = require 'plugins/physics/Physical'

class Spear extends cg.Actor
  texture: 'spear'
  init: ->
    @topHalf = @addChild new cg.Actor
      texture: 'spear'
      anchor:
        x: 0.5
        y: 0.5
    m = @addChild new cg.gfx.Graphics
    m.beginFill()
    m.drawRect 0,0, @width/2, @height
    m.endFill()
    m.x = -@width/2
    m.y = -@height/2
    @topHalf.mask = m

    @anchor.x = 0.5
    @anchor.y = 0.5
    @aiming = true
    @addClass 'spear'
    @crosshair = cg('#crosshair')
    @boat = cg('#boat')
    @body.offset.x = -@width/2
    @body.offset.y = -@height/2

    @once cg.input, 'mouseUp', ->
      m = (new cg.math.Vector2).set(@crosshair)
      @aiming = false
      marker = cg('#main').addChild new cg.Actor
        texture: 'crosshair'
        x: @crosshair.x
        y: @crosshair.y
        anchor:
          x: 0.5
          y: 0.5

      marker.tween 'rotation', Math.PI * 2, 1000, 'linear'
      @boat.body.v.$add(@vecTo(m).mag(-45))
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
        cg('#main').addChild new Splash
          spear: @
          x: m.x
          y: m.y
        @tween
          duration: 150
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
        @body.offset.x = -16
        @body.offset.y = -16

        marker.destroy()
    @t = 0

  update: ->
    @t += cg.dt_seconds
    if @aiming
      @origRotation = @rotation = @vecTo(@crosshair).angle()
      @scale.x = 0.6666 + 0.3333 * Math.abs Math.cos @rotation
      @x = @boat.x + 6
      @y = @boat.y - 15 + @boat.person.y
    else if @floating
      @rotation = @origRotation + 0.1 * Math.sin @t * 2
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
        mult = 0
        for fish in @children when fish instanceof Fish
          totScore += fish.score
          ++mult
        if totScore != 0
          cg('#main').score += totScore * mult

          cg('#main').addChild(new cg.Text ''+totScore + 'x' + mult,
            x: @boat.x
            y: @boat.y
            align: 'center'
            alpha: 0
            scale:
              x: 0
              y: 0
          ).tween
            values:
              y: '-20'
              alpha: 1
              'scale.x': 1
              'scale.y': 1
            duration: 500
            easeFunc: 'elastic.out'
          .then ->
            @delay 750
          .then ->
            @hide 500
          .then ->
            @destroy()

        cg.sounds.pickup.play()

        ++@boat.spearCount

Spear.plugin Physical

module.exports = Spear
