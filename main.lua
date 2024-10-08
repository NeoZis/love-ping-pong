require('constants')
require('utils/utils')

local Ball = require('components/Ball')
local Paddle = require('components/Paddle')
button = require('components/button')

local actions = require('components/actions')

isGameRunning = false

love.graphics.setFont(love.graphics.newFont(30))

function love.load()
    ball = Ball.create(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    player = Paddle.create(0, love.graphics.getHeight() / 2)
    secondPlayer = Paddle.create(love.graphics.getWidth() - player.width, love.graphics.getHeight() / 2)

    ping = love.audio.newSource("assets/blipSelect.wav", "static")
    hit = love.audio.newSource("assets/explosion.wav", "static")
    win = love.audio.newSource("assets/win.mp3", "static")
    lose = love.audio.newSource("assets/lose.mp3", "static")

    music = love.audio.newSource("assets/music.mp3", "stream")

    music:setLooping(true)

    initButtons()
end

function love.update(dt)
    button.calcMouseHover()
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

    if (checkCollisionWithBall(ball, currentPlayer)) then
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
    button.show()

    love.graphics.print(tostring(player.score), love.graphics.getWidth() / 2 - 50 - 10, 0, 0)
    love.graphics.print(tostring(secondPlayer.score), love.graphics.getWidth() / 2 + 50, 0, 0)
    love.graphics.print("Level: " .. tostring(ball.level), 0, 0, 0)

    local winner = getWinner()

    if (winner) then
        love.graphics.printf((winner == player and "Player" or "Computer") .. " won", love.graphics.getWidth() / 2 - 200 / 2, 200, 200, "center", 0)
    end
end

function initButtons()
    -- Start game button
    button.addNew("Start game", "start_game")
    actions.addHandler("start_game", function()
        music:play()
        isGameRunning = true
        button.setVisible("start_game", false)
    end)

    -- Restart game button
    button.addNew("Restart", "restart_game")
    actions.addHandler("restart_game", function()
        music:play()
        player.score = 0
        secondPlayer.score = 0
        isGameRunning = true
        button.setVisible("restart_game", false)
    end)

    -- Resume game button
    button.addNew("Resume", "resume_game")
    actions.addHandler("resume_game", function()
        music:play()
        isGameRunning = true
        button.setVisible("resume_game", false)
    end)

    -- Show start game button
    button.setVisible("start_game", true)
end

function getWinner()
    if (player.score == MAX_SCORE and (secondPlayer.score + 1) < MAX_SCORE) then
        return player
    elseif (secondPlayer.score == MAX_SCORE and (player.score + 1) < MAX_SCORE) then
        return secondPlayer
    elseif (secondPlayer.score > MAX_SCORE and secondPlayer.score - player.score == 2) then
        return secondPlayer
    elseif (player.score > MAX_SCORE and player.score - secondPlayer.score == 2) then
        return player
    elseif (player.score == 6 and secondPlayer.score == 0) then
        return player
    elseif (secondPlayer.score == 6 and player.score == 0) then
        return secondPlayer
    end

    return nil
end

function movePlayer(dt)
    if (love.keyboard.isDown('down')) then
        player:move(player.y + Y_PADDLE_SHIFT * dt)
    elseif (love.keyboard.isDown('up')) then
        player:move(player.y - Y_PADDLE_SHIFT * dt)
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
        button.setVisible("restart_game", true)
    end
end
