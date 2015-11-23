local class = require 'middleclass'
local vector = require 'vector'
local HC = require 'HC'

local Person = class('Person')

function Person:initialize(x, y, r, g, b, collider)
  self.width = 100
  self.height = 100
  self.collider = collider:rectangle(x - self.width * 0.5 , y - self.height * 0.5 , 100, 100)
  self.r = r
  self.g = g
  self.b = b
  self.speed = 200
end

function Person:getX()
  return collider.x + self.width * 0.5
end

function Person:getY()
  return collider.y + self.width * 0.5
end

function Person:move(moveVec, dt)
  self.collider:move(moveVec.x * self.speed * dt, moveVec.y * self.speed * dt)
end

function Person:draw()
  drawX, drawY = self.collider:center()
  drawX = drawX - self.width * 0.5
  drawY = drawY - self.height * 0.5
  love.graphics.setColor(self.r, self.g, self.b, 255)
  love.graphics.rectangle("fill", drawX, drawY, self.width, self.width)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", drawX + 25, drawY + 25, 10, 10)
  love.graphics.rectangle("fill", drawX + 75, drawY + 25, 10, 10)
  love.graphics.rectangle("fill", drawX + 45, drawY + 45, 10, 10)
  love.graphics.rectangle("fill", drawX + 20, drawY + 75, 60, 10)
end

function love.load()
  love.window.setMode(800, 800)
  fTime = love.timer.getTime()
  collider = HC(100, onCollide)

  redPerson = Person:new(400, 50, 255, 0, 0, collider)
  bluePerson = Person:new(400, 750, 0, 0, 255, collider)
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
    redMove = redMove:normalized()
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
    blueMove = blueMove:normalized()
    bluePerson:move(blueMove, dt)
  end
end

function love.draw()
  love.graphics.setColor(99, 99, 255, 255)
  love.graphics.rectangle("fill", 0, 0, 800, 800)
  redPerson:draw()
  bluePerson:draw()
end
