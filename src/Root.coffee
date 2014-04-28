cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'

class Root extends cg.SpriteActor
  @plugin Physical, Interactive
  
  constructor: (properties) ->
    super properties

  update: ->
    super

module.exports = Root