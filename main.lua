local class = require 'middleclass'
local vector = require 'vector'

local Person = class('Person')
local Physics = class('Physics')

function Physics:initialize()
end

function Physics:isOverlap(personA, personB) 
  if (personA:leftEdge() > personB:leftEdge() and personA:leftEdge() < personB:rightEdge() or personA:rightEdge() < personB:rightEdge() and personA:rightEdge() > personB:leftEdge()) and (personA:topEdge() > personB:topEdge() and personA:topEdge() < personB:bottomEdge() or personA:bottomEdge() < personB:bottomEdge() and personA:bottomEdge() > personB:topEdge()) then
    return true
  else
    return false
  end
end


function Person:initialize(x, y, r, g, b)
  self.x = x
  self.y = y
  self.width = 100
  self.height = 100
  self.r = r
  self.g = g
  self.b = b
  self.speed = 200
end

function Person:getX()
  return self.x
end

function Person:getY()
  return self.y
end

function Person:leftEdge()
  return self.x - self.width * 0.5
end

function Person:rightEdge()
  return self.x + self.width * 0.5
end

function Person:topEdge()
  return self.y - self.width * 0.5
end

function Person:bottomEdge()
  return self.y + self.width * 0.5
end

function Person:move(moveVec, dt)
  moveVec = moveVec:normalized()
  self.x = self.x + moveVec.x * self.speed * dt
  self.y = self.y + moveVec.y * self.speed * dt
end

function Person:draw()
  love.graphics.setColor(self.r, self.g, self.b, 255)
  love.graphics.rectangle("fill", self.x - self.width * 0.5, self.y - self.width * 0.5, self.width, self.width)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", self.x + 25 - self.width * 0.5, self.y + 25 - self.height * 0.5, 10, 10)
  love.graphics.rectangle("fill", self.x + 75 - self.width * 0.5, self.y + 25 - self.height * 0.5, 10, 10)
  love.graphics.rectangle("fill", self.x + 45 - self.width * 0.5, self.y + 45 - self.height * 0.5, 10, 10)
  love.graphics.rectangle("fill", self.x + 20 - self.width * 0.5, self.y + 75 - self.height * 0.5, 60, 10)
end

function love.load()
  love.window.setMode(800, 800)
  fTime = love.timer.getTime()

  physics = Physics:new()
  redPerson = Person:new(400, 50, 255, 0, 0)
  bluePerson = Person:new(400, 750, 0, 0, 255)
end

function love.update(dt)
  -- moving
  -- redMove
  redMove = vector(0, 0)
  if love.keyboard.isDown("w", "a", "s", "d") then
    if love.keyboard.isDown("a") then
      redMove.x = -1
    elseif love.keyboard.isDown("d") then
      redMove.x = 1
    end
    if love.keyboard.isDown("w") then
      redMove.y = -1
    elseif love.keyboard.isDown("s") then
      redMove.y = 1
    end
    redPerson:move(redMove, dt)
  end

  --blueMove
  blueMove = vector(0, 0)
  if love.keyboard.isDown("up", "left", "down", "right") then
    if love.keyboard.isDown("left") then
      blueMove.x = -1
    elseif love.keyboard.isDown("right") then
      blueMove.x = 1
    end
    if love.keyboard.isDown("up") then
      blueMove.y = -1
    elseif love.keyboard.isDown("down") then
      blueMove.y = 1
    end
    bluePerson:move(blueMove, dt)
  end
  end

function love.draw()
  love.graphics.setColor(99, 99, 255, 255)
  love.graphics.rectangle("fill", 0, 0, 800, 800)
  redPerson:draw()
  bluePerson:draw()
  if physics:isOverlap(redPerson, bluePerson) then
    love.graphics.print("overlapping!")
  end
end
