local Menu

function Menu:new()
    newObj = { visible = false, buttons = {} }
    self.__index = self
    return setmetatable(newObj, self)
end

return Menu
