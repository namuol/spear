cg = require 'combo'
extras = require 'extras'
UI = require 'plugins/ui/UI'
Physics = require 'plugins/physics/Physics'
SpearGame = require 'SpearGame'
assets = require 'assets.json'
TitleScreen = require 'TitleScreen'

# App-wide plugins need to be loaded before `cg.init` is called:
cg.plugin UI
cg.plugin Physics

cg.plugin
  update: ->
    cg('#main')?.displacement?.offset.x += 0.4
    cg('#main')?.displacement?.offset.y += 0.1

# This will set up graphics, sound, input, data, plugins, and start our game loop:
cg.init
  name: 'Spear Game'
  width: 400
  height: 240
  backgroundColor: 0x303c55
  textureFilter: 'nearest'
  displayMode: 'pixelPerfect'


loadingScreen = cg.stage.addChild new extras.LoadingScreen
loadingScreen.begin()

cg.load assets, (src, data, loaded, count) ->
    cg.log "Loaded '#{src}'"
    loadingScreen.setProgress loaded/count
.then ->
  loadingScreen.complete()
.then ->
  loadingScreen.destroy()
  cg.stage.addChild new SpearGame
    id: 'main'
    interactive: true
    buttonMode: true
    defaultCursor: 'none'

  gameOver = cg.stage.addChild new TitleScreen
    id: 'gameOver'
  # gameOver.pause().hide()

  cg.stage.addChild new extras.PauseScreen
    id: 'pauseScreen'
  cg('#pauseScreen').hide()

  pause = ->
    cg.sound.pauseAll()
    cg('#main').pause()
    cg('#gameOver').pause()
    cg('#pauseScreen').show()

  cg.on 'blur', pause

  cg('#pauseScreen').on 'dismiss', ->
    if cg('#gameOver').visible
      cg('#gameOver').resume()
    else
      cg('#main').resume()
    cg.sound.resumeAll()

  gameOver.splash()

  pause()

# Hide the pre-pre loading "Please Wait..." message:
document.getElementById('pleasewait').style.display = 'none'

# Show our game container:
document.getElementById('combo-game').style.display = 'inherit'
