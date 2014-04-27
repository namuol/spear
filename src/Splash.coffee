cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Fish = require 'Fish'

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
    fishes = []
    for shadow in cg('shadow') by -1
      if @touches shadow
        shadow.destroy()
        fishes.push new Fish

    for fish,i in fishes
      fish.x = ((@spear.width*.5)/fishes.length)*i
      @spear.addChild fish
      cg.log 'fish!' + i

module.exports = Splash
