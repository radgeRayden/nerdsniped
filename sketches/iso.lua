-- board width, board height
local BW, BH = 30, 20
local tile_size = 10
local rotation = math.pi/4
local colors = {}
for i=1,BW*BH do
  colors[i] = {
    love.math.random(),
    love.math.random(),
    love.math.random(),
    1.0
  }
end

local function rotate2d (theta, x,y)
  return math.cos(theta) * x - math.sin(theta) * y, math.sin(theta)*x + math.cos(theta)*y
end

local function screen2iso (x,y)
  local ww,wh = love.graphics.getDimensions()
  -- undo transformations exactly, in the reverse order as they were applied.
  x,y = x-ww/2, y-wh/2
  y = y*2
  x,y = rotate2d(-rotation,x,y)
  x,y = x+tile_size*BW/2, y+tile_size*BH/2
  return math.floor(x/tile_size),math.floor(y/tile_size)
end

local selx, sely = 0,0

local function draw_board()
  for k,v in ipairs(colors) do
    local x, y = ((k-1) % BW), math.floor((k-1) / BW) -- standard 1d to 2d array conversion

    -- draw selection cursor
    if (x == selx and y == sely) then
      love.graphics.setColor(1,1,1,1)
    else
      love.graphics.setColor(unpack(v))
    end

    love.graphics.rectangle('fill', x*tile_size,y*tile_size,tile_size,tile_size)
    love.graphics.setColor(1,1,1,1)
  end
end

function love.update(dt)
  selx,sely = screen2iso(love.mouse.getPosition())
  -- rotation = math.pi*2*(love.mouse.getX()/800)
end

function love.draw ()
  local ww,wh = love.graphics.getDimensions()

  love.graphics.print(string.format("%f, %f", selx,sely))
  love.graphics.push("transform")

  -- these transformations are applied in reverse order.
  -- center board on the screen
  -- NOTE: to create a camera, parameterize this instead of centering.
  -- This is the actual translation vector.
  love.graphics.translate(ww/2,wh/2)
  -- squash height
  love.graphics.scale(1,0.5)
  -- rotate
  love.graphics.rotate(rotation)
  -- set rotation offset to center
  love.graphics.translate(-tile_size*BW/2,-tile_size*BH/2)

  draw_board()

  love.graphics.pop()
end
