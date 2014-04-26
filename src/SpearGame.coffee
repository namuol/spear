cg = require 'cg'
Spear = require 'Spear'
Boat = require 'Boat'
Shadow = require 'Shadow'
Crosshair = require 'Crosshair'

class SpearGame extends cg.Scene
  constructor: ->
    super
    cg.physics.gravity.zero()
    @reset()

  reset: ->
    @clearChildren()

    @addChild new cg.SpriteActor
      texture: 'bg'

    for i in [0..12]
      @addChild new Shadow
        x: cg.rand cg.width
        y: cg.rand 60, cg.height

    @boat = @addChild new Boat
      id: 'boat'
      x: 50
      y: cg.height - 40

    @crosshair = @addChild new Crosshair

  update: ->
    super

module.exports = SpearGame
