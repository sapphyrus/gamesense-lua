-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, math_atan2, math_cos, math_deg, math_rad, math_sin, math_sqrt, renderer_line, renderer_triangle, renderer_world_to_screen, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, math.atan2, math.cos, math.deg, math.rad, math.sin, math.sqrt, renderer.line, renderer.triangle, renderer.world_to_screen, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible

local quickstop_reference = ui_reference("RAGE", "Other", "Quick stop")

local enabled_reference = ui_new_checkbox("RAGE", "Other", "Quick peek")
local hotkey_reference = ui_new_hotkey("RAGE", "Other", "Quick peek hotkey", true)
local triggers_reference = ui_new_multiselect("RAGE", "Other", "\nQuick peek triggers", {"X shots", "Kill", "Standing still"})
local shots_reference = ui_new_slider("RAGE", "Other", "\nQuick peek shots", 1, 6, 1)
local draw_reference = ui_new_checkbox("VISUALS", "Other ESP", "Draw quick peek")
local color_reference = ui_new_color_picker("VISUALS", "Other ESP", "Quick peek color", 198, 70, 70, 146)

local single_fire_weapons = {
	"CDeagle",
	"CWeaponSSG08",
	"CWeaponAWP"
}

local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage, fill_r, fill_g, fill_b, fill_a)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local center_x, center_y
	if fill_a then
		center_x, center_y = renderer_world_to_screen(x, y, z)
	end

	local screen_x_line_old, screen_y_line_old
	for rot=start_degrees, percentage*360, accuracy do
		local rot_temp = math_rad(rot)
		local lineX, lineY, lineZ = radius * math_cos(rot_temp) + x, radius * math_sin(rot_temp) + y, z
		local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~=nil and screen_x_line_old ~= nil then
			if fill_a and center_x ~= nil then
				renderer_triangle(screen_x_line, screen_y_line, screen_x_line_old, screen_y_line_old, center_x, center_y, fill_r, fill_g, fill_b, fill_a)
			end
			for i=1, width do
				local i=i-1
				renderer_line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
				renderer_line(screen_x_line-1, screen_y_line, screen_x_line_old-i, screen_y_line_old, r, g, b, a)
			end
			if outline then
				local outline_a = a/255*160
				renderer_line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
				renderer_line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function table_contains(tbl, val)
	for i = 1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function vector_angles(x1, y1, z1, x2, y2, z2)
	--https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/mathlib/mathlib_base.cpp#L535-L563
	local origin_x, origin_y, origin_z
	local target_x, target_y, target_z
	if x2 == nil then
		target_x, target_y, target_z = x1, y1, z1
		origin_x, origin_y, origin_z = client_eye_position()
		if origin_x == nil then
			return
		end
	else
		origin_x, origin_y, origin_z = x1, y1, z1
		target_x, target_y, target_z = x2, y2, z2
	end

	local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z

	if delta_x == 0 and delta_y == 0 then
		return (delta_z > 0 and 270 or 90), 0
	else
		local yaw = math_deg(math_atan2(delta_y, delta_x))
		local hyp = math_sqrt(delta_x*delta_x + delta_y*delta_y)
		local pitch = math_deg(math_atan2(-delta_z, hyp))

		return pitch, yaw
	end
end

local hotkey_prev, shots, pos_x, pos_y, pos_z = false, 0
local quickstop_prev, quickstop_allowed, standing

local function update_visiblity()
	local enabled = ui_get(enabled_reference)
	ui_set_visible(triggers_reference, enabled)
	ui_set_visible(shots_reference, enabled and table_contains(ui_get(triggers_reference), "X shots"))

	if not enabled then
		hotkey_prev = false
		shots = 0
		pos_x = nil
	end
end
ui_set_callback(enabled_reference, update_visiblity)
ui_set_callback(triggers_reference, update_visiblity)
update_visiblity()

local function on_paint()
	local is_enabled = ui_get(enabled_reference) and ui_get(hotkey_reference) and pos_x ~= nil and entity_is_alive(entity_get_local_player())

	if quickstop_allowed or not is_enabled then
		if quickstop_prev ~= nil then
			ui_set(quickstop_reference, true)
			quickstop_prev = nil
		end
		quickstop_allowed = nil
	end

	if not is_enabled or not ui_get(draw_reference) then
		return
	end

	local wx, wy = renderer_world_to_screen(pos_x, pos_y, pos_z)

	if wx ~= nil then
		local r, g, b, a = ui_get(color_reference)
		draw_circle_3d(pos_x, pos_y, pos_z, 14, r, g, b, a, 3, 2, false, 0, 1, r, g, b, a*0.6)
	end
end
client_set_event_callback("paint", on_paint)

local function on_aim_fire(e)
	shots = shots + 1
end
client_set_event_callback("aim_fire", on_aim_fire)

local function on_player_death(e)
	if table_contains(ui_get(triggers_reference), "Kill") and client_userid_to_entindex(e.attacker) == entity_get_local_player() then
		shots = -1
	end
end
client_set_event_callback("player_death", on_player_death)

local function on_setup_command(cmd)
	if not ui_get(enabled_reference) then
		return
	end

	local hotkey = ui_get(hotkey_reference)

	if hotkey then
		local local_player = entity_get_local_player()
		if not hotkey_prev then
			pos_x, pos_y, pos_z = entity_get_prop(local_player, "m_vecAbsOrigin")
			shots = 0
		end

		if cmd.in_attack == 1 then
			shots = -1
		end

		local is_single_fire_weapon = table_contains(single_fire_weapons, entity_get_classname(entity_get_player_weapon(local_player)))
		local shots_min = is_single_fire_weapon and 1 or ui_get(shots_reference)
		local triggers = ui_get(triggers_reference)

		if table_contains(triggers, "Standing still") then
			if not standing and distance3d(0, 0, 0, entity_get_prop(local_player, "m_vecVelocity")) < 15 then
				standing = true
			elseif cmd.sidemove ~= 0 or cmd.forwardmove ~= 0 then
				standing = false
			end
		else
			standing = false
		end

		if (table_contains(triggers, "X shots") and (shots >= shots_min or shots == -1)) or standing then
			local x, y, z = entity_get_prop(local_player, "m_vecAbsOrigin")

			if 15 > distance3d(x, y, z, pos_x, pos_y, pos_z) then
				shots = 0
				quickstop_allowed = true
			else
				local pitch, yaw = vector_angles(x, y, z, pos_x, pos_y, pos_z)
				local require_moving = false
				if not require_moving or cmd.forwardmove ~= 0 or cmd.sidemove ~= 0 then
					cmd.in_forward = 1
					cmd.in_back = 0
					cmd.in_moveleft = 0
					cmd.in_moveright = 0
					cmd.in_speed = 0

					cmd.forwardmove = 450
					cmd.sidemove = 0

					cmd.move_yaw = yaw

					if ui_get(quickstop_reference) then
						quickstop_prev = true
						ui_set(quickstop_reference, false)
					end
				end
			end
		else
			quickstop_allowed = true
		end
	else
		shots = 0
		pos_x = nil
	end

	hotkey_prev = hotkey
end
client_set_event_callback("setup_command", on_setup_command)

local function on_shutdown()
	if quickstop_prev ~= nil then
		ui_set(quickstop_reference, true)
		quickstop_prev = nil
	end
end
client_set_event_callback("shutdown", on_shutdown)
