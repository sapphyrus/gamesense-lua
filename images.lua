local M = {}

local renderer_load_svg, renderer_texture, math_floor = renderer.load_svg, renderer.texture, math.floor

local image_class = {}
local image_mt = {
	__index = image_class
}

local cache = {}

function image_class:measure(width, height)
	if width == nil and height == nil then
		return self.width, self.height
	elseif width == nil then
		height = height or self.height
		local width = math_floor(self.width * (height/self.height))
		return width, height
	elseif height == nil then
		width = width or self.width
		local height = math_floor(self.height * (width/self.width))
		return width, height
	else
		return width, height
	end
end

function image_class:draw(x, y, width, height, r, g, b, a, force_same_res_render)
	local width, height = self:measure(width, height)
	local id = width .. "_" .. height
	local texture = self.textures[id]
	if texture == nil then
		if ({next(self.textures)})[2] == nil or force_same_res_render then
			texture = renderer_load_svg(self.svg, width, height)
			if texture == nil then
				self.textures[id] = -1
				error("failed to load svg " .. self.name .. " for " .. width .. "x" .. height)
			else
				client.log("loaded svg ", self.name, " for ", width, "x", height)
				self.textures[id] = texture
			end
		else
			--right now we just choose a random texture (determined by the pairs order aka unordered)
			--todo: select the texture with the highest or closest resolution?
			texture = ({next(self.textures)})[2]
		end
	end
	if texture == nil or texture == -1 then
		return
	end
	if a > 0 then
		renderer_texture(texture, x, y, width, height, r, g, b, a)
	end
	return width, height
end

function M.load(data)
	local result = {}

	if cache[data] == nil then
		local header = data[-1]
		for image_name, image_data in pairs(data) do
			if image_name ~= -1 then
				local image = setmetatable({}, image_mt)

				--initialize image object
				image.name = image_name
				image.width = image_data[1]
				image.height = image_data[2]

				image.svg = image_data[3]
				if header ~= nil and image.svg:sub(0, 5) ~= "<?xml" then
					image.svg = header .. image.svg
				end

				image.textures = {}

				result[image_name] = image
			end
		end

		cache[data] = result
	else
		result = cache[data]
	end

	return result
end

return M
