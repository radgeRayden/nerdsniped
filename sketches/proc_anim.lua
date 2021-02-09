local LIMB_LENGTH = 40

local body = {}
for i=1,50 do
  body[i] = {200,200}
end
local feet = {}

local function add_feet(root)
  local lf = {
    root = root,
    side = "left",
    position = {0,0}
  }
  local rf =  {
    root = root,
    side = "right",
    position = {0,0}
  }
  table.insert(feet,lf)
  table.insert(feet,rf)
end

for i=1,50 do
  if i % 10 == 7 then
    add_feet(i)
  end
end

local function rotate2d (v, theta)
  local x,y = v[1],v[2]
  return {math.cos(theta) * x - math.sin(theta) * y, math.sin(theta)*x + math.cos(theta)*y}
end

local function vsub (a,b)
  return {a[1]-b[1],a[2]-b[2]}
end

local function vadd (a,b)
  return {a[1]+b[1],a[2]+b[2]}
end

local function distance (a,b)
  local d = vsub(b,a)
  return math.sqrt(d[1]^2 + d[2]^2)
end

local function propagate()
  for i=1,#body-1 do
    body[i][1],body[i][2] = body[i+1][1],body[i+1][2]
  end
end

local function update_foot(f)
  -- direction calculation
  local d
  local ats = body[f.root]
  -- if limbs go from the head. We don't handle the case where the body has a single segment.
  if f.root < #body then
    local nexts = body[f.root + 1]
    d = vsub(nexts, ats)
  else
    local nexts = body[f.root - 1]
    d = vsub(ats, nexts)
  end
  local theta = math.atan2(d[2], d[1])
  local turn = math.pi/6 * (f.side == "right" and 1 or -1)
  f.position = vadd(ats, rotate2d({LIMB_LENGTH-5, 0}, theta+turn))
end

for k,v in ipairs(feet) do
  update_foot(v)
end

function love.update(dt)
  local head = body[#body]
  local mx,my = love.mouse.getPosition()
  local nx,ny = mx,my

  -- if distance(head, {mx,my}) > 5 then

  -- end

  body[#body][1], body[#body][2] = nx,ny
  if distance(body[#body], body[#body - 1]) > 10 then
    propagate()
  end

  for k,v in ipairs(feet) do
    if distance(v.position, body[v.root]) > LIMB_LENGTH then
      update_foot(v)
    end
  end
end

function love.draw ()
  for i,v in ipairs(body) do
    love.graphics.circle('line',v[1],v[2],3)
  end
  local points = {}
  for k,v in ipairs(body) do
    table.insert(points, v[1])
    table.insert(points, v[2])
  end
  love.graphics.line(points)

  for k,v in ipairs(feet) do
    local p = v.position
    local s = body[v.root]
    love.graphics.line(p[1], p[2], s[1], s[2])
  end
end
