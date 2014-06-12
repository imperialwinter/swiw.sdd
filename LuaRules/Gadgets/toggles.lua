function gadget:GetInfo()
	return {
		name = "toggles",
		desc = "easy toggles",
		author = "KDR_11k (David Becker)",
		date = "2008-02-10",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local CMD_TOGGLE=35950
local maxToggles=3
local toggleValue=1028

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local toggleUnit={}

local InsertUnitCmdDesc=Spring.InsertUnitCmdDesc
local EditUnitCmdDesc=Spring.EditUnitCmdDesc
local FindUnitCmdDesc=Spring.FindUnitCmdDesc
local CallCOBScript=Spring.CallCOBScript

function gadget:UnitCreated(u, ud, team)
	if toggleUnit[ud] then
		for t,d in pairs(toggleUnit[ud]) do
			InsertUnitCmdDesc(u, {
				id = CMD_TOGGLE + t,
				type=CMDTYPE.ICON_MODE,
				name=d.on,
				tooltip=d.tooltipname .. ": " .. d.tooltip,
				action="toggle"..t,
				params={"0",d.off,d.on}
			})
		end
	end
end

function gadget:AllowCommand(u, ud, team, cmd, param, opt)
	if cmd > CMD_TOGGLE and cmd <= CMD_TOGGLE + maxToggles then
		if toggleUnit[ud] and toggleUnit[ud][cmd - CMD_TOGGLE] then
			local toggle=toggleUnit[ud][cmd - CMD_TOGGLE]
			local f = FindUnitCmdDesc(u,cmd)
			EditUnitCmdDesc(u,f,{ params={param[1],toggle.off, toggle.on}})
			CallCOBScript(u, "Toggle", 0, cmd - CMD_TOGGLE, param[1])
		end
		return false
	end
	return true
end

function gadget:Initialize()
	for ud,d in pairs(UnitDefs) do
		local toggles={}
		for i=1,maxToggles do
			if d.customParams["toggle"..i] then
				toggles[i]={
					on=d.customParams["toggle"..i.."on"],
					off=d.customParams["toggle"..i.."off"],
					tooltip=d.customParams["toggle"..i.."tooltip"],
					tooltipname=d.customParams["toggle"..i.."tooltipname"],
				}
			else
				break --toggles must be consecutive
			end
		end
		if #toggles > 0 then
			toggleUnit[ud]=toggles
		end
	end
end

else

--UNSYNCED

return false

end
