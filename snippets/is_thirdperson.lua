--returns true if you're in thirdperson
local function is_thirdperson()
	local x, y, z = client.eye_position()
	local pitch, yaw = client.camera_angles()

	yaw = yaw - 180
	pitch, yaw = math.rad(pitch), math.rad(yaw)

	x = x + math.cos(yaw)*4
	y = y + math.sin(yaw)*4
	z = z + math.sin(pitch)*4

	return renderer.world_to_screen(x, y, z) ~= nil
end
