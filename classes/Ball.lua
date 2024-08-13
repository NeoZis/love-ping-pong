local B = {}

Ball = {}

function Ball:new(x, y)
    newObj = { x = x, y = y, radius = 10, speed = 5, velocityX = 5, velocityY = 5 }
    self.__index = self
    return setmetatable(newObj, self)
end

function Ball:move(x, y)
    self.x = x;
    self.y = y;
end

function Ball:draw()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

function B.create(x, y)
    instance = Ball:new(x, y)
    return instance
end

return B

