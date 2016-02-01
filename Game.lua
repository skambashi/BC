require "lib/nhub.nhub"

Gamestate = require "lib/hump.gamestate"
hx = require "lib/hxdx/hxdx"

Class = require "lib/hump.class"

local SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
local FONT = love.graphics.newFont('res/fonts/babyblue.ttf', 48)

local hub = noobhub.new({ server = "server.kambashi.com"; port = 1337; })

local menu = {}
local game = {}
local pause = {}

local Game = Class {}

function Game:init()
    love.graphics.setFont(FONT)

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function Game:update(dt)

end

function Game:draw()

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
    self.world = hx.newWorld({
        gravity_y = 200
    })

    self.world:addCollisionClass("player")
    -- self.world:addCollisionClass("environment")
    self.world:collisionClassesSet()

    box = self.world:newRectangleCollider(375, 300, 50, 50, {
        collision_class = "player"
    })

    ground  = self.world:newRectangleCollider(300, 400, 200, 30, {
        -- collision_class = "environment",
        body_type = "static"
    })

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
    self.world:update(dt)

    if box:enter("Default") then
        box.body:applyLinearImpulse(0, -1500)
    end

    hub:enterFrame()

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
    self.world:draw()
end

function game:keypressed(key)
    if key == 'p' then
        return Gamestate.push(pause)
    end

    if key == 'escape' then
        love.event.push('quit')
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

    if key == 'escape' then
        love.event.push('quit')
    end
end


return Game
