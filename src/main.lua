---@diagnostic disable: param-type-mismatch
UI = require("game.ui")

Screen = {}
World = love.physics.newWorld(0, 0, true)
function love.load()
	-- Important Inits
	math.randomseed(os.time())
	Screen = UI.windowResized()

	collectgarbage("restart")
	collectgarbage("setpause", 120)
	collectgarbage("setstepmul", 200)
end

function love.update(dt)
	World:update(dt)
end

function love.draw() end

function love.resize()
	Screen = UI.windowResized()
end

function love.keypressed(key, scancode, isrepeat) end

function love.keyreleased(key, scancode) end
