cg = require 'cg'
require 'index'

UI = require 'plugins/ui/UI'
Physics = require 'plugins/physics/Physics'
SpearGame = require 'SpearGame'

module.exports = ->
  # App-wide plugins need to be loaded before `cg.init` is called:
  cg.plugin UI
  cg.plugin Physics

  # This will set up graphics, sound, input, data, plugins, and start our game loop:
  cg.init
    name: 'Spear Game'
    width: 400
    height: 240
    backgroundColor: 0x303c55
    displayMode: 'pixelPerfect'

  loadingScreen = cg.stage.addChild new cg.extras.LoadingScreen
  loadingScreen.begin()

  cg.assets.loadJSON('assets.json').then (pack) ->
    setTimeout ->
      cg.assets.preload pack,
        error: (src) ->
          cg.error 'Failed to load asset ' + src
        progress: (src, data, loaded, count) ->
          cg.log "Loaded '#{src}'"
          loadingScreen.setProgress loaded/count
        complete: ->
          loadingScreen.complete().then ->
            loadingScreen.destroy()
            cg.stage.addChild new SpearGame
              id: 'main'
    , 100
  , (err) ->
    throw new Error 'Failed to load assets.json: ' + err.message

  # Hide the pre-pre loading "Please Wait..." message:
  document.getElementById('pleasewait').style.display = 'none'

  # Show our game container:
  document.getElementById('combo-game').style.display = 'inherit'

module.exports()
