function gadget:GetInfo()
	return {
		name = "Area Attack",
		desc = "Give area attack commands to ground units",
		author = "KDR_11k (David Becker)",
		date = "2008-01-20",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local attackList={}
local CMD_AREAATTACK = 39954

local aadesc= {
	name="Area Attack",
	cursor='Attack',
	action="areaattack",
	id=CMD_AREAATTACK,
	type=CMDTYPE.ICON_AREA,
	tooltip="Attack an area randomly",
}

function gadget:GameFrame(f)
	for i,o in pairs(attackList) do
		attackList[i] = nil
		local phase = math.random(200*math.pi)/100.0
		local amp = math.random(o.radius)
		Spring.GiveOrderToUnit(o.unit, CMD.INSERT, {0, CMD.ATTACK, 0, o.x + math.cos(phase)*amp, o.y, o.z + math.sin(phase)*amp}, {"alt"})
	end
end

function gadget:CommandFallback(u,ud,team,cmd,param,opt)
	if cmd == CMD_AREAATTACK then
		table.insert(attackList, {unit = u, x=param[1], y=param[2], z=param[3], radius=param[4]})
		return true, false
	end
	return false
end

function gadget:UnitCreated(u, ud, team)
	if UnitDefs[ud].customParams.canareaattack=="1" then
		Spring.InsertUnitCmdDesc(u,aadesc)
	end
end

end
