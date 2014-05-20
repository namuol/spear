cg = require 'cg'
Physical = require 'plugins/physics/Physical'

STALK_DIST = 100
STALK_DIST2 = STALK_DIST*STALK_DIST

DEFAULT_SPEED = 60

class Shark extends cg.Actor
  @plugin Physical

  init: ->
    @texture = 'fin'
    @anchorX = 0.5
    @anchorY = 0
    @alpha = 0
    @speed = DEFAULT_SPEED

  update: ->
    @x = @shadow.x + @shadow.width/2
    @y = @shadow.y + 3

    @flipX = @shadow.body.v.x > 0

    boat = cg('#boat')
    if @shadow.stalking
      tv = @vecTo(boat).mag(@speed)
      @shadow.body.v.$add(tv.sub(@shadow.body.v).mul(0.01))
    else if @vecTo(boat).len() < STALK_DIST
      @shadow.stalking = true
      cg.sounds.warning.play()
      @tween
        duration: 250
        values:
          alpha: 1
          anchorY: 1
      .then ->
        @animate ['anchorY', 1.01],
          ['anchorY', 0.99]

    if @shadow.touches boat
      cg('#gameOver').splash()
      cg.sounds.dead.play()
      cg.music.surf.fadeTo 0
      cg('#main').pause()

module.exports = Shark
