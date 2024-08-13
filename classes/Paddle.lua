local P = {}

Paddle = {}

function Paddle:new(x, y)
    newObj = { x = x, y = y, width = 20, height = 80, score = 0 }
    self.__index = self
    return setmetatable(newObj, self)
end

function Paddle:move(y)
    self.y = y;
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function P.create(x, y)
    instance = Paddle:new(x, y)
    return instance
end

return P