local ui_get, sdr = ui.get, cvar.sdr

--http://steamcdn-a.akamaihd.net/apps/sdr/network_config.json
local datacenters = {
	["ams"] = "Amsterdam, Netherlands",
	["atl"] = "Atlanta, USA",
	["bom"] = "Bombay, India",
	["dxb"] = "Dubai, United Arab Emirates",
	["eat"] = "Moses Lake (old), USA",
	["fra"] = "Frankfurt, Germany",
	["ggru"] = "Google Cloud sa-east1, Brazil",
	["ghel"] = "Google Cloud eu-north1, Finland",
	["gru"] = "Sao Paulo, Brazil",
	["hkg"] = "Hong Kong, PRC",
	["iad"] = "Sterling, USA",
	["jnb"] = "Johannesburg, RSA",
	["lax"] = "Los Angeles, USA",
	["lhr"] = "London, United Kingdom",
	["lim"] = "Lima, Peru",
	["lux"] = "Luxembourg, Luxembourg",
	["maa"] = "Chennai, India",
	["mad"] = "Madrid, Spain",
	["man"] = "Manilla, Philippines",
	["mwh"] = "Moses Lake, USA",
	["okc"] = "Oklahoma City, USA",
	["ord"] = "Chicago, USA",
	["par"] = "Paris, France",
	["scl"] = "Santiago, Chile",
	["sea"] = "Seattle, USA",
	["sgp"] = "Singapore, Singapore",
	["sto"] = "Stockholm (Kista), Sweden",
	["sto2"] = "Stockholm (Bromma), Sweden",
	["syd"] = "Sydney, Australia",
	["tyo"] = "Tokyo, Japan",
	["tyo1"] = "Tokyo (TY2), Japan",
	["vie"] = "Vienna, Austria",
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

--set a ui callback that gets executed when the menu element is changed
local function on_datacenter_changed()
	--look up the datacenter ID and fall back to "" if not found (Off)
	local datacenter_id = datacenters_name_to_id[ui_get(datacenter_reference)] or "\0"

	--invoke the callback of the "sdr" command (which also has some nice other options) with "ClientForceRelayCluster <datacenter_id>"
	sdr:invoke_callback("ClientForceRelayCluster", datacenter_id)
end
ui.set_callback(datacenter_reference, on_datacenter_changed)
on_datacenter_changed()
