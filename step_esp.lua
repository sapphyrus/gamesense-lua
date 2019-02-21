--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_random_int, client_latency, client_set_clan_tag, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_error_log, client_draw_hitboxes, client_camera_angles, client_open_panorama_context, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.random_int, client.latency, client.set_clan_tag, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.error_log, client.draw_hitboxes, client.camera_angles, client.open_panorama_context, client.system_time
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_new_checkbox, ui_mouse_position, ui_new_listbox, ui_new_multiselect, ui_is_menu_open, ui_new_hotkey, ui_set, ui_new_button, ui_set_callback, ui_name, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.new_checkbox, ui.mouse_position, ui.new_listbox, ui.new_multiselect, ui.is_menu_open, ui.new_hotkey, ui.set, ui.new_button, ui.set_callback, ui.name, ui.get
local renderer_load_svg, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_world_to_screen, renderer_indicator, renderer_texture = renderer.load_svg, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.world_to_screen, renderer.indicator, renderer.texture
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local materialsystem_chams_material, materialsystem_arms_material, materialsystem_find_texture, materialsystem_find_material, materialsystem_override_material, materialsystem_find_materials, materialsystem_get_model_materials = materialsystem.chams_material, materialsystem.arms_material, materialsystem.find_texture, materialsystem.find_material, materialsystem.override_material, materialsystem.find_materials, materialsystem.get_model_materials
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local teammates_reference = ui.reference("VISUALS", "Player ESP", "Teammates")
local enabled_reference = ui_new_combobox("VISUALS", "Effects", "Show steps", {"Off", "Text", "Icon", "Circle"})
local color_reference = ui_new_color_picker("VISUALS", "Effects", "Step color", 150, 200, 60, 150)
local size_reference = ui_new_slider("VISUALS", "Effects", "Step circle size", 1, 30, 12, true, "u")
local duration_reference = ui_new_slider("VISUALS", "Effects", "Step duration", 1, 80, 20, true, "s", 0.1)
local max_distance_reference = ui_new_slider("VISUALS", "Effects", "Step distance", 300, 10000, 2500, true, "u")

local steps = {}
local last_step = {}
local scope_level_player = {}
local weapon_mode_player = {}
local weapon_prev_player = {}

local function draw_circle_3d(ctx, x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
	local accuracy = accuracy or 3
	local width = width or 1
	local outline = outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local screen_x_line_old, screen_y_line_old
	for rot = start_degrees, percentage * 360, accuracy do
		local rot_temp = math_rad(rot)
		local lineX, lineY, lineZ = radius * math_cos(rot_temp) + x, radius * math_sin(rot_temp) + y, z
		local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~= nil and screen_x_line_old ~= nil then
			for i = 1, width do
				local i = i - 1
				renderer_line(screen_x_line, screen_y_line - i, screen_x_line_old, screen_y_line_old - i, r, g, b, a)
			end
			if outline then
				local outline_a = a / 255 * 160
				renderer_line(screen_x_line, screen_y_line - width, screen_x_line_old, screen_y_line_old - width, 16, 16, 16, outline_a)
				renderer_line(screen_x_line, screen_y_line + 1, screen_x_line_old, screen_y_line_old + 1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

local function distance(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1))
end

local function contains(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end

local function on_enabled_change()
	local enabled = ui_get(enabled_reference)
	ui_set_visible(duration_reference, enabled ~= "Off")
	ui_set_visible(max_distance_reference, enabled ~= "Off")
	ui_set_visible(size_reference, enabled == "Circle")
end
ui.set_callback(enabled_reference, on_enabled_change)
on_enabled_change()

local function reset()
	steps = {}
	last_step = {}
	scope_level_player = {}
	weapon_mode_player = {}
end
client.set_event_callback("round_start", reset)


local function on_noise(player)
	if player ~= nil and entity_is_enemy(player) then-- and ((ui_get(teammates_reference) and player == entity_get_local_player()) or is_enemy(player)) then --and contains(entity_get_players(), player)
		local realtime = globals_realtime()
		local local_x, local_y, local_z = entity_get_prop(entity_get_local_player(), "m_vecAbsOrigin")
		local max_distance = ui_get(max_distance_reference)
		local x, y, z = entity_get_prop(player, "m_vecAbsOrigin")
		if x ~= nil then
			if max_distance > distance(local_x, local_y, local_z, x, y, z) then
				table_insert(steps, {realtime, x, y, z, player})
			end
		end
	end
end

local function on_noise_event(e)
	local enabled = ui_get(enabled_reference)
	if enabled == "Off" then
		return
	end

	local player = client_userid_to_entindex(e.userid)
	on_noise(player)
end
client.set_event_callback("player_footstep", on_noise_event)

--technically noise aswell, but it's too much spam
--client.set_event_callback("weapon_fire", on_noise_event)

local function on_paint(ctx)
	local enabled = ui_get(enabled_reference)
	if enabled == "Off" then
		return
	end

	if #steps > 0 then
		local realtime = globals_realtime()
		local duration = ui_get(duration_reference) * 0.1
		local r, g, b, a = ui_get(color_reference)
		local steps_new = {}
		for i = 1, #steps do
			local step = steps[i]

			local opacity_multiplier_dormant = step[6]
			if opacity_multiplier_dormant == nil then
				local _, _, _, _, temp = entity_get_bounding_box(ctx, step[5])
				if step[5] == entity_get_local_player() then
					opacity_multiplier_dormant = 1
				else
					opacity_multiplier_dormant = temp
				end
			end
			step[6] = opacity_multiplier_dormant

			if step[1] + duration > realtime and opacity_multiplier_dormant > 0 then
				local time_since_step = realtime - step[1]
				local opacity_multiplier = 1
				local size_multiplier = ((time_since_step) / duration)
				if duration - time_since_step < duration then
					opacity_multiplier = (duration - time_since_step) / duration
				end
				opacity_multiplier = math_min(opacity_multiplier, 1)
				opacity_multiplier = math_max(opacity_multiplier, 0)

				local wx, wy = renderer_world_to_screen(step[2], step[3], step[4])

				if wx ~= nil then
					if enabled == "Text" then
						renderer_text(wx, wy, r, g, b, a * opacity_multiplier, "c-", 0, "STEP")
					elseif enabled == "Icon" then
						renderer_text(wx, wy, r, g, b, a * opacity_multiplier, "c", 0, "▪")
					elseif enabled == "Circle" then
						local size = ui_get(size_reference)
						local width = 2
						width = width + (1 - size_multiplier) * 2
						draw_circle_3d(ctx, step[2], step[3], step[4], size_multiplier * size, r, g, b, a * opacity_multiplier * opacity_multiplier_dormant, 36, width, true)
					end
				end
				table_insert(steps_new, step)
			end
		end
		steps = steps_new
	end
end
client.set_event_callback("paint", on_paint)

local function on_run_command(e)
	local scope_level_player_prev = scope_level_player
	local weapon_mode_player_prev = weapon_mode_player
	scope_level_player = {}
	weapon_mode_player = {}

	local players = entity_get_players(not ui_get(teammates_reference))
	--players = {entity_get_local_player()}
	for i = 1, #players do
		local player = players[i]
		local weapon = entity_get_player_weapon(player)
		if weapon ~= nil then
			local weapon_name = entity_get_classname(weapon)
			local scope_level = entity_get_prop(weapon, "m_zoomLevel")
			if scope_level ~= nil and 3 > scope_level and scope_level >= 0 then
				scope_level_player[player] = scope_level
				if weapon_prev_player[player] == weapon and scope_level_player_prev[player] ~= nil and scope_level_player_prev[player] ~= scope_level then
					--client.log("changed from ", scope_level_player_prev[player], " to ", scope_level)
					on_noise(player)
				end
			end
			if weapon_name == "CWeaponFamas" or weapon_name == "CWeaponGlock" then
				local weapon_mode = entity_get_prop(weapon, "m_weaponMode")
				if weapon_prev_player[player] == weapon and weapon_mode ~= nil and 3 > weapon_mode and weapon_mode >= 0 then
					weapon_mode_player[player] = weapon_mode
					if weapon_mode_player_prev[player] ~= nil and weapon_mode_player_prev[player] ~= weapon_mode then
						--client.log("changed from ", weapon_mode_player_prev[player], " to ", weapon_mode)
						on_noise(player)
					end
				end
			end
			weapon_prev_player[player] = weapon
		end
	end
end
client.set_event_callback("run_command", on_run_command)
