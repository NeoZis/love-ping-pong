local Ball = require('classes/Ball')
local Paddle = require('classes/Paddle')

yPaddleShift = 250
yBallShift = 250
ballDirectionCoef = 1

function love.load()
    ball = Ball.create(200, 200)
    player = Paddle.create(0, 200)
    secondPlayer = Paddle.create(love.graphics.getWidth() - player.width, 500)
end

function love.update(dt)
    movePlayer(dt)
    moveBall(dt)
    moveSecondPlayer(dt)
end

function love.draw()
    ball:draw()
    player:draw()
    secondPlayer:draw()
end

function movePlayer(dt)
    if (love.keyboard.isDown('down')) then
        player:move(player.y + yPaddleShift * dt)
    elseif (love.keyboard.isDown('up')) then
        player:move(player.y - yPaddleShift * dt)
    end
end

function moveBall(dt)
    if ((ball.y + ball.radius) > love.graphics.getHeight()) then
        ballDirectionCoef = -1
    elseif ((ball.y - ball.radius) < 0) then
        ballDirectionCoef = 1
    end

    ball.y = ball.y + yBallShift * dt * ballDirectionCoef
end

function moveSecondPlayer()
    secondPlayer:move(ball.y * 0.7)
end