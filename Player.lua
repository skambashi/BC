local Class = require "lib/middleclass.middleclass"

local Player = Class("Player")

function Player:initialize(world, x, y)
    self.width = 50
    self.height = 50

    self.moveLeft = false
    self.moveRight = false
    self.moveVel = 500

    self.grounded = false

    world:addCollisionClass('Player')
    self.collider = world:newRectangleCollider(x - self.width / 2, y, self.width, self.height, {
        collision_class = "Player"
    })
end

function Player:draw()
    local r, g, b = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", self.collider.body:getX() - self.width / 2, self.collider.body:getY() - self.height / 2, self.width, self.height)

    love.graphics.setColor(r, g, b)
end

function Player:update(dt)
    if Input:pressed('left') then self.moveLeft = true
    elseif Input:released('left') then self.moveLeft = false end

    if Input:pressed('right') then self.moveRight = true
    elseif Input:released('right') then self.moveRight = false end

    if self.moveLeft ~= self.moveRight then
        local direction = self.moveLeft and -1 or 1
        local x, y = self.collider.body.getPosition(self.collider.body)
        self.collider.body:setPosition(x + self.moveVel * direction * dt, y)
    end

    if Input:pressed('space') and self.grounded then
        self.collider.body:applyLinearImpulse(0, -3500)
        self.grounded = false
    end

    if self.collider:enter("Ground") then
        self.grounded = true
    end
end

return Player
