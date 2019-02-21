--calls a function with console output disabled. handles errors properly
local cvar_con_filter_enable, cvar_con_filter_text = cvar.con_filter_enable, cvar.con_filter_text
local function disable_console_output(block, ...)
	--backup their values, then set console filter cvars
	local con_filter_enable_prev, con_filter_text_prev = cvar_con_filter_enable:get_int(), cvar_con_filter_text:get_string()
	cvar_con_filter_enable:set_raw_int(1)
	cvar_con_filter_text:set_string("___")

	--call the passed function with args protectedly
	xpcall(block, client.error_log, ...)

	--set back to backed up values
	cvar_con_filter_enable:set_raw_int(con_filter_enable_prev)
	cvar_con_filter_text:set_string(con_filter_text_prev)
end
