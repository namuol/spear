cg = require 'cg'
Spear = require 'Spear'
Boat = require 'Boat'
Shadow = require 'Shadow'
Crosshair = require 'Crosshair'
GameOver = require 'GameOver'

class SpearGame extends cg.Scene
  constructor: ->
    super
    cg.physics.gravity.zero()
    cg.music.surf.loop()
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

    @delay 0, ->
      @gameOver = cg.stage.addChild new GameOver
        id: 'gameOver'

      @on @gameOver, 'done', ->
        @resume()
        @resetGame()
        @show()

      @gameOver.pause().hide()

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


    @delay 0, ->

      @addChild new cg.SpriteActor
        texture: 'bg'
      @scoreText = @addChild new cg.Text '0',
        font: 'font'
        x: 4
        y: 4
      @score = 0

      @on cg.input, 'keyDown:0', ->
        cg.physics.toggleDebugVisuals()

      @targetFishCount = 40

      @water = @addChild new cg.Actor

      @boat = @addChild new Boat
        id: 'boat'
        x: cg.rand cg.width
        y: cg.rand cg.height
      @crosshair = @addChild new Crosshair
        id: 'crosshair'
    return @

  update: ->
    super
    cg.music.surf.volume = @boat?.turbulence()

module.exports = SpearGame
