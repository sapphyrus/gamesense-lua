-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_latency, client_screen_size, client_set_event_callback, entity_get_local_player, entity_get_player_resource, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_alive, globals_chokedcommands, globals_curtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, math_max, math_min, renderer_gradient, renderer_indicator, renderer_load_svg, renderer_measure_text, renderer_rectangle, renderer_text, renderer_texture, table_insert, tonumber, unpack, pairs, type = client.camera_angles, client.latency, client.screen_size, client.set_event_callback, entity.get_local_player, entity.get_player_resource, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_alive, globals.chokedcommands, globals.curtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, math.max, math.min, renderer.gradient, renderer.indicator, renderer.load_svg, renderer.measure_text, renderer.rectangle, renderer.text, renderer.texture, table.insert, tonumber, unpack, pairs, type

local dragging = (function() local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider("LUA","A",u.." window position",0,x,v/j*x)local z=ui.new_slider("LUA","A","\n"..u.." window position y",0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;client.set_event_callback("paint",function()c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end)function a.drag(q,r,A,B,C,D,E)if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end;if E then end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local ui_lib = (function() local function a(b,c,d,e)c=c or""d=d or 1;e=e or#b;local f=""for g=d,e do f=f..c..tostring(b[g])end;return f end;local function h(b,i)for g=1,#b do if b[g]==i then return true end end;return false end;local function j(k,...)if not k then error(a({...}),3)end end;local function l(b)local m,n=false,false;for o,k in pairs(b)do if type(o)=="number"then m=true else n=true end end;return m,n end;local p=globals.realtime()local q={}local r={}local s={}local function t(b)local u=false;for o,k in pairs(b)do if getmetatable(k)==s then u=true end end;return u end;local function v(k,w)return k~=q[w].default end;local function x(k)return#k>0 end;function s.__index(w,o)if q[w]~=nil and type(o)=="string"and o:sub(1,1)~="_"then return q[w][o]or r[o]end end;function s.__call(w,...)local y={...}if globals.realtime()==p and#y==1 and type(y[1])=="table"then local z={}local A=y[1]local B=false;local C=false;local D={}for o,k in pairs(A)do if type(o)~="number"then D[o]=k;C=true end end;if A[1]~=nil and(type(A[1])~="table"or not t(A[1]))then D[1]=A[1]B=true;if type(D[1])~="table"then D[1]={D[1]}end end;if C then table.insert(z,D)end;for g=B and 2 or 1,#A do if t(A[g])then table.insert(z,A[g])end end;for g=1,#z do local E=z[g]local k;if E[1]~=nil then k=E[1]end;for o,F in pairs(E)do if o~=1 then w:add_children(F,k,o)end end end;return w end;if#y==0 then return w:get()else local G,H=pcall(ui.set,y[1].reference,select(2,unpack(y)))end end;function s.__tostring(w)return"Menu item: "..w.tab.." - "..w.container.." - "..w.name end;function r.new(I,J,K,L,...)local y={...}local M,N;local O;if type(I)=="function"and I~=ui.reference then for o,k in pairs(ui)do if k==I and o:sub(1,4)=="new_"then O=o:sub(5,-1)end end;local G;G,M=pcall(I,J,K,L,unpack(y))if not G then error(M,2)end;N=I==ui.reference else M=I;N=true end;if O==nil then local k={pcall(ui.get,M)}if k[1]==false then O="button"else k={select(2,unpack(k))}if#k==1 then local P=type(k[1])if P=="string"then local G=pcall(ui.set,M,nil)ui.set(M,k[1])O=G and"textbox"or"combobox"elseif P=="number"then local G=pcall(ui.set,M,-9999999999999999)ui.set(M,k[1])O=G and"listbox"or"slider"elseif P=="boolean"then O="checkbox"elseif P=="table"then O="multiselect"end elseif#k>=2 and type(k[1])=="boolean"and type(k[2])=="number"then O="hotkey"elseif#k==4 then if type(k[1])=="number"and type(k[2])=="number"and type(k[3])=="number"and type(k[4])=="number"then O="color_picker"end end end end;local Q;if N==false and O~=nil then if O=="slider"then Q=y[3]or y[1]elseif O=="combobox"then Q=y[1][1]elseif O=="checkbox"then Q=false end end;local w={}q[w]={tab=J,container=K,name=L,reference=M,type=O,default=Q,visible=true,ui_callback=nil,callbacks={},is_gamesense_reference=N,children_values={},children_callbacks={}}if N==false and O~=nil then if O=="slider"then q[w].min=y[1]q[w].max=y[2]elseif O=="combobox"or O=="multiselect"or O=="listbox"then q[w].values=y[1]end end;return setmetatable(w,s)end;function r:set(...)local R={...}local S=q[self]local T={pcall(ui.set,S.reference,unpack(R))}end;function r:get()local S=q[self]return ui.get(S.reference)end;function r:contains(k)local S=q[self]if S.type=="multiselect"then return h(ui.get(S.reference),k)elseif S.type=="combobox"then return ui.get(S.reference)==k else error(string.format("Invalid type %s for contains",S.type),2)end end;function r:as_keys()local S=q[self]if S.type=="multiselect"then local k=ui.get(S.reference)local f={}for g=1,#k do f[k[g]]=true end;return f elseif S.type=="combobox"then return{[ui.get(S.reference)]=true}else error(string.format("Invalid type %s for as_keys",S.type),2)end end;function r:set_visible(U)local S=q[self]if S==nil then error("Invalid ui element",2)end;ui.set_visible(S.reference,U)S.visible=U end;function r:set_default(k)q[self].default=k;self:set(k)end;function r:add_children(V,W,o)local S=q[self]local X=type(W)=="function"if W==nil then W=true;if S.type=="boolean"then W=true elseif S.type=="combobox"then X=true;W=v elseif S.type=="multiselect"then X=true;W=x end end;if getmetatable(V)==s then V={V}end;for Y,F in pairs(V)do if X then q[F].parent_visible_callback=W else q[F].parent_visible_value=W end;self[o or F.reference]=F end;r._process_callbacks(self)end;function r:add_callback(Z)local S=q[self]table.insert(S.callbacks,Z)r._process_callbacks(self)end;r.set_callback=r.add_callback;function r:_process_callbacks()local S=q[self]if S.ui_callback==nil then local Z=function(M,_)local k=self:get()local a0=S.combo_elements;if a0~=nil and#a0>0 then local a1;for g=1,#a0 do local a2=a0[g]if#a2>0 then local a3={}for g=1,#a2 do if h(k,a2[g])then table.insert(a3,a2[g])end end;if#a3>1 then a1=a1 or k;for g=#a3,1,-1 do if h(S.value_prev,a3[g])and#a3>1 then table.remove(a3,g)end end;local a4=a3[1]for g=#a1,1,-1 do if a1[g]~=a4 and h(a2,a1[g])then table.remove(a1,g)end end elseif#a3==0 and not(a2.required==false)then a1=a1 or k;if S.value_prev~=nil then for g=1,#S.value_prev do if h(a2,S.value_prev[g])then table.insert(a1,S.value_prev[g])break end end end end end end;if a1~=nil then self:set(a1)end;S.value_prev=k;k=a1 or k end;for o,F in pairs(self)do local a5=q[F]local a6=false;if S.visible then if a5.parent_visible_callback~=nil then a6=a5.parent_visible_callback(k,self,F)elseif S.type=="multiselect"then local a7=type(a5.parent_visible_value)for g=1,#k do if a7 and h(a5.parent_visible_value,k[g])or a5.parent_visible_value==k[g]then a6=true;break end end elseif type(a5.parent_visible_value)=="table"then a6=a5.parent_visible_value[k]or h(a5.parent_visible_value,k)else a6=k==a5.parent_visible_value end end;ui.set_visible(a5.reference,a6)a5.visible=a6;if a5.ui_callback~=nil then a5.ui_callback(F)end end;for g=1,#S.callbacks do S.callbacks[g]()end end;ui.set_callback(S.reference,Z)S.ui_callback=Z end;S.ui_callback()end;local a8={}local a9={__index=function(Y,o)if a8[o]then return a8[o]end;local aa=o;if aa:sub(1,4)~="new_"then aa="new_"..aa end;if ui[aa]~=nil then local ab=ui[aa]return function(self,L,...)local y={...}local a0={}local ac=aa:sub(5,-1)local ad="Cannot create a "..ac..": "local w;if ab==ui.new_textbox and L==nil then L="\n"end;L=(self.prefix or"")..L..(self.suffix or"")if ab==ui.new_slider then local ae,af,ag,ah,ai,aj,ak=unpack(y)if type(ag)=="table"then local al=ag;ag=al.default;ah=al.show_tooltip;ai=al.unit;aj=al.scale;ak=al.tooltips end;if ag~=nil then end;if ai~=nil then end;ag=ag or nil;if ah==nil then ah=true end;ai=ai or nil;aj=aj or 1;ak=ak or nil;w=r.new(ui.new_slider,self.tab,self.container,L,ae,af,ag,ah,ai,aj,ak)elseif ab==ui.new_combobox or ab==ui.new_multiselect or ab==ui.new_listbox then local am={...}if#am==1 and type(am[1])=="table"then am=am[1]end;if ab==ui.new_multiselect then local an={}for g=1,#am do local I=am[g]if type(I)=="table"then table.insert(a0,I)for ao=1,#I do table.insert(an,I[ao])end else table.insert(an,I)end end;am=an end;for g=1,#am do local I=am[g]end;if ab==ui.new_multiselect then local G;G,w=pcall(r.new,ui.new_multiselect,self.tab,self.container,L,am)if not G then error(w,2)end end elseif ab==ui.new_hotkey then if y[1]==nil then y[1]=false end;local ap=unpack(y)elseif ab==ui.new_button then local Z=unpack(y)elseif ab==ui.new_color_picker then local aq,ar,as,at=unpack(y)end;if w==nil then local G;G,w=pcall(r.new,ab,self.tab,self.container,L,...)if not G then error(w,2)end end;self[q[w].reference]=w;if#a0>0 then q[w].combo_elements=a0;local au={}for g=1,#a0 do if not a0[g].required==false then table.insert(au,a0[g][1])end end;w:set(au)q[w].value_prev=au;r._process_callbacks(w)end;return w end end end}local av={RAGE={"Aimbot","Other"},AA={"Anti-aimbot angles","Fake lag","Other"},LEGIT={"Weapon type","Aimbot","Triggerbot","Other"},VISUALS={"Player ESP","Other ESP","Colored models","Effects"},MISC={"Miscellaneous","Settings","Lua","Other"},SKINS={"Weapon skin","Knife options","Glove options"},PLAYERS={"Players","Adjustments"},LUA={"A","B"}}for J,aw in pairs(av)do av[J]={}for g=1,#aw do av[J][aw[g]:lower()]=true end end;function a8.new(J,K)J=J:upper()return setmetatable({tab=J,container=K,items={}},a9)end;function a8.reference(J,K,L)if L==nil and type(J)=="table"and getmetatable(J)==a9 then L=K;J,K=J.tab,J.container end;local ax={pcall(ui.reference,J,K,L)}j(ax[1]==true,"Cannot reference a Gamesense menu item: the menu item does not exist.")local ay={select(2,unpack(ax))}local az={}for g=1,#ay do local M=ay[g]local w=r.new(M,J,K,L)table.insert(az,w)end;return unpack(az)end;local aA=setmetatable({},{__index=function(Y,o)if ui[o]~=nil and o~="new_string"and(o==ui.reference or o:sub(1,4)=="new_")then return function(...)local G,f=pcall(ui[o],...)if not G then error(f,2)end;return r.new(f,...)end end end})return setmetatable(a8,{__call=function(Y,...)return a8.new(...)end,__index=function(Y,aB)return r[aB]or aA[aB]or ui[aB]end}) end)()

local bool_items = {
	["Double tap"] = {
		references = {({ui_lib.reference("RAGE", "Other", "Double tap")})[1], ({ui_lib.reference("RAGE", "Other", "Double tap")})[2]},
		text = "DT"
	},
	["Safe point"] = {
		references = {({ui_lib.reference("RAGE", "Aimbot", "Force safe point")})[1]},
		text = "SP"
	},
	["Freestanding"] = {
		references = {({ui_lib.reference("AA", "Anti-aimbot angles", "Freestanding")})[1], ({ui_lib.reference("AA", "Anti-aimbot angles", "Freestanding")})[2]},
		text = "FS"
	},
	["Anti-aim correction override"] = {
		references = {(ui_lib.reference("RAGE", "Other", "Anti-aim correction override"))},
		text = "OR"
	}
}

local function rectangle_outline(x, y, w, h, r, g, b, a, s)
	s = s or 1
	renderer_rectangle(x, y, w, s, r, g, b, a) -- top
	renderer_rectangle(x, y+h-s, w, s, r, g, b, a) -- bottom
	renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a) -- left
	renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a) -- right
end

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function normalize_yaw(angle)
	angle = (angle % 360 + 360) % 360
	return angle > 180 and angle - 360 or angle
end

local bar_min_width = 130
local custom_items = {
	{
		name = "Fake lag",
		title_text = "Fake lag",
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			if self.maxusrcmdprocessticks_reference == nil then
				self.maxusrcmdprocessticks_reference = ui_lib.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
			end

			self.chokedcommands_prev = self.chokedcommands
			self.chokedcommands = globals_chokedcommands()
			if self.chokedcommands_max == nil or self.chokedcommands > self.chokedcommands_max then
				self.chokedcommands_max = self.chokedcommands
			elseif self.chokedcommands == 0 and self.chokedcommands_prev ~= 0 then
				self.chokedcommands_max = self.chokedcommands_prev
			elseif self.chokedcommands == 0 and self.chokedcommands_prev_cmd == 0 then
				self.chokedcommands_max = 0
			end

			if self.limit == nil or self.chokedcommands == 0 then
				self.limit = self.maxusrcmdprocessticks_reference:get()-2
			end

			self.tickcount = globals_tickcount()
			if self.tickcount ~= self.tickcount_prev then
				self.last_cmd = globals_curtime()
				self.chokedcommands_prev_cmd = self.chokedcommands_prev
				self.tickcount_prev = self.tickcount
			end

			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local interp = (globals_curtime() - self.last_cmd) / globals_tickinterval()

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7
			local chokedcommands_interpolated = math_max(0, math_min(self.chokedcommands_max, self.chokedcommands + (interp < 1 and interp or 0)))

			-- 4280ECCB
			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local bar_width = math_floor(bar_w*math_max(0, math_min(1, self.chokedcommands_max / self.limit)))

			renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
			renderer_gradient(bar_x+1, bar_y+1, math_max(bar_width-2, 0), bar_h-2, r_top, g_top, b_top, a*0.25, r_bot, g_bot, b_bot, a*0.25, false)
			renderer_gradient(bar_x+1, bar_y+1, math_max(bar_width*math_max(0, math_min(1, chokedcommands_interpolated / self.chokedcommands_max))-2, 0), bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

			renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

			-- rounded_bar(bar_x-1, bar_y-1, bar_w+2, bar_h+2, 0, 0, 0, 255)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands_max / self.limit)+3, bar_h, 255, 255, 255, 100)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands / self.limit)+3, bar_h, 255, 255, 255, 255)

			if self.chokedcommands_max > 0 then
				renderer_text(bar_x+math_min(bar_width-4, bar_w-7), y+4, 255, 255, 255, 255, "-", 0, self.chokedcommands_max)
			end
		end
	},
	{
		name = "Body yaw",
		title_text = "Body yaw",
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local local_player = entity_get_local_player()
			if local_player ~= nil then
				local body_yaw = math_max(-60, math_min(60, math_floor((entity_get_prop(local_player, "m_flPoseParameter", 11) or 0)*120-60+0.5)))

				local percentage = (math_max(-60, math_min(60, body_yaw*1.06))+60) / 120

				-- display reversed for backwards AAs
				local _, camera_yaw = client_camera_angles()
				local _, rot_yaw = entity_get_prop(local_player, "m_angAbsRotation")

				if camera_yaw ~= nil and rot_yaw ~= nil and 60 < math_abs(normalize_yaw(camera_yaw-(rot_yaw+body_yaw))) then
					percentage = 1-percentage
				end

				renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
				renderer_gradient(bar_x+1, bar_y+1, bar_w-2, bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

				local center = math_floor(bar_w/2+0.5)
				if percentage > 0.5 then
					renderer_rectangle(bar_x+center+1, bar_y+1, bar_w*(percentage-0.5)-2, bar_h-2, 14, 14, 14, 255)
					renderer_gradient(bar_x+center+1, bar_y+1, bar_w*(percentage-0.5)-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)
				else
					local start = math_floor(bar_w*percentage)
					renderer_rectangle(bar_x+1+start, bar_y+1, center-start, bar_h-2, 14, 14, 14, 255)
					renderer_gradient(bar_x+1+start, bar_y+1, center-start, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)
				end

				renderer_gradient(bar_x+center, bar_y+1, 1, bar_h-2, 255, 255, 255, a, 140, 140, 140, a, false)

				if body_yaw ~= 0 then
					renderer_text(math_max(bar_x+4, math_min(bar_x+bar_w-6, bar_x+bar_w*percentage+0.5-(body_yaw < 0 and 2 or 0))), y+9, 255, 255, 255, 255, "c-", 0, body_yaw) --string.format("%.3f", entity_get_prop(local_player, "m_flPoseParameter", 11)*120-60)
				end
			end
		end
	},
	{
		name = "Head height",
		title_text = "Head height",
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			local local_player = entity_get_local_player()
			local _, _, o_z = entity_get_prop(local_player, "m_vecAbsOrigin")
			local _, _, h_z = entity_hitbox_position(local_player, 0)

			if o_z ~= nil and h_z ~= nil then
				if h_z ~= self.h_z_prev then
					self.h_z_prev = self.h_z
					self.duckamount = entity_get_prop(local_player, "m_flDuckAmount") or 0
				end

				local delta = h_z - o_z + (self.duckamount or 0)*12
				local max_height = 70
				local min_height = 55

				local percentage = math_max(0, math_min(1, 1-(delta-min_height)/(max_height-min_height)))

				-- slider bar
				local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
				local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

				local bar_width = math_floor(bar_w*percentage)

				renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
				renderer_gradient(bar_x+1, bar_y+1, bar_width-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

				renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)
			end
		end
	},
	{
		name = "Ping spike + amount",
		title_text = "Ping spike",
		group = "Ping spike",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference, self.amount_reference = ui_lib.reference("MISC", "Miscellaneous", "Ping spike")
			end
			local draw = self.reference:get() and self.hotkey_reference:get()
			if draw then
				self.ping_extra = tonumber(entity_get_prop(entity_get_player_resource(), "m_iPing", entity_get_local_player()) or 0)-client_latency()*1000-5
				self.percentage = math_min(1, math_max(0, self.ping_extra / self.amount_reference:get()))
			end
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			-- slider bar
			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local bar_width = math_floor(bar_w*(self.percentage))

			renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
			renderer_gradient(bar_x+1, bar_y+1, bar_width-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

			renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

			-- rounded_bar(bar_x-1, bar_y-1, bar_w+2, bar_h+2, 0, 0, 0, 255)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands_max / self.limit)+3, bar_h, 255, 255, 255, 100)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands / self.limit)+3, bar_h, 255, 255, 255, 255)
		end
	},
	{
		name = "Fake duck + height",
		title_text = "Fake duck",
		group = "Fake duck",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Duck peek assist")
				self.infinite_duck_reference = ui_lib.reference("MISC", "Movement", "Infinite duck")
			end
			local draw = self.reference:get() and self.infinite_duck_reference:get()
			if draw then
				self.tickcount = globals_tickcount()
				if self.tickcount ~= self.tickcount_prev then
					self.duckamount_prev_2 = self.duckamount_prev
					self.duckamount_prev = self.duckamount
					self.duckamount = entity_get_prop(entity_get_local_player(), "m_flDuckAmount") or 0
					self.tickcount_prev = self.tickcount
				end

				if self.duckamount_max == nil or self.duckamount > self.duckamount_max then
					self.duckamount_max = self.duckamount
				elseif self.duckamount_prev ~= nil and self.duckamount_prev_2 ~= nil and self.duckamount_prev > self.duckamount and self.duckamount_prev > self.duckamount_prev_2 then
					self.duckamount_max = self.duckamount_prev
				elseif self.duckamount_prev == 0 and self.duckamount == 0 and self.duckamount_prev_2 == 0 then
					self.duckamount_max = 0
				end
			else
				self.duckamount_prev_2 = nil
				self.duckamount_prev = nil
				self.duckamount_max = nil
			end
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self, text_width)
			return text_width+bar_min_width, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)

			local bar_x, bar_y, bar_w, bar_h = x+text_width+3, y+2, w-text_width-3, 7

			-- slider bar
			local r_top, g_top, b_top = math_max(0, math_min(255, r+4)), math_max(0, math_min(255, g+4)), math_max(0, math_min(255, b+4))
			local r_bot, g_bot, b_bot = math_max(0, math_min(255, r-40)), math_max(0, math_min(255, g-40)), math_max(0, math_min(255, b-40))

			local bar_width = math_floor(bar_w*math_max(0, math_min(1, self.duckamount_max)))

			renderer_rectangle(bar_x, bar_y, bar_w, bar_h, 14, 14, 14, 255)
			renderer_gradient(bar_x+1, bar_y+1, bar_width-2, bar_h-2, r_top, g_top, b_top, a*0.25, r_bot, g_bot, b_bot, a*0.25, false)
			renderer_gradient(bar_x+1, bar_y+1, bar_w*(self.duckamount)-2, bar_h-2, r_top, g_top, b_top, a, r_bot, g_bot, b_bot, a, false)

			renderer_gradient(bar_x+1+math_max(0, bar_width-2), bar_y+1, math_min(bar_w-2, bar_w-bar_width), bar_h-2, 52, 52, 52, a, 68, 68, 68, a, false)

			-- rounded_bar(bar_x-1, bar_y-1, bar_w+2, bar_h+2, 0, 0, 0, 255)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands_max / self.limit)+3, bar_h, 255, 255, 255, 100)
			-- rounded_bar(bar_x, bar_y, bar_w*(self.chokedcommands / self.limit)+3, bar_h, 255, 255, 255, 255)
		end
	},
	{
		name = "Ping spike",
		title_text = "Ping spike",
		group = "Ping spike",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference, self.amount_reference = ui_lib.reference("MISC", "Miscellaneous", "Ping spike")
			end
			local draw = self.reference:get() and self.hotkey_reference:get()
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Fake duck",
		title_text = "Fake duck",
		group = "Fake duck",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Duck peek assist")
				self.infinite_duck_reference = ui_lib.reference("MISC", "Movement", "Infinite duck")
			end
			local draw = self.reference:get() and self.infinite_duck_reference:get()
			return draw
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right, text_width, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Double tap",
		title_text = "Double tap",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("RAGE", "Other", "Double tap")
				self.mode_reference = ui_lib.reference("RAGE", "Other", "Double tap mode")
			end
			return self.reference:get() and self.hotkey_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			self.right_text_width = math_max((renderer_measure_text("b", "[Offensive]")+4), (renderer_measure_text("b", "[Defensive]")+4))
			return self.title_text_width+self.right_text_width, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			local local_player = entity_get_local_player()
			local weapon = entity_get_player_weapon(local_player)

			local next_attack = math_max(entity_get_prop(weapon, "m_flNextPrimaryAttack") or 0, entity_get_prop(local_player, "m_flNextAttack") or 0)
			local r, g, b, a = unpack(globals_curtime() > next_attack and {126, 195, 12} or {230, 230, 39})
			renderer_text(x+w, y, r, g, b, 255, "rb", 0, "[", self.mode_reference:get(), "]")
		end
	},
	{
		name = "On-shot anti-aim",
		title_text = "On-shot AA",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("AA", "Other", "On shot anti-aim")
				self.dt_reference, self.dt_hotkey_reference = ui_lib.reference("RAGE", "Other", "Double tap")
			end
			return self.reference:get() and self.hotkey_reference:get() and not (self.dt_reference:get() and self.dt_hotkey_reference:get())
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Safe point",
		title_text = "Safe point",
		get_should_draw = function(self)
			if self.reference == nil then
				self.force_reference = ui_lib.reference("RAGE", "Aimbot", "Force safe point")
			end
			return self.force_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Freestanding",
		title_text = "Freestanding",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("AA", "Anti-aimbot angles", "Freestanding")
			end
			return #self.reference:get() > 0 and self.hotkey_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Slow motion",
		title_text = "Slow motion",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference, self.hotkey_reference = ui_lib.reference("AA", "Other", "Slow motion")
			end
			return self.reference:get() and self.hotkey_reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Anti-aim correction override",
		title_text = "Override",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Anti-aim correction override")
			end
			return self.reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	},
	{
		name = "Force body aim",
		title_text = "Force baim",
		get_should_draw = function(self)
			if self.reference == nil then
				self.reference = ui_lib.reference("RAGE", "Other", "Force body aim")
			end
			return self.reference:get()
		end,
		get_text_width = function(self)
			self.title_text_width = self.title_text_width or renderer_measure_text(nil, self.title_text)+4
			return self.title_text_width
		end,
		get_size = function(self)
			return self.title_text_width+30, 10
		end,
		draw = function(self, x, y, w, h, align_right)
			renderer_text(x, y, 255, 255, 255, 255, nil, 0, self.title_text)
			renderer_text(x+w, y, 126, 195, 12, 255, "rb", 0, "[On]")
		end
	}
}
local svg_patterns = {}

local function table_get_keys(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do
		table_insert(keys, key)
	end
	return keys
end

local function gen_pattern(width, height)
	local svg = [[
<svg width="]] .. width .. [[" height="]] .. height .. [[" viewBox="0 0 ]] .. width .. [[ ]] .. height .. [[">
<rect width="]] .. width .. [[" height="]] .. height .. [[" y="0" x="0" fill="#151515"/>
#pattern
</svg>
]]
	for x=0, width, 4 do
		for y=0, height, 4 do
			local pattern = [[
<rect height="3" width="1" x="]] .. x+1 .. [[" y="]] .. y .. [[" fill="#0d0d0d"/>
<rect height="1" width="1" x="]] .. x+3 .. [[" y="]] .. y .. [[" fill="#0d0d0d"/>
<rect height="2" width="1" x="]] .. x+3 .. [[" y="]] .. y+2 .. [[" fill="#0d0d0d"/>
]]
			svg = svg:gsub("#pattern", pattern .. "#pattern")
		end
	end
	svg = svg:gsub("#pattern\n", "")
	return svg
end

local function draw_container(x, y, w, h, a, header, background_pattern)
	a = a or 255
	rectangle_outline(x, y, w, h, 18, 18, 18, a)
	rectangle_outline(x+1, y+1, w-2, h-2, 62, 62, 62, a)
	rectangle_outline(x+2, y+2, w-4, h-4, 44, 44, 44, a, 3)
	rectangle_outline(x+5, y+5, w-10, h-10, 62, 62, 62, a)

	if background_pattern then
		local rw, ph, lxa, pw = w-12, h-12, 0

		for i=6, 2, -1 do
			pw = 2^i
			if rw % pw < 7 then
				break
			end
		end

		for i=1, 2 do
			if svg_patterns[pw] == nil or svg_patterns[pw][ph] == nil then
				svg_patterns[pw] = svg_patterns[pw] or {}
				svg_patterns[pw][ph] = renderer_load_svg(gen_pattern(pw, ph), pw, ph) or -1
			end

			if svg_patterns[pw][ph] ~= -1 then
				for xa=0, rw-pw, pw do
					renderer_texture(svg_patterns[pw][ph], x+6+xa+lxa, y+6, pw, ph, 255, 255, 255, a)
				end
			end

			if rw % pw == 0 then break end
			lxa, pw = rw - (rw % pw), rw % pw
			rw = pw
		end
	else
		renderer_rectangle(x+6, y+6, w-12, h-12, 25, 25, 25, a)
	end

	if header then
		local x, y = x+7, y+7
		local w1, w2 = math_floor((w-14)/2), math_ceil((w-14)/2)

		for i=1, 2 do
			renderer_gradient(x, y, w1, 1, 59, 175, 222, a, 202, 70, 205, a, true)
			renderer_gradient(x+w1, y, w2, 1, 202, 70, 205, a, 201, 227, 58, a, true)
			y, a = y+1, a*0.2
		end
	end
end

-- set up menu
local custom_items_names, custom_items_groups = {}, {}

local j=1
for i=1, #custom_items do
	local item = custom_items[i]
	if item.group == nil then
		table_insert(custom_items_names, item.name)
		j = j + 1
	else
		if custom_items_groups[item.group] == nil then
			custom_items_groups[item.group] = {i=j}
		end
		table_insert(custom_items_groups[item.group], item)
	end
end

for _, group_items in pairs(custom_items_groups) do
	local names = {}
	for i=1, #group_items do
		table_insert(names, group_items[i].name)
	end
	table_insert(custom_items_names, group_items.i, names)
end

local container = ui_lib.new("VISUALS", "Other ESP")
local indicators = container:combobox("Indicators", {"Off", "Built-in", "Custom"}) {
	{"Built-in",
		additional = container:checkbox("Additional indicators") {
			types = container:multiselect("\nAdditional indicator types", table_get_keys(bool_items))
		},
		move_up = container:slider("Move indicators", 0, 60, 0, true, "", 1, {[0] = "Off"})
	},
	{"Custom",
		custom_types = container:multiselect("Indicator types", custom_items_names),
		custom_color = container:color_picker("Indicator color", 240, 240, 240, 255)
	}
}
indicators:set("Built-in")

local dragging_indicators = dragging.new("indicators", 15, 420)

client_set_event_callback("paint", function()
	local indicators_value = indicators:get()

	if indicators_value == "Built-in" then
		local value = indicators.move_up:get()

		if value > 0 then
			for i=1, value do
				renderer_indicator(255, 255, 255, 0, "A")
			end
		end

		if indicators.additional:get() and entity_is_alive(entity_get_local_player()) and #indicators.additional.types:get() > 0 then
			local x, y = 10
			y = renderer_indicator(255, 255, 255, 0, "Additional indicators")

			local active_bool_items = indicators.additional.types:get()
			for i=1, #active_bool_items do
				local item = bool_items[active_bool_items[i]]

				if item then
					local enabled = true
					for i=1, #item.references do
						local value = item.references[i]:get()
						if not value or (type(value) == "table" and #value == 0) then
							enabled = false
						end
					end

					if item.width == nil or item.height == nil then
						item.width, item.height = renderer_measure_text("+", item.text)
					end

					local r, g, b, a = unpack(enabled and {126, 195, 12, 255} or {255, 0, 0, 255})
					renderer_text(x, y, r, g, b, a, "+", 0, item.text)

					x = x + item.width + 8
				end
			end

			if indicators.additional.types:contains("Fake lag") then
			end
		end
	else
		local y = 10
		for i=1, 100 do
			y = renderer_indicator(255, 255, 255, 0, "A")
			if 0 > y then
				break
			end
		end
	end

	if indicators_value == "Custom" and entity_is_alive(entity_get_local_player()) then
		local screen_width, screen_height = client_screen_size()
		local x, y = dragging_indicators:get()

		local align_right = x > screen_width/2
		local margin = 3
		local types = indicators.custom_types:get()

		local items_drawn, text_width = {}, 0
		for i=1, #custom_items do
			local item = custom_items[i]

			if table_contains(types, item.name) then
				if item.get_should_draw == nil or item:get_should_draw() then
					table_insert(items_drawn, item)
				end

				local w_t = item:get_text_width()
				text_width = math_max(text_width, w_t)
			end
		end

		if #items_drawn > 0 then
			local y_item, h_item = {}, {}
			local width, height = 120, 10

			for i=1, #items_drawn do
				local item = items_drawn[i]
				local w, h = item:get_size(text_width)

				y_item[item], h_item[item] = y+height, h

				width = math_max(width, w)
				height = height + h + ((i == #items_drawn) and 0 or margin)
			end
			height = height + 12

			dragging_indicators:drag(width, height)

			draw_container(x, y, width, height, 255, true, true)
			local r, g, b, a = indicators.custom_color:get()

			local inner_x, inner_y, inner_w, inner_h = x+10, y+15, width-20, height-25
			for i=1, #items_drawn do
				local item = items_drawn[i]
				item:draw(inner_x, y_item[item], inner_w, h_item[item], align_right, text_width, r, g, b, a)
			end
		end
	end
end)
