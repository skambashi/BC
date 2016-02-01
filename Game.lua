local Class = require "lib/middleclass.middleclass"

require "lib/nhub.nhub"
local Stateful = require "lib/stateful.stateful"
local hx = require "lib/hxdx/hxdx"

local SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
local FONT = love.graphics.newFont('res/fonts/babyblue.ttf', 48)
local hub = noobhub.new({ server = "server.kambashi.com"; port = 1337; })

local Game = Class("Game")
Game:include(Stateful)
local menu = Game:addState("Menu")
local play = Game:addState("Play")
local pause = Game:addState("Pause")

function Game:initialize()
    love.graphics.setFont(FONT)

    self:gotoState("Menu")
end

function Game:update(dt)
    hub:enterFrame()
end

function Game:draw()

end

----- Menu -----
function menu:draw()
    love.graphics.printf("BLESSED CHILD", 0, SCREEN_HEIGHT / 2 - FONT.getHeight(FONT), SCREEN_WIDTH, 'center')
    love.graphics.printf("Press ENTER to START", 0, SCREEN_HEIGHT / 2 + FONT.getHeight(FONT), SCREEN_WIDTH * 2.5, 'center', 0, 0.4, 0.4)
end

function menu:update(dt)
    if Input:pressed('return') then
        self:gotoState("Play")
    end
end

----- It's only game -----
function play:enteredState()
    if hub.sock == nil then
        hub:subscribe({
            channel = "blessed-child",
            callback = function(message)
                if (message.action == "update") then
                end
            end
        });
    end
end

function play:update(dt)
    Game.update(self, dt)

    if Input:pressed('p') then
        return self:gotoState("Pause")
    end

    hub:publish({
        message = {
            action  =  "update",
            dt = dt
        }
    });
end

function play:draw()
    love.graphics.printf("PLAYING", 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 'center')
end

----- Pause -----
function pause:update(dt)
    Game.update(self, dt)

    if Input:pressed('p') then
        return self:gotoState("Play")
    end
end

function pause:draw()
    play:draw()

    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, SCREEN_WIDTH,SCREEN_HEIGHT)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("PAUSED", 0, SCREEN_HEIGHT - FONT.getHeight(FONT)*2, SCREEN_WIDTH, 'center')
end

return Game
