local Class = require "lib/middleclass.middleclass"

local Player = Class("Player")

function Player:initialize(world, x, y)
    self.width = 50
    self.height = 50

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

return Player
