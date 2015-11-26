local class = require 'middleclass'
local HC = require 'HC'
local vector = require 'vector'
local Bullet = require('bullet')
local Person = class('Person')

function Person:initialize(x, y, r, g, b, collider, bullets, playerTag)
  self.width = 100
  self.height = 100
  self.shape = collider.rectangle(x - self.width * 0.5 , y - self.height * 0.5 , 100, 100)
  self.collider = collider
  self.r = r
  self.g = g
  self.b = b
  self.speed = 200
  self.bullets = bullets
  self.playerTag = playerTag
end

function Person:getShape()
  return self.shape
end

function Person:move(moveVec, dt)
  self.shape:move(moveVec.x * self.speed * dt, moveVec.y * self.speed * dt)
end

function Person:shoot(direction)
  drawX, drawY = self.shape:center()
  table.insert(self.bullets, Bullet:new(drawX, drawY, direction, self.collider, self.playerTag))
end

function Person:draw()
  drawX, drawY = self.shape:center()
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

return Person
