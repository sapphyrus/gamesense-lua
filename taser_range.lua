--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function renderer_is_thirdperson()
	local x, y, z = client_eye_position()
	local pitch, yaw = client_camera_angles()

	yaw = yaw - 180
	pitch, yaw = math_rad(pitch), math_rad(yaw)

	x = x + math_cos(yaw)*4
	y = y + math_sin(yaw)*4
	z = z + math_sin(pitch)*4

	local wx, wy = renderer_world_to_screen(x, y, z)
	return wx ~= nil
end

local function is_player(entindex)
	return entity_get_classname(entindex) == "CCSPlayer"
end

local function is_teammate(player)
	return is_player(player) and entity_get_prop(player, "m_iTeamNum") == entity_get_prop(entity_get_local_player(), "m_iTeamNum")
end

local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
	local x = (x2 - x1) * percentage + x1
	local y = (y2 - y1) * percentage + y1
	local z = (z2 - z1) * percentage + z1
	return x, y, z
end

local function trace_line_skip_teammates(skip_entindex, x1, y1, z1, x2, y2, z2, max_traces)
	local max_traces = max_traces or 10
	local fraction, entindex_hit = 0, -1
	local x_hit, y_hit, z_hit = x1, y1, z1

	local i=1
	while (entindex_hit == -1 or (entindex_hit ~= 0 and is_teammate(entindex_hit))) and 1 > fraction and max_traces >= i do
		fraction, entindex_hit = client_trace_line(entindex_hit, x_hit, y_hit, z_hit, x2, y2, z2)
		x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, fraction)

		i = i + 1
	end

	local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
	local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

	return traveled_total/total_distance, entindex_hit
end

local function trace_line_skip(skip_function, x1, y1, z1, x2, y2, z2, max_traces)
	local max_traces = max_traces or 10
	local fraction, entindex_hit = 0, -1
	local x_hit, y_hit, z_hit = x1, y1, z1
	local skip_entindex = -1

	local i=1
	while (entindex_hit == -1 or (entindex_hit ~= 0 and skip_function(entindex_hit))) and 1 > fraction and max_traces >= i do
		fraction, entindex_hit = client_trace_line(entindex_hit, x_hit, y_hit, z_hit, x2, y2, z2)
		x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, fraction)

		i = i + 1
	end

	local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
	local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

	return traveled_total/total_distance, entindex_hit
end

local function hsv_to_rgb(h, s, v, a)
  local r, g, b

  local i = math_floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

local enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Visualize Taser range")

local weapon_name_prev = nil
local last_switch = 0
local accuracy = 1
local MOVETYPE_NOCLIP = 8

local is_thirdperson, is_thirdperson_prev
local points = {}

local function on_run_command(e)
	points = {}
	local local_player = entity_get_local_player()

	local weapon = entity_get_player_weapon(local_player)
	if weapon == nil then
		return
	end
	local weapon_name = entity_get_classname(weapon)

	local radius
	if weapon_name == "CWeaponTaser" or weapon_name_prev == "CWeaponTaser" then
		radius = 183-16
	else
		return
	end

	local local_x, local_y, local_z = entity_get_prop(local_player, "m_vecAbsOrigin")
	local vo_z = entity_get_prop(local_player, "m_vecViewOffset[2]")-4

	if not is_thirdperson then
		vo_z = vo_z-12
	end

	for rot=0, 360, accuracy do
		local rot_temp = math_rad(rot)
		local temp_x, temp_y, temp_z = local_x + radius * math_cos(rot_temp), local_y + radius * math_sin(rot_temp), local_z
		local fraction, entindex_hit = trace_line_skip(is_player, local_x, local_y, local_z+vo_z, temp_x, temp_y, local_z+vo_z)

		--local fraction_x, fraction_y = local_x+(temp_x-local_x)*fraction, local_y+(temp_y-local_y)*fraction
		local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)

		local hue_extra = globals_realtime() % 8 / 8
		local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

		local fraction_multiplier = 1
		table_insert(points, {rot, fraction_x, fraction_y, temp_z+vo_z, fraction_multiplier})
	end
end
client.set_event_callback("run_command", on_run_command)

local function on_paint()
	if not ui_get(enabled_reference) then
		return
	end

	local local_player = entity_get_local_player()

	if not entity_is_alive(local_player) then
		points = {}
		return
	end

	local curtime = globals_curtime()

	local weapon = entity_get_player_weapon(local_player)
	if weapon == nil then
		return
	end

	local weapon_name = entity_get_classname(weapon)

	if weapon_name ~= weapon_name_prev then
		last_switch = curtime
		weapon_name_prev = weapon_name
	end

	local opacity
	if weapon_name == "CWeaponTaser" or weapon_name_prev == "CWeaponTaser" then
		opacity = 1
	else
		is_thirdperson_prev = nil
		return
	end

	is_thirdperson_prev = is_thirdperson
	is_thirdperson = renderer_is_thirdperson()

	if is_thirdperson_prev ~= is_thirdperson or entity_get_prop(local_player, "m_MoveType") == MOVETYPE_NOCLIP then
		on_run_command()
	end

	--determine fade multiplier
	local fade_multiplier
	if curtime - last_switch < 0.3 then
		fade_multiplier = (curtime - last_switch) * 1/0.3
	else
		fade_multiplier = 1
	end

	if weapon_name ~= "CWeaponTaser" and weapon_name == "CWeaponTaser" then
		fade_multiplier = 1 - fade_multiplier
	end

	if fade_multiplier == 0 then
		return
	end
	local opacity_multiplier = opacity * fade_multiplier

	local points_amt = #points
	local shift = globals_realtime() % 8 / 8

	local previous_world_x, previous_world_y
	for i=1, points_amt do
		local rot, fraction_x, fraction_y, temp_z, fraction_multiplier = unpack(points[i])

		local world_x, world_y = renderer_world_to_screen(fraction_x, fraction_y, temp_z)
		local r, g, b = hsv_to_rgb(rot/360+shift, 1, 1, 255)

		local i_s = i / points_amt
		i_s = i_s + ((shift * 4) % 1)
		i_s = i_s % 1

		--renderer_text(world_x, world_y, 255, 255, 255, 255, "-", 0, i_s)

		local temp_multiplier = 0.4 + (i_s * 0.6)

		fraction_multiplier = fraction_multiplier * temp_multiplier

		if world_x ~= nil and previous_world_x ~= nil then
			renderer_line(world_x, world_y, previous_world_x, previous_world_y, r, g, b, 255*opacity_multiplier*fraction_multiplier)
			renderer_line(world_x, world_y+1, previous_world_x, previous_world_y+1, r, g, b, 50*opacity_multiplier*fraction_multiplier)
			--renderer_line(world_x, world_y-1, previous_world_x, previous_world_y-1, r, g, b, 50*opacity_multiplier*fraction_multiplier)
		end
		previous_world_x, previous_world_y = world_x, world_y
	end
end
client.set_event_callback("paint", on_paint)
