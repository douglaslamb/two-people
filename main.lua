local class = require 'middleclass'
local vector = require 'vector'
local HC = require 'HC'
local Person = require 'person'

function love.load()
  love.window.setMode(800, 800)
  fTime = love.timer.getTime()
  leftScreenEdge = HC.rectangle(-1, 0, 1, 800)
  rightScreenEdge = HC.rectangle(800, 0, 1, 800)
  bullets = { }

  redPerson = Person:new(400, 50, 255, 0, 0, HC, bullets, 'red')
  bluePerson = Person:new(400, 750, 0, 0, 255, HC, bullets, 'blue')
end

function love.update(dt)
  -- moving
  
  -- redShoot
  if love.keyboard.isDown("lctrl") then
    redPerson:shoot(vector(0, 1))
  end

  -- redMove
  redMove = vector(0, 0)
  if love.keyboard.isDown("a", "d") then
    if love.keyboard.isDown("a") then
      redMove.x = -1
    elseif love.keyboard.isDown("d") then
      redMove.x = 1
    end
    redMove = redMove:normalized()
    redPerson:move(redMove, dt)
  end
  
  -- blueShoot
  if love.keyboard.isDown("rctrl") then
    bluePerson:shoot(vector(0, -1))
  end
  
  --blueMove
  blueMove = vector(0, 0)
  if love.keyboard.isDown("left", "right") then
    if love.keyboard.isDown("left") then
      blueMove.x = -1
    elseif love.keyboard.isDown("right") then
      blueMove.x = 1
    end
    blueMove = blueMove:normalized()
    bluePerson:move(blueMove, dt)
  end

  -- resolve collisions

  for shape, delta in pairs(HC.collisions(leftScreenEdge)) do
    shape:move(-delta.x, -delta.y)
  end

  for shape, delta in pairs(HC.collisions(rightScreenEdge)) do
    shape:move(-delta.x, -delta.y)
  end

  -- update bullets

  for i, bullet in pairs(bullets) do
    bullet:update(dt)
  end

end

function love.draw()
  love.graphics.setColor(99, 99, 255, 255)
  love.graphics.rectangle("fill", 0, 0, 800, 800)
  redPerson:draw()
  bluePerson:draw()
  for i, bullet in pairs(bullets) do
    bullet:draw()
  end
end
