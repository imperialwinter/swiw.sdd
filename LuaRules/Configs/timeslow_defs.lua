local array = {}

------------------------
-- Config

local MAX_SLOW_FACTOR = 1.1
-- Max slow damage on a unit = MAX_SLOW_FACTOR * current health
-- Slowdown of unit = slow damage / current health
-- So MAX_SLOW_FACTOR is the limit for how much units can be slowed

local DEGRADE_TIMER = 0.5
-- Time in seconds before the slow damage a unit takes starts to decay

local DEGRADE_FACTOR = 0.04
-- Units will lose DEGRADE_FACTOR*(current health) slow damage per second

local UPDATE_PERIOD = 15 -- I'd preffer if this was not changed


local weapons = {
	imp_d_ioncannon_with_slowcannon = { slowDamage = 0.000001, onlySlow = true, smartRetarget = 0.5, scaleSlow = true},}

------------------------
-- Send the Config

for name,data in pairs(WeaponDefNames) do
	
	if weapons[name] then 
		Spring.Echo(name)
		array[data.id] = weapons[name] 
	end
end

return array, MAX_SLOW_FACTOR, DEGRADE_TIMER*30/UPDATE_PERIOD, DEGRADE_FACTOR*UPDATE_PERIOD/30, UPDATE_PERIOD