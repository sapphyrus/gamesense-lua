local customplayers = {
	{"Local T Agent", "models/player/custom_player/legacy/tm_phoenix.mdl", true},
	{"Local CT Agent", "models/player/custom_player/legacy/ctm_sas.mdl", false},
	{"Blackwolf | Sabre", "models/player/custom_player/legacy/tm_balkan_variantj.mdl", true},
	{"Rezan The Ready | Sabre", "models/player/custom_player/legacy/tm_balkan_variantg.mdl", true},
	{"Maximus | Sabre", "models/player/custom_player/legacy/tm_balkan_varianti.mdl", true},
	{"Dragomir | Sabre", "models/player/custom_player/legacy/tm_balkan_variantf.mdl", true},
	{"Lt. Commander Ricksaw | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_varianti.mdl", false},
	{"'Two Times' McCoy | USAF TACP", "models/player/custom_player/legacy/ctm_st6_variantm.mdl", false},
	{"Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantg.mdl", false},
	{"Seal Team 6 Soldier | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variante.mdl", false},
	{"3rd Commando Company | KSK", "models/player/custom_player/legacy/ctm_st6_variantk.mdl", false},
	{"'The Doctor' Romanov | Sabre", "models/player/custom_player/legacy/tm_balkan_varianth.mdl", true},
	{"Michael Syfers  | FBI Sniper", "models/player/custom_player/legacy/ctm_fbi_varianth.mdl", false},
	{"Markus Delrow | FBI HRT", "models/player/custom_player/legacy/ctm_fbi_variantg.mdl", false},
	{"Operator | FBI SWAT", "models/player/custom_player/legacy/ctm_fbi_variantf.mdl", false},
	{"Slingshot | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantg.mdl", true},
	{"Enforcer | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantf.mdl", true},
	{"Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianth.mdl", true},
	{"The Elite Mr. Muhlik | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantf.mdl", true},
	{"Prof. Shahmat | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianti.mdl", true},
	{"Osiris | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianth.mdl", true},
	{"Ground Rebel  | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantg.mdl", true},
	{"Special Agent Ava | FBI", "models/player/custom_player/legacy/ctm_fbi_variantb.mdl", false},
	{"B Squadron Officer | SAS", "models/player/custom_player/legacy/ctm_sas_variantf.mdl", false},
	{"Anarchist", "models/player/custom_player/legacy/tm_anarchist.mdl", true},
	{"Anarchist (Variant A)", "models/player/custom_player/legacy/tm_anarchist_varianta.mdl", true},
	{"Anarchist (Variant B)", "models/player/custom_player/legacy/tm_anarchist_variantb.mdl", true},
	{"Anarchist (Variant C)", "models/player/custom_player/legacy/tm_anarchist_variantc.mdl", true},
	{"Anarchist (Variant D)", "models/player/custom_player/legacy/tm_anarchist_variantd.mdl", true},
	{"Pirate", "models/player/custom_player/legacy/tm_pirate.mdl", true},
	{"Pirate (Variant A)", "models/player/custom_player/legacy/tm_pirate_varianta.mdl", true},
	{"Pirate (Variant B)", "models/player/custom_player/legacy/tm_pirate_variantb.mdl", true},
	{"Pirate (Variant C)", "models/player/custom_player/legacy/tm_pirate_variantc.mdl", true},
	{"Pirate (Variant D)", "models/player/custom_player/legacy/tm_pirate_variantd.mdl", true},
	{"Professional", "models/player/custom_player/legacy/tm_professional.mdl", true},
	{"Professional (Variant 1)", "models/player/custom_player/legacy/tm_professional_var1.mdl", true},
	{"Professional (Variant 2)", "models/player/custom_player/legacy/tm_professional_var2.mdl", true},
	{"Professional (Variant 3)", "models/player/custom_player/legacy/tm_professional_var3.mdl", true},
	{"Professional (Variant 4)", "models/player/custom_player/legacy/tm_professional_var4.mdl", true},
	{"Separatist", "models/player/custom_player/legacy/tm_separatist.mdl", true},
	{"Separatist (Variant A)", "models/player/custom_player/legacy/tm_separatist_varianta.mdl", true},
	{"Separatist (Variant B)", "models/player/custom_player/legacy/tm_separatist_variantb.mdl", true},
	{"Separatist (Variant C)", "models/player/custom_player/legacy/tm_separatist_variantc.mdl", true},
	{"Separatist (Variant D)", "models/player/custom_player/legacy/tm_separatist_variantd.mdl", true},
	{"GIGN", "models/player/custom_player/legacy/ctm_gign.mdl", false},
	{"GIGN (Variant A)", "models/player/custom_player/legacy/ctm_gign_varianta.mdl", false},
	{"GIGN (Variant B)", "models/player/custom_player/legacy/ctm_gign_variantb.mdl", false},
	{"GIGN (Variant C)", "models/player/custom_player/legacy/ctm_gign_variantc.mdl", false},
	{"GIGN (Variant D)", "models/player/custom_player/legacy/ctm_gign_variantd.mdl", false},
	{"GSG-9", "models/player/custom_player/legacy/ctm_gsg9.mdl", false},
	{"GSG-9 (Variant A)", "models/player/custom_player/legacy/ctm_gsg9_varianta.mdl", false},
	{"GSG-9 (Variant B)", "models/player/custom_player/legacy/ctm_gsg9_variantb.mdl", false},
	{"GSG-9 (Variant C)", "models/player/custom_player/legacy/ctm_gsg9_variantc.mdl", false},
	{"GSG-9 (Variant D)", "models/player/custom_player/legacy/ctm_gsg9_variantd.mdl", false},
	{"IDF", "models/player/custom_player/legacy/ctm_idf.mdl", false},
	{"IDF (Variant B)", "models/player/custom_player/legacy/ctm_idf_variantb.mdl", false},
	{"IDF (Variant C)", "models/player/custom_player/legacy/ctm_idf_variantc.mdl", false},
	{"IDF (Variant D)", "models/player/custom_player/legacy/ctm_idf_variantd.mdl", false},
	{"IDF (Variant E)", "models/player/custom_player/legacy/ctm_idf_variante.mdl", false},
	{"IDF (Variant F)", "models/player/custom_player/legacy/ctm_idf_variantf.mdl", false},
	{"SWAT", "models/player/custom_player/legacy/ctm_swat.mdl", false},
	{"SWAT (Variant A)", "models/player/custom_player/legacy/ctm_swat_varianta.mdl", false},
	{"SWAT (Variant B)", "models/player/custom_player/legacy/ctm_swat_variantb.mdl", false},
	{"SWAT (Variant C)", "models/player/custom_player/legacy/ctm_swat_variantc.mdl", false},
	{"SWAT (Variant D)", "models/player/custom_player/legacy/ctm_swat_variantd.mdl", false},
	{"SAS (Variant A)", "models/player/custom_player/legacy/ctm_sas_varianta.mdl", false},
	{"SAS (Variant B)", "models/player/custom_player/legacy/ctm_sas_variantb.mdl", false},
	{"SAS (Variant C)", "models/player/custom_player/legacy/ctm_sas_variantc.mdl", false},
	{"SAS (Variant D)", "models/player/custom_player/legacy/ctm_sas_variantd.mdl", false},
	{"ST6", "models/player/custom_player/legacy/ctm_st6.mdl", false},
	{"ST6 (Variant A)", "models/player/custom_player/legacy/ctm_st6_varianta.mdl", false},
	{"ST6 (Variant B)", "models/player/custom_player/legacy/ctm_st6_variantb.mdl", false},
	{"ST6 (Variant C)", "models/player/custom_player/legacy/ctm_st6_variantc.mdl", false},
	{"ST6 (Variant D)", "models/player/custom_player/legacy/ctm_st6_variantd.mdl", false},
	{"Balkan (Variant E)", "models/player/custom_player/legacy/tm_balkan_variante.mdl", true},
	{"Balkan (Variant A)", "models/player/custom_player/legacy/tm_balkan_varianta.mdl", true},
	{"Balkan (Variant B)", "models/player/custom_player/legacy/tm_balkan_variantb.mdl", true},
	{"Balkan (Variant C)", "models/player/custom_player/legacy/tm_balkan_variantc.mdl", true},
	{"Balkan (Variant D)", "models/player/custom_player/legacy/tm_balkan_variantd.mdl", true},
	{"Jumpsuit (Variant A)", "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl", true},
	{"Jumpsuit (Variant B)", "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl", true},
	{"Jumpsuit (Variant C)", "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl", true},
	{"Phoenix Heavy", "models/player/custom_player/legacy/tm_phoenix_heavy.mdl", true},
	{"Heavy", "models/player/custom_player/legacy/ctm_heavy.mdl", false},
	{"Leet (Variant A)", "models/player/custom_player/legacy/tm_leet_varianta.mdl", true},
	{"Leet (Variant B)", "models/player/custom_player/legacy/tm_leet_variantb.mdl", true},
	{"Leet (Variant C)", "models/player/custom_player/legacy/tm_leet_variantc.mdl", true},
	{"Leet (Variant D)", "models/player/custom_player/legacy/tm_leet_variantd.mdl", true},
	{"Leet (Variant E)", "models/player/custom_player/legacy/tm_leet_variante.mdl", true},
	{"Phoenix", "models/player/custom_player/legacy/tm_phoenix.mdl", true},
	{"Phoenix (Variant A)", "models/player/custom_player/legacy/tm_phoenix_varianta.mdl", true},
	{"Phoenix (Variant B)", "models/player/custom_player/legacy/tm_phoenix_variantb.mdl", true},
	{"Phoenix (Variant C)", "models/player/custom_player/legacy/tm_phoenix_variantc.mdl", true},
	{"Phoenix (Variant D)", "models/player/custom_player/legacy/tm_phoenix_variantd.mdl", true},
	{"FBI", "models/player/custom_player/legacy/ctm_fbi.mdl", false},
	{"FBI (Variant A)", "models/player/custom_player/legacy/ctm_fbi_varianta.mdl", false},
	{"FBI (Variant C)", "models/player/custom_player/legacy/ctm_fbi_variantc.mdl", false},
	{"FBI (Variant D)", "models/player/custom_player/legacy/ctm_fbi_variantd.mdl", false},
	{"FBI (Variant E)", "models/player/custom_player/legacy/ctm_fbi_variante.mdl", false},
	{"SAS", "models/player/custom_player/legacy/ctm_sas.mdl", false}
}

local ffi = require "ffi"
ffi.cdef [[
typedef struct {
  float x;
  float y;
  float z;
}vec3_t;

typedef struct
{
  void*   fnHandle;               //0x0000
  char    szName[260];            //0x0004
  int     nLoadFlags;             //0x0108
  int     nServerCount;           //0x010C
  int     type;                   //0x0110
  int     flags;                  //0x0114
  vec3_t  vecMins;                //0x0118
  vec3_t  vecMaxs;                //0x0124
  float   radius;                 //0x0130
  char    pad[0x1C];              //0x0134
}model_t;//Size=0x0150

typedef int(__thiscall* get_model_index_t)(void*, const char*);
typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
typedef void*(__thiscall* find_table_t)(void*, const char*);
typedef void(__thiscall* set_model_index_t)(void*, int);
typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
]]

local class_ptr = ffi.typeof("void***")
local void_ptr = ffi.typeof("void*")

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)
local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineServerStringTable001") or error("VEngineServerStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)

local function precache_model(modelname)
	local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
	if rawprecache_table then
		local precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
		if precache_table then
			local add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)
			local emtpy_void_ptr = ffi.cast(void_ptr, 0)

			find_or_load_model(ivmodelinfo, modelname)
			local idx = add_string(precache_table, false, modelname, -1, emtpy_void_ptr)
			if idx == -1 then
			  return false
			end
		end
	end
	return true
end

local override_knife_reference = ui.reference("SKINS", "Knife options", "Override knife")
local teams = {
	{"Counter-Terrorist", false},
	{"Terrorist", true}
}
local team_references, team_model_paths = {}, {}
local model_index_prev

for i=1, #teams do
	local teamname, is_t = unpack(teams[i])

	team_model_paths[is_t] = {}
	local model_names = {}
	local l_i = 0
	for i=1, #customplayers do
		local model_name, model_path, model_is_t = unpack(customplayers[i])

		if model_is_t == nil or model_is_t == is_t then
			table.insert(model_names, model_name)
			l_i = l_i + 1
			team_model_paths[is_t][l_i] = model_path
		end
	end

	team_references[is_t] = {
		enabled_reference = ui.new_checkbox("SKINS", "Knife options", "Override player model\n" .. teamname),
		model_reference = ui.new_listbox("SKINS", "Knife options", "Selected player model\n" .. teamname, "-", unpack(model_names))
	}
	for key, value in pairs(team_references[is_t]) do
		ui.set_visible(value, false)
	end
end

client.set_event_callback("net_update_end", function()
	local local_player = entity.get_local_player()

	if local_player == nil then
		return
	end

	local model_path, model_index
	local teamnum = entity.get_prop(local_player, "m_iTeamNum")
	local is_t
	if teamnum == 2 then
		is_t = true
	elseif teamnum == 3 then
		is_t = false
	end

	for references_is_t, references in pairs(team_references) do
		ui.set_visible(references.enabled_reference, references_is_t == is_t)

		if references_is_t == is_t and ui.get(references.enabled_reference) then
			ui.set_visible(references.model_reference, true)
			model_path = team_model_paths[is_t][ui.get(references.model_reference)]
		else
			ui.set_visible(references.model_reference, false)
		end
	end

	if entity.is_alive(local_player) then
		local model_index

		if model_path ~= nil then
			model_index = get_model_index(ivmodelinfo, model_path)

			if model_index == -1 then
				model_index = nil
			end
		end

		if model_index ~= model_index_prev then
			local override_knife = ui.get(override_knife_reference)

			ui.set(override_knife_reference, not override_knife)
			ui.set(override_knife_reference, override_knife)
		end
		model_index_prev = model_index

		if model_index ~= nil then
			entity.set_prop(local_player, "m_nModelIndex", model_index)
		end
	end
end)
