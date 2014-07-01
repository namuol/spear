cg = require 'combo'
Physical = require 'plugins/physics/Physical'
Shark = require 'Shark'

SHARK_RATE = 0.2

class Shadow extends cg.Actor
  @plugin Physical

  init: ->
    @body.gravityScale = 0
    @texture = 'shadow'
    @addClass 'shadow'
    @height = 6
    @width = 40
    @body.v.x = cg.rand(10,50) * cg.rand([-1,1])
    @body.v.y = cg.rand(0,8) * cg.rand([-1,1])
    @body.bounds =
      top: cg.physics.bounds.top
      left: -cg.width
      right: cg.width*2
      bottom: cg.height*2
    @body.bounce = 1
    @body.height = @height*2
    @body.width = @width
    @alpha = 0
    @tween 'alpha', 0.25

    @isShark = cg.rand() < SHARK_RATE

    if @isShark
      @fin = cg('#main').addChild new Shark
        shadow: @


  destroy: ->
    super
    @fin?.destroy()

module.exports = Shadow
