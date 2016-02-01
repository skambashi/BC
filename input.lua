local Input = {}

local keys = setmetatable({}, {
    __index = function(table, key)
        return {
            pressed = false,
            released = false,
            isDown = false
        }
    end
})

function Input:clear()
    for key, value in pairs(keys) do
        value.pressed = false
        value.released = false
        value.isDown = love.keyboard.isDown(key)
    end
end

----- Setters -----
function love.keypressed(key)
    keys[key] = keys[key]
    keys[key].pressed = true
end

function love.keyreleased(key)
    keys[key] = keys[key]
    keys[key].released = true
end

----- Getters -----
function Input:pressed(key)
    return keys[key].pressed
end

function Input:released(key)
    return keys[key].released
end

function Input:isDown(key)
    return keys[key].isDown
end

return Input
