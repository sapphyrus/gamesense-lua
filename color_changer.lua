--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_random_int, client_latency, client_set_clan_tag, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_visible, client_exec, client_delay_call, client_set_cvar, client_eye_position, client_draw_hitboxes, client_camera_angles, client_open_panorama_context, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.random_int, client.latency, client.set_clan_tag, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.visible, client.exec, client.delay_call, client.set_cvar, client.eye_position, client.draw_hitboxes, client.camera_angles, client.open_panorama_context, client.system_time
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_hotkey, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_mouse_position, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_hotkey, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.mouse_position, ui.new_button, ui.new_multiselect, ui.get
local renderer_load_svg, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_world_to_screen, renderer_indicator, renderer_texture = renderer.load_svg, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.world_to_screen, renderer.indicator, renderer.texture
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local mat_ambient_light_r, mat_ambient_light_g, mat_ambient_light_b = cvar.mat_ambient_light_r, cvar.mat_ambient_light_g, cvar.mat_ambient_light_b
local r_modelAmbientMin = cvar.r_modelAmbientMin

local wallcolor_reference = ui.new_checkbox("VISUALS", "Effects", "Wall Color")
local wallcolor_color_reference = ui.new_color_picker("VISUALS", "Effects", "Wall Color", 255, 0, 0, 128)

local bloom_reference = ui.new_slider("VISUALS", "Effects", "Bloom scale", -1, 500, -1, true, nil, 0.01, {[-1]="Off"})
local exposure_reference = ui.new_slider("VISUALS", "Effects", "Auto Exposure", -1, 2000, -1, true, nil, 0.001, {[-1]="Off"})
local model_ambient_min_reference = ui.new_slider("VISUALS", "Effects", "Minimum model brightness", 0, 1000, -1, true, nil, 0.05)

local max_val = 1

local bloom_default, exposure_min_default, exposure_max_default
local bloom_prev, exposure_prev, model_ambient_min_prev, wallcolor_prev

local function reset_bloom(tone_map_controller)
	if bloom_default == -1 then
		entity_set_prop(tone_map_controller, "m_bUseCustomBloomScale", 0)
		entity_set_prop(tone_map_controller, "m_flCustomBloomScale", 0)
	else
		entity_set_prop(tone_map_controller, "m_bUseCustomBloomScale", 1)
		entity_set_prop(tone_map_controller, "m_flCustomBloomScale", bloom_default)
	end
end

local function reset_exposure(tone_map_controller)
	if exposure_min_default == -1 then
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMin", 0)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMin", 0)
	else
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMin", 1)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMin", exposure_min_default)
	end
	if exposure_max_default == -1 then
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMax", 0)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMax", 0)
	else
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMax", 1)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMax", exposure_max_default)
	end
end

local function on_paint()
	local wallcolor = ui_get(wallcolor_reference)
	if wallcolor or wallcolor_prev then
		if wallcolor then
			local r, g, b, a = ui_get(wallcolor_color_reference)
			r, g, b = r/255, g/255, b/255
			local a_temp = a / 128 - 1
			local r_res, g_res, b_res
			if a_temp > 0 then
				local multiplier = 900^(a_temp) - 1
				a_temp = a_temp * multiplier
				r_res, g_res, b_res = r*a_temp, g*a_temp, b*a_temp
			else
				a_temp = a_temp * max_val
				r_res, g_res, b_res = (1-r)*a_temp, (1-g)*a_temp, (1-b)*a_temp
			end
			if mat_ambient_light_r:get_float() ~= r_res or mat_ambient_light_g:get_float() ~= g_res or mat_ambient_light_b:get_float() ~= b_res then
				mat_ambient_light_r:set_raw_float(r_res)
				mat_ambient_light_g:set_raw_float(g_res)
				mat_ambient_light_b:set_raw_float(b_res)
			end
		else
			mat_ambient_light_r:set_raw_float(0)
			mat_ambient_light_g:set_raw_float(0)
			mat_ambient_light_b:set_raw_float(0)
		end
	end
	wallcolor_prev = wallcolor

	local model_ambient_min = ui_get(model_ambient_min_reference)
	if model_ambient_min > 0 or (model_ambient_min_prev ~= nil and model_ambient_min_prev > 0) then
		if r_modelAmbientMin:get_float() ~= model_ambient_min*0.05 then
			r_modelAmbientMin:set_raw_float(model_ambient_min*0.05)
		end
	end
	model_ambient_min_prev = model_ambient_min

	local bloom = ui_get(bloom_reference)
	local exposure = ui_get(exposure_reference)
	if bloom ~= -1 or exposure ~= -1 or bloom_prev ~= -1 or exposure_prev ~= -1 then
		local tone_map_controllers = entity_get_all("CEnvTonemapController")
		for i=1, #tone_map_controllers do
			local tone_map_controller = tone_map_controllers[i]
			if bloom ~= -1 then
				if bloom_default == nil then
					if entity_get_prop(tone_map_controller, "m_bUseCustomBloomScale") == 1 then
						bloom_default = entity_get_prop(tone_map_controller, "m_flCustomBloomScale")
					else
						bloom_default = -1
					end
				end
				entity_set_prop(tone_map_controller, "m_bUseCustomBloomScale", 1)
				entity_set_prop(tone_map_controller, "m_flCustomBloomScale", bloom*0.01)
			elseif bloom_prev ~= nil and bloom_prev ~= -1 and bloom_default ~= nil then
				reset_bloom(tone_map_controller)
			end
			if exposure ~= -1 then
				if exposure_min_default == nil then
					if entity_get_prop(tone_map_controller, "m_bUseCustomAutoExposureMin") == 1 then
						exposure_min_default = entity_get_prop(tone_map_controller, "m_flCustomAutoExposureMin")
					else
						exposure_min_default = -1
					end
					if entity_get_prop(tone_map_controller, "m_bUseCustomAutoExposureMax") == 1 then
						exposure_max_default = entity_get_prop(tone_map_controller, "m_flCustomAutoExposureMax")
					else
						exposure_max_default = -1
					end
				end
				entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMin", 1)
				entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMax", 1)
				entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMin", math_max(0.0000, exposure*0.001))
				entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMax", math_max(0.0000, exposure*0.001))
			elseif exposure_prev ~= nil and exposure_prev ~= -1 and exposure_min_default ~= nil then
				reset_exposure(tone_map_controller)
			end
		end
	end
	bloom_prev = bloom
	exposure_prev = exposure
end
client.set_event_callback("paint", on_paint)

local function task()
	if globals_mapname() == nil then
		bloom_default, exposure_min_default, exposure_max_default = nil, nil, nil
	end
	client_delay_call(0.5, task)
end
task()

local function on_shutdown()
	local tone_map_controllers = entity_get_all("CEnvTonemapController")
	for i=1, #tone_map_controllers do
		local tone_map_controller = tone_map_controllers[i]
		if bloom_prev ~= -1 and bloom_default ~= nil then
			reset_bloom(tone_map_controller)
		end
		if exposure_prev ~= -1 and exposure_min_default ~= nil then
			reset_exposure(tone_map_controller)
		end
	end
	mat_ambient_light_r:set_raw_float(0)
	mat_ambient_light_g:set_raw_float(0)
	mat_ambient_light_b:set_raw_float(0)
	r_modelAmbientMin:set_raw_float(0)
end
client.set_event_callback("shutdown", on_shutdown)
