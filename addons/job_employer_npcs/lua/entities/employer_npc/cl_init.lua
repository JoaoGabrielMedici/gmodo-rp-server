include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)
	
		cam.Start3D2D(self:GetPos()+self:GetUp()*80, Ang, 0.05)
			draw.SimpleTextOutlined( self:GetNWString("CustomName"), "ENPCFont", -3, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
	end
end