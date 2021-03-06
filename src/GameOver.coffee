cg = require 'combo'
Interactive = require 'plugins/ui/Interactive'

class GameOver extends cg.Scene
  @plugin Interactive

  init: ->
    @width = cg.width
    @height = cg.height

    @bg = @addChild(new cg.gfx.Graphics)
    @bg.clear()
    @bg.beginFill 0x000000, 0.8
    @bg.drawRect 0, 0, cg.width, cg.height
    @bg.endFill()
    @gameOverText = @addChild(new cg.Text('GAME OVER',
      align: 'center'
      x: cg.width / 2
      y: 20
      scale:
        x: 2
        y: 2
    ))
    @scoreText = @addChild(new cg.Text('high score: 0\nyour score: 0',
      align: 'center'
      x: cg.width / 2
      y: cg.height / 2
    ))
    @clickToPlay = @addChild(new cg.Text('click to play again',
      align: 'center'
      x: cg.width / 2
    ))
    @clickToPlay.top = @scoreText.bottom + 10
    return

  splash: ->
    @resume().show()
    @scoreText.string = 'high score: ' + cg('#main').highScore + '\n' + 'your score: ' + cg('#main').score
    @gameOverText.bottom = 0
    @gameOverText.tween 'bottom', @scoreText.top - 10, 1000, 'bounce.out'

    # We add a small delay here to prevent the player from accidentally
    #  restarting before they have a chance to review their score.
    @delay 500, ->
      @once 'tap', @splashOut
      return

    @clickToPlay.blink()
    return

  splashOut: ->
    @emit 'done'
    @pause()
    @hide()
    cg('#main').resetGame().resume()
    return

  module.exports = GameOver
