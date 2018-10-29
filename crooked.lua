-- ==gslua==
-- @update_repo simpleavaster/gslua/sapphyrus/crooked 
-- @version 1.0.0
-- ==/gslua==

local ref_crooked_conditions = ui.new_combobox("aa", "Anti-aimbot angles", "Crooked", "Off", "Standing", "While in air", "Both")
local ref_crooked_force_on = ui.new_hotkey("aa", "Anti-aimbot angles", "Crooked - force enable")

local ui_get = ui.get
local ui_set = ui.set
local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local client_delay_call = client.delay_call
local globals_tickcount = globals.tickcount

local ref_freestanding = ui.reference("aa", "Anti-aimbot angles", "Freestanding")
local ref_crooked = ui.reference("aa", "Anti-aimbot angles", "Crooked")
local ref_fakelag_limit = ui.reference("aa", "Fake lag", "Limit")

local was_default_active = false
local do_once = false
local last_inair_tick = nil

local table_remove = table.remove
local table_insert = table.insert
local math_sqrt = math.sqrt

local function array_copy(tbl)
	local copy = {}
	for i=1,#tbl do copy[i] = tbl[i] end
	return copy
end

local function on_paint(ctx)
	local crooked = ui_get(ref_crooked_conditions)
	if crooked == "Off" then 
		return 
	end
	
	local local_entindex = entity_get_local_player()
	local local_health = entity_get_prop(local_entindex, "m_iHealth")
	local tickcount = globals_tickcount()
	if local_health <= 0 then
		return
	end
	
	local velocity_x, velocity_y, velocity_z  = entity_get_prop(local_entindex, "m_vecVelocity")
	local velocity = math_sqrt(velocity_x^2 + velocity_y^2)
	
	local active = false
	local freestanding = ui_get(ref_freestanding)
	local default_active = freestanding[1] == "Default"
	local max_speed_for_standing = 0.1
	local standing = velocity < max_speed_for_standing
	local in_air = velocity_z ~= 0
	if in_air then
		last_inair_tick = tickcount
	end
	if last_inair_tick ~= nil and last_inair_tick + 3 > tickcount then
		in_air = true
	end

	if crooked == "Standing" and standing then active = true end
	if crooked == "While in air" and in_air then active = true end
	if crooked == "Both" and (standing or in_air) then active = true end
	if not active and ui_get(ref_crooked_force_on) then active = true end

	if active and not do_once then
		if default_active then
			table_remove(freestanding, 1)
			ui_set(ref_freestanding, freestanding)
		end
		was_default_active = default_active

		ui_set(ref_crooked, true)
		do_once = true
	elseif not active and do_once then
		if was_default_active then
			table_insert(freestanding, "Default")
			ui_set(ref_freestanding, freestanding)
		end
		was_default_active = false
		do_once = false
		ui_set(ref_crooked, false)
	end
end
client.set_event_callback("paint", on_paint)
