local images_lib = require "images"
local images_icons = images_lib.load(require("imagepack_icons"))

client.set_event_callback("paint", function()
	--Starting x and y
	local x, y = 590, 15

	local i = 1

	--loop through all elements in images_icons
	for name, image in pairs(images_icons) do
		--calculate x and y of the current image
		local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30

		--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
		local width, height = image:draw(x_i, y_i, nil, 16, 255, 255, 255, 255)

		--draw image name
		renderer.text(x_i, y_i+16, 255, 255, 255, 255, nil, 0, name)

		i = i + 1
	end
end)
