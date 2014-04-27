cg = require 'cg'
Spear = require 'Spear'
Boat = require 'Boat'
Shadow = require 'Shadow'
Crosshair = require 'Crosshair'

class SpearGame extends cg.Scene
  constructor: ->
    super
    cg.physics.gravity.zero()
    cg.physics.bounds.top = 55
    cg.input.map 'boat',
      horiz: ['a/d', 'left/right']
      vert: ['w/s', 'up/down']
    @reset()

  reset: ->
    @removeChildren()  if @children.length > 0

    @addChild new cg.SpriteActor
      texture: 'bg'

    water = @addChild new cg.Actor
      id: 'water'

    for i in [0..12]
      water.addChild new Shadow
        x: cg.rand cg.width
        y: cg.rand 60, cg.height

    @boat = @addChild new Boat
      id: 'boat'
      x: 50
      y: cg.height - 40
    @crosshair = @addChild new Crosshair
      id: 'crosshair'

    @on cg.input, 'mouseDown', ->
      if @boat.spearCount > 0
        @addChild new Spear
        --@boat.spearCount
  update: ->
    super

module.exports = SpearGame
