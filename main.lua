local Ball = require('classes/Ball')
local Paddle = require('classes/Paddle')

yPaddleShift = 500

function love.load()
    ball = Ball.create(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    player = Paddle.create(0, love.graphics.getHeight() / 2)
    secondPlayer = Paddle.create(love.graphics.getWidth() - player.width, love.graphics.getHeight() / 2)
end

function love.update(dt)
    movePlayer(dt)
    moveBall()
    moveSecondPlayer()

    if (ball.y + ball.radius > love.graphics.getHeight() or ball.y - ball.radius < 0) then
        ball.velocityY = -ball.velocityY
    end

    local currentPlayer = (ball.x < love.graphics.getWidth() / 2) and player or secondPlayer

    if (collision(ball, currentPlayer)) then
        local collidePoint = ball.y - (currentPlayer.y + currentPlayer.height / 2)
        collidePoint = collidePoint / (currentPlayer.height / 2)
        local angleRad = collidePoint * math.pi / 4
        local direction = (ball.x < love.graphics.getWidth() / 2) and 1 or -1

        ball.velocityX = direction * ball.speed * math.cos(angleRad)

        ball.velocityY = ball.speed * math.sin(angleRad)

        ball.speed = ball.speed + 0.5
    end

    if (ball.x - ball.radius < 0) then
        secondPlayer.score = secondPlayer.score + 1
        resetBall()
    elseif (ball.x + ball.radius > love.graphics.getWidth()) then
        player.score = player.score + 1
        resetBall()
    end
end

function love.draw()
    ball:draw()
    player:draw()
    secondPlayer:draw()

    love.graphics.print(tostring(player.score), love.graphics.getWidth() / 2 - 50, 0, 0, 2, 2)
    love.graphics.print(tostring(secondPlayer.score), love.graphics.getWidth() / 2 + 50, 0, 0, 2, 2)
end

function movePlayer(dt)
    if (love.keyboard.isDown('down')) then
        player:move(player.y + yPaddleShift * dt)
    elseif (love.keyboard.isDown('up')) then
        player:move(player.y - yPaddleShift * dt)
    end

    player.y = player.y < 0 and 0 or player.y
    player.y = (player.y + player.height) > love.graphics.getHeight() and love.graphics.getHeight() - player.height or player.y
end

function moveBall()
    ball.x = ball.x + ball.velocityX
    ball.y = ball.y + ball.velocityY
end

function moveSecondPlayer()
    local computerLevel = 0.05
    secondPlayer.y = secondPlayer.y + (ball.y - (secondPlayer.y + secondPlayer.height / 2)) * computerLevel
end

function resetBall()
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2

    ball.speed = 5
    ball.velocityX = 5
    ball.velocityY = 5
end

function collision(b, p)
    b.top = b.y - b.radius
    b.bottom = b.y + b.radius
    b.left = b.x - b.radius
    b.right = b.x + b.radius

    p.top = p.y
    p.bottom = p.y + p.height
    p.left = p.x
    p.right = p.x + p.width

    return b.right > p.left and b.bottom > p.top and b.left < p.right and b.top < p.bottom
end
