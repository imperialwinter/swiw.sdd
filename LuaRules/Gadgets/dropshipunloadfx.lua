function gadget:GetInfo()
	return {
		name = "Dropship Unload Effect",
		desc = "Shows a dropship that unloads the constructed unit",
		author = "KDR_11k (David Becker)",
		date = "2008-10-29",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local LSspeedZ=.5
local LSspeedY=-.95

local APPROACH=1
local BRAKE=2
local LAND=3
local LANDED=4
local RAISE=5
local FLYOFF=6

local landFrames=100

local dropshipTypes, dropshipUnits = include("gamedata/LuaConfigs/dropship_defs.lua")

local function LandStraight(dropship,f)
	local u=dropship.unit
	local con=dropship.controls
	if con.ls==APPROACH then
		if f > con.brakeFrame then
			con.ls=BRAKE
		end
	elseif con.ls == BRAKE then
		if con.speed > 0.01 then
			con.speed=con.speed - .3
			Spring.MoveCtrl.SetRelativeVelocity(u,0,LSspeedY*con.speed,LSspeedZ*con.speed)
		else
			con.ls=LAND
			con.speed=0
			local headdiff = con.ang - con.thead
			if headdiff > 3.14159 then
				headdiff = headdiff - 6.28318
			elseif headdiff < -3.14159 then
				headdiff = headdiff + 6.28318
			end
			con.headdiff=headdiff/landFrames
			con.landframe=f + landFrames
			Spring.CallCOBScript(u,"Landing",0)
			Spring.MoveCtrl.SetRelativeVelocity(u,0,-1,0)
		end
	elseif con.ls == LAND then
		con.ang = con.ang - con.headdiff
		Spring.MoveCtrl.SetRotation(u,0,con.ang,0)
		if con.landframe<=f then
			con.ls=LANDED
			Spring.MoveCtrl.SetRelativeVelocity(u,0,0,0)
		end
	elseif con.ls == LANDED then
		--nothing
	else
		local pos = dropship.pos
		Spring.MoveCtrl.Enable(u)
		local thead = (dropship.heading / 32756 * 3.14159)
		local ang = math.random(-100000,100000)/100000 + thead
		local dist = 1200
		Spring.MoveCtrl.SetPosition(u, pos[1]-math.sin(ang)*dist, pos[2]+2400, pos[3]-math.cos(ang)*dist)
		Spring.MoveCtrl.SetRotation(u,0,ang,0)
		con.ang=ang
		con.speed=dropship.speed
		con.thead=thead
		Spring.MoveCtrl.SetRelativeVelocity(u,0,LSspeedY*con.speed,LSspeedZ*con.speed)
		con.brakeFrame=(dropship.frames+f)
		con.ls=APPROACH
	end
end

local function TakeoffVert(dropship,f)
	local u=dropship.unit
	local con=dropship.controls
	if con.ts==RAISE then
		if con.forward then
			Spring.MoveCtrl.SetRelativeVelocity(u,0,0 - LSspeedY*con.speed,0 - LSspeedZ*con.speed)
			if con.speed >0 then
				con.forward=false
			end
		else
			Spring.MoveCtrl.SetRelativeVelocity(u,0,con.speed,0)
		end
		if con.speed < 50 then
			con.speed = con.speed +.4
		else
			con.ts=FLYOFF
			con.flyoffFrame=f+100
		end
	elseif con.ts==FLYOFF then
		if con.flyoffFrame < f then
			Spring.DestroyUnit(u,false,true)
		end
	elseif con.ls then
		if con.ls == LANDED or con.ls==LAND then
			Spring.CallCOBScript(u,"Takeoff",0)
		end
		if con.speed > 0 then
			con.speed = - con.speed
			if con.ls == APPROACH or con.ls==BRAKING then
				con.forward=true
			end
		end
		con.ls=nil
		con.ts=RAISE
	end
end

local dropFunction = {
	["LandStraight"] = LandStraight,
	["TakeoffVert"] = TakeoffVert,
}
local useDropship={}
local dropshipWait={}
local dropship={}

function gadget:UnitCreated(u, ud, team, builder)
	if builder then
		if useDropship[ud] then
			local bud = Spring.GetUnitDefID(builder)
			local ds = useDropship[ud]
			local x,y,z=Spring.GetUnitPosition(u)
			local h = Spring.GetUnitHeading(u)
			local approachTime = dropshipUnits[UnitDefs[ud].name].approachTime or ds.approachTime
			local atBuild=1 - (approachTime / UnitDefs[ud].buildTime * UnitDefs[bud].buildSpeed) --Build completion at which the dropship will spawn
			dropshipWait[u]={
				ds=ds,
				pos={x,y,z},
				heading=h,
				atBuild=atBuild,
				ud=ud,
				team=team,
				speed=dropshipUnits[UnitDefs[ud].name].speed,
				frames=dropshipUnits[UnitDefs[ud].name].frames,
			}
			Spring.SetUnitNoDraw(u,true)
		end
	end
end

function gadget:AllowCommand(u,ud,team,cmd,param,opt)
	if dropship[u] then
		return false
	end
	return true
end

local function EndDropshipWait(u)
	Spring.SetUnitNoDraw(u,false)
	local d = dropshipWait[u]
	if d.dropship then
		local dr = dropship[d.dropship]
		if dr then
			dr.controlFunc=dropFunction[dr.ds.startFunc]
		end
	end
	dropshipWait[u]=nil
end

function gadget:UnitFinished(u, ud, team, builder)
	if dropshipWait[u] then
		if dropshipUnits[UnitDefs[ud].name].landceg then
			local x,y,z=Spring.GetUnitBasePosition(u)
			Spring.SpawnCEG(dropshipUnits[UnitDefs[ud].name].landceg, x, y, z, 0, 1.0, 0,0,0)
		end
		EndDropshipWait(u)
	end
end

function gadget:UnitDestroyed(u,ud,team)
	if dropshipWait[u] then
		EndDropshipWait(u)
	end
	if dropship[u] then
		dropship[u]=nil
	end
end

function gadget:GameFrame(f)
	if f%16 < .01 then
		for tu,d in pairs(dropshipWait) do
			if not d.dropship then
				local _,_,_,_,b = Spring.GetUnitHealth(tu) --build progress
				if b >= d.atBuild then
					local pos = d.pos
					nu = Spring.CreateUnit(d.ds.unitname,pos[1],pos[2],pos[3],0,d.team)
					local dr = {
						unit=nu,
						ds=d.ds,
						pos=pos,
						heading=d.heading,
						controlFunc=dropFunction[d.ds.landFunc],
						controls={},
						targetUnit=tu,
						speed=d.speed,
						frames=d.frames,
					}
					Spring.SetUnitNeutral(nu,true)
					Spring.SetUnitNoSelect(nu,true)
					dropship[nu]=dr
					--dr.controlFunc(dr,f)
					d.dropship=nu
				end
			end
		end
	end
	for u,d in pairs(dropship) do
		d.controlFunc(d,f)
	end
end

function gadget:Initialize()
	for unitname,d in pairs(dropshipUnits) do
		if dropshipTypes[d.dropship] then
			useDropship[d.id]=dropshipTypes[d.dropship]
		elseif d.dropship then
			Spring.Echo ("Unrecognized dropship type '"..d.dropship.."' on unit "..unitname)
		end
	end
	_G.dropshipWait=dropshipWait
end

else

--UNSYNCED

local rerolled=0
local flicker=1
local offset=0

function gadget:DrawWorld()
	local ateam = Spring.GetLocalAllyTeamID()
	offset=offset+.001
	if rerolled > 5 then
		if math.random(10)>8 then
			flicker=true
		else
			flicker=false
		end
		rerolled=0
	end
	rerolled=rerolled+1
	--gl.MultiTexGen(1,GL.S,GL.TEXTURE_GEN_MODE,GL.EYE_LINEAR)
	gl.MultiTexGen(1,GL.T,GL.TEXTURE_GEN_MODE,GL.EYE_LINEAR)
	gl.MultiTexGen(1,GL.T,GL.EYE_PLANE,0,.1,0,offset)
	if flicker then
		gl.Color(0.7,0.7,0.7,1)
	else
		gl.Color(1,1,1,1)
	end
	gl.Blending(GL.ONE,GL.ONE)
	gl.DepthTest(GL.LEQUAL)
	gl.Texture(1,":a:LuaRules/Images/interference.png")
	for u,d in spairs(SYNCED.dropshipWait) do
		local pos = d.pos
		gl.Texture(0,"%"..d.ud..":0")
		gl.Unit(u,true,0)
	end
	gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA)
	gl.Color(1,1,1,1)
	gl.Texture(0,false)
	gl.Texture(1,false)
	gl.MultiTexGen(1,GL.S,false)
	gl.MultiTexGen(1,GL.T,false)
	gl.DepthTest(false)
end

end
