cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Fish = require 'Fish'

class Splash extends cg.Actor
  init: ->
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
    fishes = []
    for shadow in cg('shadow') by -1
      if @touches shadow
        shadow.destroy()
        shadow.fin?.destroy()
        fishes.push new Fish
          shadow: shadow

    for fish,i in fishes
      fish.x = ((@spear.width*0.5)/fishes.length)*i
      fish.scaleX = fish.scaleY = 0
      fish.tween
        values:
          scaleX: 1
          scaleY: 1
        delay: i*80
        easeFunc: 'elastic.out'
      fish.delay i*80, -> cg.sounds.whoosh.play()
      @spear.addChild fish

    @spear.children.reverse()

Splash.plugin Physical

module.exports = Splash
