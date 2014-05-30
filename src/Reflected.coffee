Reflected = ({width, height, x, y, alpha, scaleY, offsetX, offsetY}) ->
  preInit: ->
    @reflection = {}
    @reflection.width = width ? 100
    @reflection.height = height ? 100
    @reflection.x = x ? 0
    @reflection.y = y ? 0
    @reflection.alpha = alpha ? 0.25
    @reflection.scaleY = scaleY ? 1
    @reflection.offsetX = offsetX ? 0
    @reflection.offsetY = offsetY ? 0

    if @children?.length > 0
      @masked = @addChildAt new cg.Actor, 0
    else
      @masked = @addChild new cg.Actor

    @masked.mask = @addChild new cg.gfx.Graphics

    @buffer = new cg.gfx.RenderTexture @reflection.width, @reflection.height
    @reflectionActor = cg('#water').addChild new cg.Actor
      texture: @buffer
      alpha: @reflection.alpha
      scaleY: -@reflection.scaleY
      anchorY: 1

  draw: ->
    @masked.mask.clear()
    @masked.mask.beginFill(0xFFFFFF, 0.5)
    @masked.mask.drawRect(0,0,@reflection.width,@reflection.height)
    @masked.mask.endFill()
    @masked.mask.x = @reflection.x
    @masked.mask.y = @reflection.y

    @buffer.render @,
      x: -@reflection.x
      y: -@reflection.y
    , true
    @reflectionActor.x = @x + @reflection.offsetX
    @reflectionActor.y = @y + @reflection.offsetY

  dispose: ->
    @reflectionActor.destroy()

module.exports = Reflected