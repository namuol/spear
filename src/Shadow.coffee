cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'

class Shadow extends cg.SpriteActor
  @plugin Physical, Interactive

  constructor: (properties) ->
    super properties
    @texture = 'shadow'
    @height = 4
    @width = 20
    @body.v.x = cg.rand(30,60) * cg.rand([-1,1])
    @body.bounce = 1

  update: ->
    super

module.exports = Shadow
