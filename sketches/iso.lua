local BW, BH = 20, 20
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
  -- undo transformations exactly
  y = y*2
  x,y = x-20*BH,y-20*BH
  x,y = rotate2d(-rotation,x,y)
  x,y = x-20*-BH/2,y-20*-BH/2
  return math.floor(x/20),math.floor(y/20)
end

local selx, sely = 0,0

local function draw_board()
  for k,v in ipairs(colors) do
    local x, y = ((k-1) % BW), math.floor((k-1) / BW) -- standard 1d to 2d array conversion

    if (x == selx and y == sely) then
      love.graphics.setColor(1,1,1,1)
    else
      love.graphics.setColor(unpack(v))
    end

    love.graphics.rectangle('fill', x*20,y*20,20,20)
    love.graphics.setColor(1,1,1,1)
  end
end

function love.update(dt)
  selx,sely = screen2iso(love.mouse.getPosition())
  rotation = math.pi*2*(love.mouse.getX()/800)
end

function love.draw ()
  love.graphics.print(string.format("%f, %f", selx,sely))
  love.graphics.push("transform")

  love.graphics.scale(1,0.5)
  love.graphics.translate(20*BH,20*BH)
  love.graphics.rotate(rotation)
  love.graphics.translate(20*-BH/2, 20*-BH/2)
  draw_board()

  love.graphics.pop()
end
