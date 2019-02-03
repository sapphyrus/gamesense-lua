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

local function lerp(a, b, percentage)
	return a + (b - a) * percentage
end

local function table_lerp(a, b, percentage)
	local result = {}
	for i=1, #a do
		result[i] = lerp(a[i], b[i], percentage)
	end
	return result
end

local function rgb_to_hsv(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max

	local d = max - min
	if max == 0 then s = 0 else s = d / max end

	if max == min then
		h = 0 -- achromatic
	else
		if max == r then
		h = (g - b) / d
		if g < b then h = h + 6 end
		elseif max == g then h = (b - r) / d + 2
		elseif max == b then h = (r - g) / d + 4
		end
		h = h / 6
	end

	return h, s, v
end

local function hsv_to_rgb(h, s, v)
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

	return r * 255, g * 255, b * 255
end

local function ui_element_exists(tab, container, name)
	local val = {pcall(ui.reference, tab, container, name)}
	return val[1]
end

local colorpickers_default = {
	{reference={"MISC", "Settings", "Menu color", 1}},
	{reference={"Visuals", "Player ESP", "Bounding Box", 2}},
	{reference={"Visuals", "Player ESP", "Weapon icon", 2}},
	{reference={"Visuals", "Player ESP", "Ammo", 2}},
	{reference={"Visuals", "Player ESP", "Glow", 2}},
	{reference={"Visuals", "Player ESP", "Visualize sounds", 2}},
	{reference={"Visuals", "Player ESP", "Line of sight", 2}},
	{reference={"Visuals", "Player ESP", "Skeleton", 2}},
	{reference={"Visuals", "Player ESP", "Out of FOV arrow", 2}},
	{reference={"Visuals", "Colored models", "Player", 2}},
	{reference={"Visuals", "Colored models", "Player behind wall", 2}},
	{reference={"Visuals", "Colored models", "Player behind wall", 4}, name="Player effect"},
	{reference={"Visuals", "Colored models", "Show teammates", 2}},
	{reference={"Visuals", "Colored models", "Hands", 2}},
	{reference={"Visuals", "Colored models", "Hands", 4}, name="Hands effect"},
	{reference={"Visuals", "Colored models", "Shadow", 2}},
	{reference={"Visuals", "Colored models", "Local fake shadow", 2}},
	{reference={"Visuals", "Other ESP", "Dropped weapons", 2}},
	{reference={"Visuals", "Other ESP", "Grenades", 2}},
	{reference={"Visuals", "Other ESP", "Inaccuracy overlay", 2}},
	{reference={"Visuals", "Other ESP", "Bomb", 2}},
	{reference={"Visuals", "Other ESP", "Grenade trajectory", 2}},
	{reference={"Visuals", "Other ESP", "Hostages", 2}},
	{reference={"Visuals", "Effects", "Bullet tracers", 2}},
}

local effects_ordered = {
	{
		name="Rainbow",
		references={
			"speed",
			"color"
		},
		callback=function(colorpicker, h, s, v, a, speed)
			speed = speed / 100
			local realtime = globals_realtime() * speed * 0.2
			h = h - realtime % 1

			return h, s, v, a
		end
	},
	{
		name="Rainbow (Alternative)",
		references={
			"speed",
			"color"
		},
		callback=function(colorpicker, h, s, v, a, speed)
			speed = speed / 100
			local realtime = globals_realtime() * speed * 0.2 * 3
			local val = realtime % 3

			local r, g, b = math_abs(s * math_sin(val + 4))*255, math_abs(s * math_sin(val + 2))*255, math_abs(s * math_sin(val))*255

			local h_new, s_new, v_new = rgb_to_hsv(r, g, b)
			return h_new, s_new, v_new, a
		end
	},
	{
		name="Pulsing",
		references={
			"speed",
			"color",
			"strength"
		},
		callback=function(colorpicker, h, s, v, a, speed, strength)
			speed = speed / 100
			local realtime = globals_realtime() * speed

			local a2 = a*(1-(strength*1.2)/100)

			local val = realtime % 2
			if val > 1 then
				val = 2 - val
			end

			local a_new = a*0.15 + lerp(a, a2, val)
			a_new = math_min(a, math_max(0, a_new))

			return h, s, v, a_new
		end
	},
	{
		name="Fade",
		references={
			"speed",
			"color",
			"color_2"
		},
		callback=function(colorpicker, h, s, v, a, speed, r2, g2, b2, a2)
			speed = speed / 100
			local realtime = globals_realtime() * speed

			local val = realtime % 2
			if val > 1 then
				val = 2 - val
			end

			local r, g, b = ui_get(colorpicker.references.color)

			local r_new, g_new, b_new, a_new = unpack(table_lerp({r, g, b, a}, {r2, g2, b2, a2}, val))

			local h_new, s_new, v_new = rgb_to_hsv(r_new, g_new, b_new)
			return h_new, s_new, v_new, a_new
		end
	},
	{
		name="Own health",
		references={
			"color"
		},
		callback=function(colorpicker, h, s, v, a)
			local val = 1
			local local_player = entity_get_local_player()
			if local_player ~= nil then
				local health = entity_get_prop(local_player, "m_iHealth")
				if health ~= nil then
					val = math_max(0, math_min(1, health/100))
				end
			end

			--val = 1-(globals_realtime() / 2) % 1
			local r = 124*2 - 124 * val
			local g = 195 * val
			local b = 13

			local h_new, s_new, v_new = rgb_to_hsv(r, g, b)

			return h_new, s_new*s, v_new*v, a
		end
	}
}
local effects = {}
for i=1, #effects_ordered do
	local effect = effects_ordered[i]
	effects[effect.name] = effect
end

local colorpickers = {}
local listbox_items = {}

local function setup_colorpicker(reference, name)
	local colorpicker = {
		references={},
		reference=reference
	}
	colorpickers[name] = colorpicker

	table_insert(listbox_items, name)
end

for i=1, #colorpickers_default do
	local tab, container, menu_name, reference_index = unpack(colorpickers_default[i].reference)
	local name = colorpickers_default[i].name or menu_name
	if ui_element_exists(tab, container, menu_name) then
		local reference = ({ui_reference(tab, container, menu_name)})[reference_index]

		setup_colorpicker(reference, container .. " - " .. name)
	end
end

--client_delay_call(0, function()
local enabled_reference = ui.new_checkbox("LUA", "B", "Color effects")
local configure_reference = ui.new_listbox("LUA", "B", "Configure color effect", listbox_items)

local function on_configure_changed()
	local enabled = ui_get(enabled_reference)
	local configure = ui_get(configure_reference)

	if type(configure) == "number" then
		configure = listbox_items[configure+1]
	end

	for name, colorpicker in pairs(colorpickers) do
		for id, reference in pairs(colorpicker.references) do
			ui_set_visible(reference, enabled and name == configure and id == "enabled")
		end

		if enabled and name == configure then
			local effect_name = ui_get(colorpicker.references.enabled)
			if effects[effect_name] ~= nil then
				local effect = effects[effect_name]
				for i=1, #effect.references do
					ui_set_visible(colorpicker.references[effect.references[i]], true)
				end
			end
		end
	end

	ui_set_visible(configure_reference, enabled)
end

local effects_list = {"-"}
for i=1, #effects_ordered do
	table_insert(effects_list, effects_ordered[i].name)
end

for name, colorpicker in pairs(colorpickers) do
	colorpicker.references.enabled = ui_new_combobox("LUA", "B", "Effect\n" .. name, effects_list)
	colorpicker.references.speed = ui.new_slider("LUA", "B", "Speed\n" .. name, 1, 800, 100, true, nil, 0.01)
	colorpicker.references.color = ui.new_color_picker("LUA", "B", "Color\n" .. name, 254, 254, 254, 254)
	colorpicker.references.color_2 = ui.new_color_picker("LUA", "B", "Color 2\n" .. name, 210, 0, 40, 200)
	colorpicker.references.strength = ui.new_slider("LUA", "B", "Strength\n" .. name, 0, 120, 100, true, "%")

	ui.set_callback(colorpicker.references.enabled, on_configure_changed)

	for id, reference in pairs(colorpicker.references) do
		ui_set_visible(reference, false)
	end
end

ui.set_callback(enabled_reference, on_configure_changed)
ui.set_callback(configure_reference, on_configure_changed)
on_configure_changed()
--end)

local function do_effects()
	for name, colorpicker in pairs(colorpickers) do
		local references = colorpicker.references
		local enabled = ui_get(references.enabled)
		if enabled ~= "-" then
			local effect = effects[enabled]
			local r, g, b, a = ui_get(references.color)

			if r == 254 and g == 254 and b == 254 and a == 254 then
				r, g, b, a = ui_get(colorpicker.reference)
				ui_set(references.color, r, g, b, a)
			end

			local h, s, v = rgb_to_hsv(r, g, b, a)

			local extra = {}
			for i=1, #effect.references do
				local effect_reference = effect.references[i]
				if effect_reference ~= "color" then
					local values = {ui_get(references[effect_reference])}
					for i=1, #values do
						table_insert(extra, values[i])
					end
				end
			end

			h, s, v, a = effect.callback(colorpicker, h, s, v, a, unpack(extra))

			r, g, b = hsv_to_rgb(h, s, v, a)
			ui_set(colorpicker.reference, r, g, b, a)
		end
	end
end

local function task()
	do_effects()
	client.delay_call(0.02, task)
end
task()

client.set_event_callback("paint", do_effects)
