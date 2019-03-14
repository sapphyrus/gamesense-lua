local math_ceil, math_floor = math.ceil, math.floor
local table_insert, table_remove, table_concat, string_len = table.insert, table.remove, table.concat, string.len
local client_log, client_color_log = client.log, client.color_log

local to_dump = {
	"client",
	"entity",
	"globals",
	"ui",
	"renderer",
	"math",
	"table",
	"string",
	"materialsystem"
}

local to_dump_global = {
	"tonumber",
	"tostring",
	"assert",
	"error",
	"pairs",
	"ipairs",
	"next",
	"setmetatable",
	"getmetatable",
	"pcall",
	"type",
	"unpack",
}

local ignore = {
	["string"] = {
		"rep",
		"dump",
		"byte",
		"char",
	},
	["table"] = {
		"maxn",
		"foreach",
		"foreachi",
		"move",
		"getn",
		"pack",
		"unpack"
	},
	["math"] = {
		"log10",
		"randomseed",
		"random",
		"huge",
		"ldexp",
		"frexp",
		"tanh",
		"modf"
	},
}

local ignore_draw = true
local optimize_lookups = false
local split_tables = true
local split_message_length = false

local function table_contains(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end

local function array_split(table, n, start)
	local new_table = {}
	local start = start or 1
	for i=start, n do
		local element = table[i]
		if element ~= nil then
			table_insert(new_table, element)
		end
	end
	return new_table
end

local function array_sub(t1, t2)
  local t = {}
  for i = 1, #t1 do
    t[t1[i]] = true
  end
  for i = #t2, 1, -1 do
    if t[t2[i]] then
      table_remove(t2, i)
    end
  end
end

local function create_local_variables(tbl, name, ignored)
	local part1 = {}
	local part2 = {}

	for key, name_tmp in pairs(tbl) do
		local name = name
		if type(name_tmp) == "string" then
			name = name_tmp
		end
		if not table_contains(ignored, key) and type(key) == "string" then
			if name then
				table_insert(part1, name .. "_" .. key)
				table_insert(part2, name .. "." .. key)
			else
				table_insert(part1, key)
				table_insert(part2, key)
			end
		end
	end

	local message = "local " .. table_concat(part1, ", ") .. " = " .. table_concat(part2, ", ")
	if split_message_length then
		local messages = {}

		local parts = 1
		if message:len() > 400 then
			parts = math_ceil(message:len() / 400)
		end

		local split_at = math_floor(#part1/parts)
		local start = 0

		for i=1, parts do
			local split_at_temp = split_at * i + 2
			local part1_1, part2_1 = array_split(part1, split_at_temp, start+1), array_split(part2, split_at_temp, start+1)
			table_insert(messages, "local " .. table_concat(part1_1, ", ") .. " = " .. table_concat(part2_1, ", "))
			start = split_at_temp
		end
		for i=1, #messages do
			client_color_log(150, 150, 150, messages[i])
		end
	else
		client_color_log(150, 150, 150, message)
	end
end

local function dump_api()
	client_log("Copy and paste this into your script:")
	client_color_log(182, 231, 23, "--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua")

	local tbl = {}

	if split_tables then
		for i=1, #to_dump do
			local name = to_dump[i]
			local tbl = _G[name]
			local ignored = ignore[name] or {}
			if ignore_draw and name == "client" then
				for key, _ in pairs(renderer) do
					table_insert(ignored, key)
					table_insert(ignored, "draw_" .. key)
				end
			end
			create_local_variables(tbl, name, ignored)
		end
	else
		for i=1, #to_dump do
			local name = to_dump[i]
			local tbl = _G[name]
			local ignored = ignore[name] or {}
			if ignore_draw and name == "client" then
				for key, _ in pairs(renderer) do
					table_insert(ignored, key)
					table_insert(ignored, "draw_" .. key)
				end
			end
		end
	end

	for i=1, #to_dump_global do
		tbl[to_dump_global[i]] = false
	end
	create_local_variables(tbl, nil, {})

	client_color_log(182, 231, 23, "--end of local variables")
end

local function dump_globals_recursive(tbl, ignored, inspect)
	local result = {fields={}}
	for key, value in pairs(tbl) do
		if type(key) ~= "number" then
			if type(value) == "function" or type(value) == "number" or type(value) == "string" then
				result.fields[key] = {}
			elseif type(value) == "table" and value ~= tbl and key ~= "_G" then
				if (key == "loaded" or key == "preload") and tbl == package then
					result.fields[key] = {other_fields = true}
				else
					result.fields[key] = dump_globals_recursive(value)
				end
			end
		end
	end

	if next(result.fields) == nil then
		result = {other_fields = true}
	end

	return result
end

local function dump_globals()
	local inspect = require "inspect"
	local result = dump_globals_recursive(_G, {}, inspect)["fields"]

	client.log("std = ", inspect({
		read_globals = result
	}))
end

ui.new_button("MISC", "Lua", "Generate API local variables", dump_api)
ui.new_button("MISC", "Lua", "Generate .luacheckrc", dump_globals)
