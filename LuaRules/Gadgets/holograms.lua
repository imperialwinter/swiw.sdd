-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Hologram",
		desc      = "Displays the holograms above some units",
		author    = "Maelstrom",
		date      = "17th October 2007",
		license   = "CC by-nc, version 3.0",
		layer     = 5,
		enabled   = false  -- loaded by default?
	}
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- speed-ups

local GetUnitDefID         = Spring.GetUnitDefID
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
local GetUnitExperience    = Spring.GetUnitExperience
local GetTeamList          = Spring.GetTeamList
local GetTeamUnits         = Spring.GetTeamUnits
local GetMyAllyTeamID      = Spring.GetMyAllyTeamID

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

if (gadgetHandler:IsSyncedCode()) then

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		SendToUnsynced("MexCreated", unitID, unitDefID, teamID)
	end

	function gadget:UnitDestroyed(unitID, unitDefID, unitTeamID)
		SendToUnsynced("MexDestroyed", unitID)
	end

else

	local glAlphaTest      = gl.AlphaTest
	local glBillboard      = gl.Billboard
	local glColor          = gl.Color
	local glDepthTest      = gl.DepthTest
	local glDepthMask      = gl.DepthMask
	local glDrawFuncAtUnit = gl.DrawFuncAtUnit
	local glTexRect        = gl.TexRect
	local glTexture        = gl.Texture
	local glTranslate      = gl.Translate
	local GetGameFrame = Spring.GetGameFrame
	local GetLocalTeamID = Spring.GetLocalTeamID
	local GetUnitDefDimensions = Spring.GetUnitDefDimensions
	local GetTeamColor = Spring.GetTeamColor
	local GetUnitHealth = Spring.GetUnitHealth
	local IsUnitVisible = Spring.IsUnitVisible
	local GetLocalPlayerID = Spring.GetLocalPlayerID
	local GetPlayerInfo = Spring.GetPlayerInfo
	local GetUnitPosition = Spring.GetUnitPosition
	local GetPositionLosState = Spring.GetPositionLosState
	local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID
	local GetAllUnits = Spring.GetAllUnits
	
	local GL_GREATER = GL.GREATER

		--Some local stuff
	local frame = 0
	local myTeam = 0
	local mex = { }
	local textures = { }

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
		gadgetHandler:AddSyncAction("MexCreated", MexCreated)
		gadgetHandler:AddSyncAction("MexDestroyed", MexDestroyed)
		gadgetHandler:AddSyncAction("MexSteal", MexSteal)
		gadgetHandler:AddSyncAction("MexStealStop", MexStealStop)

		local rawTextures = include("gamedata/LuaConfigs/hologram_defs.lua")
		textures = checkHoloDefs(rawTextures)
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

	function gadget:DrawWorld()

		frame = GetGameFrame()
		myTeam = GetLocalTeamID()

		glDepthMask(true)
		glDepthTest(true)
		glAlphaTest(GL_GREATER, 0.01)

		local _,_,spec = GetPlayerInfo(GetLocalPlayerID())
		local units = GetAllUnits()
		for i=1,#units do
			local uid = units[i]
			local udid = GetUnitDefID(uid)
			local ud = UnitDefs[udid]

			if ud then
				local unitname = ud.name
				if(ud.name == 'a_p_flag' 
					or ud.name == 'imp_p_flag' or ud.name == 'imp_p_flagecon1' or ud.name == 'imp_p_flagmil1' 
					or ud.name == 'reb_p_flag' or ud.name == 'reb_p_flagecon1' or ud.name == 'reb_p_flagmil1') then

						local x, y, z = GetUnitPosition(uid)
						local los,_,_,radar = GetPositionLosState(x,y,z,GetLocalAllyTeamID())
						if(los or spec) then
							glDrawFuncAtUnit(uid, false, DrawUnitFunc, mex[uid])
						end
				end
			end
		end
		glColor(1,1,1,1)

		glTexture(false)
		glAlphaTest(false)
		glDepthTest(false)
		glDepthMask(false)

	end

end
