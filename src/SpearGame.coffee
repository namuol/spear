cg = require 'combo'
Spear = require 'Spear'
Boat = require 'Boat'
Shadow = require 'Shadow'
Crosshair = require 'Crosshair'
GameOver = require 'GameOver'

class SpearGame extends cg.Scene
  init: ->
    cg.physics.gravity.zero()
    cg.physics.bounds.top = 55
    cg.Text.defaults.font = 'font'

    cg.input.map 'boat',
      horiz: ['a/d', 'left/right']
      vert: ['w/s', 'up/down']
    @highScore = 0

    @resetGame()

    @repeat 250, ->
      if cg('shadow').length < @targetFishCount
        @water.addChild new Shadow
          x: cg.rand -cg.width, cg.width*2
          y: cg.rand 60, cg.height*2

    @on cg.input, 'mouseDown', ->
      if @boat.spearCount > 0
        cg.sounds.draw.play()
        @addChild new Spear
        --@boat.spearCount

    @on cg.input, 'keyDown:0', ->
      cg.physics.toggleDebugVisuals()

    @t = 0

    @tween cg, 'width', cg.width * 2

  @defineProperty 'score',
    get: -> @_score
    set: (val) ->
      @_score = val
      if @_score > @highScore
        @highScore = @_score
      @scoreText?.string = '' + @_score

  resetGame: ->
    for c in @children
      c.destroy()

    @targetFishCount = 40
    @water = @addChild new cg.Actor
      id: 'water'
      texture: 'bg'
    @water.width = cg.width
    @water.height = cg.height
    @displacement = new cg.gfx.DisplacementFilter(cg.textures.displace)
    @water.filters = [@displacement]

    @sky = @addChild new cg.Actor
      texture: 'sky'
    @scoreText = @addChild new cg.Text '0',
      font: 'font'
      x: 4
      y: 4
    @score = 0

    @boat = @addChild new Boat
      id: 'boat'
      x: cg.rand cg.width
      y: cg.rand cg.height

    @crosshair = @addChild new Crosshair
      id: 'crosshair'

    cg.music.surf.stop().loop().volume = 0.2

    return @

  update: ->
    cg.music.surf.volume = @boat?.turbulence() ? 0

module.exports = SpearGame
