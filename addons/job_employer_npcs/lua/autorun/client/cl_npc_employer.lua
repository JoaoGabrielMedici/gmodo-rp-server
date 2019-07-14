surface.CreateFont("ENPCFont", {
	font = "Roboto Bold",
	size = 72,
	weight = 300,
	extended = true
})

surface.CreateFont("JobsHeaderFont", {
	font = "Roboto Bold",
	size = 21,
	weight = 300,
	extended = true
})

surface.CreateFont("JobsListFont", {
	font = "Roboto Bold",
	size = 18,
	weight = 300,
	extended = true
})

surface.CreateFont("JobsListSmallFont", {
	font = "Roboto Bold",
	size = 16,
	weight = 300,
	extended = true
})

surface.CreateFont("JobsDescFont",{
	font = "Roboto Bold",
	size = 15,
	weight = 300,
	extended = true
})

local close_mat = Material("job_employ/close.png", "noclamp smooth")
local settings_mat = Material("job_employ/settings.png", "noclamp smooth")
local clock_mat = Material("job_employ/clock.png", "noclamp smooth")
local star_mat = Material("job_employ/star.png", "noclamp smooth")
local lock_mat = Material("job_employ/lock.png", "noclamp smooth")
local money_mat = Material("job_employ/money.png", "noclamp smooth")

local function draw_mat(mat, x, y, activated)
	surface.SetMaterial(mat)
	if activated then
		surface.SetDrawColor(ENPC.Colors.icons_a)
	else
		surface.SetDrawColor(ENPC.Colors.icons)
	end
	surface.DrawTexturedRect(x, y, 15, 15)
end

local function InWhitelist(whitelist, name)
 for k,v in pairs(whitelist) do
 		if k == name then return  true end
 end
 return false
end

local function IsDark(color)
	local val = ((color.r*299)+(color.g*587)+(color.b*114))/1000
	if val < 75 then
		return {r = color.r+75, g = color.g+75, b = color.b+75, a = color.a}
	else
		return color
	end
end

local function timeFormat( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24

	return string.format( "%02i:%02i:%02i", h, m, s )
end

local function FindJobByName(name)
	for k,v in pairs(RPExtraTeams) do
		if v.name == name then
			return v
		end
	end
	return false
end

local function IsAvailable(job)

	if job.customCheck and 
		not LocalPlayer():IsIgnoreRules("customcheck") and 
		not job.customCheck(LocalPlayer()) then 

		return false, ENPC.Translate("Unavailable") 
	end

	if job.max and job.max != 0 and 
		not LocalPlayer():IsIgnoreRules("countlimit") and 
		team.NumPlayers(job.team) >= job.max then 

		return false, ENPC.Translate("Limit reached") 
	end

	return true
end

local function IsBoughtJob(job)
	if job.jobcost and 
		not LocalPlayer():IsIgnoreRules("jobcost") and 
		not LocalPlayer():IsUnlocked(job.name) then 

		return false, ENPC.Translate("Job Cost")
	end
	return true
end

local function IsOpenedJob(job)
	if job.jobcost and not LocalPlayer():IsUnlocked(job.name) then return false end
	return true
end

local function IsJobNotRequired(job)
	if job.requiredjob and 
		not LocalPlayer():IsIgnoreRules("jobcost") and 
		not IsOpenedJob(FindJobByName(job.requiredjob)) then 

		return false, ENPC.Translate("Need to buy").." \""..job.requiredjob.."\"" 
	end

	return true
end

local function IsBlockedBy(job)
	local str = ""
	local time = false
	local level = false
	local total_time = LocalPlayer().GetUTimeTotalTime and LocalPlayer():GetUTimeTotalTime() or 0
	if job.playtime and not LocalPlayer():IsIgnoreRules("utime") and job.playtime > total_time then
		str = str..ENPC.Translate("Time")..": "..timeFormat(job.playtime-total_time).." "
		time = true
	end

	local total_level = LocalPlayer():getDarkRPVar('level') or 0
	if job.level and not LocalPlayer():IsIgnoreRules("level") and job.level > total_level then
		str = str..ENPC.Translate("Lvl")..": "..job.level
		level = true
	end

	if str == "" then
		return false, false, false
	else
		return str, time, level
	end
end

local function GetIconsTable(job)
	local tbl = {}
	if not IsAvailable(job) then
		table.insert(tbl, lock_mat)
	end
	local str, time, lvl = IsBlockedBy(job)
	local bought = IsBoughtJob(job)
	if time then table.insert(tbl, clock_mat)	end
	if lvl then	table.insert(tbl, star_mat) end
	if not bought then table.insert(tbl, money_mat) end
	return tbl
end

local blur = Material("pp/blurscreen")
local function drawBlur(panel, amount, passes)
	-- Intensity of the blur.
	amount = amount or 5
	
	if (useCheapBlur) then
		surface.SetDrawColor(50, 50, 50, amount * 20)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255)

		local x, y = panel:LocalToScreen(0, 0)
		
		for i = -(passes or 0.2), 1, 0.2 do
			-- Do things to the blur material to make it blurry.
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()

			-- Draw the blur material over the screen.
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end
end

local function IsBlurEnabled(panel)
	if ENPC.EnableBlur then
		ENPC.Colors.bg.a = 220
		ENPC.Colors.s_bg.a = 220
		ENPC.Colors.header.a = 220
		drawBlur(panel, 1, 3)
	end
end

function Derma_StringRequestCustom(whitelist, fnEnter, fnCancel)

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( ENPC.Translate("Add Job") )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )
	Window.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ENPC.Colors.header)
	end

	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetPaintBackground( false )

	local NameLabel = vgui.Create("DLabel", InnerPanel)
	NameLabel:SetText(ENPC.Translate("Select Job")..":")
	NameLabel:SetPos(10, 10)
	NameLabel:SizeToContents()	

	local DComboBox = vgui.Create( "DComboBox", InnerPanel )
	DComboBox:SetPos( 65, 7 )
	DComboBox:SetSize( 100, 20 )
	DComboBox:SetValue( ENPC.Translate("Jobs") )
	for k,v in pairs(RPExtraTeams) do
		if whitelist[v.name] then continue end
		DComboBox:AddChoice( v.name )	
	end

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( ENPC.Translate("OK") )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() fnEnter( DComboBox:GetValue() ) end

	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
	ButtonCancel:SetText( ENPC.Translate("Cancel") )
	ButtonCancel:SizeToContents()
	ButtonCancel:SetTall( 20 )
	ButtonCancel:SetWide( Button:GetWide() + 20 )
	ButtonCancel:SetPos( 5, 5 )
	ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( DComboBox:GetValue() ) end end
	ButtonCancel:MoveRightOf( Button, 5 )

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )

	local w, h = 135, 20

	Window:SetSize( w + 50, h + 25 + 75 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()

	return Window
end

local base_menu
local base

local function OpenSettingsMenu(ent, whitelist)
	if ValidPanel(base) then base:Remove(); base = nil end
	if ValidPanel(base_menu) then base_menu:Remove(); base_menu = nil end

	base = vgui.Create("DFrame")
	base:SetSize(600, 625)
	base:Center()
	base:MakePopup()
	base:SetTitle(ENPC.Translate("Settings"))
	base.Paint = function(slf, w, h)
		IsBlurEnabled(slf)
		draw.RoundedBox(0, 0, 0, w, h, ENPC.Colors.header)
	end

	base["ScrollPanel"] = vgui.Create("DScrollPanel", base)
	base["ScrollPanel"]:SetSize(base:GetWide(), base:GetTall()-25)
	base["ScrollPanel"]:SetPos(0, 25)
	base["ScrollPanel"].Paint = function(slf, w, h)
	end

	base["NameLabel"] = vgui.Create("DLabel", base["ScrollPanel"])
	base["NameLabel"]:SetText(ENPC.Translate("Name of NPC"))
	base["NameLabel"]:SetPos(10, 20)
	base["NameLabel"]:SizeToContents()	

	base["NameEntry"] = vgui.Create( "DTextEntry", base["ScrollPanel"] )
	base["NameEntry"]:SetPos( 75, 15 )
	base["NameEntry"]:SetSize( base:GetWide() -95, 25 )
	base["NameEntry"]:SetText( ent:GetNWString("CustomName") )

	base["ModelLabel"] = vgui.Create("DLabel", base["ScrollPanel"])
	base["ModelLabel"]:SetText(ENPC.Translate("Model path"))
	base["ModelLabel"]:SetPos(10, 50)
	base["ModelLabel"]:SizeToContents()	

	base["ModelEntry"] = vgui.Create( "DTextEntry", base["ScrollPanel"] )
	base["ModelEntry"]:SetPos( 75, 45 )
	base["ModelEntry"]:SetSize( base:GetWide() -95, 25 )
	base["ModelEntry"]:SetText( ent:GetModel() )

	base["NameLabel"] = vgui.Create("DLabel", base["ScrollPanel"])
	base["NameLabel"]:SetText(ENPC.Translate("Jobs List")..":")
	base["NameLabel"]:SetPos(10, 75)
	base["NameLabel"]:SetFont("DermaLarge")
	base["NameLabel"]:SizeToContents()	

	base["AvailableJob"] = vgui.Create("DListView", base["ScrollPanel"])
  base["AvailableJob"]:SetPos(5, 125)
  base["AvailableJob"]:SetSize(280, 420)
  base["AvailableJob"]:AddColumn(ENPC.Translate("Available"))

  base["SelectedJob"] = vgui.Create("DListView", base["ScrollPanel"])
  base["SelectedJob"]:SetPos(315, 125)
  base["SelectedJob"]:SetSize(280, 420)
  base["SelectedJob"]:AddColumn(ENPC.Translate("Selected"))

	for k,v in pairs(RPExtraTeams) do
  	if InWhitelist(whitelist, v.name) then continue end
  	base["AvailableJob"]:AddLine(v.name)
  end

   for k,v in pairs(whitelist) do
  	base["SelectedJob"]:AddLine(k)
  end

  AddPriv = vgui.Create("DButton", base["ScrollPanel"])
  AddPriv:SetPos(287, 125)
  AddPriv:SetSize(25, 25)
  AddPriv:SetText(">")
  AddPriv.DoClick = function()
      for k,v in pairs(base["AvailableJob"]:GetSelected()) do
          local priv = v.Columns[1]:GetValue()
          base["SelectedJob"]:AddLine(priv)
          base["AvailableJob"]:RemoveLine(v.m_iID)
      end
  end

  RemPriv = vgui.Create("DButton", base["ScrollPanel"])
  RemPriv:SetPos(287, 155)
  RemPriv:SetSize(25, 25)
  RemPriv:SetText("<")
  RemPriv.DoClick = function()
      for k,v in pairs(base["SelectedJob"]:GetSelected()) do
          local priv = v.Columns[1]:GetValue()
          base["AvailableJob"]:AddLine(priv)
          base["SelectedJob"]:RemoveLine(v.m_iID)
      end
  end

	base["BtnSaveSettings"] = vgui.Create("DButton", base)
	base["BtnSaveSettings"]:SetPos(0,base:GetTall()-50)
	base["BtnSaveSettings"]:SetSize(base:GetWide(),50)
	base["BtnSaveSettings"]:SetText(ENPC.Translate("Save"))
	base["BtnSaveSettings"]:SetFont("DermaLarge")
	base["BtnSaveSettings"]:SetTextColor(Color(255,255,255))
	base["BtnSaveSettings"].DoClick = function()
		local info = {
			name = base["NameEntry"]:GetValue(),
			model = base["ModelEntry"]:GetValue(),
		}
		info.whitelist = {}
		for k,v in pairs(base["SelectedJob"]:GetLines()) do
			info.whitelist[v:GetValue(1)] = true
		end
		net.Start("ENPC.SaveSettingsGS")
		net.WriteEntity(ent)
		net.WriteTable(info)
		net.SendToServer()
	end
	base["BtnSaveSettings"].Paint = function(slf, w, h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100))
		if slf:IsHovered() then
			slf:SetTextColor(Color( 255, 249, 149, 255 ))
		else
			slf:SetTextColor(Color(255,255,255,255))
		end
	end
end

local function OpenJobPanel(job)
	if ValidPanel(base_menu["JobPanel"]) then base_menu["JobPanel"]:Remove(); base_menu["JobPanel"] = nil end

	base_menu["JobPanel"] = vgui.Create("DPanel", base_menu)
	base_menu["JobPanel"]:SetSize(580, base_menu:GetTall()-80)
	base_menu["JobPanel"]:SetPos(210, 70)
	base_menu["JobPanel"].Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ENPC.Colors.s_bg)
		draw.DrawText(job.name, "JobsHeaderFont", w/2, 10, IsDark(job.color), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local curModel
	if type(job.model) == "table" then
		curModel = table.GetFirstValue( job.model )
	end

	base_menu.icon = vgui.Create( "DModelPanel", base_menu["JobPanel"] )
	base_menu.icon:SetSize(base_menu["JobPanel"]:GetWide()/2+50, base_menu["JobPanel"]:GetWide()/2+50)
	base_menu.icon:SetPos(base_menu["JobPanel"]:GetWide()/5,0)
	if type(job.model) == "table" then
		base_menu.icon:SetModel( curModel )
	else
		base_menu.icon:SetModel( job.model )
	end
	function base_menu.icon:LayoutEntity( ent )
		ent:SetAngles( Angle(0,45 + math.sin( CurTime() / 2 ) * 25,0) )
	end
	-- function base_menu.icon.Entity:GetPlayerColor() return Vector(1, 0, 0) end

	if type(job.model) == "table" and #job.model > 1 then
		base_menu["prevBtn"] = vgui.Create("DButton", base_menu["JobPanel"])
		base_menu["prevBtn"]:SetPos(5, 150)
		base_menu["prevBtn"]:SetSize(50, 50)
		base_menu["prevBtn"]:SetText("<")
		base_menu["prevBtn"]:SetTextColor(Color( 200, 200, 200 ))
		base_menu["prevBtn"]:SetFont("Trebuchet24")
		base_menu["prevBtn"].Paint = function()
		end
		base_menu["prevBtn"].DoClick = function()
			local nextModel = table.FindPrev( job.model, curModel )
			base_menu.icon:SetModel( nextModel )
			curModel = nextModel
		end

		base_menu["nextBtn"] = vgui.Create("DButton", base_menu["JobPanel"])
		base_menu["nextBtn"]:SetPos(base_menu["JobPanel"]:GetWide() - 50 -5, 150)
		base_menu["nextBtn"]:SetSize(50, 50)
		base_menu["nextBtn"]:SetText(">")
		base_menu["nextBtn"]:SetTextColor(Color( 200, 200, 200 ))
		base_menu["nextBtn"]:SetFont("Trebuchet24")
		base_menu["nextBtn"].Paint = function()
		end
		base_menu["nextBtn"].DoClick = function()
			local nextModel = table.FindNext( job.model, curModel )
			base_menu.icon:SetModel( nextModel )
			curModel = nextModel
		end
	end

	base_menu["descLabel"] = vgui.Create("DLabel", base_menu["JobPanel"])
	base_menu["descLabel"]:SetPos(40, base_menu["JobPanel"]:GetTall()/2+50) 
	base_menu["descLabel"]:SetSize(base_menu["JobPanel"]:GetWide(), 100)
	base_menu["descLabel"]:SetText(job.description)
	base_menu["descLabel"]:SetFont("JobsDescFont")
	base_menu["descLabel"]:SetAutoStretchVertical(true)
	base_menu["descLabel"]:SetWrap(true)
	base_menu["descLabel"]:SetTextColor(Color( 200, 200, 200 ))

	base_menu["selectBtn"] = vgui.Create("DButton", base_menu["JobPanel"])
	base_menu["selectBtn"]:SetPos(0, base_menu["JobPanel"]:GetTall()-40)
	base_menu["selectBtn"]:SetSize(base_menu["JobPanel"]:GetWide(), 40)
	base_menu["selectBtn"]:SetText("")
	base_menu["selectBtn"].DoClick = function()
		if IsBlockedBy(job) then return end
		if not IsAvailable(job) then return end
		if not IsBoughtJob(job) and IsJobNotRequired(job) then
			net.Start("ENPC.BuyJob")
			net.WriteInt(job.team, 16)
			net.SendToServer()
		else
			if type(job.model) == "table" then
				for _, team in pairs( team.GetAllTeams() ) do
					if team.Name == job.name then
						DarkRP.setPreferredJobModel(_, curModel)
					end
				end
			end
			net.Start("ENPC.ChangeJobNPC")
			net.WriteInt(job.team, 16)
			net.SendToServer()
			base_menu:Remove()
		end
	end
	base_menu["selectBtn"].Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,100))
		local can, message = IsAvailable(job)
		if not can then
			draw.SimpleText( message, "JobsHeaderFont", w/2, h/2+2, ENPC.Colors.unavailable, 1, 1 )
		else
			local available, time, level = IsBlockedBy(job)
			local bought, msg = IsBoughtJob(job)
			local required_, msg1 = IsJobNotRequired(job) 

			if available then
				draw.SimpleText( ENPC.Translate("Required").." "..available, "JobsHeaderFont", w/2, h/2+2, ENPC.Colors.unavailable, 1, 1 )
			elseif job.requiredjob and not required_ then
				draw.SimpleText( msg1, "JobsHeaderFont", w/2, h/2+2, ENPC.Colors.unavailable, 1, 1 )
			elseif job.jobcost and not bought then
				draw.SimpleText( msg..": "..DarkRP.formatMoney(job.jobcost), "JobsHeaderFont", w/2, h/2+2, color_white, 1, 1 )
			else
				draw.SimpleText( ENPC.Translate("Select"), "JobsHeaderFont", w/2, h/2+2, color_white, 1, 1 )
			end
		end
	end

end


net.Receive("ENPC.OpenNPCInteractiveMenu", function()
	local ent = net.ReadEntity()
	local whitelist = net.ReadTable()

	base_menu = vgui.Create("DFrame")
	base_menu:SetSize(800, 625)
	base_menu:Center()
	base_menu:MakePopup()
	base_menu:SetTitle("")
	base_menu:ShowCloseButton(false)
	base_menu.Paint = function(slf, w, h)
		IsBlurEnabled(slf)
		draw.RoundedBox(0, 0, 0, w, h, ENPC.Colors.bg)
		draw.RoundedBox(0, 0, 0, w, 60, ENPC.Colors.s_bg)
		draw.RoundedBox(0, 0, 0, 200, 60, ENPC.Colors.header)
		draw.SimpleText(ent:GetNWString("CustomName"), "JobsHeaderFont", 100, 30, color_white, 1, 1)
	end

	base_menu["ExitBtn"] = vgui.Create("DButton", base_menu)
	base_menu["ExitBtn"]:SetPos(base_menu:GetWide() - 20 - 15, 30-10)
	base_menu["ExitBtn"]:SetSize(20, 20)
	base_menu["ExitBtn"]:SetText("")
	base_menu["ExitBtn"].DoClick = function()
		if base_menu then base_menu:Remove() end
	end
	base_menu["ExitBtn"].Paint = function(slf, w, h)
		if slf:IsHovered() then
			draw_mat(close_mat, 0, 0, true)
		else
			draw_mat(close_mat, 0, 0)
		end
	end

	if LocalPlayer():IsSuperAdmin() then
		base_menu["SettingsBtn"] = vgui.Create("DButton", base_menu)
		base_menu["SettingsBtn"]:SetSize(20, 20)
		base_menu["SettingsBtn"]:SetPos(base_menu:GetWide() - 20 - 45, 30-10)
		base_menu["SettingsBtn"]:SetText("")
		base_menu["SettingsBtn"].Paint = function(slf, w, h)
			if slf:IsHovered() then
				draw_mat(settings_mat, 0, 0, true)
			else
				draw_mat(settings_mat, 0, 0)
			end
		end
		base_menu["SettingsBtn"].DoClick = function()
			OpenSettingsMenu(ent, whitelist)
		end
	end

	base_menu["ScrollPanel"] = vgui.Create("DScrollPanel", base_menu)
	base_menu["ScrollPanel"]:SetSize(200, base_menu:GetTall()-60)
	base_menu["ScrollPanel"]:SetPos(0, 60)
	base_menu["ScrollPanel"].Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, 200, h, ENPC.Colors.s_bg)
	end

	base_menu["JobList"] = vgui.Create("DIconLayout", base_menu["ScrollPanel"])
	base_menu["JobList"]:SetSize( base_menu["ScrollPanel"]:GetWide(), base_menu["ScrollPanel"]:GetTall())
	base_menu["JobList"]:SetPos( 0, 0 )
	base_menu["JobList"]:SetSpaceY( 5 )
	base_menu["JobList"]:SetSpaceX( 5 )

	local job_list = {}
	for k,v in pairs(RPExtraTeams) do
		if whitelist[v.name] then
			table.insert(job_list, v)
		end
	end

	for k,v in pairs(job_list) do
		base_menu["ColorJob"..k] = Color(97,97,97)
		base_menu["JobPanel"..k] = base_menu["JobList"]:Add("DPanel")
		base_menu["JobPanel"..k]:SetSize(base_menu["JobList"]:GetWide(), 40)
		base_menu["JobPanel"..k].Paint = function(slf, w, h)
			local iconsTbl = GetIconsTable(v)
			if slf.Selected then
				draw.RoundedBox(0, 0, 0, 5, h, IsDark(v.color))
				if #iconsTbl > 0 then
					draw.SimpleText(v.name, "JobsListFont", 15, h/2-10, ENPC.Colors.f_list, 0, 1)
				else
					draw.SimpleText(v.name, "JobsListFont", 15, h/2-2, ENPC.Colors.f_list, 0, 1)
				end
				local can, message = IsAvailable(v)
				if not can then
					draw.SimpleText(message, "JobsListSmallFont", 16, 21, ENPC.Colors.f_list, 0, 0)
				else
					local available, time, level = IsBlockedBy(v)
					local bought, msg = IsBoughtJob(v)
					local required_, msg1 = IsJobNotRequired(v)

					if available then
						draw.SimpleText(available, "JobsListSmallFont", 16, 21, ENPC.Colors.f_list, 0, 0)
					elseif v.requiredjob and not required_ then
						draw.SimpleText( msg1, "JobsListSmallFont", 16, 21, ENPC.Colors.f_list, 0, 0 )
					elseif v.jobcost and not bought then
						draw.SimpleText(msg..": "..DarkRP.formatMoney(v.jobcost), "JobsListSmallFont", 16, 21, ENPC.Colors.f_list, 0, 0)
					end 
				end
			else
				if #iconsTbl > 0 then
					draw.SimpleText(v.name, "JobsListFont", 10, h/2-10, ENPC.Colors.f_list, 0, 1)
				else
					draw.SimpleText(v.name, "JobsListFont", 10, h/2-2, ENPC.Colors.f_list, 0, 1)
				end
			end
			surface.SetDrawColor(Color(0,0,0,75))
			surface.DrawLine(8, h-1, w-16, h-1)
		end

		base_menu["IconLayot"] = vgui.Create("DIconLayout", base_menu["JobPanel"..k])
		base_menu["IconLayot"]:SetSize( base_menu["JobPanel"..k]:GetWide()-20, base_menu["JobPanel"..k]:GetTall()-20)
		base_menu["IconLayot"]:SetPos( 10, 20 )
		base_menu["IconLayot"]:SetSpaceY( 0 )
		base_menu["IconLayot"]:SetSpaceX( 5 )

		for _,z in pairs(GetIconsTable(v)) do
			base_menu["Icon"] = base_menu["IconLayot"]:Add("DPanel")
			base_menu["Icon"]:SetSize(15, 15)
			base_menu["Icon"].Paint = function(slf, w, h)
				if not base_menu["JobPanel"..k].Selected then
					draw_mat(z, 0, 0, true)
				end
			end
		end

		base_menu["JobBtn"..k] = vgui.Create("DButton", base_menu["JobPanel"..k])
		base_menu["JobBtn"..k]:SetPos(0, 0)
		base_menu["JobBtn"..k]:SetSize(base_menu["JobPanel"..k]:GetWide(), base_menu["JobPanel"..k]:GetTall())
		base_menu["JobBtn"..k]:SetText("")
		base_menu["JobBtn"..k].Paint = function(slf, w, h)
		end
		base_menu["JobBtn"..k].DoClick = function(slf)
			for _,but in pairs( base_menu["JobList"]:GetChildren() ) do
				but.Selected = false
			end
			base_menu["JobPanel"..k].Selected = true
			OpenJobPanel(v)
		end
	end

	if base_menu["JobBtn1"] then base_menu["JobBtn1"].DoClick() end
end)

net.Receive("ENPC.SyncJobs", function()
	local jobs = net.ReadTable()
	LocalPlayer().unlocked_jobs = jobs
end)

hook.Add( "Think", "ENPC.Think.Jobs", function()
	if not IsValid(LocalPlayer()) then return end
	LocalPlayer().unlocked_jobs = {}
	net.Start("ENPC.PlayerIsLoaded")
	net.SendToServer()
	hook.Remove("Think", "ENPC.Think.Jobs")
end)