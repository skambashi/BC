local Class = require "lib/middleclass.middleclass"

local Enemy = Class("Enemy")

function Enemy:initialize(world, x, y)
    self.width = 50
    self.height = 50

    world:addCollisionClass('Enemy')
    self.collider = world:newRectangleCollider(x - self.width / 2, y, self.width, self.height, {
        collision_class = "Enemy",
        ignores = { 'Player' },
        body_type = 'static'
    })
end

function Enemy:draw()
    love.graphics.setColor(226, 118, 74)
    love.graphics.rectangle("fill", self.collider.body:getX() - self.width / 2, self.collider.body:getY() - self.height / 2, self.width, self.height)
end

function Enemy:update(x, y)
    self.collider.body:setPosition(x, y)
end

return Enemy
