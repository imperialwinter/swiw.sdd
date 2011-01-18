function gadget:GetInfo()
	return {
		name      = "Flag Graphics",
		desc      = "Displays capture radius and Holograms for flags",
		author    = "Maelstrom/Gnome/TheFatController",
		date      = "November 2009",
		license   = "CC by-nc, version 3.0",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

	function gadget:GameFrame(n)
		SendToUnsynced("fg_GameFrame", n)
	end

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		SendToUnsynced("MexCreated", unitID, unitDefID, teamID)
	end

	function gadget:UnitDestroyed(unitID, unitDefID, unitTeamID)
		SendToUnsynced("MexDestroyed", unitID)
	end
else

local weaponRange = 1

local GetAllUnits = Spring.GetAllUnits
local IsGUIHidden = Spring.IsGUIHidden
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitPosition = Spring.GetUnitPosition
local GetPositionLosState = Spring.GetPositionLosState
local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID
local GetPlayerInfo = Spring.GetPlayerInfo
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitAllyTeam = Spring.GetUnitAllyTeam
local IsUnitSelected = Spring.IsUnitSelected
local GetFPS = Spring.GetFPS

local glColor = gl.Color
local glDepthTest = gl.DepthTest
local glDrawGroundCircle = gl.DrawGroundCircle
local glTexture = gl.Texture
local glTranslate = gl.Translate
local glBillboard = gl.Billboard
local glTexRect = gl.TexRect
local glDepthMask = gl.DepthMask
local glAlphaTest = gl.AlphaTest
local glDrawFuncAtUnit = gl.DrawFuncAtUnit
local GL_GREATER = GL.GREATER

local playerID = Spring.GetLocalPlayerID()
local units = {}
local mex = { }
local textures = { }
local frame = 0
local lastFrame = 0
local myTeam = 0
local fadein = 0

local isFlag = {
  ['a_p_flag'] = 1,
  ['imp_p_flag'] = 1,
  ['imp_p_flagecon1'] = 0,
  ['imp_p_flagmil1'] = 0,
  ['reb_p_flag'] = 1,
  ['reb_p_flagecon1'] = 0,
  ['reb_p_flagmil1'] = 0,
}

local teamColors = {}
local function GetTeamColor(teamID)
  local color = teamColors[teamID]
  if (color) then
    return color[1],color[2],color[3]
  end
  local r,g,b = Spring.GetTeamColor(teamID)
  color = { r, g, b }
  teamColors[teamID] = color
  return r, g, b
end

local function MexCreated(command, unitID, unitDefID, unitTeamID)
		-- If the unit is a mex
	if textures.holoDefID[unitDefID] then
			-- If the height hasnt been initialized
		if UnitDefs[unitDefID].height == nil then
			UnitDefs[unitDefID].height = GetUnitDefDimensions(unitDefID).height
		end
				-- Assigning the colours
		mex[unitID] = {}
		local colour = {}
		colour[1], colour[2], colour[3] = GetTeamColor(unitTeamID)
		colour[1] = colour[1] * 0.5 + 0.5
		colour[2] = colour[2] * 0.5 + 0.5
		colour[3] = colour[3] * 0.5 + 0.5
		colour[4] = 1
		mex[unitID].colour = colour
				--Unit ID, side, ect
		mex[unitID].id = unitID
		mex[unitID].side = textures.holoDefID[unitDefID]
		mex[unitID].tex = textures.textures[mex[unitID].side]
		mex[unitID].animOffset = math.random(100)
		mex[unitID].steal = false
		mex[unitID].defID = unitDefID
	end

end

local function MexDestroyed(unitID)
	mex[unitID] = nil
end

local function MexSteal(command, unitID)
	if mex[unitID] then
		mex[unitID].steal = true
	end
end

local function MexStealStop(command, unitID)
	if mex[unitID] then
		mex[unitID].steal = false
	end
end

local function checkHoloDefs(rawTextures)
	for name, texClass in pairs(rawTextures.textures) do
		texClass.iconsize = texClass.iconsize * 0.5
		texClass.frameLength = 1 / texClass.frameLength
	end
	return rawTextures
end

function gadget:Initialize()
	local flagNames, captureNames, weaponID = include("gamedata/LuaConfigs/flag_capture_defs.lua")

	local weaponDef = WeaponDefs[weaponID]
	if weaponDef ~= nil then
		weaponRange = weaponDef.range
	else
		Spring.Echo("Flag range display - Bad weapon '" .. weaponID .. "'")
	end
	gadgetHandler:AddSyncAction("fg_GameFrame", GameFrame)
	gadgetHandler:AddSyncAction("MexCreated", MexCreated)
	gadgetHandler:AddSyncAction("MexDestroyed", MexDestroyed)
	gadgetHandler:AddSyncAction("MexSteal", MexSteal)
	gadgetHandler:AddSyncAction("MexStealStop", MexStealStop)
	
	local rawTextures = include("gamedata/LuaConfigs/hologram_defs.lua")
	textures = checkHoloDefs(rawTextures)
		
	playerID = Spring.GetLocalPlayerID()
end

local function DrawUnitFunc(mex)
	local texs

		-- Working out which texture set to use
	if mex.steal then
		texs = mex.tex.steal
	else
		texs = mex.tex.normal
	end
			-- Working out which tex frame to use
	local texFrame = (math.floor((frame + mex.animOffset) * mex.tex.frameLength % #texs) + 1)
	local curTex = texs[texFrame]
	glTexture(curTex)

		-- Working out the health
	local health, maxHealth = GetUnitHealth(mex.id)
	mex.colour[4] = (health / maxHealth) * 0.8

		-- Drawing the thing
	glColor(mex.colour)
	glTranslate(mex.tex.xshift, mex.tex.yshift, mex.tex.zshift)
	glBillboard()
	glTexRect(-mex.tex.iconsize, -mex.tex.iconsize, mex.tex.iconsize, mex.tex.iconsize)
end

function gadget:DrawWorldPreUnit()
	if (not IsGUIHidden()) then
		glDepthTest(true)
		for _,defs in ipairs(units) do
			glColor(defs.r,defs.g,defs.b,defs.alpha * fadein)
			glDrawGroundCircle(defs.x,defs.y,defs.z,weaponRange * fadein,32)
		end
		glDepthTest(false)
		glColor(1,1,1,1)
	end
end

function gadget:DrawWorld()
	if (lastFrame ~= frame) then
		lastFrame = frame
		local _,_,spec = GetPlayerInfo(playerID)
		local allUnits = GetAllUnits()
		local allyTeamID = GetLocalAllyTeamID()
		if frame > 90 then
		  GetAllUnits = Spring.GetVisibleUnits
		end
		units = {}
		for i=1,#allUnits do
		  local unitID = allUnits[i]
		  local ud = UnitDefs[GetUnitDefID(unitID)]
		  if ud and isFlag[ud.name] then
			local x, y, z = GetUnitPosition(unitID)
			local los,_,_,radar = GetPositionLosState(x,y,z,allyTeamID)
			local r,g,b = 1,1,1
			local id = nil
			if (spec or los) then
			  r,g,b = GetTeamColor(GetUnitTeam(unitID))
			  id = unitID
			elseif radar and (isFlag[ud.name] ~= 0) then
			  r,g,b = GetTeamColor(GetUnitTeam(unitID))
			end
			local alpha = 0.5
			if GetUnitAllyTeam(unitID) == allyTeamID then
			  if (IsUnitSelected(unitID)) then
			    alpha = 0.75
			  else
			    alpha = 0.3
			  end
			end
			table.insert(units, {x = x, y = y, z = z, r = r, g = g, b = b, unitID = id, alpha = alpha})
		  end
		end
	end

	if (fadein < 1) and next(units) then
		fadein = fadein + (1 / GetFPS())
		if (fadein > 1) then
		  fadein = 1
		end
	end

	glDepthMask(true)
	glDepthTest(true)
	glAlphaTest(GL_GREATER, 0.01)

	for _,defs in ipairs(units) do
	  if defs.unitID then
		glDrawFuncAtUnit(defs.unitID, false, DrawUnitFunc, mex[defs.unitID])
	  end
	end

	glColor(1,1,1,1)
	glTexture(false)
	glAlphaTest(false)
	glDepthTest(false)
	glDepthMask(false)
end

function GameFrame(_,n)
    frame = n
end

end
