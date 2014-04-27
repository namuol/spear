cg = require 'cg'

SCORE = [
  100  # bronze
  250  # silver
  1000 # gold
]

ODDS = [
  0,0,0,0,0
  1,1,1
  2
]

class Fish extends cg.SpriteActor
  constructor: (properties) ->
    super properties
    @type = cg.rand ODDS
    @texture = cg.sheets.fish[@type]
    @anchorX = 0.5
    @anchorY = 0.5
    @rotation = Math.PI/2 + cg.rand(-0.2,0.2)
    @flipX = cg.rand([true, false])
    @score = SCORE[@type]

  update: ->
    super

module.exports = Fish
