local entity_get_player_weapon, entity_get_local_player, entity_get_classname, entity_get_prop, entity_get_all, math_sqrt = entity.get_player_weapon, entity.get_local_player, entity.get_classname, entity.get_prop, entity.get_all, math.sqrt
local use_blocked, use_released = false, false
local chokedcommands_prev = 0

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

local function entities_close(lx, ly, lz, classname, bool_prop)
	local entities = entity_get_all(classname)
	for i=1, #entities do
		if bool_prop == nil or entity_get_prop(entities[i], bool_prop) == 1 then
			local x, y, z = entity_get_prop(entities[i], "m_vecOrigin")

			if 100 > distance3d(lx, ly, lz, x, y, z) then
				return true
			end
		end
	end
end

client.set_event_callback("setup_command", function(cmd)
	local in_use = cmd.in_use == 1
	local chokedcommands = cmd.chokedcommands

	--if a command is not in_use, save that we released use key
	if not in_use then
		use_released = true
	end

	--check if we should handle in_use (checks if we're fakelagging and if we're in_use or previously blocked a in_use), if not, return
	if not ((in_use or use_blocked) and (chokedcommands > 0 or chokedcommands_prev > 0)) then
		chokedcommands_prev = chokedcommands
		return
	end

	--keep track of our previously choked commands to see if we're fakelagging
	chokedcommands_prev = chokedcommands

	--check if we're holding a c4
	local local_player = entity_get_local_player()
	local weapon = entity_get_classname(entity_get_player_weapon(local_player))
	if weapon == "CC4" then
		return
	end

	--check if we're close to a planted c4 or hostage
	local lx, ly, lz = entity_get_prop(local_player, "m_vecOrigin")
	if entities_close(lx, ly, lz, "CPlantedC4", "m_bBombTicking") or entities_close(lx, ly, lz, "CHostage") then
		return
	end

	--checks if we're in_use for the first time and havent blocked a in_use yet
	if use_released and not use_blocked then
		use_blocked, use_released = true, false
	end

	--sets in_use to false, then checks if we have a in_use blocked and can send it
	cmd.in_use = 0
	if use_blocked and chokedcommands == 0 then
		cmd.in_use = 1
		use_blocked = false
	end

end)
