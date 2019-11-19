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

local ignore_self = false
local ignore_dropped = false
local planting_time = 3.125
local enabled_reference, color_reference = ui.reference("VISUALS", "Other ESP", "Bomb")
local bar_enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Bomb timer bar")
local dropped_weapons_reference = ui.reference("VISUALS", "Other ESP", "Dropped weapons")

local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
	local x = (x2 - x1) * percentage + x1
	local y = (y2 - y1) * percentage + y1
	local z = (z2 - z1) * percentage + z1
	return x, y, z
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

local function get_site_name(site)
	local player_resource = entity_get_player_resource()
	local a_x, a_y, a_z = entity_get_prop(player_resource, "m_bombsiteCenterA")
	local b_x, b_y, b_z = entity_get_prop(player_resource, "m_bombsiteCenterB")

	local site_x1, site_y1, site_z1 = entity_get_prop(site, "m_vecMins")
	local site_x2, site_y2, site_z2 = entity_get_prop(site, "m_vecMaxs")
	local site_x, site_y, site_z = lerp_pos(site_x1, site_y1, site_z1, site_x2, site_y2, site_z2, 0.5)

	local distance_a, distance_b = distance3d(site_x, site_y, site_z, a_x, a_y, a_z), distance3d(site_x, site_y, site_z, b_x, b_y, b_z)

	return distance_b > distance_a and "A" or "B"
end

local function damage_apply_armor(damage, armor_value)
	local armor_ratio = 0.5
	local armor_bonus = 0.5
	if armor_value > 0 then
		local flNew = damage * armor_ratio
		local flArmor = (damage - flNew) * armor_bonus

		if flArmor > armor_value then
			flArmor = armor_value * (1 / armor_bonus)
			flNew = damage - flArmor
		end

		damage = flNew
	end
	return damage
end

local function calculate_bomb_damage(player, x, y, z)
	--full credits for this to n0xius, https://www.unknowncheats.me/forum/1511502-post27.html
	local player_x, player_y, player_z = entity_get_prop(player, "m_vecAbsOrigin")
	player_z = player_z + entity_get_prop(player, "m_vecViewOffset[2]")

	local distance = distance3d(player_x, player_y, player_z, x, y, z)

	--not possible to get dynamically, could maybe add a check for demolition (apparently defaults to 300)
	local damage = 500
	local radius = damage * 3.5

	damage = damage * math_exp(-((distance * distance) / ((radius * 2/3) * (radius/3))))
	damage = math_max(damage, 0)

	--apply player armor to it
	local armor_value = entity_get_prop(player, "m_ArmorValue")
	damage = damage_apply_armor(damage, armor_value)

	return damage
end

local planting_player, planting_site, planting_started_at
local function draw_bomb_damage(x, y, player, nodraw)
	if not entity_is_alive(player) then
		local observer_mode = entity_get_prop(player, "m_iObserverMode")
		if (observer_mode == 4 or observer_mode == 5) then
			player = entity_get_prop(player, "m_hObserverTarget")
		else
			return false
		end

		if player == nil or not entity_is_alive(player) then
			return false
		end
	end

	--code below tries to get the bomb position using multiple methods, resorting to bombsite center
	local bomb_x, bomb_y, bomb_z
	local bomb = entity_get_all("CPlantedC4")[1]
	if bomb == nil then
		local player_resource = entity_get_player_resource()
		local player_c4 = entity_get_prop(player_resource, "m_iPlayerC4")
		if entity_get_classname(player_c4) == "CCSPlayer" and not entity_is_dormant(player_c4) then
			bomb = player_c4
		end
		if bomb == nil then
			if planting_site ~= nil then
				bomb_x, bomb_y, bomb_z = entity_get_prop(player_resource, "m_bombsiteCenter" .. planting_site)
			end
		end
	end
	if bomb ~= nil then
		bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, "m_vecOrigin")
	end

	--calculate bomb damage and round it
	local damage = math_floor(calculate_bomb_damage(player, bomb_x, bomb_y, bomb_z))

	--if optional nodraw is set just return if the line wouldve been drawn
	if nodraw then
		return (damage >= 1)
	end

	--draw bomb timer text, fatal if bomb dmg > hp
	if damage > entity_get_prop(player, "m_iHealth") then
		renderer_text(x, y, 255, 1, 1, 255, "+", 0, "FATAL")
	elseif damage >= 1 then
		renderer_text(x, y, 210, 210, 120, 245, "+", 0, "-", string_format("%d", damage), " HP")
	else
		--damage below 1, line would've been empty, return false
		return false
	end
	return true
end

local function draw_sidebar(r, g, b, fill_percentage, screen_height, reversed)
	local remove_from_height = screen_height * fill_percentage
	--background
	renderer_rectangle(0, 0, 20, screen_height, 0, 0, 0, 120)
	--precentage bar
	renderer_rectangle(1, 0+remove_from_height+1, 18, screen_height-remove_from_height-3, r, g, b, 120)
end

local function draw_item_esp(entindex, r, g, b, a)
	local x, y, z = entity_get_prop(entindex, "m_vecOrigin")
	if x == 0 and y == 0 and z == 0 then
		return
	end
	local wx, wy = renderer_world_to_screen(x, y, z)
	if wx ~= nil then
		renderer_text(wx, wy, r, g, b, a, "c-", 0, "BOMB")
	end
end

local function on_bomb_beginplant(e)
	local player = client_userid_to_entindex(e.userid)
	if ignore_self and player == entity_get_local_player() then
		return
	end

	planting_player = player
	planting_site = get_site_name(e.site)
	planting_started_at = globals_curtime()
end
client.set_event_callback("bomb_beginplant", on_bomb_beginplant)

local function reset(e)
	planting_player = nil
	planting_site = nil
end
client.set_event_callback("round_start", reset)
client.set_event_callback("bomb_abortplant", reset)
client.set_event_callback("bomb_planted", reset)

local c4_temp
client.set_event_callback("bomb_pickup", function()
	--c4_temp = nil
end)

local function on_paint(ctx)
	--we dont do anything if the bomb esp is off
	if not ui_get(enabled_reference) then
		return
	end

	if not ignore_dropped then
		local c4_items = entity_get_all("CC4")
		for i=1, #c4_items do
			if entity_get_prop(c4_items[i], "m_hOwner") == nil then
				draw_item_esp(c4_items[i], ui_get(color_reference))
			end
		end
		if #c4_items == 1 then
			c4_temp = c4_items[1]
		elseif #c4_items == 0 then
			if c4_temp ~= nil and entity_get_classname(c4_temp) == "CC4" and entity_is_dormant(c4_temp) then
				local player_resource = entity_get_player_resource()
				local player_c4 = entity_get_prop(player_resource, "m_iPlayerC4")
				if player_c4 == nil or player_c4 == 0 then
					local r, g, b, a = ui_get(color_reference)
					draw_item_esp(c4_temp, r, g, b, a*0.3)
				else
					--client.log("c4 temp deleted ", player_c4, " ", entity_get_player_name(player_c4))
					c4_temp = nil
				end
			end
		end
	end

	if planting_player ~= nil then
		--how far along is the plant
		local plant_percentage = (globals_curtime() - planting_started_at) / planting_time
		if plant_percentage > 0 and 1 > plant_percentage then
			local game_rules_proxy = entity_get_game_rules()
			if entity_get_prop(game_rules_proxy, "m_bBombPlanted") == 1 then
				return
			end

			--check if enough time is left to plant
			local finished_at = (planting_started_at + planting_time)
			local round_end_time = entity_get_prop(game_rules_proxy, "m_fRoundStartTime") + entity_get_prop(game_rules_proxy, "m_iRoundTime")
			local has_time = round_end_time > finished_at

			--check if enough time is left to plant after round end
			if not has_time then
				local restart_round_time = entity_get_prop(game_rules_proxy, "m_flRestartRoundTime")
				if restart_round_time ~= 0 and restart_round_time > finished_at then
					--client.log("restart_round_time ", restart_round_time)
					--client.log("finished at ", finished_at)
					has_time = true
				end
			end

			local r_bar, g_bar, b_bar = 0, 255, 0
			local r_text, g_text, b_text, a_text = 255, 178, 0, 255

			--make our text and bar red if time isnt enough
			if not has_time then
				r_bar, g_bar, b_bar = 255, 0, 0
				r_text, g_text, b_text = 255, 1, 1
			end

			--draw sidebar
			local screen_width, screen_height = client_screen_size()
			draw_sidebar(r_bar, g_bar, b_bar, (1-plant_percentage), screen_height)

			--draw planting text
			renderer_text(5, 5, r_text, g_text, b_text, a_text, "+", 0, planting_site, " - Planting")

			--draw damage (if we arent the one planting) and render player name below it
			local local_player = entity_get_local_player()
			local y_additional = 25
			--planting_player == local_player or
			if draw_bomb_damage(5, 5+25, local_player) == false then
				y_additional = 0
			end

			--render player thats planting
			renderer_text(5, 5+25+y_additional, 255, 255, 255, 255, "+", 0, entity_get_player_name(planting_player))
		end
	else
		local c4_entities = entity_get_all("CPlantedC4")
		for i=1, #c4_entities do
			local c4 = c4_entities[i]
			if entity_get_prop(c4, "m_bBombTicking") == 1 then
				if not ignore_dropped then
					draw_item_esp(c4, ui_get(color_reference))
				end

				local player = entity_get_prop(c4, "m_hBombDefuser")
				if player ~= nil then
					local defused_at = entity_get_prop(c4, "m_flDefuseCountDown")
					local site = entity_get_prop(c4, "m_nBombSite") == 0 and "A" or "B"
					local defuse_length = entity_get_prop(c4, "m_flDefuseLength")

					--just a general nil check to catch edge cases (?)
					if defused_at == nil or defuse_length == nil then
						return
					end

					local defuse_percentage = (globals_curtime() - (defused_at - defuse_length)) / defuse_length
					local explodes_at = entity_get_prop(c4, "m_flC4Blow")

					--makes text green if a teammate is defusing and orange if an enemy is
					local r_text, g_text, b_text, a_text = 124, 195, 13, 255
					--if entity_is_enemy(player) then
					--	r_text, g_text, b_text = 255, 178, 0
					--end

					--makes the text red if no time is left
					local has_time = explodes_at > defused_at
					if not has_time then
						r_text, g_text, b_text = 255, 1, 1
					end

					--we want to render the "being defused" thing next to the default bomb timer
					local x_additional = renderer_measure_text("+", site, " - ", string_format("%.1f", explodes_at - globals_curtime()), "s")
					renderer_text(5+x_additional, 5, r_text, g_text, b_text, a_text, "+", 0, " - Being defused")

					--render player name below the first line, also depends on the bomb damage esp
					local y_additional = 25
					if draw_bomb_damage(5, 5+25, entity_get_local_player(), true) == false then
						y_additional = 0
					end

					--render player thats defusing
					renderer_text(5, 5+25+y_additional, 255, 255, 255, 255, "+", 0, entity_get_player_name(player))
					return
				end

				--bomb is not being defused, draw our normal timer (if enabled)
				if ui_get(bar_enabled_reference) then
					local time_left = entity_get_prop(c4, "m_flC4Blow") - globals_curtime()
					local percentage = time_left / entity_get_prop(c4, "m_flTimerLength")

					if percentage >= 0 and 1 >= percentage then
						local screen_width, screen_height = client_screen_size()
						local r, g, b = 0, 255, 0
						if 5 > time_left then
							r, g, b = 255, 0, 0
						elseif 10 > time_left then
							r, g, b = 211, 211, 115
						end
						draw_sidebar(r, g, b, (1-percentage), screen_height)
						return
					end
				end
			end
		end
	end
end
client.set_event_callback("paint", on_paint)
