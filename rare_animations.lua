-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, entity_get_local_player, entity_get_prop, entity_is_alive, entity_set_prop, pairs, ui_get, ui_new_checkbox, ui_new_multiselect, ui_set_visible = bit.band, entity.get_local_player, entity.get_prop, entity.is_alive, entity.set_prop, pairs, ui.get, ui.new_checkbox, ui.new_multiselect, ui.set_visible

local weapons = ((function() local a={}local type,b=type,bit.band;local c,d={},{}local e,f={[1]={"deagle",1,250,0,"Desert Eagle",0,0,1.0,0.87,2.2},[2]={"elite",1,250,0,"Dual Berettas",0,0,1.0,2.9,3.77},[3]={"fiveseven",1,250,0,"Five-SeveN",0,0,1.0,0.93,2.27},[4]={"glock",1,250,0,"Glock-18",0,0,1.1,0.93,2.27},[7]={"ak47",2,250,0,"AK-47",0,0,1.0,1.17,2.43},[8]={"aug",2,250,0,"AUG",0,0,1.17,1.53,3.77},[9]={"awp",2,250,0,"AWP",0,0,1.25,2.0,3.67},[10]={"famas",2,250,0,"FAMAS",0,0,1.0,1.63,3.3},[11]={"g3sg1",2,250,0,"G3SG1",0,0,1.0,2.6,4.67},[13]={"galilar",2,250,0,"Galil AR",0,0,1.1,1.17,3.03},[14]={"m249",3,250,0,"M249",0,0,1.1,3.73,5.7},[16]={"m4a1",2,250,0,"M4A4",0,0,1.13,1.37,3.07},[17]={"mac10",4,250,0,"MAC-10",0,0,1.0,1.27,2.57},[19]={"p90",4,250,0,"P90",0,0,1.0,1.97,3.37},[23]={"mp5sd",4,250,0,"MP5-SD",0,0,1.0,1.97,2.94},[24]={"ump45",4,250,0,"UMP-45",0,0,1.0,1.5,3.43},[25]={"xm1014",3,250,0,"XM1014",0,0,1.0,0.53,4.22},[26]={"bizon",4,250,0,"PP-Bizon",0,0,1.1,1.17,2.43},[27]={"mag7",3,250,0,"MAG-7",0,0,1.0,1.07,2.47},[28]={"negev",3,250,0,"Negev",0,0,1.1,3.83,5.7},[29]={"sawedoff",3,250,0,"Sawed-Off",0,0,1.0,0.55,4.22},[30]={"tec9",1,250,0,"Tec-9",0,0,1.0,1.33,2.57},[31]={"taser",5,250,0,"Zeus x27",0,0,-1,-1,-1},[32]={"hkp2000",1,250,0,"P2000",0,0,1.0,0.97,2.27},[33]={"mp7",4,250,0,"MP7",0,0,1.0,1.43,3.13},[34]={"mp9",4,250,0,"MP9",0,0,1.2,0.87,2.13},[35]={"nova",3,250,0,"Nova",0,0,1.0,0.54,4.74},[36]={"p250",1,250,0,"P250",0,0,1.0,0.93,2.27},[37]={"shield",1,250,0,"Ballistic Shield",0,0,-1,-1,-1},[38]={"scar20",2,250,0,"SCAR-20",0,0,1.0,1.4,3.07},[39]={"sg556",2,250,0,"SG 553",0,0,1.0,1.03,2.77},[40]={"ssg08",2,250,0,"SSG 08",0,0,1.0,1.97,3.7},[42]={"knife",6,250,0,"Knife",0,0,-1,-1,-1},[43]={"flashbang",7,250,0,"Flashbang",0,0,-1,-1,-1},[44]={"hegrenade",7,250,0,"High Explosive Grenade",0,0,-1,-1,-1},[45]={"smokegrenade",7,250,0,"Smoke Grenade",0,0,-1,-1,-1},[46]={"molotov",7,250,0,"Molotov",0,0,-1,-1,-1},[47]={"decoy",7,250,0,"Decoy Grenade",0,0,-1,-1,-1},[48]={"incgrenade",7,250,0,"Incendiary Grenade",0,0,-1,-1,-1},[49]={"c4",8,250,0,"C4 Explosive",0,0,-1,-1,-1},[50]={"item_kevlar",5,250,0,"Kevlar Vest",0,0,-1,-1,-1},[51]={"item_assaultsuit",5,250,0,"Kevlar + Helmet",0,0,-1,-1,-1},[52]={"item_heavyassaultsuit",5,250,0,"Heavy Assault Suit",0,0,-1,-1,-1},[55]={"item_defuser",5,250,0,"Defuse Kit",0,0,-1,-1,-1},[56]={"item_cutters",5,250,0,"Rescue Kit",0,0,-1,-1,-1},[59]={"knife_t",6,250,0,"Knife",0,0,-1,-1,-1},[60]={"m4a1_silencer",2,250,0,"M4A1-S",0,0,1.13,1.37,3.07},[61]={"usp_silencer",1,250,0,"USP-S",0,0,1.0,0.97,2.17},[63]={"cz75a",1,250,0,"CZ75-Auto",0,0,1.83,1.53,2.73},[64]={"revolver",1,250,0,"R8 Revolver",0,0,1.17,1.97,2.27},[74]={"melee",6,250,0,"Knife",0,0,-1,-1,-1},[500]={"bayonet",6,250,0,"Bayonet",0,0,-1,-1,-1},[503]={"knife_css",6,250,0,"Classic Knife",0,0,-1,-1,-1},[505]={"knife_flip",6,250,0,"Flip Knife",0,0,-1,-1,-1},[506]={"knife_gut",6,250,0,"Gut Knife",0,0,-1,-1,-1},[507]={"knife_karambit",6,250,0,"Karambit",0,0,-1,-1,-1},[508]={"knife_m9_bayonet",6,250,0,"M9 Bayonet",0,0,-1,-1,-1},[509]={"knife_tactical",6,250,0,"Huntsman Knife",0,0,-1,-1,-1},[512]={"knife_falchion",6,250,0,"Falchion Knife",0,0,-1,-1,-1},[514]={"knife_survival_bowie",6,250,0,"Bowie Knife",0,0,-1,-1,-1},[515]={"knife_butterfly",6,250,0,"Butterfly Knife",0,0,-1,-1,-1},[516]={"knife_push",6,250,0,"Shadow Daggers",0,0,-1,-1,-1},[517]={"knife_cord",6,250,0,"Paracord Knife",0,0,-1,-1,-1},[518]={"knife_canis",6,250,0,"Survival Knife",0,0,-1,-1,-1},[519]={"knife_ursus",6,250,0,"Ursus Knife",0,0,-1,-1,-1},[520]={"knife_gypsy_jackknife",6,250,0,"Navaja Knife",0,0,-1,-1,-1},[521]={"knife_outdoor",6,250,0,"Nomad Knife",0,0,-1,-1,-1},[522]={"knife_stiletto",6,250,0,"Stiletto Knife",0,0,-1,-1,-1},[523]={"knife_widowmaker",6,250,0,"Talon Knife",0,0,-1,-1,-1},[525]={"knife_skeleton",6,250,0,"Skeleton Knife",0,0,-1,-1,-1},[5027]={"studded_bloodhound_gloves",9,250,0,"Bloodhound Gloves",0,0,-1,-1,-1},[5028]={"t_gloves",9,250,0,"Default T Gloves",0,0,-1,-1,-1},[5029]={"ct_gloves",9,250,0,"Default CT Gloves",0,0,-1,-1,-1},[5030]={"sporty_gloves",9,250,0,"Sport Gloves",0,0,-1,-1,-1},[5031]={"slick_gloves",9,250,0,"Driver Gloves",0,0,-1,-1,-1},[5032]={"leather_handwraps",9,250,0,"Hand Wraps",0,0,-1,-1,-1},[5033]={"motorcycle_gloves",9,250,0,"Moto Gloves",0,0,-1,-1,-1},[5034]={"specialist_gloves",9,250,0,"Specialist Gloves",0,0,-1,-1,-1},[5035]={"studded_hydra_gloves",9,250,0,"Hydra Gloves",0,0,-1,-1,-1}},{"secondary","rifle","heavy","smg","equipment","melee","grenade","c4","clothing_hands"}for g,h in pairs(e)do local i,j=("weapon_"..h[1]):gsub("weapon_item_","item_"),f[h[2]]c[g]={console_name=i,idx=g,type=j,max_speed=h[3],price=h[4],name=h[5],primary_clip_size=h[6],cycletime=h[7]}d[i]=c[g]end;a.weapons=setmetatable(c,{__call=function(k,g)end,__index=function(k,g)if type(g)=="string"then return d[g]elseif type(g)=="number"then g=b(g,0xFFFF)return rawget(c,g)end end})return a end)()).weapons
local table_clear = require "table.clear"

local function table_map(tbl, func)
	local result = {}
	for key, value in pairs(tbl) do
		result[key] = func(value)
	end
	return result
end

local function table_array_to_keys(tbl)
	local result = {}
	for i=1, #tbl do
		result[tbl[i]] = i
	end
	return result
end

local sequence_overrides = {
	{
		weapon = weapons["weapon_knife_butterfly"],
		overrides = {
			[1] = 0,
			[13] = 15,
			[14] = 15,
		}
	},
	{
		weapon = weapons["weapon_knife_falchion"],
		overrides = {
			[12] = 13,
		}
	},
	{
		weapon = weapons["weapon_knife_ursus"],
		overrides = {
			[0] = 1,
			[14] = 13,
		}
	},
	{
		weapon = weapons["weapon_knife_stiletto"],
		overrides = {
			[13] = 12,
		}
	},
	{
		weapon = weapons["weapon_knife_widowmaker"],
		overrides = {
			[14] = 15,
		}
	},
	{
		weapon = weapons["weapon_knife_skeleton"],
		overrides = {
			[0] = 1,
			[13] = 14,
		}
	},
	{
		weapon = weapons["weapon_knife_canis"],
		overrides = {
			[0] = 1,
			[14] = 13,
		}
	},
	{
		weapon = weapons["weapon_knife_cord"],
		overrides = {
			[0] = 1,
			[14] = 13,
		}
	},
	{
		weapon = weapons["weapon_knife_outdoor"],
		overrides = {
			-- [1] = 0,
			[14] = 13,
		},
		overrides_durations = {
			[1] = 4
		}
	},
	{
		weapon = weapons["weapon_deagle"],
		overrides = {
			[7] = 8,
		}
	},
	{
		weapon = weapons["weapon_revolver"],
		overrides = {
			[3] = 4,
		}
	},
}

local idx_to_overrides = {}

local enabled_reference = ui_new_checkbox("SKINS", "Knife options", "Rare weapon animations")
local active_rare_animations_reference = ui_new_multiselect("SKINS", "Knife options", "\nActive rare animations", table_map(sequence_overrides, function(sequence_override) return sequence_override.name or sequence_override.weapon.name end))
ui_set_visible(active_rare_animations_reference, false)

ui.set_callback(enabled_reference, function()
	ui_set_visible(active_rare_animations_reference, ui_get(enabled_reference))
end)
ui.set_callback(active_rare_animations_reference, function()
	table_clear(idx_to_overrides)

	local active_rare_animations = table_array_to_keys(ui_get(active_rare_animations_reference))
	for i=1, #sequence_overrides do
		local sequence_override = sequence_overrides[i]
		if active_rare_animations[sequence_override.name or sequence_override.weapon.name] ~= nil then
			local idx = sequence_override.weapon.idx
			idx_to_overrides[idx] = idx_to_overrides[idx] or {}

			for key, value in pairs(sequence_override.overrides) do
				idx_to_overrides[idx][key] = value
			end
		end
	end
end)

client.set_event_callback("net_update_start", function()
	if not ui_get(enabled_reference) then return end

	local local_player = entity_get_local_player()
	if local_player == nil or not entity_is_alive(local_player) then return end

	local viewmodel = entity_get_prop(local_player, "m_hViewModel[0]")
	if viewmodel == nil then return end

	local weapon = entity_get_prop(viewmodel, "m_hWeapon")
	if weapon == nil then return end

	local idx = bit_band(entity_get_prop(weapon, "m_iItemDefinitionIndex") or 0, 0xFFFF)
	local sequence_overrides_idx = idx_to_overrides[idx]

	if sequence_overrides_idx ~= nil then
		local sequence = entity_get_prop(viewmodel, "m_nSequence")
		if sequence_overrides_idx[sequence] ~= nil then
			entity_set_prop(viewmodel, "m_nSequence", sequence_overrides_idx[sequence])
		end
	end
end)
