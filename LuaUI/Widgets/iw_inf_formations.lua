function widget:GetInfo()
  return {
    name      = "IW/Infantry Formations",
    desc      = "Moves Infantry into square formations",
    author    = "TheFatController",
    date      = "16 January, 2010",
    license   = "MIT",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local GetSelectedUnits = Spring.GetSelectedUnits
local GiveOrderToUnit  = Spring.GiveOrderToUnit
local GetUnitPosition  = Spring.GetUnitPosition
local GetUnitDefID = Spring.GetUnitDefID
local myOrder = false
local moveMaps = {}
local SPACING = 30

local INFANTRY = {}
for defId,defs in pairs(UnitDefs) do
	if defs.moveData.name == "infantry1x1" then
	  INFANTRY[defId] = true
	end
end

local function getSqrDistance(x1,z1,x2,z2)
	local dx,dz = x1-x2,z1-z2
	return (dx*dx)+(dz*dz)
end

local function getMoveMap(size)
	if moveMaps[size] then
		return moveMaps[size]
	else
		moveMaps[size] = {}
		local rows = math.ceil(math.sqrt(size))
		local min = (SPACING * (rows / 2) * -1) - (SPACING/2)
		local c = 1
		for i=1,rows,1 do
			for j=1,rows,1 do
				if c > size then
					break
				else
					moveMaps[size][c] = {x = min + (i * SPACING), z = min + (j * SPACING)}
					c = c + 1
				end
			end
		end
		return moveMaps[size]
	end
end

function widget:CommandNotify(id, params, options)
	if (id == CMD.MOVE) and params[3] and (not myOrder) and (not options.ctrl) and options.coded then
	    local selUnits = GetSelectedUnits()
	    local count = #selUnits
		if (count > 1) then
			for i=1,count,1 do
				if (not INFANTRY[GetUnitDefID(selUnits[i])]) then
					return false
				end
			end
			local tx = params[1]
			local ty = params[2]
			local tz = params[3] 
			local ax = 0
			local az = 0
			local unitList = {}
			for i=1,count,1 do
				local x,_,z = GetUnitPosition(selUnits[i])
				ax = ax + x
				az = az + z
				local dist = getSqrDistance(x,z,tx,tz)
				unitList[i] = {dist=dist,unitID=selUnits[i],x=x,z=z}
			end
			table.sort(unitList, function(u1,u2) return u1.dist < u2.dist; end)
			local moveMap = getMoveMap(count)
			ax = (ax / count)
			az = (az / count)
			for i=1,count,1 do
				moveMap[i].dist = getSqrDistance(tx+moveMap[i].x,tz+moveMap[i].z,ax,az)
			end
			table.sort(moveMap, function(u1,u2) return u1.dist > u2.dist; end)
			myOrder = true
			for i=1,count,1 do
				GiveOrderToUnit(unitList[i].unitID,CMD.MOVE,{tx+moveMap[i].x,ty,tz+moveMap[i].z},options.coded)
			end
			myOrder = false
			return true
		end
	end
	return false
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
