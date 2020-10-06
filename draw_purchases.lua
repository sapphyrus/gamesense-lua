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

local images = require "gamesense/images"
local bit_band = bit.band
local idx_to_console_name, weapon_types = {[1]="weapon_deagle",[2]="weapon_elite",[3]="weapon_fiveseven",[4]="weapon_glock",[7]="weapon_ak47",[8]="weapon_aug",[9]="weapon_awp",[10]="weapon_famas",[11]="weapon_g3sg1",[13]="weapon_galilar",[14]="weapon_m249",[16]="weapon_m4a1",[17]="weapon_mac10",[19]="weapon_p90",[23]="weapon_mp5sd",[24]="weapon_ump45",[25]="weapon_xm1014",[26]="weapon_bizon",[27]="weapon_mag7",[28]="weapon_negev",[29]="weapon_sawedoff",[30]="weapon_tec9",[31]="weapon_taser",[32]="weapon_hkp2000",[33]="weapon_mp7",[34]="weapon_mp9",[35]="weapon_nova",[36]="weapon_p250",[38]="weapon_scar20",[39]="weapon_sg556",[40]="weapon_ssg08",[41]="weapon_knifegg",[42]="weapon_knife",[43]="weapon_flashbang",[44]="weapon_hegrenade",[45]="weapon_smokegrenade",[46]="weapon_molotov",[47]="weapon_decoy",[48]="weapon_incgrenade",[49]="weapon_c4",[50]="item_kevlar",[51]="item_assaultsuit",[52]="item_heavyassaultsuit",[55]="item_defuser",[56]="item_cutters",[57]="weapon_healthshot",[59]="weapon_knife_t",[60]="weapon_m4a1_silencer",[61]="weapon_usp_silencer",[63]="weapon_cz75a",[64]="weapon_revolver",[68]="weapon_tagrenade",[69]="weapon_fists",[70]="weapon_breachcharge",[72]="weapon_tablet",[74]="weapon_melee",[75]="weapon_axe",[76]="weapon_hammer",[78]="weapon_spanner",[80]="weapon_knife_ghost",[81]="weapon_firebomb",[82]="weapon_diversion",[83]="weapon_frag_grenade",[84]="weapon_snowball",[500]="weapon_bayonet",[505]="weapon_knife_flip",[506]="weapon_knife_gut",[507]="weapon_knife_karambit",[508]="weapon_knife_m9_bayonet",[509]="weapon_knife_tactical",[512]="weapon_knife_falchion",[514]="weapon_knife_survival_bowie",[515]="weapon_knife_butterfly",[516]="weapon_knife_push",[519]="weapon_knife_ursus",[520]="weapon_knife_gypsy_jackknife",[522]="weapon_knife_stiletto",[523]="weapon_knife_widowmaker"}, {["secondary"]={1,2,3,4,30,32,36,61,63,64},["rifle"]={7,8,9,10,11,13,16,38,39,40,60},["heavy"]={14,25,27,28,29,35},["smg"]={17,19,23,24,26,33,34},["equipment"]={31,50,51,52,55,56},["melee"]={41,42,59,69,74,75,76,78,80,500,505,506,507,508,509,512,514,515,516,519,520,522,523},["grenade"]={43,44,45,46,47,48,68,81,82,83,84},["c4"]={49,70},["boost"]={57},["utility"]={72}}
local weapon_types_lookup, console_name_to_idx = setmetatable({}, {__index=function(tbl, idx) return type(idx) == "number" and rawget(tbl, bit_band(idx, 0xFFFF)) or nil end}), {}
for type, weapons in pairs(weapon_types) do
	for i=1, #weapons do
		weapon_types_lookup[weapons[i]], weapon_types_lookup[idx_to_console_name[weapons[i]]], console_name_to_idx[weapons[i]] = type, type, idx_to_console_name[weapons[i]]
	end
end

--{"c4", "boost", "utility", "rifle", "heavy", "smg", "secondary", "melee", "equipment", "grenade"}

local type_opacities = {
	secondary=0.7,
	equipment=0.7,
	grenade=0.4,
	utility=0.4,
}

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function draw_container(x, y, w, h, header, a)
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

local enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Draw purchases")
local color_reference = ui.new_color_picker("VISUALS", "Other ESP", "Draw purchases color", 230, 230, 230, 255)

local player_name_flags = nil
local icon_height = 13
local padding = 4
local line_height = 17

local purchases = {}

local function on_paint()
	if not ui_get(enabled_reference) then
		return
	end
	local r, g, b, a = ui_get(color_reference)

	local width_max = 90
	local names, width_name = {}, {}
	local i = 1
	for player, purchases_player in pairs(purchases) do
		names[player] = entity_get_player_name(player) .. " bought "
		local width = renderer_measure_text(player_name_flags, names[player])
		width_name[player] = width

		for i=1, #purchases_player do
			if purchases_player[i] ~= "kevlar" or not table_contains(purchases_player, "assaultsuit") then
				local icon = images.get_weapon_icon(purchases_player[i])
				if icon ~= nil then
					width = width + icon:measure(nil, icon_height) + padding
				--else
				--	client.log("icon for ", purchases_player[i], " not found")
				end
			end
		end

		width_max = math_max(width_max, width)
		i = i + 1
	end

	if i == 1 then
		return
	end

	local game_rules = entity_get_game_rules()
	local a = 255
	local round_start_time = entity_get_prop(game_rules, "m_fRoundStartTime")
	local round_time = entity_get_prop(game_rules, "m_timeUntilNextPhaseStarts")

	local time_since_start = globals_curtime()-round_start_time

	if time_since_start > 5 and time_since_start <= 6 then
		a = 255 * (1-(time_since_start-5)/1)
	elseif time_since_start > 6 then
		a = 0
	end

	if a == 0 then
		return
	end

	local screen_width, screen_height = client_screen_size()
	local x, y = screen_width-width_max-16-11, screen_height/2.3

	draw_container(x-4, y-4, width_max+16, i*line_height, true, a)
	local x, y = x+5, y+8

	local i = 1
	for player, purchases_player in pairs(purchases) do
		local y_offset = (i-1)*line_height
		renderer_text(x, y+y_offset, r, g, b, a, player_name_flags, 0, names[player])
		local x_offset = width_name[player]

		local weapon_types_order = {"c4", "boost", "utility", "rifle", "heavy", "smg", "secondary", "melee", "equipment", "grenade"}
		for i=1, #weapon_types_order do
			local type_current = weapon_types_order[i]
			for i=1, #purchases_player do
				local weapon_type = weapon_types_lookup[purchases_player[i]]
				if weapon_type == type_current then
					if purchases_player[i] ~= "item_kevlar" or not table_contains(purchases_player, "item_assaultsuit") then
						local icon = images.get_weapon_icon(purchases_player[i])
						if icon ~= nil then
							local opacity_multiplier = type_opacities[weapon_type] or 1
							local width = icon:draw(x+x_offset, y+y_offset, nil, icon_height, r, g, b, a*opacity_multiplier)
							x_offset = x_offset + width + padding
						end
					end
				end
				end
		end

		i = i + 1
	end
end
client.set_event_callback("paint", on_paint)

local function on_item_purchase(e)
	local player = client_userid_to_entindex(e.userid)
	if not entity_is_enemy(player) then return end
	if purchases[player] == nil then
		purchases[player] = {}
	end
	table_insert(purchases[player], e.weapon)
end
client.set_event_callback("item_purchase", on_item_purchase)

local function on_player_spawn(e)
	local player = client_userid_to_entindex(e.userid)
	if not entity_is_enemy(player) then return end
	if purchases[player] == nil then
		purchases[player] = {}
	end
end
client.set_event_callback("player_spawn", on_player_spawn)

local function reset()
	purchases = {}
end
client.set_event_callback("round_end", reset)
client.set_event_callback("round_start", reset)
