local Ball = require('classes/Ball')
local Paddle = require('classes/Paddle')

function love.load()
    ball = Ball.create(200, 200)
    player = Paddle.create(0, 200)
end

function love.update(dt)

end

function love.draw()
    ball:draw()
    player:draw()
end