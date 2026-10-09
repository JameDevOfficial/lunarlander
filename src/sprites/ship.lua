local ship = {}
ship.__index = ship

ship.initialUpdateDone = false

function ship:new(opts)
  opts = opts or {}
  local o = setmetatable({}, self)
  o.type = "ship"
  o.size = opts.size or Settings.ship.size
  o.color = opts.color or { 1, 1, 1, 1 }
  o.position = opts.position or { x = Screen.centerX / 10, y = Screen.centerY / 3 }
  o.velocity = opts.velocity or { x = 0, y = 0 }
  o.damping = opts.damping or 0.5
  o.rotation = opts.rotation or 0
  o.offset = opts.offset or { x = 0, y = 0 }
  o.scale = opts.scale or { w = 1, y = 1 }
  o.safeTime = Settings.ship.safeTime

  local w_2 = o.size.w / 2
  local h_2 = o.size.h / 2

  o.shape = {
    w_2,
    0,
    -w_2,
    -h_2,
    -(o.size.w / 4),
    0,
    -w_2,
    h_2,
  }

  if opts.world then
    o.body = love.physics.newBody(opts.world, o.position.x, o.position.y, "dynamic")
    o.body:setLinearDamping(o.damping)
    ---@diagnostic disable-next-line: deprecated
    o.fixture = love.physics.newPolygonShape(unpack(o.shape))
    o.collision = love.physics.newFixture(o.body, o.fixture)
    o.collision:setUserData(o)
    o.body:setAngle(o.rotation)
  end
  return o
end

function ship:checkMovement(dt)
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    self:applyThrust(10)
  end

  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    self:rotate(-dt * 3)
    self:stopSpin()
  end

  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    self:rotate(dt * 3)
    self:stopSpin()
  end
end

function ship:render()
  local shipVisible = true
  if self.safeTime and self.safeTime > 0 then
    local blinkRate = 4
    shipVisible = (math.floor(self.safeTime * blinkRate) % 2) == 0
  end
  love.graphics.push()
  love.graphics.setLineWidth(2)
  love.graphics.translate(self.body:getX(), self.body:getY())
  love.graphics.rotate(self.body:getAngle())
  love.graphics.setColor(self.color)
  if shipVisible then
    UI.drawNeonPolyline(self.shape, Settings.ship.color, 16, 2)
  else
  end
  if Settings.DEBUG then
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.line(0, 0, 30, 0)
  end

  love.graphics.pop()
end

function ship:stopSpin()
  if self.body and self.body.setAngularVelocity then
    self.body:setAngularVelocity(0)
  end
end

function ship:destroy()
  if self.body then
    self.body:destroy()
    self.body = nil
  end
end

function ship:checkBounds(dt)
  if not self.body then
    return
  end
  if self.body:getX() > Screen.X + Settings.ship.screenPadding then
    self.body:setPosition(-Settings.ship.screenPadding, self.body:getY())
  end
  if self.body:getX() < -Settings.ship.screenPadding then
    self.body:setPosition(Screen.X + Settings.ship.screenPadding, self.body:getY())
  end
  if self.body:getY() > Screen.Y + Settings.ship.screenPadding then
    self.body:setPosition(self.body:getX(), -Settings.ship.screenPadding)
  end
  if self.body:getY() < -Settings.ship.screenPadding then
    self.body:setPosition(self.body:getX(), Screen.Y + Settings.ship.screenPadding)
  end
end

function ship:update(dt)
  if self.initialUpdateDone == false then
    Player.ship:applyThrust(10000)
    self.initialUpdateDone = true
    return
  end
  if self.safeTime > 0 then
    self.safeTime = self.safeTime - dt
  end
  self:checkBounds(dt)
  self:checkMovement(dt)
  print("Updating")

end

function ship:applyThrust(force)
  if self.body then
    local angle = self.body:getAngle()
    local forceX = math.cos(angle) * force
    local forceY = math.sin(angle) * force
    self.body:applyForce(forceX, forceY)
  end
end

function ship:rotate(amount)
  if self.body then
    self.body:setAngle(self.body:getAngle() + amount)
  else
    self.rotation = self.rotation + amount
  end
end

return ship
