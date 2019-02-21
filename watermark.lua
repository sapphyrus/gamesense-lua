--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_system_time, client_color_log, client_open_panorama_context, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.system_time, client.color_log, client.open_panorama_context, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

--local pingspike_reference = ui.reference("MISC", "Miscellaneous", "Ping spike")
local antiut_reference = ui.reference("MISC", "Settings", "Anti-untrusted")

local watermark_reference = ui.new_multiselect("VISUALS", "Effects", "Watermark ", {"Logo", "FPS", "Ping", "Velocity", "Time", "Time + seconds", "Custom text"})
local color_reference = ui.new_color_picker("VISUALS", "Effects", "Watermark", 149, 184, 6, 255)
local custom_name_reference = ui.new_textbox("VISUALS", "Effects", "Watermark name")
local rainbow_header_reference = ui.new_checkbox("VISUALS", "Effects", "Watermark rainbow header")

--support migrating from old version
local transfer_reference = ui.new_combobox("VISUALS", "Effects", "Watermark", {"Off", "On", "Rainbow"})
ui.set_visible(transfer_reference, false)

local frametimes = {}
local fps_prev = 0
local value_prev = {}
local last_update_time = 0

local offset_x, offset_y = -15, 15
--local offset_x, offset_y = 525, 915 --debug, show above net_graph
local a_text = 230

local function draw_container(x, y, w, h, header)
	local a = 255
	local c = {10, 60, 40, 40, 40, 60, 20}

	for i = 0,6,1 do
		renderer_rectangle(x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], a)
	end

	if header then
		local x_inner, y_inner = x+7, y+7
		local w_inner = w-14

		renderer_gradient(x_inner, y_inner, math_floor(w_inner/2), 1, 59, 175, 222, a, 202, 70, 205, a, true)
		renderer_gradient(x_inner+math_floor(w_inner/2), y_inner, math_ceil(w_inner/2), 1, 202, 70, 205, a, 201, 227, 58, a, true)

		local a_lower = a*0.2
		renderer_gradient(x_inner, y_inner+1, math_floor(w_inner/2), 1, 59, 175, 222, a_lower, 202, 70, 205, a_lower, true)
		renderer_gradient(x_inner+math_floor(w_inner/2), y_inner+1, math_ceil(w_inner/2), 1, 202, 70, 205, a_lower, 201, 227, 58, a_lower, true)
	end
end

local function table_contains(tbl, val)
	for i=1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_remove_element(tbl, val)
	local tbl_new = {}
	for i=1, #tbl do
		if tbl[i] ~= val then
			table_insert(tbl_new, tbl[i])
		end
	end
	return tbl_new
end

local function on_watermark_changed()
	local value = ui_get(watermark_reference)

	if #value > 0 then
		--Make Time / Time + seconds act as a kind of "switch", only allow one to be selected at a time.
		if table_contains(value, "Time") and table_contains(value, "Time + seconds") then
			local value_new = value
			if not table_contains(value_prev, "Time") then
				value_new = table_remove_element(value_new, "Time + seconds")
			elseif not table_contains(value_prev, "Time + seconds") then
				value_new = table_remove_element(value_new, "Time")
			end

			--this shouldn't happen, but why not add a failsafe
			if table_contains(value_new, "Time") and table_contains(value_new, "Time + seconds") then
				value_new = table_remove_element(value_new, "Time")
			end

			ui_set(watermark_reference, value_new)
			on_watermark_changed()
			return
		end
	end
	ui_set_visible(custom_name_reference, table_contains(value, "Custom text"))
	ui_set_visible(rainbow_header_reference, #value > 0)

	value_prev = value
end
ui.set_callback(watermark_reference, on_watermark_changed)
on_watermark_changed()

local function on_transfer_changed()
	if ui_get(transfer_reference) ~= "Off" then
		if #ui_get(watermark_reference) == 0 then
			ui_set(watermark_reference, {"Logo", "FPS", "Ping"})
			on_watermark_changed()
		end
		ui_set(transfer_reference, "Off")
	end
end
on_transfer_changed()
ui.set_callback(transfer_reference, on_transfer_changed)

local function hsv_to_rgb(h, s, v, a)
	local r, g, b

	local i = math_floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

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

local function accumulate_fps()
	local rt, ft = globals_realtime(), globals_absoluteframetime()

	if ft > 0 then
		table_insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local accum = 0
	local i = 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end

	accum = accum / i

	while i < count do
		i = i + 1
		table_remove(frametimes)
	end

	local fps = 1 / accum
	local time_since_update = rt - last_update_time
	if math_abs(fps - fps_prev) > 4 or time_since_update > 1 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end

	return math_floor(fps + 0.5)
end

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math_floor(num * mult + 0.5) / mult
end

local widths = {
	["Logo"] = 66,
	["FPS"] = 46,
	["Ping"] = 45,
	["Velocity"] = 50,
	["Time"] = 40,
	["Time + seconds"] = 58,
}

local function on_paint(ctx)
	local fps = accumulate_fps()

	local value = ui_get(watermark_reference)
	if #value == 0 then
		return
	end

	if table_contains(value, "Custom text") then
		value = table_remove_element(value, "Custom text")
		if table_contains(value, "Logo") then
			table_insert(value, 2, "Custom text")
		else
			table_insert(value, 1, "Custom text")
		end
	end

	local screen_width, screen_height = client_screen_size()
	local x = offset_x >= 0 and offset_x or screen_width + offset_x
	local y = offset_y >= 0 and offset_y or screen_height + offset_y
	local r, g, b = 255, 255, 255
	local custom_name_text = ui_get(custom_name_reference)

	--calculate width and draw container
	local width = 13
	for i=1, #value do
		local value_temp = value[i]
		if value_temp == "Custom text" then
			if custom_name_text == "" then
				widths[value_temp] = nil
			else
				widths[value_temp] = renderer_measure_text(nil, custom_name_text)+7
			end
		end
		if widths[value_temp] ~= nil then
			width = width + widths[value_temp]
		end
	end

	local x_text = x-width
	local y_text = y+8

	if ui_get(rainbow_header_reference) then
		draw_container(x-width, y, width, 32, true)
		y_text = y_text + 2
	else
		draw_container(x-width, y, width, 30)
	end

	--draw shit
	for i=1, #value do
		local value_temp = value[i]
		if value_temp == "Logo" then
			--gamesense logo
			local r_sense, g_sense, b_sense = ui_get(color_reference)

			renderer_text(x_text+10, y_text, 255, 255, 255, a_text, nil, 0, "game")
			renderer_text(x_text+37, y_text, r_sense, g_sense, b_sense, a_text, nil, 0, "sense")
		elseif value_temp == "Custom text" then
			renderer_text(x_text+9, y_text, 255, 255, 255, a_text, nil, 0, custom_name_text)
		elseif value_temp == "FPS" then
			--fps
			local fps = math_min(999, fps)
			local fps_r, fps_g, fps_b = r, g, b
			if fps < (1 / globals_tickinterval()) then
				fps_r, fps_g, fps_b = 255, 0, 0
			end

			renderer_text(x_text+48, y_text, fps_r, fps_g, fps_b, a_text, "r", 0, fps, " fps")
		elseif value_temp == "Ping" then
			local ping = math_min(999, client_latency() * 1000)
			ping = round(ping, 0)
			local ping_r, ping_g, ping_b = r, g, b

			local max_ping = 200
			if not ui_get(antiut_reference) then
				max_ping = 100
			end

			if ping > max_ping then
				ping_r, ping_g, ping_b = 255, 0, 0
			end
			renderer_text(x_text+47, y_text, ping_r, ping_g, ping_b, a_text, "r", 0, ping, "ms")
		elseif value_temp == "Velocity" then
			local local_player = entity_get_local_player()
			local vel_x, vel_y = entity_get_prop(local_player, "m_vecVelocity")
			if vel_x ~= nil then
				local velocity = math_sqrt(vel_x*vel_x + vel_y*vel_y)
				velocity = math_min(9999, velocity) + 0.2
				velocity = round(velocity, 0)

				renderer_text(x_text+38, y_text, 255, 255, 255, a_text, "r", 0, velocity)
				renderer_text(x_text+38, y_text+3, 255, 255, 255, a_text, "-", 0, "u / t")
			end
		elseif value_temp == "Time" or value_temp == "Time + seconds" then
			local time_center = x_text + 24

			local hours, minutes, seconds, milliseconds = client_system_time()
			hours, minutes = string_format("%02d", hours), string_format("%02d", minutes)
			renderer_text(time_center, y_text, 255, 255, 255, a_text, "r", 0, hours)
			renderer_text(time_center+1, y_text, 255, 255, 255, a_text, "", 0, ":")
			renderer_text(time_center+4, y_text, 255, 255, 255, a_text, "", 0, minutes)

			time_center = time_center + 18

			if value_temp == "Time + seconds" then
				seconds = string_format("%02d", seconds)
				renderer_text(time_center+1, y_text, 255, 255, 255, a_text, "", 0, ":")
				renderer_text(time_center+4, y_text, 255, 255, 255, a_text, "", 0, seconds)
			end
		end

		if widths[value_temp] ~= nil then
			x_text = x_text + widths[value_temp]
		end

		if #value > i then
			renderer_text(x_text, y_text, 255, 255, 255, a_text, nil, 0, " | ")
		end
	end
end
client.set_event_callback("paint", on_paint)
