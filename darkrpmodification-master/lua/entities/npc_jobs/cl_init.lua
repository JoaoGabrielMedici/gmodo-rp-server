include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end
net.Receive("job_npc", function( len, ply)
	local entl = net.ReadEntity()
	local title = entl:GetNWString("Title")
	local text = entl:GetNWString("Textone")
	local yes =	entl:GetNWString("Yes")
	local no =	entl:GetNWString("No")
	local model = entl:GetNWString("SpawnModel")
	local command = entl:GetNWString("Command")
	
	
	
	--[ Main Frame ]--
	if IsValid(frame) then
	 frame:Remove()
	end	
	local frame = vgui.Create("DFrame")
	frame:SetSize( 585,200)
	frame:MakePopup()
	frame:SetTitle("")	
	frame.Paint = function(pnl,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
		draw.RoundedBox(0,0,0,w,25,Color(125,125,125,255))
		draw.SimpleText( title,"JobsHeadText", 5, 2.5,Color(255,255,255))
		surface.SetDrawColor(Color(0, 0, 0))
		surface.DrawLine( 173, 25, 173, pnl:GetTall())
		surface.DrawLine( 0, 25, pnl:GetWide(), 25)
		surface.DrawOutlinedRect( 0, 0, w, h)
	end
	frame.Close = function(pnl)
		pnl:Remove()
	end
	frame:Center()
	local ListItem = vgui.Create("SpawnIcon", frame) 
		ListItem:SetSize( 173, 173 ) 
		ListItem:SetPos( 1, 26 )
		ListItem:SetModel(model)
	
	local DScrollPanel = vgui.Create( "DScrollPanel", frame )
		DScrollPanel:SetSize( 400, 150 )
		DScrollPanel:SetPos( 178, 30 )
		
	local TextPanel =  vgui.Create( "DPanel", DScrollPanel )
		TextPanel:SetSize( 400, 140)
		TextPanel.Paint = function(pnl, w, h)
		--	draw.RoundedBox(0,0,0,w,h,Color(125,125,125,200))
			draw.DrawNonParsedText( text, "TargetID", 0, 0, Color(0, 0, 0), 0)
		end
	local button = vgui.Create("DButton", frame)
		button:SetSize( 200, 20)
		button:SetPos( 178, 170)
		button:SetText(yes)
		button.DoClick = function(pnl, w, h)
			LocalPlayer():ConCommand("say "..command)
			frame:Remove()
		end
	
	local obutton = vgui.Create("DButton", frame)
		obutton:SetSize( 200, 20)
		obutton:SetPos( 378, 170)
		obutton:SetText(no)
		obutton.DoClick = function(pnl, w, h)
			frame:Remove()
		end
end)

