love.filesystem.setIdentity("love-pixels")

local canvas = love.graphics.newCanvas(800, 600)
love.graphics.setCanvas(canvas)
love.graphics.clear(1,1,1)
love.graphics.setCanvas()

local lineSegments = {}
local drawNecessary = false
local lineColor = {0,0,0}

local function saveImage()
  local data = canvas:newImageData()
  local img = data:encode("png", "image.png")
  love.filesystem.write(img:getFilename(), img)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 's' then
    saveImage()
  elseif key == 'f5' then
    lineSegments = {}
    drawNecessary = false
    love.graphics.setCanvas(canvas)
    love.graphics.clear(1,1,1)
    love.graphics.setCanvas()
  end
end

function love.mousepressed(x, y, b)
  if b == 1 then
    lineSegments = {x, y, x,y}
    drawNecessary = true
    lineColor = {0,0,0}
  elseif b == 2 then
    lineSegments = {x, y, x,y}
    drawNecessary = true
    lineColor = {1,1,1}
  end
end

function love.mousereleased(x,y,b)
  if b == 1 or b == 2 then
    lineSegments = {}
  end
end

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) or love.mouse.isDown(2) then
    for k, vertex in ipairs({x-dx, y-dy, x, y}) do
      table.insert(lineSegments, vertex)
    end
    drawNecessary = true
  end
end

function love.draw()
  love.graphics.setCanvas(canvas)
  if drawNecessary then
    love.graphics.setColor(lineColor)
    love.graphics.line(lineSegments)
    love.graphics.setColor(1,1,1)
    drawNecessary = false
    lineSegments = {}
  end
  love.graphics.setCanvas()
  love.graphics.draw(canvas)
end
