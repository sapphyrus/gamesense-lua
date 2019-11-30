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

local orig_save_reference = ui.reference("CONFIG", "Presets", "Save")
local export_reference = ui.reference("CONFIG", "Presets", "Export to clipboard")
local reset_reference = ui.reference("CONFIG", "Presets", "Reset")
local reset_layout_reference = ui.reference("MISC", "Settings", "Reset menu layout")
local unload_reference = ui.reference("MISC", "Settings", "Unload")
local hitboxes_reference = ui.reference("RAGE", "Aimbot", "Target hitbox")
local override_awp_reference = ui.reference("RAGE", "Aimbot", "Override AWP")
local anti_untrusted_reference = ui.reference("MISC", "Settings", "Anti-untrusted")
local aimstep_reference = ui.reference("RAGE", "Aimbot", "Reduce aim step")
local force_baim_reference = ui.reference("RAGE", "Other", "Force body aim")
local remove_spread_reference = ui.reference("RAGE", "Other", "Remove spread")
local dump_mm_wins_reference = ui.reference("MISC", "Miscellaneous", "Dump MM wins")

local multipoint_hitboxes_reference, _, multipoint_mode_reference = ui.reference("RAGE", "Aimbot", "Multi-point")
local multipoint_scale_reference = ui.reference("RAGE", "Aimbot", "Multi-point scale")
local multipoint_dynamic_reference = ui.reference("RAGE", "Aimbot", "Dynamic Multi-point")

local last_save_click
local save_reference, save_confirm_reference, save_cancel_reference

ui.set_visible(orig_save_reference, false)
local function save()
	local realtime = globals_realtime()
	ui_set(export_reference, true)
	ui_set_visible(save_reference, false)
	ui_set_visible(save_confirm_reference, true)
	ui_set_visible(save_cancel_reference, true)
	last_save_click = realtime
	client_exec("playvol ui/weapon_cant_buy 1")
	client_delay_call(5, function(realtime)
        if last_save_click == realtime then
            client.log("Timed out")
            client_exec("playvol ui/weapon_cant_buy 1")
            last_save_click = nil
            ui_set_visible(save_reference, true)
            ui_set_visible(save_confirm_reference, false)
            ui_set_visible(save_cancel_reference, false)
        end
    end,
    realtime)
end

local function save_confirm()
	client.log("Config exported to clipboard and saved")
	ui_set_visible(save_reference, true)
	ui_set_visible(save_confirm_reference, false)
	ui_set_visible(save_cancel_reference, false)
	ui_set(orig_save_reference, true)
	last_save_click = nil
	client_exec("playvol ui/buttonclick 1")
end

local function save_cancel()
	ui_set_visible(save_reference, true)
	ui_set_visible(save_confirm_reference, false)
	ui_set_visible(save_cancel_reference, false)
	last_save_click = nil
	client_exec("playvol ui/menu_invalid 1")
end

local function ui_element_exists(tab, container, name)
	local val = {pcall(ui.reference, tab, container, name)}
	return val[1]
end

ui.new_button("CONFIG", "Presets", "Save", save)
ui.new_button("CONFIG", "Presets", "Save: CANCEL", save_cancel)
ui.new_button("CONFIG", "Presets", "Save: CONFIRM", save_confirm)

--ui.new_button doesn't return a reference - this is the ghetto fix
save_reference = ui.reference("CONFIG", "Presets", "Save")
save_confirm_reference = ui.reference("CONFIG", "Presets", "Save: CANCEL")
save_cancel_reference = ui.reference("CONFIG", "Presets", "Save: CONFIRM")

ui_set_visible(save_confirm_reference, false)
ui_set_visible(save_cancel_reference, false)

local show_reference = ui.new_checkbox("CONFIG", "Presets", "Show other buttons")

local function on_show_change()
	local show = ui_get(show_reference)
	ui_set_visible(reset_reference, show)
	ui_set_visible(reset_layout_reference, show)
	ui_set_visible(unload_reference, show)
end
on_show_change()
ui.set_callback(show_reference, on_show_change)

local function task()
	local hitboxes = ui_get(hitboxes_reference)
	local headonly = #hitboxes == 1 and hitboxes[1] == "Head"
	local anti_ut = ui_get(anti_untrusted_reference)

	--ui_set_visible(strict_hitbox_checks_reference, not headonly)
	ui_set_visible(override_awp_reference, not headonly and not anti_ut)
	ui_set_visible(force_baim_reference, not headonly)
	ui_set_visible(remove_spread_reference, not anti_ut)

	local mp_enabled = #ui_get(multipoint_hitboxes_reference) > 0
	ui_set_visible(multipoint_mode_reference, mp_enabled)
	ui_set_visible(multipoint_scale_reference, mp_enabled)
	ui_set_visible(multipoint_dynamic_reference, mp_enabled)

	local is_valve_server = false
	local game_rules = entity_get_game_rules()
	if game_rules ~= nil then
		is_valve_server = entity_get_prop(game_rules, "m_bIsValveDS") == 1
	end

	ui_set_visible(aimstep_reference, is_valve_server)
	if not is_valve_server then
		ui_set(aimstep_reference, false)
	end

	if not ui_is_menu_open() then
		if last_save_click ~= nil then
			save_cancel()
		end

		if ui_get(show_reference) then
			ui_set(show_reference, false)
			on_show_change()
		end
	end

	client_delay_call(0.05, task)
end
task()
--ui_set(lua_script_manager_reference, true)

ui.set_visible(dump_mm_wins_reference, false)
