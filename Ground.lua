local Class = require "lib/middleclass.middleclass"

local Ground = Class("Ground")

function Ground:initialize(world, x, y, w, h)
    self.width = w
    self.height = h

    world:addCollisionClass('Ground')
    self.collider = world:newRectangleCollider(x, y, w, h, {
        collision_class = "Ground",
        body_type = "static"
    })
end

function Ground:draw()
    love.graphics.setColor(64, 128, 244)
    love.graphics.rectangle("fill", self.collider.body:getX() - self.width / 2, self.collider.body:getY() - self.height / 2, self.width, self.height)
end

return Ground
