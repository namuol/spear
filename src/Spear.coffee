cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'

class Spear extends cg.SpriteActor
  @plugin Physical, Interactive

  constructor: (properties) ->
    super properties
    @texture = 'spear'

  update: ->
    super

module.exports = Spear
