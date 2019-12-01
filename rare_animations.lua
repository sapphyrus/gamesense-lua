-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, entity_get_local_player, entity_get_prop, entity_is_alive, entity_set_prop, pairs, ui_get, ui_new_checkbox, ui_new_multiselect, ui_set_visible = bit.band, entity.get_local_player, entity.get_prop, entity.is_alive, entity.set_prop, pairs, ui.get, ui.new_checkbox, ui.new_multiselect, ui.set_visible

local weapons = ((function() local a={}local type,b=type,bit.band;local c,d={},{}local e,f={[1]={"deagle",1,230,700,"Desert Eagle",7,0.225},[2]={"elite",1,240,400,"Dual Berettas",30,0.12},[3]={"fiveseven",1,240,500,"Five-SeveN",20,0.15},[4]={"glock",1,240,200,"Glock-18",20,0.15},[7]={"ak47",2,215,2700,"AK-47",30,0.1},[8]={"aug",2,220,3300,"AUG",30,0.09},[9]={"awp",2,200,4750,"AWP",10,1.455},[10]={"famas",2,220,2250,"FAMAS",25,0.09},[11]={"g3sg1",2,215,5000,"G3SG1",20,0.25},[13]={"galilar",2,215,2000,"Galil AR",35,0.09},[14]={"m249",3,195,5200,"M249",100,0.08},[16]={"m4a1",2,225,3100,"M4A4",30,0.09},[17]={"mac10",4,240,1050,"MAC-10",30,0.075},[19]={"p90",4,230,2350,"P90",50,0.07},[23]={"mp5sd",4,235,1500,"MP5-SD",30,0.08},[24]={"ump45",4,230,1200,"UMP-45",25,0.09},[25]={"xm1014",3,215,2000,"XM1014",7,0.35},[26]={"bizon",4,240,1400,"PP-Bizon",64,0.08},[27]={"mag7",3,225,1300,"MAG-7",5,0.85},[28]={"negev",3,150,1700,"Negev",150,0.075},[29]={"sawedoff",3,210,1100,"Sawed-Off",7,0.85},[30]={"tec9",1,240,500,"Tec-9",18,0.12},[31]={"taser",5,220,200,"Zeus x27",1,0.15},[32]={"hkp2000",1,240,200,"P2000",13,0.17},[33]={"mp7",4,220,1500,"MP7",30,0.08},[34]={"mp9",4,240,1250,"MP9",30,0.07},[35]={"nova",3,220,1050,"Nova",8,0.88},[36]={"p250",1,240,300,"P250",13,0.15},[38]={"scar20",2,215,5000,"SCAR-20",20,0.25},[39]={"sg556",2,210,2750,"SG 553",30,0.09},[40]={"ssg08",2,230,1700,"SSG 08",10,1.25},[41]={"knifegg",6,250,0,"Knife",-1,0.15},[42]={"knife",6,250,0,"Knife",-1,0.15},[43]={"flashbang",7,245,200,"Flashbang",-1,0.15},[44]={"hegrenade",7,245,300,"High Explosive Grenade",-1,0.15},[45]={"smokegrenade",7,245,300,"Smoke Grenade",-1,0.15},[46]={"molotov",7,245,400,"Molotov",-1,0.15},[47]={"decoy",7,245,50,"Decoy Grenade",-1,0.15},[48]={"incgrenade",7,245,600,"Incendiary Grenade",-1,0.15},[49]={"c4",8,250,0,"C4 Explosive",-1,0.15},[50]={"item_kevlar",5,1,650,"Kevlar Vest",-1,0.15},[51]={"item_assaultsuit",5,1,1000,"Kevlar + Helmet",-1,0.15},[52]={"item_heavyassaultsuit",5,1,6000,"Heavy Assault Suit",-1,0.15},[55]={"item_defuser",5,1,400,"Defuse Kit",-1,0.15},[56]={"item_cutters",5,1,400,"Rescue Kit",-1,0.15},[57]={"healthshot",9,250,0,"Medi-Shot",-1,0.15},[59]={"knife_t",6,250,0,"Knife",-1,0.15},[60]={"m4a1_silencer",2,225,3100,"M4A1-S",25,0.1},[61]={"usp_silencer",1,240,200,"USP-S",12,0.17},[63]={"cz75a",1,240,500,"CZ75-Auto",12,0.1},[64]={"revolver",1,180,600,"R8 Revolver",8,0.5},[68]={"tagrenade",7,245,100,"Tactical Awareness Grenade",-1,0.15},[69]={"fists",6,275,0,"Bare Hands",-1,0.15},[70]={"breachcharge",8,245,300,"Breach Charge",3,0.15},[72]={"tablet",10,220,300,"Tablet",1,0.15},[74]={"melee",6,250,0,"Knife",-1,0.15},[75]={"axe",6,250,0,"Axe",-1,0.15},[76]={"hammer",6,250,0,"Hammer",-1,0.15},[78]={"spanner",6,250,0,"Wrench",-1,0.15},[80]={"knife_ghost",6,250,0,"Spectral Shiv",-1,0.15},[81]={"firebomb",7,245,400,"Fire Bomb",-1,0.15},[82]={"diversion",7,245,50,"Diversion Device",-1,0.15},[83]={"frag_grenade",7,245,300,"Frag Grenade",-1,0.15},[84]={"snowball",7,245,100,"Snowball",-1,0.15},[500]={"bayonet",6,250,0,"Bayonet",-1,0.15},[505]={"knife_flip",6,250,0,"Flip Knife",-1,0.15},[506]={"knife_gut",6,250,0,"Gut Knife",-1,0.15},[507]={"knife_karambit",6,250,0,"Karambit",-1,0.15},[508]={"knife_m9_bayonet",6,250,0,"M9 Bayonet",-1,0.15},[509]={"knife_tactical",6,250,0,"Huntsman Knife",-1,0.15},[512]={"knife_falchion",6,250,0,"Falchion Knife",-1,0.15},[514]={"knife_survival_bowie",6,250,0,"Bowie Knife",-1,0.15},[515]={"knife_butterfly",6,250,0,"Butterfly Knife",-1,0.15},[516]={"knife_push",6,250,0,"Shadow Daggers",-1,0.15},[519]={"knife_ursus",6,250,0,"Ursus Knife",-1,0.15},[520]={"knife_gypsy_jackknife",6,250,0,"Navaja Knife",-1,0.15},[522]={"knife_stiletto",6,250,0,"Stiletto Knife",-1,0.15},[523]={"knife_widowmaker",6,250,0,"Talon Knife",-1,0.15},[1349]={"spraypaint",11,250,0,"Graffiti",0,0}},{"secondary","rifle","heavy","smg","equipment","melee","grenade","c4","boost","utility","spray"}for g,h in pairs(e)do local i,j=("weapon_"..h[1]):gsub("weapon_item_","item_"),f[h[2]]c[g]={console_name=i,idx=g,type=j,max_speed=h[3],price=h[4],name=h[5],primary_clip_size=h[6],cycletime=h[7]}d[i]=c[g]end;a.weapons=setmetatable(c,{__call=function(k,g)end,__index=function(k,g)if type(g)=="string"then return d[g]elseif type(g)=="number"then g=b(g,0xFFFF)return rawget(c,g)end end})return a end)()).weapons
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
