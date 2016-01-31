require "lib/nhub.nhub"

Gamestate = require "lib/hump.gamestate"
Lovebird = require "lib/lovebird.lovebird"

----- Local Variables -----
local menu = {}
local game = {}
local pause = {}

local SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
local FONT = love.graphics.newFont('res/fonts/babyblue.ttf', 48)

local hub = noobhub.new({ server = "server.kambashi.com"; port = 1337; })

----- Love Handles -----
function love.load()
    love.graphics.setFont(FONT)
    love.mouse.setVisible(false)
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end
end

function love.update(dt)
    hub:enterFrame()
end

----- Menu -----
function menu:draw()
    love.graphics.printf("BLESSED CHILD", 0, SCREEN_HEIGHT / 2 - FONT.getHeight(FONT), SCREEN_WIDTH, 'center')
    love.graphics.printf("Press ENTER to START", 0, SCREEN_HEIGHT / 2 + FONT.getHeight(FONT), SCREEN_WIDTH * 2.5, 'center', 0, 0.4, 0.4)
end

function menu:keyreleased(key)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

----- It's only game -----
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

    Lovebird.update()
end

function game:draw()
    love.graphics.printf("PLAYING", 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 'center')
end

function game:keypressed(key)
    if key == 'p' then
        return Gamestate.push(pause)
    end
end

----- Pause -----
function pause:enter(from)
    self.from = from
end

function pause:draw()
    self.from:draw()
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, SCREEN_WIDTH,SCREEN_HEIGHT)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("PAUSED", 0, SCREEN_HEIGHT - FONT.getHeight(FONT)*2, SCREEN_WIDTH, 'center')
end

function pause:keypressed(key)
    if key == 'p' then
        return Gamestate.pop()
    end
end
