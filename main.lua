function love.load()
	-- love.graphics.setNewFont('res/fonts/hirosh.ttf', 48)
	-- love.mouse.setVisible(false)
end

function love.keypressed(key)
	if key == 'escape' then
    	love.event.push('quit')
    end
end
