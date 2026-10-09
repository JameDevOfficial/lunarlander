local UI = {}

UI.windowResized = function()
    local screen = {
        X = 0,
        Y = 0,
        centerX = 0,
        centerY = 0,
        minSize = 0,
        topLeft = { X = 0, Y = 0 },
        topRight = { X = 0, Y = 0 },
        bottomLeft = { X = 0, Y = 0 },
        bottomRight = { X = 0, Y = 0 }
    }
    screen.X, screen.Y = love.graphics.getDimensions()
    screen.minSize = (screen.Y < screen.X) and screen.Y or screen.X
    screen.centerX = screen.X / 2
    screen.centerY = screen.Y / 2

    local half = screen.minSize / 2
    screen.topLeft.X = screen.centerX - half
    screen.topLeft.Y = screen.centerY - half
    screen.topRight.X = screen.centerX + half
    screen.topRight.Y = screen.centerY - half
    screen.bottomRight.X = screen.centerX + half
    screen.bottomRight.Y = screen.centerY + half
    screen.bottomLeft.X = screen.centerX - half
    screen.bottomLeft.Y = screen.centerY + half

    return screen
end

function UI.drawNeonPolyline(points, color, intensity, width)
    color = color or { 1, 1, 1 }
    intensity = intensity or 5
    width = width or 2

    love.graphics.setBlendMode("add")
    for i = intensity, 1, -1 do
        local a = (i / intensity) * 0.02
        love.graphics.setColor(color[1], color[2], color[3], a)
        love.graphics.setLineWidth(width + i)
        love.graphics.polygon("line", points)
    end
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(color[1], color[2], color[3], 1)
    love.graphics.setLineWidth(width)
    love.graphics.polygon("line", points)
end

return UI;
