Gamestate = require "lib/hump.gamestate"
NHub = require "lib/nhub.nhub"
local Lovebird = require "lib/lovebird.lovebird"

local menu = {}
local game = {}
local pause = {}
local SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
local font = love.graphics.newFont('res/fonts/babyblue.ttf', 48)
local hub = noobhub.new({ server = "server.kambashi.com"; port = 1337; })


function menu:draw()
    love.graphics.printf("BLESSED CHILD", 0, SCREEN_HEIGHT / 2 - font.getHeight(font), SCREEN_WIDTH, 'center')
    love.graphics.printf("Press ENTER to START", 0, SCREEN_HEIGHT / 2 + font.getHeight(font), SCREEN_WIDTH * 2.5, 'center', 0, 0.4, 0.4)
end

function menu:keyreleased(key)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

function game:init()
    hub:subscribe({
        channel = "blessed-child",
        callback = function(message)
            if (message.action == "update") then
                Lovebird.print(message.dt)
            end
        end
    });
end

function game:enter()
end

function game:update(dt)
    hub:publish({
        message = {
            action  =  "update",
            dt = dt
        }
    });
end

function game:draw()
    love.graphics.printf("PLAYING", 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 'center')
end

function game:keypressed(key)
    if key == 'p' then
        return Gamestate.push(pause)
    end
end

function pause:enter(from)
    self.from = from
end

function pause:draw()
    self.from:draw()
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, SCREEN_WIDTH,SCREEN_HEIGHT)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("PAUSED", 0, SCREEN_HEIGHT - font.getHeight(font)*2, SCREEN_WIDTH, 'center')
end

function pause:keypressed(key)
    if key == 'p' then
        return Gamestate.pop()
    end
end

function love.load()
    love.graphics.setFont(font)
    love.mouse.setVisible(false)
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end
end
