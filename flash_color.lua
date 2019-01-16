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

local migrate_reference = ui.new_checkbox("VISUALS", "Effects", "Flashbang color")
local noflash_reference = ui.reference("VISUALS", "Effects", "Remove flashbang effects")

local enabled_reference = ui.new_checkbox("VISUALS", "Effects", "Flashbang color ")
local color_reference = ui.new_color_picker("VISUALS", "Effects", "Flashbang color", 255, 255, 255, 255)

local blinded_at, blinded_duration = {}, {}
local enabled_prev

local function on_enabled_changed()
	local enabled = ui_get(enabled_reference)
	if enabled_prev and not enabled then
		local player = entity_get_local_player()
		if player ~= nil then
			entity_set_prop(player, "m_flFlashMaxAlpha", 255)
		end
	end
	enabled_prev = enabled
end
ui.set_callback(enabled_reference, on_enabled_changed)

ui.set_visible(migrate_reference, false)
ui.set_callback(migrate_reference, function()
	if ui_get(migrate_reference) then
		ui_set(migrate_reference, false)
		ui_set(enabled_reference, true)
		ui_set(noflash_reference, false)
	end
end)

local function on_paint(ctx)
	--not doing this in run_command since it gets triggered to late, but always doing it (regardless of activation state)
	local players = entity_get_players()
	for i=1, #players do
		local player = players[i]
		local duration = entity_get_prop(player, "m_flFlashDuration")
		if duration > 0 then
			if duration ~= blinded_duration[player] then
				blinded_at[player] = globals_curtime()
				blinded_duration[player] = duration
			end
		else
			blinded_at[player] = nil
			blinded_duration[player] = nil
		end
	end

	if not ui_get(enabled_reference) then
		return
	end

	local player = entity_get_local_player()
	if player == nil then
		return
	end
	--if entity_get_prop(player, "m_flFlashMaxAlpha") > 0 then
		entity_set_prop(player, "m_flFlashMaxAlpha", 0)
	--end

	--check the flash duration of our spectator target if we are spectating in firstperson
	if not entity_is_alive(player) then
		if entity_get_prop(player, "m_iObserverMode") == 4 then
			player = entity_get_prop(player, "m_hObserverTarget")
		end
	end

	if player == nil then
		return
	end

	local duration = entity_get_prop(player, "m_flFlashDuration")
	if duration ~= nil and duration > 0 and blinded_at[player] ~= nil then
		local blinded_until = blinded_at[player] + duration
		local time_left = blinded_until - globals_curtime()
		if time_left > 0 then
			local alpha = 0
			local is_short = 1.8 > duration

			if duration > 0.1 and duration-time_left < 0.1 then
				alpha = math_min(1, (duration-time_left) / 0.1 * 1.25)
			elseif time_left > 3 then
				alpha = 1
			elseif not is_short and time_left > 1 then
				alpha = (time_left - 1) / 2
			elseif is_short then
				alpha = time_left / 30
			end

			if alpha > 0 then
				local screen_width, screen_height = client_screen_size()
				local r, g, b, a = ui_get(color_reference)
				renderer_rectangle(0, 0, screen_width, screen_height, r, g, b, a*alpha)
			end

			--debug stuff
			--renderer_text(255, 240, 255, 0, 0, 255, nil, 0, "duration:     ", duration)
			--renderer_text(255, 250, 255, 0, 0, 255, nil, 0, "time left:     ", time_left)
			--renderer_text(255, 260, 255, 0, 0, 255, nil, 0, "alpha mult: ", alpha)
		end
	end
end
client.set_event_callback("paint", on_paint)
