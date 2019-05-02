--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_random_int, client_latency, client_set_clan_tag, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_draw_hitboxes, client_camera_angles, client_open_panorama_context, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.random_int, client.latency, client.set_clan_tag, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.draw_hitboxes, client.camera_angles, client.open_panorama_context, client.system_time
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_hotkey, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_mouse_position, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_hotkey, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.mouse_position, ui.new_button, ui.new_multiselect, ui.get
local renderer_load_svg, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_world_to_screen, renderer_indicator, renderer_texture = renderer.load_svg, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.world_to_screen, renderer.indicator, renderer.texture
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local materialsystem_find_material, materialsystem_override_material, materialsystem_find_materials, materialsystem_get_model_materials = materialsystem.find_material, materialsystem.override_material, materialsystem.find_materials, materialsystem.get_model_materials
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local remove_scope_overlay_reference = ui.reference("VISUALS", "Effects", "Remove scope overlay")
local instant_scope_reference = ui.reference("VISUALS", "Effects", "Instant scope")
local anti_ut_reference = ui.reference("MISC", "Settings", "Anti-untrusted")
local remove_spread_reference = ui.reference("RAGE", "Other", "Remove spread")
local override_fov_reference = ui.reference("MISC", "Miscellaneous", "Override FOV")

local remove_zoom_reference = ui.new_checkbox("VISUALS", "Effects", "Remove zoom")
local first_zoom_reference = ui.new_slider("VISUALS", "Effects", "\nFirst level zoom", 0, 50, 0, true, "°", 1, {[0] = " "})
local second_zoom_reference = ui.new_slider("VISUALS", "Effects", "\nSecond level zoom", 0, 80, 0, true, "°", 1, {[0] = " "})

local function on_remove_zoom_changed()
	local remove_zoom = ui_get(remove_zoom_reference)
	ui_set_visible(first_zoom_reference, remove_zoom)
	ui_set_visible(second_zoom_reference, remove_zoom)
end
ui.set_callback(remove_zoom_reference, on_remove_zoom_changed)
on_remove_zoom_changed()

local show_inaccuracy_reference = ui.new_checkbox("VISUALS", "Effects", "Scope overlay inaccuracy")
ui.set_visible(show_inaccuracy_reference, false)

local weapon_accuracy_nospread = cvar.weapon_accuracy_nospread
local r_drawviewmodel = cvar.r_drawviewmodel
local MATERIAL_VAR_NO_DRAW = 2

local remove_scope_prev = false
local scoped_until = 0
local dirty_materials = {}

local materials = {
	"dev/scope_bluroverlay",
	"models/weapons/shared/scope/scope_dot_green",
	"models/weapons/shared/scope/scope_dot_red"
}

local max_velocity_weapons = {
	["CWeaponSG556"] = 150,
	["CWeaponAug"] = 150,
	["CWeaponSCAR20"] = 120,
	["CWeaponG3SG1"] = 120,
	["CWeaponSSG08"] = 230,
	["CWeaponAWP"] = 100
}

local fov_changed, is_scoped_prev, unscoping_until = false
local unscope_duration = 7*1/64

local function reset(local_player, force)
	if fov_changed or force then
		entity_set_prop(local_player, "m_iDefaultFOV", 90)
		entity_set_prop(local_player, "m_iFOV", 90)
		fov_changed = false
	end
end

local function on_predict_command()
	local remove_zoom = ui_get(remove_zoom_reference) and ui_get(remove_scope_overlay_reference) and ui_get(instant_scope_reference)

	local local_player = entity_get_local_player()
	local weapon_name = entity_get_classname(entity_get_player_weapon(local_player))
	local has_single_zoom_weapon = (weapon_name == "CWeaponSG556" or weapon_name == "CWeaponAug")

	local scoped = entity_get_prop(local_player, "m_bIsScoped") == 1

	if entity_is_alive(local_player) then
		if remove_zoom then
			-- remove zoom is enabled

			-- simulate unscoping with single zoom gun to fix fov. needs to be improved
			local unscoping = false
			if has_single_zoom_weapon then
				if is_scoped_prev and not scoped then
					unscoping_until = globals_realtime()+unscope_duration
				end
				is_scoped_prev = scoped

				if unscoping_until ~= nil and unscoping_until >= globals_realtime() then
					unscoping = true
				end
			else
				unscoping_until, is_scoped_prev = nil, false
			end

			if scoped then
				-- player is scoped normally
				local fov = entity_get_prop(local_player, "m_iFOV")
				if fov ~= nil then
					if fov ~= 0 and fov ~= 90 then
						local fov_extra = (fov == 15 or fov == 10) and ui_get(second_zoom_reference) or ui_get(first_zoom_reference)
						fov = fov + fov_extra
					end

					entity_set_prop(local_player, "m_iDefaultFOV", fov == 0 and 90 or fov)
					fov_changed = true
					return
			end
			elseif unscoping then
				-- player is unscoping with a single zoom weapon
				local fov = entity_get_prop(local_player, "m_iFOV")
				local dur = 1-(unscoping_until-globals_realtime())/unscope_duration
				entity_set_prop(local_player, "m_iDefaultFOV", 45 + 45*dur)
				fov_changed = true
				return
			end

		elseif has_single_zoom_weapon and scoped then
			local fov_new = math_floor(90.5+(ui_get(override_fov_reference)-90)/2)
			entity_set_prop(local_player, "m_iDefaultFOV", fov_new)
			fov_changed = true
			return
		end
	end

	reset(local_player)
end
client.set_event_callback("predict_command", on_predict_command)

local function on_player_death(e)
	if client.userid_to_entindex(e.userid) == entity_get_local_player() then
		if fov_changed then
			reset(entity_get_local_player())
			client_delay_call(0, reset, entity_get_local_player(), true)
			client_delay_call(0.1, reset, entity_get_local_player(), true)
		end
	end
end
client.set_event_callback("player_death", on_player_death)

local function on_paint()
	local local_player = entity_get_local_player()
	local weapon = entity_get_player_weapon(local_player)
	local weapon_name = entity_get_classname(weapon)
	local realtime = globals_realtime()

	local scoped = entity_get_prop(local_player, "m_bIsScoped") == 1
	if scoped then
		scoped_until = realtime+0.08
	end
	local remove_scope = ui_get(remove_scope_overlay_reference) and local_player ~= nil and weapon ~= nil and (weapon_name == "CWeaponSG556" or weapon_name == "CWeaponAug") and (scoped_until > realtime)

	if (remove_scope and not remove_scope_prev) or (remove_scope_prev and not remove_scope) then
		r_drawviewmodel:set_raw_int(remove_scope and 0 or 1)

		if remove_scope then
			for i=1, #materials do
				local material = materialsystem_find_material(materials[i])
				if material ~= nil and not material:get_material_var_flag(MATERIAL_VAR_NO_DRAW) then
					material:set_material_var_flag(MATERIAL_VAR_NO_DRAW, true)
					table_insert(dirty_materials, material)
				end
			end
		else
			for i=1, #dirty_materials do
				dirty_materials[i]:set_material_var_flag(MATERIAL_VAR_NO_DRAW, false)
			end
			dirty_materials = {}
		end
	end

	if remove_scope then
		local screen_width, screen_height = client_screen_size()
		renderer_rectangle(screen_width/2, 0, 1, screen_height, 0, 0, 0, 255)
		renderer_rectangle(0, screen_height/2, screen_width, 1, 0, 0, 0, 255)
	end

	remove_scope_prev = remove_scope

	if ui_get(show_inaccuracy_reference) and false then
		local max_velocity = max_velocity_weapons[weapon_name]
		if max_velocity ~= nil then
			local max_velocity_no_spread = max_velocity*0.3395

			local spread = 0
			if weapon_accuracy_nospread:get_int() == 0 and not (ui_get(anti_ut_reference) and ui_get(remove_spread_reference)) then
				local vel_x, vel_y, vel_z = entity_get_prop(local_player, "m_vecVelocity")
				local velocity = math_sqrt(vel_x*vel_x + vel_y*vel_y + vel_z*vel_z)
				spread = math_max(0, velocity-max_velocity_no_spread) / (max_velocity*0.6605)
				spread = spread + math_max(0, entity_get_prop(weapon, "m_fAccuracyPenalty")*10-0.025)
				spread = math_min(3, spread*4)

				if spread > 0.01 then
					local screen_width, screen_height = client_screen_size()
					local size = screen_width*0.007*spread*2.5
					local size_outer = 10
					local opacity_inner = 150
					local opacity_middle = 130
					local opacity_outer = 0

					local alpha = 255-spread/3*70

					if scoped or remove_scope then
						renderer_gradient(screen_width/2-math_ceil(size/2), 0, math_ceil(size/2), screen_height, 16, 16, 16, 0, 0, 0, 0, alpha, true)
						renderer_gradient(screen_width/2, 0, math_floor(size/2), screen_height, 0, 0, 0, alpha, 0, 0, 0, 0, true)
						--renderer_rectangle(screen_width/2-size/2, 0, size, screen_height, 0, 0, 0, opacity_inner)
					end
				end
			end
		end
	end
end
client.set_event_callback("paint", on_paint)

local function on_shutdown()
	reset(entity_get_local_player())
end
client.set_event_callback("shutdown", on_shutdown)
