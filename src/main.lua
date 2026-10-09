UI = require("game.ui")
Handler = require("handler")
Settings = require("game.settings")
Ship = require("sprites.ship")

Screen = {}

function love.load()
	-- Important Inits
	math.randomseed(os.time())
	Screen = UI.windowResized()

	Handler:load()
	collectgarbage("restart")
end

function love.update(dt)
	World:update(dt)
	Handler:update(dt)
end

function love.draw()
    Handler:draw()
end

function love.resize()
	Screen = UI.windowResized()
end

function love.keypressed(key, scancode, isrepeat) end

function love.keyreleased(key, scancode) end
