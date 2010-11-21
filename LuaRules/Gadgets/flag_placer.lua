function gadget:GetInfo()
   return {
      name      = "Flag placer",
      desc      = "Places holobeacons on the map",
      author    = "user/Gnome/TheFatController", --Profile loader segment by Gnome, automatic map parser by user
      date      = "August 2008",
      license   = "CC by-nc, version 3.0",
      layer     = -5,
      enabled   = true  --  loaded by default?
   }
end

--------------------------------------------------------------------------------

if (gadgetHandler:IsSyncedCode()) then

local spawnList = {}
local placedList = {}
local hideFlags = {}
local flagDefs
local mapProfile
local flagnum = 1
local updateFrame = 2
local spawnCount = 0
local gaiaID
local SetUnitNeutral = Spring.SetUnitNeutral
local SetUnitBlocking = Spring.SetUnitBlocking
local GetUnitDefID = Spring.GetUnitDefID
local GetGroundInfo = Spring.GetGroundInfo
local GetGroundHeight = Spring.GetGroundHeight
local SetUnitCOBValue = Spring.SetUnitCOBValue
local GetUnitCOBValue = Spring.GetUnitCOBValue
local SetUnitAlwaysVisible = Spring.SetUnitAlwaysVisible

local function getDistance(x1,z1,x2,z2)
  local dx,dz = x1-x2,z1-z2
  return (dx*dx)+(dz*dz)
end

function gadget:Initialize()

	flagDefs = VFS.Include('gamedata/LuaConfigs/flag_spawner.lua')
	if not flagDefs then
		Spring.Echo("Neutral Flag Spawner - no mod profile found. Gamedata/LuaConfigs/flag_spawner.lua")
		gadgetHandler:RemoveGadget()
	end

	local mapProfileName = string.gsub(Game.mapName, '.smf', '.lua', 1)
	if(VFS.FileExists('maps/' .. mapProfileName)) then
		mapProfile = VFS.Include('maps/' .. mapProfileName)
	end
	
	if(mapProfile) then
		for _,hotspot in ipairs(mapProfile) do
			table.insert(spawnList, {unitName = flagDefs.neutralFlag, x = hotspot.x, z = hotspot.z, feature = hotspot.feature})
		end
	else
		local metalmap = {}                --the metal map array
		local mapx = Game.mapX*64          --the metal map x
		local mapy = Game.mapY*64          --the metal map y
		local result = 0
		local offset = 32
		local exr = math.max(Game.extractorRadius, 64)
		exr = (exr * exr)
		for i = 8,mapx-8,1 do
			metalmap[i] = {}
			for j = 8,mapy-8,1 do
				_,metalmap[i][j] = GetGroundInfo(i*8,j*8)
				result = result + metalmap[i][j] --add all them to result
			end
		end	
		
		result = result / (mapx*mapy) --divide result by the number of metal values in the map
		
		if (result > 1) then
			result = (result / 4)
		else
			exr = (exr * 2.5)
		end
		
		for i = 8,mapx-8,1 do
			for j = 8,mapy-8,1 do
				if (metalmap[i][j] > (result*10)) then
					local good = true
					if(GetGroundHeight((i*8)+offset,(j*8)+offset) < 0) then
						good = false
						break
					else
						for _,placedDefs in pairs(placedList) do
						    local dist = getDistance(((i*8)+offset),((j*8)+offset),placedDefs.x,placedDefs.z)
							if (dist <= exr) then
								good = false
								break
							end
						end
					end
					if good then
						table.insert(spawnList, {unitName = flagDefs.neutralFlag, x = ((i*8)+offset), z = ((j*8)+offset), feature = flagDefs.defaultFeature})
					    table.insert(placedList, {x = ((i*8)+offset), z = ((j*8)+offset)})
					end								
				end
			end
		end
		
		placedList = nil
		spawnCount = #spawnList
		
	end
	
	
end

local counter=0 --counts over all frames

function gadget:GameFrame(n)

    if n == updateFrame then
        gaiaID = Spring.GetGaiaTeamID()

        local count = 0
        local limit = (spawnCount / 5)

		for i,spawnDef in pairs(spawnList) do
			local flagID = Spring.CreateUnit(spawnDef.unitName,spawnDef.x,0,spawnDef.z,0,gaiaID)
			SetUnitNeutral(flagID,true)
			Spring.SetUnitNoDraw(flagID, true)
			Spring.SetUnitNoMinimap(flagID, true)
			SetUnitAlwaysVisible(flagID,true)
			counter=counter+1
			SetUnitCOBValue(flagID,4096,counter) --4096 = first global var
			SetUnitCOBValue(flagID,4096+counter,GetUnitCOBValue(flagID,9)) --9 = UNIT_XZ

			hideFlags[flagID] = true

			local flag = {}
			flag.x = spawnDef.x
			flag.z = spawnDef.z
			flag.teamID = gaiaID
			flag.allyID = -1
			flag.unitList = {}
			flag.unitRepairList = {}
			flag.unitID = flagID
			flag.unitDefID = GetUnitDefID(flagID)
			flag.name = UnitDefs[flag.unitDefID].name
			flag.alwaysVisible = false
			_G.flags[flagnum] = flag
			flagnum = flagnum + 1		
		
			if spawnDef.feature then
				Spring.CreateFeature(spawnDef.feature,spawnDef.x,100,spawnDef.z,0)
			end
		
			spawnList[i] = nil
			count = count + 1
			if count > limit then
			  updateFrame = n+1
			  break
			end
			
		end	
	
    end
    
    if n == (updateFrame+25) then
      for flagID in pairs(hideFlags) do
        SetUnitAlwaysVisible(flagID,false)
      end
    end
    
    if n > (updateFrame+35) then
      for flagID in pairs(hideFlags) do
		Spring.SetUnitNoDraw(flagID, false)
		Spring.SetUnitNoMinimap(flagID, false)
	  end
      gadgetHandler:RemoveGadget()
    end
    
        
end --end GameFrame()

end --end synced
