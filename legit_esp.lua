--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_unset_event_callback, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_random_int, client_latency, client_set_clan_tag, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_error_log, client_draw_hitboxes, client_camera_angles, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.unset_event_callback, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.random_int, client.latency, client.set_clan_tag, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.error_log, client.draw_hitboxes, client.camera_angles, client.system_time
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

local enabled_reference = ui.new_checkbox("VISUALS", "Player ESP", "Legit ESP")
local hotkey_reference = ui.new_hotkey("VISUALS", "Player ESP", "Legit ESP hotkey", true)
local filters_reference = ui.new_multiselect("VISUALS", "Player ESP", "\nLegit ESP filter", {"Visible to you", "Visible to teammates", "Making noise", "When dead"})
local playerlist_reference = ui.reference("PLAYERS", "Players", "player list")
local disable_visuals_reference = ui.reference("PLAYERS", "Adjustments", "Disable visuals")
local dormant_reference = ui.reference("VISUALS", "Player ESP", "Dormant")

ui.set(hotkey_reference, "Off hotkey")

local on_screen, last_noise, visible_to_teammates = {}, {}, {}
local noise_duration = 1.25

local hitbox_head = 0
local hitbox_neck = 1
local hitbox_pelvis = 2
local hitbox_spine_0 = 3
local hitbox_spine_1 = 4
local hitbox_spine_2 = 5
local hitbox_spine_3 = 6
local hitbox_leg_upper_L = 7
local hitbox_leg_upper_R = 8
local hitbox_leg_lower_L = 9
local hitbox_leg_lower_R = 10
local hitbox_ankle_L = 11
local hitbox_ankle_R = 12
local hitbox_hand_L = 13
local hitbox_hand_R = 14
local hitbox_arm_upper_L = 15
local hitbox_arm_lower_L = 16
local hitbox_arm_upper_R = 17
local hitbox_arm_lower_R = 18
local hitboxes = {hitbox_head, hitbox_ankle_L, hitbox_ankle_R, hitbox_arm_lower_L, hitbox_arm_lower_R}

local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
	local x = (x2 - x1) * percentage + x1
	local y = (y2 - y1) * percentage + y1
	local z = (z2 - z1) * percentage + z1
	return x, y, z
end

local function set_plist(player, setter)
	local value_prev = ui_get(playerlist_reference)
	if value_prev ~= player then
		ui_set(playerlist_reference, player)
	end
	if ui_get(playerlist_reference) == player then
		local values = {setter()}
		if value_prev ~= player then
			ui_set(playerlist_reference, value_prev)
		end
		return true, unpack(values)
	else
		return false
	end
end

local function table_contains(table, val)
	for i=1,#table do
		if table[i] == val then
			return true
		end
	end
	return false
end

local function get_view_offset(player)
	if player == entity_get_local_player() then
		return entity_get_prop(player, "m_vecViewOffset[2]")
	else
		return 64 - (entity_get_prop(player, "m_flDuckAmount") * 18)
	end
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function is_player(entindex)
	return entity_get_classname(entindex) == "CCSPlayer"
end

local function is_teammate(player)
	if player == 0 then return false end
	return is_player(player) and not entity_is_enemy(player)
end

local function trace_line_skip(skip_function, x1, y1, z1, x2, y2, z2, max_traces, skip_entindex)
	local max_traces = max_traces or 10
	local fraction, entindex_hit = 0, skip_entindex or -1
	local x_hit, y_hit, z_hit = x1, y1, z1

	local i=0
	while max_traces >= i and fraction < 1 and ((entindex_hit > -1 and skip_function(entindex_hit)) or i == 0) do
		fraction, entindex_hit = client_trace_line(entindex_hit, x_hit, y_hit, z_hit, x2, y2, z2)
		x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, fraction)

		i = i + 1
		-- client.log("- trace #", i, " hit ", entindex_hit)
	end

	if i == 1 then
		return fraction, entindex_hit
	else
		local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
		local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

		return traveled_total/total_distance, entindex_hit
	end
end

local function player_can_see(player1, player2)
	local start_x, start_y, start_z
	if player1 == entity_get_local_player() then
		start_x, start_y, start_z = client_eye_position()
	else
		start_x, start_y, start_z = entity_get_prop(player1, "m_vecAbsOrigin")
		start_z = start_z + get_view_offset(player1)
	end

	for i=1, #hitboxes do
		-- client.log("checking if ", player1, " can see hitbox ", hitboxes[i], " of ", player2)
		local x, y, z = entity_hitbox_position(player2, hitboxes[i])
		local fraction, entindex_hit = trace_line_skip(is_teammate, start_x, start_y, start_z, x, y, z, 10, player1)
		-- local fraction, entindex_hit = client_trace_line(player1, start_x, start_y, start_z, x, y, z)
		-- client.draw_debug_text(x, y, z, 0, 0.1, 255, 255, 255, 255, hitboxes[i], " ", entindex_hit)
		-- client.draw_debug_text(x, y, z, 1, 0.1, 255, 255, 255, 255, string_format("%.3f", fraction))
		if entindex_hit == player2 or (entindex_hit == -1 and fraction == 1) then
			return true
		end
	end
	return false
end

local function players_can_see(players_start, player)
	for i=1, #players_start do
		local player_start = players_start[i]
		if player_can_see(player_start, player) then
			return true
		end
	end

	return false
end

--handle noise events
local noise_events = {
	"weapon_fire",
	"player_footstep",
}

local function on_noise(e)
	local player = client_userid_to_entindex(e.userid)
	if player ~= nil then
		last_noise[player] = globals_realtime()
	end
end

for i=1, #noise_events do
	client_set_event_callback(noise_events[i], on_noise)
end

local function update_legit_esp(enemy, force_value)
	local visible = force_value or false

	if entity_get_classname(enemy) ~= "CCSPlayer" or not entity_is_enemy(enemy) then
		return
	elseif not on_screen[enemy] then
		return
	elseif (entity_is_dormant(enemy) and ui_get(dormant_reference) and false) or not entity_is_alive(enemy) then
		visible = true
	end

	if not visible then
		local filters = ui_get(filters_reference)

		if table_contains(filters, "Making noise") then
			local realtime = globals_realtime()
			local last_noise_time = last_noise[enemy] or 0
			if last_noise_time + noise_duration > realtime then
				visible = true
			end
		end

		if not visible then
			local local_player = entity_get_local_player()
			if table_contains(filters, "Visible to teammates") then

				-- update teammate visibility?
				if globals_tickcount() % 16 == 0 then
					visible_to_teammates[enemy] = false
					local players_temp = entity_get_players()
					for i=1, #players_temp do
						local player = players_temp[i]
						if player ~= local_player and not visible_to_teammates[enemy] and is_teammate(player) then
							if player_can_see(player, enemy) then
								visible_to_teammates[enemy] = true
								visible = true
							end
						end
					end
				end

				if visible_to_teammates[enemy] then
					visible = true
				end
			end

			if not visible and table_contains(filters, "Visible to you") then
				if player_can_see(local_player, enemy) then
					visible = true
				end
			end
		end
	end

	set_plist(enemy, function()
		ui_set(disable_visuals_reference, not visible)
	end)
end

local function on_net_update_end()
	if not ui_get(enabled_reference) then
		return
	end

	local filters = ui_get(filters_reference)
	if #filters == 0 then
		return
	end

	local force_value
	if not ui_get(hotkey_reference) then
		force_value = true
	elseif table_contains(filters, "When dead") and not entity_is_alive(entity_get_local_player()) then
		force_value = true
	end

	for enemy=1, globals_maxplayers() do
		update_legit_esp(enemy, force_value)
	end
end
client.set_event_callback("net_update_end", on_net_update_end)

local function on_paint()
	on_screen = {}
	for enemy=1, globals_maxplayers() do
		if entity_get_classname(enemy) == "CCSPlayer" then
			local x1, y1, x2, y2, a = entity_get_bounding_box(enemy)
			if x1 ~= nil and a ~= nil and a > 0 then
				on_screen[enemy] = true
			end
		end
	end
end
client.set_event_callback("paint", on_paint)

local function on_shutdown()
	for enemy=1, globals_maxplayers() do
		update_legit_esp(enemy, true)
	end
end
client.set_event_callback("shutdown", on_shutdown)

local function on_player_death(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		on_net_update_end()
	end
end
client.set_event_callback("player_death", on_player_death)

local function on_enabled_changed()
	local enabled = ui_get(enabled_reference)
	ui_set_visible(filters_reference, enabled)

	local active = enabled and #ui_get(filters_reference) > 0
	if not active then
		on_shutdown()
	end
end
ui.set_callback(enabled_reference, on_enabled_changed)
ui.set_callback(filters_reference, on_enabled_changed)
