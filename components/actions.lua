local actions = {
    eventHandlers = {}
}

function actions.addHandler(event, handler)
    actions.eventHandlers[event] = handler
end

function love.mousepressed(x, y, b)
    local event = button.handleClick()

    if event then
        if (actions.eventHandlers[event]) then
            actions.eventHandlers[event]()
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        isGameRunning = false
        music:stop()
        button.setVisible("resume_game", true)
    end
end

return actions