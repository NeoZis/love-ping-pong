-- TODO: add Point class

local Classes = {
    Paddle = {},
    Ball = {}
}

-- Paddle


-- Ball
function Classes.Ball:new(x, y)
    newObj = { x, y, radius = 10, speed = 5, velocityX = 5, velocityY = 5 }
    self.__index = self
    return setmetatable(newObj, self)
end

function Classes.Ball:move(x, y)
    self.x = x;
    self.y = y;
end