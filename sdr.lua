local ui_get, sdr, globals_mapname = ui.get, cvar.sdr, globals.mapname

local datacenters = {
	["atl"] = "Atlanta, USA",
	["bom"] = "Bombay, India",
	["dxb"] = "Dubai, United Arab Emirates",
	["eat"] = "Moses Lake, USA",
	["gnrt"] = "Shibuya, Japan",
	["gru"] = "Sao Paulo, Brazil",
	["gtpe"] = "Google asia-east1",
	["hkg"] = "Hong Kong, China",
	["iad"] = "Sterling, USA",
	["jnb"] = "Saldanha Bay Local Municipality, RSA",
	["lax"] = "Los Angeles, USA",
	["lim"] = "Brena, Peru",
	["lux"] = "Luxembourg, Germany",
	["maa"] = "Chennai, India",
	["mad"] = "Madrid, Spain",
	["ord"] = "Chicago, USA",
	["scl"] = "Lo Barnechea, Chile",
	["sgp"] = "Singapore, Singapore",
	["shb"] = "Pudong, China",
	["sto"] = "Stockholm (Kista), Sweden",
	["syd"] = "Sydney, Australia",
	["tyo"] = "Shibuya, Japan",
	["vie"] = "Kaltenleutgeben, Austria",
	["waw"] = "Warsaw, Poland",
}

--generate 2 tables from this, one array with all datacenter names and a lookup table of datacenter name -> datacenter ID
local datacenters_names, datacenters_name_to_id = {}, {}
for id, name in pairs(datacenters) do
	table.insert(datacenters_names, name)
	datacenters_name_to_id[name] = id
end

--alphabetically sort the datacenter names
table.sort(datacenters_names)

--create a new combobox with a "Off" element and the datacenter names table
local datacenter_reference = ui.new_combobox("MISC", "Miscellaneous", "Force relay cluster", "Off", unpack(datacenters_names))
local task_running = false

local function apply_datacenter()
	local datacenter = globals_mapname() == nil and ui_get(datacenter_reference) or "Off"
	local datacenter_id = datacenters_name_to_id[datacenter] or "\0"

	-- basically the same as executing "sdr SDRClient_ForceRelayCluster " .. datacenter_id in console
	sdr:invoke_callback("SDRClient_ForceRelayCluster", datacenter_id)

	--client.log("Applied ", datacenter_id == "\0" and "none" or datacenter_id)
end

local function task()
	apply_datacenter()

	if ui_get(datacenter_reference) ~= "Off" then
		client.delay_call(1, task)
	else
		task_running = false
	end
end

--set a ui callback that gets executed when the menu element is changed
local function on_datacenter_changed()
	apply_datacenter()
	local enabled = ui_get(datacenter_reference) ~= "Off"

	if not task_running and enabled then
		client.delay_call(1, task)
		task_running = true
	end
end
ui.set_callback(datacenter_reference, on_datacenter_changed)
on_datacenter_changed()
