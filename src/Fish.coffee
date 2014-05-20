cg = require 'cg'

SCORE = [
  100  # bronze
  250  # silver
  1000 # gold
  1000 # shark
]

ODDS = [
  0,0,0,0,0
  1,1,1
  2
]

class Fish extends cg.Actor
  init: ->
    @anchorX = 0.5
    @anchorY = 0.5
    if @shadow.isShark
      @type = 3
      @texture = 'shark'
    else
      @type = cg.rand ODDS
      @texture = cg.sheets.fish[@type]
    @score = SCORE[@type]
    @rotation = Math.PI/2 + cg.rand(-0.2,0.2)
    @flipX = cg.rand([true, false])

  update: ->

module.exports = Fish
