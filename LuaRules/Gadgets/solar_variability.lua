function gadget:GetInfo()
   return {
      name      = "Solar variability",
      desc      = "Randomly changes energy output of solars",
      author    = "Gnome",
      date      = "September 2008",
      license   = "PD",
      layer     = -5,
      enabled   = true  --  loaded by default?
   }
end

if (gadgetHandler:IsSyncedCode()) then

local solar = UnitDefNames["imp_p_solar"].id
local eMin = 18
local eMax = 28
local updateFreq = 10 --in seconds

local GetAllUnits = Spring.GetAllUnits
local GetUnitDefID = Spring.GetUnitDefID
local SetUnitResourcing = Spring.SetUnitResourcing
local rand = math.random

function gadget:GameFrame(n)
	if(n % (updateFreq * 30) < 1) then
		local units = GetAllUnits()
		local e = rand(eMin * 2,eMax * 2) -- for some reason spring only gave half
		for _,uid in ipairs(units) do
			udid = GetUnitDefID(uid)
			if(udid == solar) then
				SetUnitResourcing(uid,"ume",e)
			end
		end
	end
end

end
