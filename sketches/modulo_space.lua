local leveldata =
[[
0000000000
1110000000
0000011000
0111111000
0000000000
0000001111
0000000000
1110000000
0000000000
0000000000
]]

local player = {100,0}
local level = {}
do
    local idx = 0
    for c in leveldata:gmatch('.') do
      if c == '0' then
        table.insert(level, 0)
      elseif c == '1' then
        table.insert(level, 1)
      end
    end
end

local function draw_scene(ox,oy,p)
  for k,v in ipairs(level) do
    if v == 1 then
        local x,y = (k-1)%10, math.floor((k-1)/10)
        love.graphics.rectangle('fill', ox+x*20,oy+y*20,20,20)
    end
  end
  love.graphics.rectangle('line',ox,oy,200,200)
  if p then
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle('fill',ox+player[1],oy+200+player[2]-20,20,20)
    love.graphics.setColor(1,1,1,1)
  end
end

function love.update(dt)
  if love.keyboard.isDown('a') then
    player[1] = player[1] - dt * 100
  elseif love.keyboard.isDown('d') then
    player[1] = player[1] + dt * 100
  end
  if player[1] < -50 then player[1] = 200 + player[1] end
  if player[1] > 250 then player[1] = player[1] - 200 end
end

function love.draw()
  draw_scene(200,200,true)
  draw_scene(400,200,true)
  if player[1] > 100 then
    draw_scene(400,200,false)
  else
    draw_scene(0,200,false)
  end
end
