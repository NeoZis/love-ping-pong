local button = {}

local Button = {}
BTN_WIDTH = 300
BTN_HEIGHT = 60

function Button:new(title, event)
    newObj = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        mouseHover = false,
        event = event,
        title = title,
        color = {128, 234, 255},
        hoverColor = {255, 0, 0},
        visible = false
    }
    self.__index = self
    return setmetatable(newObj, self)
end

local buttonList = {}

function button.addNew(title, event)
    local newBtn = Button:new(title, event)
    table.insert(buttonList, newBtn)
end

function button.calcMouseHover()
    mX, mY = love.mouse.getPosition()
    for k, b in pairs(buttonList) do
        if (b.visible) then
            b.mouseHover = cursorCollision(b.x - BTN_WIDTH / 2, b.y - BTN_HEIGHT / 2, BTN_WIDTH, BTN_HEIGHT, mX, mY)
        end
    end
end

function button.show()
    for k, b in pairs(buttonList) do
        if (b.visible) then
            local red, green, blue = b.mouseHover and b.hoverColor or b.color;
            love.graphics.setColor(love.math.colorFromBytes(red, green, blue))
            love.graphics.rectangle("fill", b.x - BTN_WIDTH / 2, b.y - BTN_HEIGHT / 2, BTN_WIDTH, BTN_HEIGHT)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(b.title, b.x - BTN_WIDTH / 2, b.y - BTN_HEIGHT / 2 + 10, BTN_WIDTH, "center")
        end
    end
end

function button.setVisible(btn, value)
    for k, b in pairs(buttonList) do
        if (b.event == btn) then
            b.visible = value

            if not value then
                b.mouseHover = value
            end
        end
    end
end

function button.handleClick()
    for k, b in pairs(buttonList) do
        if b.mouseHover then
            return b.event
        end
    end
end

return button