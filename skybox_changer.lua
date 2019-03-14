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

local package_searchpath = package.searchpath
local function file_exists(filename)
	return package_searchpath("", filename) == filename
end

local function skybox_exists(skybox_name)
	return file_exists("./csgo/materials/skybox/" .. skybox_name .. "up.vmt")
end

local sv_skyname = cvar.sv_skyname
local skyboxes = {
	["Tibet"]="cs_tibet",
	["Baggage"]="cs_baggage_skybox_",
	["Monastery"]="embassy",
	["Italy"]="italy",
	["Aztec"]="jungle",
	["Vertigo"]="office",
	["Daylight"]="sky_cs15_daylight01_hdr",
	["Daylight (2)"]="vertigoblue_hdr",
	["Clouds"]="sky_cs15_daylight02_hdr",
	["Clouds (2)"]="vertigo",
	["Gray"]="sky_day02_05_hdr",
	["Clear"]="nukeblank",
	["Canals"]="sky_venice",
	["Cobblestone"]="sky_cs15_daylight03_hdr",
	["Assault"]="sky_cs15_daylight04_hdr",
	["Clouds (Dark)"]="sky_csgo_cloudy01",
	["Night"]="sky_csgo_night02",
	["Night (2)"]="sky_csgo_night02b",
	["Night (Flat)"]="sky_csgo_night_flat",
	["Dusty"]="sky_dust",
	["Rainy"]="vietnam",
	["Custom: Sunrise"]="amethyst",
	["Custom: Galaxy"]="sky_descent",
	["Custom: Galaxy (2)"]="clear_night_sky",
	["Custom: Galaxy (3)"]="otherworld",
	["Custom: Galaxy (4)"]="mpa112",
	["Custom: Clouds (Night)"]="cloudynight",
	["Custom: Ocean"]="dreamyocean",
	["Custom: Grimm Night"]="grimmnight",
	["Custom: Heaven"]="sky051",
	["Custom: Heaven (2)"]="sky081",
	["Custom: Clouds"]="sky091",
	["Custom: Night (Blue)"]="sky561",
}

local skybox_names = {}
for k,v in pairs(skyboxes) do
	if k:sub(0, 8) ~= "Custom: " or skybox_exists(v) then
	  table_insert(skybox_names, k)
	end
end
table_sort(skybox_names)

local enabled_reference = ui.new_checkbox("VISUALS", "Effects", "Override skybox")
local color_reference = ui.new_color_picker("VISUALS", "Effects", "Override skybox", 255, 255, 255, 255)
local skybox_reference = ui.new_listbox("VISUALS", "Effects", "Override skybox name", skybox_names)

local enabled_prev, skyname_default = false, nil

local function on_color_changed()
	local enabled = ui_get(enabled_reference)
	if enabled or enabled_prev then
		local r, g, b, a = ui_get(color_reference)
		if not enabled then
			r, g, b, a = 255, 255, 255, 255
		end
		local materials = materialsystem_find_materials("skybox/")
		for i=1, #materials do
			materials[i]:color_modulate(r, g, b)
			materials[i]:alpha_modulate(a)
		end
	end
end
ui.set_callback(color_reference, on_color_changed)

local function on_skybox_changed()
	local enabled = ui_get(enabled_reference)

	ui_set_visible(skybox_reference, enabled)
	if enabled then
		local skybox = ui_get(skybox_reference)
		if type(skybox) == "number" then
			skybox = skybox_names[skybox+1]
		end

		if skyname_default == nil then
			skyname_default = sv_skyname:get_string()
		end

		sv_skyname:set_string(skyboxes[skybox])
		--check if new skybox is loaded, if not delay color update
		if #(materialsystem_find_materials("skybox/" .. skybox)) == 0 then
			client_delay_call(0.05, on_color_changed)
		else
			on_color_changed()
		end
	elseif enabled_prev then
		if skyname_default ~= nil then
			sv_skyname:set_string(skyname_default)
		end
	end
	on_color_changed()
	enabled_prev = enabled
end
ui.set_callback(enabled_reference, on_skybox_changed)
ui.set_callback(skybox_reference, on_skybox_changed)
on_skybox_changed()

local function on_player_connect_full(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		skyname_default = nil
		on_skybox_changed()
		on_color_changed()
	end
end
client.set_event_callback("player_connect_full", on_player_connect_full)

local function on_shutdown()
	if skyname_default ~= nil and ui_get(enabled_reference) then
		sv_skyname:set_string(skyname_default)
	end
end
client.set_event_callback("shutdown", on_shutdown)
