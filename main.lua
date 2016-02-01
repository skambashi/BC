Input = require "input"
Lovebird = require "lib/lovebird.lovebird"

local Game = require "game"

----- Love Handles -----
function love.load()
    game = Game()
end

function love.update(dt)
    game:update(dt)

    if Input:pressed('escape') then
        love.event.quit()
    end

    Lovebird:update()
    Input:clear()
end

function love.draw()
    game:draw()
end
