local orig_save_reference = ui.reference("MISC", "Other", "Save config")
local export_reference = ui.reference("MISC", "Other", "Export to clipboard")
local reset_reference = ui.reference("MISC", "Other", "Reset config")
local reset_layout_reference = ui.reference("MISC", "Other", "Reset menu layout")
local unload_reference = ui.reference("MISC", "Other", "Unload")
local hitboxes_reference = ui.reference("RAGE", "Aimbot", "Target hitbox")

local client_exec = client.exec
local ui_set = ui.set
local ui_get = ui.get
local ui_set_visible = ui.set_visible
local client_delay_call = client.delay_call

local last_save_click = nil
local headonly_prev = nil

local function save()
	local curtime = globals.curtime()
	ui_set(export_reference, true)
	ui_set_visible(save_reference, false)
	ui_set_visible(save_confirm_reference, true)
	ui_set_visible(save_cancel_reference, true)
	last_save_click = curtime
	client_exec("playvol ui/weapon_cant_buy 1")
	client.delay_call(
		5, 
		function(curtime)
			if last_save_click == curtime then
				client.log("Timed out")
				client_exec("playvol ui/weapon_cant_buy 1")
				last_save_click = nil
				ui_set_visible(save_reference, true)
				ui_set_visible(save_confirm_reference, false)
				ui_set_visible(save_cancel_reference, false)
			end
		end,
		curtime
	)

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

ui.new_button("MISC", "Other", "Save config ", save)
ui.new_button("MISC", "Other", "Save config (Cancel)", save_cancel)
ui.new_button("MISC", "Other", "Save config (Confirm)", save_confirm)

local show_reference = ui.new_checkbox("MISC", "Other", "Show other buttons")

local function on_show_change()
	local value = ui_get(show_reference)
	ui_set_visible(reset_reference, value)
	ui_set_visible(reset_layout_reference, value)
	ui_set_visible(unload_reference, value)
end
on_show_change()

local function on_paint()
	local headonly = ui_get(hitboxes_reference) == {"Head"}
	client.log(headonly)
	headonly_prev = headonly
end
client.set_event_callback("paint", on_paint)

ui.set_callback(show_reference, on_show_change)

save_reference = ui.reference("MISC", "Other", "Save config ")
save_confirm_reference = ui.reference("MISC", "Other", "Save config (Confirm)")
save_cancel_reference = ui.reference("MISC", "Other", "Save config (Cancel)")

ui_set_visible(save_reference, true)
ui_set_visible(save_confirm_reference, false)
ui_set_visible(save_cancel_reference, false)

ui_set_visible(orig_save_reference, false)
