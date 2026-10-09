local Handler = {}

World = love.physics.newWorld(0, 0, true)
Player = {
  ship = nil,
}

function Handler:load()
  Player.ship = Ship:new({
    world = World,
  })
  Player.ship.body:setLinearDamping(0)
  Player.ship.body:setAngularDamping(0)
  World.setGravity(World, 0, 5)
end

function Handler:update(dt)
  Player.ship:update(dt)
end

function Handler:draw()
  Player.ship:render()
end

return Handler
