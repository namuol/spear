cg = require 'cg'
Physical = require 'plugins/physics/Physical'
Interactive = require 'plugins/ui/Interactive'
Spear = require 'Spear'

DEFAULT_SPEED = 100
BASE_TURBULENCE = 0.1
class Boat extends cg.Actor
  @plugin Physical, Interactive

  constructor: (properties) ->
    super properties
    @spearCount = 3
    @person = @addChild new cg.SpriteActor
      texture: 'person'
      x: 6
      anchor:
        x: 0.5
        y: 1
    @sprite = @addChild new cg.SpriteActor
      texture: 'boat'
      anchor:
        x: 0.5
        y: 0.5
    @sprite.x = @sprite.width/4
    @sprite.y = @sprite.height/4
    @body.width = @sprite.width/2
    @body.height = @sprite.height/2
    @t = 0
    @controls = cg.input.controls.boat

    @speed = DEFAULT_SPEED
    @targetVelocity = new cg.math.Vector2
    @on 'horiz', (val) ->
      # @targetDirection.x = val
      @targetVelocity.x = val * @speed

    @on 'vert', (val) ->
      # @targetDirection.y = val * 0.5
      @targetVelocity.y = val * @speed * 0.5

  turbulence: -> (@body.v.len()/DEFAULT_SPEED) + BASE_TURBULENCE

  update: ->
    super
    @body.v.$add(@targetVelocity.sub(@body.v).mul(0.02))
    @t += cg.dt_seconds + @turbulence() * 0.1
    @sprite.y = @turbulence() * 3 * Math.sin @t * 2
    @person.y = @sprite.y + 6
    @sprite.rotation = 0.1 * Math.cos @t * 2
    @person.rotation = -0.2*(@body.v.x/DEFAULT_SPEED) + 0.1 * Math.cos @t * 2.1

module.exports = Boat
