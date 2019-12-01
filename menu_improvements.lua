local function recreate_button(tab, container, name, tab_new, container_new, name_new, callback, callback_pre)
	local reference = ui.reference(tab, container, name)
	ui.set_visible(reference, false)
	local new_reference = ui.new_button(tab_new, container_new, name_new, function()
		if callback_pre ~= nil then
			callback_pre(reference)
		end
		ui.set(reference, true)
		if callback ~= nil then
			callback(reference)
		end
	end)
	return new_reference
end

local function recreate_button_confirm(tab, container, name, tab_new, container_new, name_new, callback, callback_pre)
	local reference = ui.reference(tab, container, name)
	ui.set_visible(reference, false)

	local pending_action, confirm_reference, cancel_reference, new_reference
	cancel_reference = ui.new_button(tab_new, container_new, name_new .. " > Cancel", function()
		ui.set_visible(confirm_reference, false)
		ui.set_visible(cancel_reference, false)
		ui.set_visible(new_reference, true)
	end)
	confirm_reference = ui.new_button(tab_new, container_new, name_new .. " > Confirm", function()
		ui.set_visible(confirm_reference, false)
		ui.set_visible(cancel_reference, false)
		ui.set_visible(new_reference, true)
		if callback_pre ~= nil then
			callback_pre(reference)
		end
		ui.set(reference, true)
		if callback ~= nil then
			callback(reference)
		end
	end)
	new_reference = ui.new_button(tab_new, container_new, name_new, function()
		ui.set_visible(new_reference, false)
		ui.set_visible(confirm_reference, true)
		ui.set_visible(cancel_reference, true)
		pending_action = globals.realtime()
		local current_action = pending_action

		client.delay_call(5, function()
			if current_action == pending_action then
				ui.set_visible(confirm_reference, false)
				ui.set_visible(cancel_reference, false)
				ui.set_visible(new_reference, true)
			end
		end)
	end)
	ui.set_visible(confirm_reference, false)
	ui.set_visible(cancel_reference, false)
end

local function add_run_callback(tab, container, name, callback, ...)
	local args = {...}
	local ref = ui.reference(tab, container, name)

	local function run_callback()
		callback(ref, unpack(args))
	end

	ui.set_callback(ref, run_callback)
	run_callback(ref)
end

recreate_button("CONFIG", "Presets", "Load", "CONFIG", "Presets", "Load")
recreate_button_confirm("CONFIG", "Presets", "Save", "CONFIG", "Presets", "Save")
recreate_button_confirm("CONFIG", "Presets", "Delete", "CONFIG", "Presets", "Delete")
recreate_button("CONFIG", "Presets", "Reset", "CONFIG", "Presets", "Reset")
recreate_button("CONFIG", "Presets", "Import from clipboard", "CONFIG", "Presets", "Import from clipboard")
recreate_button("CONFIG", "Presets", "Export to clipboard", "CONFIG", "Presets", "Export to clipboard")

local reset_menu_layout_reference
local lock_menu_layout_reference = ui.reference("MISC", "Settings", "Lock menu layout")
local lock_reference = ui.new_button("CONFIG", "Presets", "Lock menu layout", function()
	ui.set(lock_menu_layout_reference, true)
end)
local unlock_reference = ui.new_button("CONFIG", "Presets", "Unlock menu layout", function()
	ui.set(lock_menu_layout_reference, false)
end)
local function on_lock_menu_layout_changed()
	local value = ui.get(lock_menu_layout_reference)
	ui.set_visible(unlock_reference, value)
	ui.set_visible(lock_reference, not value)
	ui.set_visible(reset_menu_layout_reference, not value)
end
reset_menu_layout_reference = recreate_button("MISC", "Settings", "Reset menu layout", "CONFIG", "Presets", "Reset menu layout")
ui.set_visible(lock_menu_layout_reference, false)
ui.set_callback(lock_menu_layout_reference, on_lock_menu_layout_changed)
on_lock_menu_layout_changed()
recreate_button_confirm("MISC", "Settings", "Unload", "CONFIG", "Presets", "Unload")

add_run_callback("MISC", "Settings", "Anti-untrusted", function(anti_ut_reference, remove_spread_reference, override_awp_reference, reduce_aim_step_reference)
	local anti_ut = ui.get(anti_ut_reference)

	ui.set_visible(remove_spread_reference, not anti_ut)
	ui.set_visible(override_awp_reference, not anti_ut)
	ui.set_visible(reduce_aim_step_reference, anti_ut)
end, (ui.reference("RAGE", "Other", "Remove spread")), (ui.reference("RAGE", "Aimbot", "Override AWP")), (ui.reference("RAGE", "Aimbot", "Reduce aim step")))
