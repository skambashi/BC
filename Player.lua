local Player = Class {
    init = function(self, world, x, y)
        self.entity = world:addCollisionClass('player')
        self.x = x
        self.y = y
    end
}

function Player:update(dt)
end

function Player:draw()
end

return Player
