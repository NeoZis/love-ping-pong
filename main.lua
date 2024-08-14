local Ball = require('classes/Ball')
local Paddle = require('classes/Paddle')

yPaddleShift = 500
maxScore = 11
isGameRunning = true

function love.load()
    ball = Ball.create(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    player = Paddle.create(0, love.graphics.getHeight() / 2)
    secondPlayer = Paddle.create(love.graphics.getWidth() - player.width, love.graphics.getHeight() / 2)

    ping = love.audio.newSource("blipSelect.wav", "static")
    hit = love.audio.newSource("explosion.wav", "static")
    win = love.audio.newSource("win.mp3", "static")
    lose = love.audio.newSource("lose.mp3", "static")

    music = love.audio.newSource("music.mp3", "stream")

    music:setLooping(true)
    music:play()
end

function love.update(dt)
    if not isGameRunning then
        return
    end

    movePlayer(dt)
    moveBall()
    moveSecondPlayer()

    if (ball.y + ball.radius > love.graphics.getHeight() or ball.y - ball.radius < 0) then
        ball.velocityY = -ball.velocityY
    end

    local currentPlayer = (ball.x < love.graphics.getWidth() / 2) and player or secondPlayer

    if (collision(ball, currentPlayer)) then
        love.audio.play(ping)

        local collidePoint = ball.y - (currentPlayer.y + currentPlayer.height / 2)
        collidePoint = collidePoint / (currentPlayer.height / 2)
        local angleRad = collidePoint * math.pi / 4
        local direction = (ball.x < love.graphics.getWidth() / 2) and 1 or -1

        ball.velocityX = direction * ball.speed * math.cos(angleRad)

        ball.velocityY = ball.speed * math.sin(angleRad)

        ball.speed = ball.speed + 0.5
        ball.level = ball.level + 1
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

    love.graphics.print(tostring(player.score), love.graphics.getWidth() / 2 - 50 - 10, 0, 0, 2, 2)
    love.graphics.print(tostring(secondPlayer.score), love.graphics.getWidth() / 2 + 50, 0, 0, 2, 2)
    love.graphics.print("Level: " .. tostring(ball.level), 0, 0, 0, 2, 2)

    local winner = getWinner()

    if (winner) then
        love.graphics.printf((winner == player and "Player" or "Computer") .. " is win", love.graphics.getWidth() / 2 - 300, 200, 200, "center", 0, 3, 3)
    end
end

function getWinner()
    if (player.score == maxScore and (secondPlayer.score + 1) < maxScore) then
        return player
    elseif (secondPlayer.score == maxScore and (player.score + 1) < maxScore) then
        return secondPlayer
    elseif (secondPlayer.score > maxScore and secondPlayer.score - player.score == 2) then
        return secondPlayer
    elseif (player.score > maxScore and player.score - secondPlayer.score == 2) then
        return player
    end

    return nil
end

function movePlayer(dt)
    if (love.keyboard.isDown('down')) then
        player:move(player.y + yPaddleShift * dt)
    elseif (love.keyboard.isDown('up')) then
        player:move(player.y - yPaddleShift * dt)
    end

    correctPaddleYPosition(player)
end

function moveBall()
    ball.x = ball.x + ball.velocityX
    ball.y = ball.y + ball.velocityY
end

function moveSecondPlayer()
    local computerLevel = 0.05
    secondPlayer.y = secondPlayer.y + (ball.y - (secondPlayer.y + secondPlayer.height / 2)) * computerLevel

    correctPaddleYPosition(secondPlayer)
end

function resetBall()
    love.audio.play(hit)

    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2

    ball.level = 1
    ball.speed = 5
    ball.velocityX = 5
    ball.velocityY = 5

    local winner = getWinner()

    if (winner) then
        music:stop()
        isGameRunning = false
        love.audio.play(winner == player and win or lose)
    end
end

function collision(b, p)
    local ballBound = b:getBound()
    local paddleBound = p:getBound()
    return ballBound.right > paddleBound.left and ballBound.bottom > paddleBound.top and ballBound.left < paddleBound.right and ballBound.top < paddleBound.bottom
end

function correctPaddleYPosition(paddle)
    paddle.y = paddle.y < 0 and 0 or paddle.y
    paddle.y = (paddle.y + paddle.height) > love.graphics.getHeight() and love.graphics.getHeight() - paddle.height or paddle.y
end
