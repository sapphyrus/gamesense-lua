--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_random_int, client_latency, client_set_clan_tag, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_error_log, client_draw_hitboxes, client_camera_angles, client_open_panorama_context, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.random_int, client.latency, client.set_clan_tag, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.error_log, client.draw_hitboxes, client.camera_angles, client.open_panorama_context, client.system_time
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_new_checkbox, ui_mouse_position, ui_new_listbox, ui_new_multiselect, ui_is_menu_open, ui_new_hotkey, ui_set, ui_new_button, ui_set_callback, ui_name, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.new_checkbox, ui.mouse_position, ui.new_listbox, ui.new_multiselect, ui.is_menu_open, ui.new_hotkey, ui.set, ui.new_button, ui.set_callback, ui.name, ui.get
local renderer_load_svg, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_world_to_screen, renderer_indicator, renderer_texture = renderer.load_svg, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.world_to_screen, renderer.indicator, renderer.texture
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_pack, table_sort, table_remove, table_unpack, table_concat, table_insert = table.pack, table.sort, table.remove, table.unpack, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local materialsystem_chams_material, materialsystem_arms_material, materialsystem_find_texture, materialsystem_find_material, materialsystem_override_material, materialsystem_find_materials, materialsystem_get_model_materials = materialsystem.chams_material, materialsystem.arms_material, materialsystem.find_texture, materialsystem.find_material, materialsystem.override_material, materialsystem.find_materials, materialsystem.get_model_materials
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local mixers_list = {
	"Footsteps",
	"Own Footsteps",
	"Weapons",
	"Ambient noise",
	"Music",
	"Radio",
	"Survival"
}

--values are the original volume the new value will be modified by, found using snd_soundmixer_list_mix_groups / snd_getmixer
local mixers_names = {
	["Footsteps"] = {
		["GlobalFootsteps"] = 1.00
	},
	["Own Footsteps"] = {
		["PlayerFootsteps"] = 0.13
	},
	["Weapons"] = {
		["Weapons1"] = 0.70,
		["FoleyWeapons"] = 0.70,
		["AllWeapons"] = 1.00,
		["DistWeapons"] = 0.70,
	},
	["Ambient noise"] = {
		["Ambient"] = 0.25,
		["ExplosionsDecoy"] = 1.60
	},
	["Music"] = {
		["SelectedMusic"] = 0.60,
		["BuyMusic"] = 0.80,
		["Music"] = 1.00
	},
	["Radio"] = {
		["Radio"] = 0.20,
		["Bot"] = 0.20,
		["Dialog"] = 0.1,
		["Commander"] = 0.30,
	},
	["Survival"] = {
		["Survival"] = 1.00
	}
}

local modifier_reference = {}
local cvar_snd_setmixer, cvar_con_filter_enable, cvar_con_filter_text = cvar.snd_setmixer, cvar.con_filter_enable, cvar.con_filter_text
local enabled_reference = ui.new_checkbox("MISC", "Miscellaneous", "Sound volume modifiers")

local function disable_console_output(block, ...)
	--backup their values, then set console filter cvars
	local con_filter_enable_prev, con_filter_text_prev = cvar_con_filter_enable:get_int(), cvar_con_filter_text:get_string()
	cvar_con_filter_enable:set_raw_int(1)
	cvar_con_filter_text:set_string("___")

	--call the passed function with args protectedly
	xpcall(block, client_error_log, ...)

	--set back to backed up values
	cvar_con_filter_enable:set_raw_int(con_filter_enable_prev)
	cvar_con_filter_text:set_string(con_filter_text_prev)
end

local function update_mixers(mixer_name)
	local mixers = mixer_name ~= nil and {mixer_name} or mixers_list

	disable_console_output(function()
		for i=1, #mixers do
			local mixer = mixers[i]
			local mixer_data = mixers_names[mixer]
			local modifier = ui_get(enabled_reference) and ui_get(modifier_reference[mixer])*0.01 or 1

			for mixer_current_name, mixer_default_volume in pairs(mixer_data) do
				cvar_snd_setmixer:invoke_callback(mixer_current_name, "vol", tostring(mixer_default_volume*modifier))
			end
		end
	end)
end

local function on_modifier_changed(modifier_name)
	update_mixers({modifier_name})
end

for i=1, #mixers_list do
	local mixer = mixers_list[i]
	modifier_reference[mixer] = ui_new_slider("MISC", "Miscellaneous", mixer .. " volume modifier", 0, 1000, 100, true, "%", 1, {[0] = "        Muted"})
	ui_set_callback(modifier_reference[mixer], function()
		update_mixers(mixer)
	end)
end

local function on_enabled_changed()
	local enabled = ui_get(enabled_reference)
	for i=1, #mixers_list do
		ui_set_visible(modifier_reference[mixers_list[i]], enabled)
	end
	update_mixers()
end
ui.set_callback(enabled_reference, on_enabled_changed)
on_enabled_changed()

client.set_event_callback("player_connect_full", function(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		update_mixers()
	end
end)
