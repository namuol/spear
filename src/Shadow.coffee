cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'


class Shadow extends cg.SpriteActor
  @plugin Physical, Interactive

  constructor: (properties) ->
    super properties
    @body.gravityScale = 0
    @texture = 'shadow'
    @addClass 'shadow'
    @height = 4
    @width = 40
    @body.v.x = cg.rand(30,90) * cg.rand([-1,1])
    @body.bounce = 1
    @body.height = @height*2
    @body.width = @width
    @alpha = 0.25

  update: ->
    super

module.exports = Shadow
