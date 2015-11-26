local class = require 'middleclass'
local vector = require 'vector'
local HC = require 'HC'
local Person = require 'person'

function love.load()
  love.window.setMode(800, 800)
  redShotTime = love.timer.getTime()
  blueShotTime = redShotTime
  leftScreenEdge = HC.rectangle(-1, 0, 1, 800)
  leftScreenEdge.tag = "edge"
  rightScreenEdge = HC.rectangle(800, 0, 1, 800)
  rightScreenEdge.tag = "edge"
  shotInterval = 1
  bullets = { }
  gameOver = false
  gameOverTimer = 5
  winText = ""

  redHealth = 100
  blueHealth = 100

  redPerson = Person:new(400, 50, 255, 0, 0, HC, bullets, 'red')
  bluePerson = Person:new(400, 750, 0, 0, 255, HC, bullets, 'blue')
end

function love.update(dt)
  -- moving
  
  -- redShoot
  if not gameOver then
    if love.keyboard.isDown("v") and love.timer.getTime() - redShotTime > shotInterval then
      redPerson:shoot(vector(0, 1))
      redShotTime = love.timer.getTime()
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
    if love.keyboard.isDown("rshift") and love.timer.getTime() - blueShotTime > shotInterval then
      bluePerson:shoot(vector(0, -1))
      blueShotTime = love.timer.getTime()
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
      x, y = bullet:getShape():center()
      if y < 0 or y > 800 then
        HC.remove(bullet:getShape())
        bullets[i] = nil
      else
        bullet:update(dt)
      end
    end

    -- resolve bullet hits
    
    for shape, delta in pairs(HC.collisions(redPerson:getShape())) do
      if shape.tag == 'blue' then
        shape:moveTo(400, -100)
        redHealth = redHealth - 10
      end
    end

    for shape, delta in pairs(HC.collisions(bluePerson:getShape())) do
      if shape.tag == 'red' then
        shape:moveTo(400, -100)
        blueHealth = blueHealth - 10
      end
    end

    -- check for win

    if redHealth < 10 then
      gameOver = true
      winText = "Blue Wins!" .. "\n" .. "Play again? Y/N"
      gameOverTimer = love.timer.getTime() + gameOverTimer
    elseif blueHealth < 10 then
      gameOver = true
      winText = "Red Wins!" .. "\n" .. "Play again? Y/N"
      gameOverTimer = love.timer.getTime() + gameOverTimer
    end
  else
    if love.keyboard.isDown("y") then 
      love.load()
    elseif love.keyboard.isDown("n") then
      love.event.push('quit')
    end
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
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("Red: " .. redHealth .. "\n" .. "Blue: " .. blueHealth, 0, 0, 125, "left")
  love.graphics.print(winText, 400, 400)
end
