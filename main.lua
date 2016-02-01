-- Input Manager
Input = require "input"
Lovebird = require "lib/lovebird.lovebird"

local Game = require "game"

function love.load()
    game = Game()
end

function love.update(dt)
    game:update(dt)

    if Input:pressed('escape') then
        love.event.quit()
    end

    Input:update()
    Lovebird:update()
end

function love.draw()
    game:draw()
end
