-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_latency, client_screen_size, client_set_event_callback, client_system_time, entity_get_local_player, entity_get_player_resource, entity_get_prop, globals_absoluteframetime, globals_tickinterval, math_ceil, math_floor, math_min, math_sqrt, renderer_measure_text, ui_reference, pcall, renderer_gradient, renderer_rectangle, renderer_text, string_format, table_insert, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_multiselect, ui_new_textbox, ui_set, ui_set_callback, ui_set_visible = client.latency, client.screen_size, client.set_event_callback, client.system_time, entity.get_local_player, entity.get_player_resource, entity.get_prop, globals.absoluteframetime, globals.tickinterval, math.ceil, math.floor, math.min, math.sqrt, renderer.measure_text, ui.reference, pcall, renderer.gradient, renderer.rectangle, renderer.text, string.format, table.insert, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_multiselect, ui.new_textbox, ui.set, ui.set_callback, ui.set_visible

local flag, old_renderer_text, old_renderer_measure_text = "d", renderer_text, renderer_measure_text
function renderer_text(x, y, r, g, b, a, flags, max_width, ...)
	return old_renderer_text(x, y, r, g, b, a, flags == nil and flag or flag .. flags, max_width, ...)
end
function renderer_measure_text(flags, ...)
	return old_renderer_measure_text(flags == nil and flag or flag .. flags, ...)
end

local allow_unsafe_scripts = pcall(client.create_interface)

local FLOW_OUTGOING, FLOW_INCOMING = 0, 1
local native_GetNetChannelInfo, GetRemoteFramerate, native_GetTimeSinceLastReceived, native_GetAvgChoke, native_GetAvgLoss, native_IsLoopback, GetAddress

if allow_unsafe_scripts then
	local ffi = require "ffi"

	local function vmt_entry(instance, index, type)
		return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
	end

	local function vmt_thunk(index, typestring)
		local t = ffi.typeof(typestring)
		return function(instance, ...)
			assert(instance ~= nil)
			if instance then
				return vmt_entry(instance, index, t)(instance, ...)
			end
		end
	end

	local function vmt_bind(module, interface, index, typestring)
		local instance = client.create_interface(module, interface) or error("invalid interface")
		local fnptr = vmt_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
		return function(...)
			return fnptr(instance, ...)
		end
	end

	native_GetNetChannelInfo = vmt_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
	local native_GetName = vmt_thunk(0, "const char*(__thiscall*)(void*)")
	local native_GetAddress = vmt_thunk(1, "const char*(__thiscall*)(void*)")
	native_IsLoopback = vmt_thunk(6, "bool(__thiscall*)(void*)")
	local native_IsTimingOut = vmt_thunk(7, "bool(__thiscall*)(void*)")
	native_GetAvgLoss = vmt_thunk(11, "float(__thiscall*)(void*, int)")
	native_GetAvgChoke = vmt_thunk(12, "float(__thiscall*)(void*, int)")
	native_GetTimeSinceLastReceived = vmt_thunk(22, "float(__thiscall*)(void*)")
	local native_GetRemoteFramerate = vmt_thunk(25, "void(__thiscall*)(void*, float*, float*, float*)")
	local native_GetTimeoutSeconds = vmt_thunk(26, "float(__thiscall*)(void*)")

	local pflFrameTime = ffi.new("float[1]")
	local pflFrameTimeStdDeviation = ffi.new("float[1]")
	local pflFrameStartTimeStdDeviation = ffi.new("float[1]")

	function GetRemoteFramerate(netchannelinfo)
		native_GetRemoteFramerate(netchannelinfo, pflFrameTime, pflFrameTimeStdDeviation, pflFrameStartTimeStdDeviation)
		if pflFrameTime ~= nil and pflFrameTimeStdDeviation ~= nil and pflFrameStartTimeStdDeviation ~= nil then
			return pflFrameTime[0], pflFrameTimeStdDeviation[0], pflFrameStartTimeStdDeviation[0]
		end
	end

	function GetAddress(netchannelinfo)
		local addr = native_GetAddress(netchannelinfo)
		if addr ~= nil then
			return ffi.string(addr)
		end
	end

	local function GetName(netchannelinfo)
		local name = native_GetName(netchannelinfo)
		if name ~= nil then
			return ffi.string(name)
		end
	end
end

local cvar_game_mode, cvar_game_type, cvar_fps_max, cvar_fps_max_menu = cvar.game_mode, cvar.game_type, cvar.fps_max, cvar.fps_max_menu
local table_clear = require "table.clear"

-- initialize window
local window = ((function() local a={}local b,c,d,e,f=renderer.rectangle,renderer.gradient,renderer.texture,math.floor,math.ceil;local function g(h,i,j,k,l,m,n,o,p)p=p or 1;b(h,i,j,p,l,m,n,o)b(h,i+k-p,j,p,l,m,n,o)b(h,i+p,p,k-p*2,l,m,n,o)b(h+j-p,i+p,p,k-p*2,l,m,n,o)end;local function q(h,i,j,k,r,s,t,u,v,w,x,y,z,p)p=p or 1;if z then b(h,i,p,k,r,s,t,u)b(h+j-p,i,p,k,v,w,x,y)c(h+p,i,j-p*2,p,r,s,t,u,v,w,x,u,true)c(h+p,i+k-p,j-p*2,p,r,s,t,u,v,w,x,u,true)else b(h,i,j,p,r,s,t,u)b(h,i+k-p,j,p,v,w,x,y)c(h,i+p,p,k-p*2,r,s,t,u,v,w,x,y,false)c(h+j-p,i+p,p,k-p*2,r,s,t,u,v,w,x,y,false)end end;local A;do local B="\x14\x14\x14\xFF"local C="\x0c\x0c\x0c\xFF"A=renderer.load_rgba(table.concat({B,B,B,C,B,C,B,C,B,C,B,B,B,C,B,C}),4,4)end;local function D(E,F)if F~=nil and type(E)=="string"and E:sub(-1,-1)=="%"then E=math.floor(tonumber(E:sub(1,-2))/100*F)end;return E end;local function G(H)if H.position=="fixed"then local I,J=client.screen_size()if H.left~=nil then H.x=D(H.left,I)elseif H.right~=nil then H.x=I-(H.w or 0)-D(H.right,I)end;if H.top~=nil then H.y=D(H.top,J)elseif H.bottom~=nil then H.y=J-(H.h or 0)-D(H.bottom,J)end end;local h,i,j,k,o=H.x,H.y,H.w,H.h,H.a or 255;local K=1;if h==nil or i==nil or j==nil or o==nil then return end;H.i_x,H.i_y,H.i_w,H.i_h=H.x,H.y,H.w,H.h;if H.title_bar then K=(H.title~=nil and select(2,renderer.measure_text(H.title_text_size,H.title))or 13)+2;H.t_x,H.t_y,H.t_w,H.t_h=H.x,H.y,H.w,K end;if H.border then g(h,i,j,k,18,18,18,o)g(h+1,i+1,j-2,k-2,62,62,62,o)g(h+2,i+K+1,j-4,k-K-3,44,44,44,o,H.border_width)g(h+H.border_width+2,i+K+H.border_width+1,j-H.border_width*2-4,k-K-H.border_width*2-3,62,62,62,o)H.i_x=H.i_x+H.border_width+3;H.i_y=H.i_y+H.border_width+3;H.i_w=H.i_w-(H.border_width+3)*2;H.i_h=H.i_h-(H.border_width+3)*2;H.t_x,H.t_y,H.t_w=H.x+2,H.y+2,H.w-4;K=K-1 end;if K>1 then c(H.t_x,H.t_y,H.t_w,K,56,56,56,o,44,44,44,o,false)if H.title~=nil then local l,m,n,o=unpack(H.title_text_color)o=o*H.a/255;renderer.text(H.t_x+3,H.t_y+2,l or 255,m or 255,n or 255,o or 255,(H.title_text_size or"")..(H.title_text_flags or""),0,tostring(H.title))end;H.i_y=H.i_y+K;H.i_h=H.i_h-K end;if H.gradient_bar then local L=0;if H.background then L=1;local M,N=16,25;b(H.i_x+1,H.i_y,H.i_w-2,1,M,M,M,o)b(H.i_x+1,H.i_y+3,H.i_w-2,1,N,N,N,o)for O=0,1 do c(H.i_x+(H.i_w-1)*O,H.i_y,1,4,M,M,M,o,N,N,N,o,false)end end;do local h,i,P=H.i_x+L,H.i_y+L,1;local Q,R=e((H.i_w-L*2)/2),f((H.i_w-L*2)/2)for O=1,2 do c(h,i,Q,1,59*P,175*P,222*P,o,202*P,70*P,205*P,o,true)c(h+Q,i,R,1,202*P,70*P,205*P,o,201*P,227*P,58*P,o,true)i,P=i+1,P*0.5 end end;H.i_y=H.i_y+2+L*2;H.i_h=H.i_h-2-L*2 end;if H.background then d(A,H.i_x,H.i_y,H.i_w,H.i_h,255,255,255,255,"t")end;if H.draggable then local p=7;renderer.triangle(h+j-1,i+k-p,h+j-1,i+k-1,h+j-p,i+k-1,62,62,62,o)end;H.i_x=H.i_x+H.margin_left;H.i_w=H.i_w-H.margin_left-H.margin_right;H.i_y=H.i_y+H.margin_top;H.i_h=H.i_h-H.margin_top-H.margin_bottom end;local S={}local T={}local U={}local V={__index=U}function U:set_active(W)if W then S[self.id]=self;table.insert(T,1,self.id)else S[self.id]=nil end end;function U:set_z_index(X)self.z_index=X;self.z_index_reset=true end;function U:is_in_window(h,i)return h>=self.x and h<=self.x+self.w and i>=self.y and i<=self.y+self.h end;function U:set_inner_width(Y)if self.border then Y=Y+(self.border_width+3)*2 end;Y=Y+self.margin_left+self.margin_right;self.w=Y end;function U:set_inner_height(Z)local K=1;if self.title_bar then K=(self.title~=nil and select(2,renderer.measure_text(self.title_text_size,self.title))or 13)+2 end;if self.border then Z=Z+(self.border_width+3)*2;K=K-1 end;if K>1 then Z=Z+K end;if self.gradient_bar then local L=0;if self.background then L=1 end;Z=Z+2+L*2 end;Z=Z+self.margin_top+self.margin_bottom;self.h=Z end;function a.new(_,h,i,j,k,a0)local H=setmetatable({id=_,top=h,left=i,w=j,h=k,a=255,paint_callback=a0,title_bar=true,title_bar_in_menu=false,title_text_color={255,255,255,255},title_text_size=nil,gradient_bar=true,border=true,border_width=3,background=true,first=true,visible=true,margin_top=0,margin_bottom=0,margin_left=0,margin_right=0,position="fixed",draggable=false,draggable_save=false,in_menu=false},V)H:set_active(true)return H end;local a1,a2,a3;local function a4(a5)local a6={"bottom","unset","top"}local a7={}for O=#T,1,-1 do local H=S[T[O]]if H~=nil then local a8=H.z_index or"unset"if H.z_index_reset then H.z_index=nil;H.z_index_reset=nil end;a7[a8]=a7[a8]or{}if H.first then table.insert(a7[a8],1,H.id)H.first=nil else table.insert(a7[a8],H.id)end end end;T={}for O=1,#a6 do local a9=a7[a6[O]]if a9~=nil then for O=#a9,1,-1 do table.insert(T,a9[O])end end end;local aa=ui.is_menu_open()local ab={}for O=1,#T do local H=S[T[O]]if H~=nil and H.in_menu==a5 then if H.title_bar_in_menu then H.title_bar=aa end;if H.pre_paint_callback~=nil then H:pre_paint_callback()end;if S[H.id]~=nil then table.insert(ab,S[H.id])end end end;if aa then local ac,ad=ui.mouse_position()local ae=client.key_state(0x01)if ae then for O=#ab,1,-1 do local H=ab[O]if H.visible and H:is_in_window(a1,a2)then H.first=true;if a3 then local af,ag=ac-a1,ad-a2;if H.position=="fixed"then local ah=H.left==nil and"right"or"left"local ai=H.top==nil and"bottom"or"top"local aj={{ah,(ah=="right"and-1 or 1)*af},{ai,(ai=="bottom"and-1 or 1)*ag}}for O=1,#aj do local ak,al=unpack(aj[O])local am=type(H[ak])if am=="string"and H[ak]:sub(-1,-1)=="%"then elseif am=="number"then H[ak]=H[ak]+al end end else H.x=H.x+af;H.y=H.y+ag end end;break end end end;a1,a2=ac,ad;a3=ae end;for O=1,#ab do local H=ab[O]if H.visible and H.in_menu==a5 then G(H)if H.paint_callback~=nil then H:paint_callback()end end end end;local a1,a2,a3;client.delay_call(0,client.set_event_callback,"paint",function()a4(false)end)client.delay_call(0,client.set_event_callback,"paint_ui",function()a4(true)end)return a end)()).new("watermark")
window.title = "Watermark"
window.title_bar = false
window.margin_bottom = 2
window.margin_left = 3
window.margin_right = 3
window.border_width = 2
window.top = 15
window.right = 15
window.in_menu = true

-- custom name
local db = database.read("sapphyrus_watermark") or {}

--local pingspike_reference = ui_reference("MISC", "Miscellaneous", "Ping spike")
local antiut_reference = ui_reference("MISC", "Settings", "Anti-untrusted")
local is_beta = pcall(ui_reference, "MISC", "Settings", "Crash logs")

local names = {"Logo", "Custom text", "FPS", "Ping", "KDR", "Server info", "Server framerate", "Server IP", "Network lag", "Tickrate", "Velocity", "Time", "Time + seconds"}

local watermark_reference = ui_new_multiselect("VISUALS", "Effects", "Watermark ", names)
local color_reference = ui_new_color_picker("VISUALS", "Effects", "Watermark", 149, 184, 6, 255)
local custom_name_reference = ui_new_textbox("VISUALS", "Effects", "Watermark name")
local rainbow_header_reference = ui_new_checkbox("VISUALS", "Effects", "Watermark rainbow header")

local fps_prev = 0
local value_prev = {}
local last_update_time = 0

local offset_x, offset_y = -15, 15
--local offset_x, offset_y = 525, 915 --debug, show above net_graph

local function clamp(cur_val, min_val, max_val)
	return math_min(math.max(cur_val, min_val), max_val)
end

local function lerp(a, b, percentage)
	return a + (b - a) * percentage
end

local function table_contains(tbl, val)
	for i=1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_remove_element(tbl, val)
	local tbl_new = {}
	for i=1, #tbl do
		if tbl[i] ~= val then
			table_insert(tbl_new, tbl[i])
		end
	end
	return tbl_new
end

local function table_lerp(a, b, percentage)
	local result = {}
	for i=1, #a do
		result[i] = lerp(a[i], b[i], percentage)
	end
	return result
end

local function on_watermark_changed()
	local value = ui_get(watermark_reference)

	if #value > 0 then
		--Make Time / Time + seconds act as a kind of "switch", only allow one to be selected at a time.
		if table_contains(value, "Time") and table_contains(value, "Time + seconds") then
			local value_new = value
			if not table_contains(value_prev, "Time") then
				value_new = table_remove_element(value_new, "Time + seconds")
			elseif not table_contains(value_prev, "Time + seconds") then
				value_new = table_remove_element(value_new, "Time")
			end

			--this shouldn't happen, but why not add a failsafe
			if table_contains(value_new, "Time") and table_contains(value_new, "Time + seconds") then
				value_new = table_remove_element(value_new, "Time")
			end

			ui_set(watermark_reference, value_new)
			on_watermark_changed()
			return
		end
	end
	ui_set_visible(custom_name_reference, table_contains(value, "Custom text"))
	ui_set_visible(rainbow_header_reference, #value > 0)

	value_prev = value
end
ui_set_callback(watermark_reference, on_watermark_changed)
on_watermark_changed()

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math_floor(num * mult + 0.5) / mult
end

local ft_prev = 0
local function get_fps()
	ft_prev = ft_prev * 0.9 + globals_absoluteframetime() * 0.1
	return round(1 / ft_prev)
end

local function lerp_color_yellow_red(val, max_normal, max_yellow, max_red, default, yellow, red)
	default = default or {255, 255, 255}
	yellow = yellow or {230, 210, 40}
	red = red or {255, 32, 32}
	if val > max_yellow then
		return unpack(table_lerp(yellow, red, clamp((val-max_yellow)/(max_red-max_yellow), 0, 1)))
	else
		return unpack(table_lerp(default, yellow, clamp((val-max_normal)/(max_yellow-max_normal), 0, 1)))
	end
end

local watermark_items = {
	{
		--gamesense logo
		name = "Logo",
		get_width = function(self, frame_data)
			self.game_width = renderer_measure_text(nil, "game")
			self.sense_width = renderer_measure_text(nil, "sense")
			self.beta_width = (is_beta and (renderer_measure_text(nil, " [beta]")) or 0)
			return self.game_width + self.sense_width + self.beta_width
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			local r_sense, g_sense, b_sense = ui_get(color_reference)

			renderer_text(x, y, 255, 255, 255, a, nil, 0, "game")
			renderer_text(x+self.game_width, y, r_sense, g_sense, b_sense, a, nil, 0, "sense")
			if is_beta then
				renderer_text(x+self.game_width+self.sense_width, y, 255, 255, 255, a*0.9, nil, 0, " [beta]")
			end
		end
	},
	{
		name = "Custom text",
		get_width = function(self, frame_data)
			local edit = ui_get(custom_name_reference)
			if edit ~= self.edit_prev and self.edit_prev ~= nil then
				db.custom_name = edit
			elseif edit == "" and db.custom_name ~= nil then
				ui_set(custom_name_reference, db.custom_name)
			end
			self.edit_prev = edit

			local text = db.custom_name
			if text ~= nil and text:gsub(" ", "") ~= "" then
				self.text = text
				return renderer_measure_text(nil, text)
			else
				self.text = nil
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			-- local r_sense, g_sense, b_sense = ui_get(color_reference)
			renderer_text(x, y, r, g, b, a, nil, 0, self.text)
		end
	},
	{
		name = "FPS",
		get_width = function(self, frame_data)
			self.fps = get_fps()
			self.text = tostring(self.fps or 0) .. " fps"

			local fps_max, fps_max_menu = cvar_fps_max:get_float(), cvar_fps_max_menu:get_float()
			local fps_max = globals.mapname() == nil and math.min(fps_max == 0 and 999 or fps_max, fps_max_menu == 0 and 999 or fps_max) or fps_max == 0 and 999 or fps_max

			self.width = math.max(renderer_measure_text(nil, self.text), renderer_measure_text(nil, fps_max .. " fps"))
			return self.width
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			--fps
			local fps_r, fps_g, fps_b = r, g, b
			if self.fps < (1 / globals_tickinterval()) then
				-- fps_r, fps_g, fps_b = 255, 0, 0
			end

			renderer_text(x+self.width, y, fps_r, fps_g, fps_b, a, "r", 0, self.text)
		end
	},
	{
		name = "Ping",
		get_width = function(self, frame_data)
			local ping = client_latency()
			if ping > 0 then
				self.ping = ping
				self.text = round(self.ping*1000, 0) .. "ms"
				self.width = math.max(renderer_measure_text(nil, "999ms"), renderer_measure_text(nil, self.text))
				return self.width
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			if self.ping > 0.15 then
				r, g, b = 255, 0, 0
			end
			renderer_text(x+self.width, y, r, g, b, a, "r", 0, self.text)
		end
	},
	{
		name = "KDR",
		get_width = function(self, frame_data)
			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			local player_resource = entity_get_player_resource()
			if player_resource == nil then return end

			self.kills = entity_get_prop(player_resource, "m_iKills", frame_data.local_player)
			self.deaths = math.max(entity_get_prop(player_resource, "m_iDeaths", frame_data.local_player), 1)

			self.kdr = self.kills/self.deaths

			if self.kdr ~= 0 then
				self.text = string.format("%1.1f", round(self.kdr, 1))
				self.text_width = math.max(renderer_measure_text(nil, "10.0"), renderer_measure_text(nil, self.text))
				self.unit_width = renderer_measure_text("-", "kdr")
				return self.text_width+self.unit_width
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x+self.text_width, y, r, g, b, a, "r", 0, self.text)
			renderer_text(x+self.text_width+self.unit_width, y+2, 255, 255, 255, a*0.75, "r-", 0, "kdr")
		end
	},
	{
		name = "Velocity",
		get_width = function(self, frame_data)
			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			local vel_x, vel_y = entity_get_prop(frame_data.local_player, "m_vecVelocity")
			if vel_x ~= nil then
				self.velocity = math_sqrt(vel_x*vel_x + vel_y*vel_y)

				self.vel_width = renderer_measure_text(nil, "9999")
				self.unit_width = renderer_measure_text("-", "vel")
				return self.vel_width+self.unit_width
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			local velocity = self.velocity
			-- velocity = string.rep(round(globals.realtime() % 9, 0), 4)
			velocity = math_min(9999, velocity) + 0.4
			velocity = round(velocity, 0)

			renderer_text(x+self.vel_width, y, 255, 255, 255, a, "r", 0, velocity)
			renderer_text(x+self.vel_width+self.unit_width, y+3, 255, 255, 255, a*0.75, "r-", 0, "vel")
		end
	},
	{
		name = "Server framerate",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end

			local frame_time, frame_time_std_dev, frame_time_start_time_std_dev = GetRemoteFramerate(frame_data.net_channel_info)
			if frame_time ~= nil then
				self.framerate = frame_time * 1000
				self.var = frame_time_std_dev * 1000

				self.text1 = "sv:"
				self.text2 = string.format("%.1f", self.framerate)
				self.text3 = " +-"
				self.text4 = string.format("%.1f", self.var)

				self.width1 = renderer_measure_text(nil, self.text1)
				self.width2 = math.max(renderer_measure_text(nil, self.text2), renderer_measure_text(nil, "99.9"))
				self.width3 = renderer_measure_text(nil, self.text3)
				self.width4 = math.max(renderer_measure_text(nil, self.text4), renderer_measure_text(nil, "9.9"))

				return self.width1 + self.width2 + self.width3 + self.width4
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			local fr_r, fr_g, fr_b = lerp_color_yellow_red(self.framerate, 8, 14, 20, {r, g, b})
			local vr_r, vr_g, vr_b = lerp_color_yellow_red(self.var, 5, 10, 18, {r, g, b})

			renderer_text(x, y, r, g, b, a, nil, 0, self.text1)
			renderer_text(x+self.width1+self.width2, y, fr_r, fr_g, fr_b, a, "r", 0, self.text2)
			renderer_text(x+self.width1+self.width2, y, r, g, b, a, nil, 0, self.text3)
			renderer_text(x+self.width1+self.width2+self.width3, y, vr_r, vr_g, vr_b, a, nil, 0, self.text4)
		end
	},
	{
		name = "Network lag",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end

			local reasons = {}

			-- timeout
			local time_since_last_received = native_GetTimeSinceLastReceived(frame_data.net_channel_info)
			if time_since_last_received ~= nil and time_since_last_received > 0.1 then
				table_insert(reasons, string_format("%.1fs timeout", time_since_last_received))
			end

			-- loss
			local avg_loss = native_GetAvgLoss(frame_data.net_channel_info, FLOW_INCOMING)
			if avg_loss ~= nil and avg_loss > 0 then
				table_insert(reasons, string_format("%d%% loss", math.ceil(avg_loss*100)))
			end

			-- choke
			local avg_choke = native_GetAvgChoke(frame_data.net_channel_info, FLOW_INCOMING)
			if avg_choke > 0 then
				table_insert(reasons, string_format("%d%% choke", math.ceil(avg_choke*100)))
			end

			if #reasons > 0 then
				self.text = table.concat(reasons, ", ")
				return renderer_measure_text(nil, self.text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 32, 32, a, nil, 0, self.text)
		end
	},
	{
		name = "Server info",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end
			frame_data.is_loopback = frame_data.is_loopback == nil and native_IsLoopback(frame_data.net_channel_info) or frame_data.is_loopback

			local game_rules = entity.get_game_rules()
			frame_data.is_valve_ds = frame_data.is_valve_ds == nil and entity.get_prop(game_rules, "m_bIsValveDS") == 1 or frame_data.is_valve_ds

			local text
			if frame_data.is_loopback then
				text = "Local server"
			elseif frame_data.is_valve_ds then
				local game_mode_name
				local game_mode, game_type = cvar_game_mode:get_int(), cvar_game_type:get_int()

				local is_queued_matchmaking = entity.get_prop(game_rules, "m_bIsQueuedMatchmaking") == 1

				if is_queued_matchmaking then
					if game_type == 0 and game_mode == 1 then
						game_mode_name = "MM"
					elseif game_type == 0 and game_mode == 2 then
						game_mode_name = "Wingman"
					elseif game_type == 3 then
						game_mode_name = "Custom"
					elseif game_type == 4 and game_mode == 0 then
						game_mode_name = "Guardian"
					elseif game_type == 4 and game_mode == 1 then
						game_mode_name = "Co-op Strike"
					elseif game_type == 6 and game_mode == 0 then
						game_mode_name = "Danger Zone"
					end
				else
					if game_type == 0 and game_mode == 0 then
						game_mode_name = "Casual"
					elseif game_type == 1 and game_mode == 0 then
						game_mode_name = "Arms Race"
					elseif game_type == 1 and game_mode == 1 then
						game_mode_name = "Demolition"
					elseif game_type == 1 and game_mode == 2 then
						game_mode_name = "Deathmatch"
					end
				end

				if game_mode_name ~= nil then
					text = "Valve (" .. game_mode_name .. ")"
				else
					text = "Valve"
				end
			end

			if text ~= nil then
				self.text = text
				return renderer_measure_text(nil, text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, a, nil, 0, self.text)
		end
	},
	{
		name = "Server IP",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end

			frame_data.is_loopback = frame_data.is_loopback == nil and native_IsLoopback(frame_data.net_channel_info) or frame_data.is_loopback
			if frame_data.is_loopback then return end

			frame_data.is_valve_ds = frame_data.is_valve_ds == nil and entity.get_prop(entity.get_game_rules(), "m_bIsValveDS") == 1 or frame_data.is_valve_ds
			if frame_data.is_valve_ds then return end

			frame_data.server_address = frame_data.server_address or GetAddress(frame_data.net_channel_info)
			if frame_data.server_address ~= nil and frame_data.server_address ~= "" then
				self.text = frame_data.server_address
				return renderer_measure_text(nil, self.text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, a, nil, 0, self.text)
		end
	},
	{
		name = "Tickrate",
		get_width = function(self, frame_data)
			if globals.mapname() == nil then return end

			local tickinterval = globals_tickinterval()
			if tickinterval ~= nil then
				local text = 1/globals_tickinterval() .. " tick"
				self.text = text
				return renderer_measure_text(nil, text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, a, nil, 0, self.text)
		end
	},
	{
		name = "Time",
		get_width = function(self, frame_data)
			self.time_width = renderer_measure_text(nil, "00")
			self.sep_width = renderer_measure_text(nil, ":")
			return self.time_width + self.sep_width + self.time_width + (self.seconds and (self.sep_width + self.time_width) or 0)
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			-- local time_center = x + 16

			local hours, minutes, seconds, milliseconds = client_system_time()
			hours, minutes = string_format("%02d", hours), string_format("%02d", minutes)
			-- renderer_text(time_center, y, 255, 255, 255, a, "r", 0, hours)
			-- renderer_text(time_center, y, 255, 255, 255, a, "", 0, ":")
			-- renderer_text(time_center+4, y, 255, 255, 255, a, "", 0, minutes)

			-- time_center = time_center + 18

			-- if self.seconds then
			-- 	seconds = string_format("%02d", seconds)
			-- 	renderer_text(time_center, y, 255, 255, 255, a, "", 0, ":")
			-- 	renderer_text(time_center+4, y, 255, 255, 255, a, "", 0, seconds)
			-- end

			renderer_text(x, y, 255, 255, 255, a, "", 0, hours)
			renderer_text(x+self.time_width, y, 255, 255, 255, a, "", 0, ":")
			renderer_text(x+self.time_width+self.sep_width, y, 255, 255, 255, a, "", 0, minutes)

			if self.seconds then
				seconds = string_format("%02d", seconds)
				renderer_text(x+self.time_width*2+self.sep_width, y, 255, 255, 255, a, "", 0, ":")
				renderer_text(x+self.time_width*2+self.sep_width*2, y, 255, 255, 255, a, "", 0, seconds)
			end

		end,
		seconds = false
	},
}

local items_drawn = {}
window.pre_paint_callback = function()
	table_clear(items_drawn)
	local value = ui_get(watermark_reference)

	if table_contains(value, "Custom text") then
		value = table_remove_element(value, "Custom text")
		if table_contains(value, "Logo") then
			table_insert(value, 2, "Custom text")
		else
			table_insert(value, 1, "Custom text")
		end
	end

	local screen_width, screen_height = client_screen_size()
	local x = offset_x >= 0 and offset_x or screen_width + offset_x
	local y = offset_y >= 0 and offset_y or screen_height + offset_y

	for i=1, #watermark_items do
		local item = watermark_items[i]
		if item.name == "Time" then
			item.seconds = table_contains(value, "Time + seconds")

			if item.seconds then
				table_insert(value, "Time")
			end
		end
	end

	--calculate width and draw container
	local item_margin = 9
	local width = 0

	local frame_data = {}

	for i=1, #watermark_items do
		local item = watermark_items[i]
		if table_contains(value, item.name) then
			local item_width = item:get_width(frame_data)
			if item_width ~= nil and item_width > 0 then
				table.insert(items_drawn, {
					item = item,
					item_width = item_width,
					x = width
				})
				width = width + item_width + item_margin
			end
		end
	end

	local _, height = renderer_measure_text(nil, "A")

	window.gradient_bar = ui_get(rainbow_header_reference)

	window:set_inner_width(width-item_margin)
	window:set_inner_height(height)

	window.visible = #items_drawn > 0
end

window.paint_callback = function()
	local r, g, b = 255, 255, 255
	local a_text = 230
	for i=1, #items_drawn do
		local item = items_drawn[i]

		-- bounding box
		-- renderer_rectangle(x_text+item.x, y_text, item.item_width, 14, 255, 0, 0, 100)

		-- draw item
		item.item:draw(window.i_x+item.x, window.i_y, item.item_width, 30, r, g, b, a_text)

		-- draw seperator
		if #items_drawn > i then
			renderer.rectangle(window.i_x+item.x+item.item_width+4, window.i_y+1, 1, window.i_h-1, 210, 210, 210, 255)
		end
	end
end

client.set_event_callback("shutdown", function()
	database.write("sapphyrus_watermark", db)
end)
