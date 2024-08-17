function correctPaddleYPosition(paddle)
    paddle.y = paddle.y < 0 and 0 or paddle.y
    paddle.y = (paddle.y + paddle.height) > love.graphics.getHeight() and love.graphics.getHeight() - paddle.height or paddle.y
end

function checkCollisionWithBall(b, p)
    local ballBound = b:getBound()
    local paddleBound = p:getBound()
    return ballBound.right > paddleBound.left and ballBound.bottom > paddleBound.top and ballBound.left < paddleBound.right and ballBound.top < paddleBound.bottom
end

function cursorCollision(xPos, yPos, width, height, xPos2, yPos2)
    return (xPos < xPos2 and xPos + width > xPos2 and yPos < yPos2 and yPos + height > yPos2)
end