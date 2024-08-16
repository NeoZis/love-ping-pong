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
        else
            --love.event.quit( 0 )
        end
    end
end

return actions