AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function ENT:Initialize()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE,CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetMaxYawSpeed(90)

end
util.AddNetworkString('job_npc')
function ENT:AcceptInput(name, activator, call, data)
	local sid = call:SteamID()
	if name == "Use" and IsValid(call) and call:IsPlayer() then
		net.Start("job_npc")
		net.WriteEntity(self.Entity)
		net.Send(call)
	end
end
