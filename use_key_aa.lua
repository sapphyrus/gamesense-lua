local use_blocked, use_released = false, false
local chokedcommands_prev = 0

client.set_event_callback("setup_command", function(cmd)
	local in_use = cmd.in_use == 1
	local chokedcommands = cmd.chokedcommands

	--if a command is not in_use, save that we released use key
	if not in_use then
		use_released = true
	end

	--check if we should handle in_use (checks if we're fakelagging and if we're in_use or previously blocked a in_use), if not, return
	if not ((in_use or use_blocked) and (chokedcommands > 0 or chokedcommands_prev > 0)) then
		chokedcommands_prev = chokedcommands
		return
	end

	--checks if we're in_use for the first time and havent blocked a in_use yet
	if use_released and not use_blocked then
		use_blocked, use_released = true, false
	end

	--sets in_use to false, then checks if we have a in_use blocked and can send it
	cmd.in_use = 0
	if use_blocked and chokedcommands == 0 then
		cmd.in_use = 1
		use_blocked = false
	end

	--keep track of our previously choked commands to see if we're fakelagging
	chokedcommands_prev = chokedcommands
end)
