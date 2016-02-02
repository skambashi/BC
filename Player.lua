local Class = require "lib/middleclass.middleclass"

local Player = Class("Player")

function Player:initialize(world, x, y)
    self.width = 50
    self.height = 50

    self.moveLeft = false
    self.moveRight = false
    self.moveVel = 500

    self.grounded = false
    self.collider = world:newRectangleCollider(x - self.width / 2, y, self.width, self.height, {
        collision_class = "Player"
    })
end

function Player:draw()
    love.graphics.setColor(30, 140, 192)
    love.graphics.rectangle("fill", self.collider.body:getX() - self.width / 2, self.collider.body:getY() - self.height / 2, self.width, self.height)
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

    if love.keyboard.isDown('space') and self.grounded then
        self.collider.body:applyLinearImpulse(0, -3500)
        self.grounded = false
    end

    if self.collider:enter("Ground") then self.grounded = true end
end

function Player:getX()
    return self.collider.body:getX()
end

function Player:getY()
    return self.collider.body:getY()
end

return Player
