function gadget:GetInfo()
	return {
		name = "Capture command",
		desc = "The flag capture command",
		author = "KDR_11k (David Becker)",
		date = "2008-10-03",
		license = "Public Domain",
		layer = 25,
		enabled = true
	}
end

local flagnames, capturernames, capweapon=VFS.Include("gamedata/LuaConfigs/flag_capture_defs.lua")
local capDist=WeaponDefs[capweapon].range
local CMD_CAPTURE_FLAG=35981

local flagUpgrades={
	[UnitDefNames.imp_p_flagecon1.id]=true,
	[UnitDefNames.imp_p_flagmil1.id]=true,
	[UnitDefNames.reb_p_flagecon1.id]=true,
	[UnitDefNames.reb_p_flagmil1.id]=true,
}

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local capturers={}
local flags={}
local closeDist=capDist*.7 --Distance to the flag to take when capping
local sqcloseDist = closeDist * closeDist

local GetUnitsInCylinder=Spring.GetUnitsInCylinder
local GetUnitAllyTeam=Spring.GetUnitAllyTeam
local GetUnitDefID=Spring.GetUnitDefID
local GetUnitPosition=Spring.GetUnitPosition
local GetUnitSeparation=Spring.GetUnitSeparation
local SetUnitMoveGoal=Spring.SetUnitMoveGoal
local InsertUnitCmdDesc=Spring.InsertUnitCmdDesc
local GiveOrderToUnit=Spring.GiveOrderToUnit
local sqrt=math.sqrt

local capDesc={
	name="Capture Flag", --must not match any built-in command AFAIK
	tooltip="Capture Flag: Attempt to capture a flag not in your possession",
	id=CMD_CAPTURE_FLAG,
	type=CMDTYPE.ICON_MAP, --probably better for handling flags the player cannot see
	cursor="Capture",
	action="capture",
}

function gadget:UnitCreated(u, ud, team)
	if capturers[ud] then
		InsertUnitCmdDesc(u,capDesc)
	end
end

function gadget:AllowCommand(u, ud, team, cmd, param, opt)
	if cmd == CMD_CAPTURE_FLAG then
		if capturers[ud] then
			return true
		else
			return false
		end
	else
		return true
	end
end

local moveGoals={}
local mgCount=1
local attacks={}
local aCount=1

local function AddMoveGoal(unitID,x,y,z,distance)
	moveGoals[mgCount]={
		unitID,x,y,z,distance
	}
	mgCount=mgCount+1
end

local function AddAttack(unitID,target)
	attacks[aCount]={
		unitID,target
	}
	aCount=aCount+1
end

function gadget:CommandFallback(u, ud, team, cmd, param, opt)
	if cmd == CMD_CAPTURE_FLAG then
		local x,_,z=GetUnitPosition(u)
		local dist=(param[1]-x)*(param[1]-x) + (param[3]-z)*(param[3]-z)
		if dist < sqcloseDist then --Don't magically know what to do, at least not from too far away
			local fl=GetUnitsInCylinder(param[1],param[3],capDist)
			local target=nil
			local allyteam=GetUnitAllyTeam(u)
			for i=1,#fl do --Check for capturable flags
				if GetUnitAllyTeam(fl[i]) ~= allyteam then
					if flags[GetUnitDefID(fl[i])] then
						target=fl[i]
						break
					elseif flagUpgrades[GetUnitDefID(fl[i])] then
						AddAttack(u,fl[i])
						return true,false --try again after the attack is done...
					end
				end
			end
			if target then --get close to the target just to be sure
				if GetUnitSeparation(u,target) > closeDist then
					local tx,ty,tz=GetUnitPosition(target)
					AddMoveGoal(u,tx,ty,tz,closeDist)
				end
				return true, false
			else --we're done, remove the command
				return true, true
			end
		else
			AddMoveGoal(u,param[1],param[2],param[3],0)
			return true, false
		end
	end
	return false
end

function gadget:GameFrame(f)
	for i=1,mgCount-1 do
		local mg=moveGoals[i]
		SetUnitMoveGoal(mg[1],mg[2],mg[3],mg[4],mg[5])
	end
	moveGoals={}
	mgCount=1
	for i=1,aCount-1 do
		local a=attacks[i]
		GiveOrderToUnit(a[1],CMD.INSERT,{0,CMD.ATTACK,0,a[1]},{"alt"})
	end
	attacks={}
	aCount=1
end

function gadget:Initialize()
	for _,un in pairs(flagnames) do
		flags[UnitDefNames[un].id]=true
	end
	for un,_ in pairs(capturernames) do
		capturers[UnitDefNames[un].id]=true
	end
end

else

--UNSYNCED

function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_CAPTURE_FLAG,"Capture",{1,.1,.1,1})
end

end
