-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_player_resource, entity_get_prop, ui_reference, ui_set, ui_set_visible = client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_player_resource, entity.get_prop, ui.reference, ui.set, ui.set_visible

local sv_maxunlag_reference = ui_reference("MISC", "Settings", "sv_maxunlag")

local function call_and_return(func, ...)
	func(...)
	return func
end

client_set_event_callback("player_connect_full", call_and_return(function(e)
	if e.force or client_userid_to_entindex(e.userid) == entity_get_local_player() then
		if e.force == nil then
			ui_set(sv_maxunlag_reference, 200)
		end

		local visible = true
		if entity_get_prop(entity_get_player_resource(), "m_bIsValveDS") == 1 then
			visible = false
		end
		ui_set_visible(sv_maxunlag_reference, visible)
	end
end, {force=true}))
