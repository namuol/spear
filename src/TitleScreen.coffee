cg = require 'combo'
Interactive = require 'plugins/ui/Interactive'

class TitleScreen extends cg.Scene
  @plugin Interactive

  init: ->
    @width = cg.width
    @height = cg.height

    @bg = @addChild(new cg.gfx.Graphics)
    @bg.clear()
    @bg.beginFill 0x000000, 0.1
    @bg.drawRect 0, 0, cg.width, cg.height
    @bg.endFill()

    @titleGraphic = @addChild new cg.Actor
      texture: 'title'
    # @t2 = cg('#water').addChild new cg.Actor
    #   texture: 'title'
    #   alpha: 0.3
    # @t2.y += 10

    @scoreText = @addChild(new cg.Text('high score: 0\nyour score: 0',
      align: 'center'
      x: cg.width / 2
      y: cg.height - 40
    ))

    @clickToPlay = @addChild(new cg.Text('click to play',
      align: 'center'
      x: cg.width / 2
      y: cg.height - 10
    ))
    @clickToPlay.top = @scoreText.bottom + 10
    return

  splash: ->
    @t2 = cg('#water').addChild new cg.Actor
      texture: 'title'
      alpha: 0.3
    @t2.y += 10

    @resume().show()
    @scoreText.string = 'high score: ' + cg('#main').highScore + '\n' + 'your score: ' + cg('#main').score
    # @titleGraphic.bottom = 0
    @titleGraphic.alpha = 1
    # @titleGraphic.tween 'alpha', 1, 2000
    # @tween @t2, 'alpha', 0.3, 2000

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
    @titleGraphic.alpha = 0
    @t2.destroy()
    @t2 = null
    @hide()
    cg('#main').resetGame().resume()
    return

  module.exports = TitleScreen
