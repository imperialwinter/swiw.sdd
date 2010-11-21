#ifndef STANDARD_COMMANDS_H_
#define STANDARD_COMMANDS_H_

// Vector-based special effects
#define	SFXTYPE_WAKE1			3

// Point-based (piece origin) special effects
#define SHATTER			1	// Has odd effects in S3O.
#define EXPLODE_ON_HIT		2	// DOES NOT WORK PROPERLY IN SPRING
#define FALL			4	// The piece will fall due to gravity, based partially on myGravity value
#define SMOKE			8	// A smoke trail will follow the piece through the air
#define FIRE			16	// A fire trail will follow the piece through the air
#define BITMAPONLY		32	// DOES NOT WORK PROPERLY IN SPRING

// Bitmap Explosion Types
#define BITMAP			10000001

// Indices for set/get value
#define ACTIVATION		1	// set or get, used by all scripts that call Activate() through UI or BOS command
#define STANDINGMOVEORDERS	2	// set or get, now works in 0.75b to set all states (Hold Position, Manuever, Roam).  Values 0, 1, 2
#define STANDINGFIREORDERS	3	// set or get, now works in 0.75b to set all states (Hold Fire, Fire at Will, Fire Back).  Values 0, 1, 2
#define HEALTH			4	// set or get, in 0.74b or above
#define INBUILDSTANCE		5	// set or get, used to tell Spring that a Factory is now able to build objects and emit nano-particles
#define BUSY			6	// set or get, will operate in Spring to pause loading state for flying transports only
#define PIECE_XZ		7	// get, for position calculation, returns two values
#define PIECE_Y			8	// get, for position calculation, returns one value
#define UNIT_XZ			9	// get, for position calculation of Unit, reads from centroid of Base
#define UNIT_Y			10	// get, for position calculation of Unit, reads from centroid of Base 
#define UNIT_HEIGHT		11	// get, for position calculation of Unit, reads from .S3O height value
#define XZ_ATAN			12	// get atan of packed x,z coords
#define XZ_HYPOT		13	// get hypot of packed x,z coords
#define ATAN			14	// get ordinary two-parameter atan, as integer
#define HYPOT			15	// get ordinary two-parameter hypot, as integer
#define GROUND_HEIGHT		16	// get, asks Spring for value of GROUND_HEIGHT based on map values
#define BUILD_PERCENT_LEFT	17	// get 0 = unit is built and ready, 1-100 = How much is left to build
#define YARD_OPEN		18	// set or get (change which plots we occupy when building opens and closes)
#define BUGGER_OFF		19	// set or get (ask other units to clear the area)  // This works in Spring, causes Units to try to move a minimum distance away, when invoked!
#define ARMORED			20	// set or get.  Turns on the Armored state.  Uses value of Armor, defined in unit FBI, which is a float, in Spring, as a multiple of health.
#define IN_WATER		28	// get only.  If unit position Y less than 0, then the unit must be in water (0 Y is the water level).
#define CURRENT_SPEED  		29	// set can allow code to halt units, or speed them up to their maximum velocity.
#define VETERAN_LEVEL  		32	// set or get.  Can make units super-accurate, or keep them inaccurate.
#define MAX_ID			70	// get only.  Returns maximum number of units - 1
#define MY_ID			71	// get only.  Returns ID of current unit
#define UNIT_TEAM		72	// get only.  Returns team of unit given with parameter
#define UNIT_BUILD_PERCENT_LEFT	73	// get only.  BUILD_PERCENT_LEFT, but comes with a unit parameter.
#define UNIT_ALLIED		74	// get only.  Is this unit allied to the unit of the current COB script? 1=allied, 0=not allied
#define MAX_SPEED		75	// set only.  Alters MaxVelocity for the given unit.
#define CLOAKED			76	// set or get.  Gets current status of cloak.
#define WANT_CLOAK		77	// set or get.  Gets current value of WANT_CLOAK (1 or 0)
#define GROUND_WATER_HEIGHT	78	// get only.  Returns negative values if unit is over water.
#define UPRIGHT			79	// set or get.  Can allow you to set the upRight state of a Unit.
#define POW			80	// get the power of a number
#define PRINT			81	// get only. Prints the value of up to 4 vars / static-vars into the Spring chat
#define HEADING			82	// set and get.  Allows unit HEADING to be returned, SET to keep units from turning.
#define TARGET_ID		83	// get.  Returns ID of currently targeted Unit.  -1 if none, -2 if force-fire, -3 if Intercept, -4 if the Weapon doesn't exist.
#define LAST_ATTACKER_ID	84	// get.  Returns ID of last Unit to attack, or -1 if never attacked.
#define LOS_RADIUS		85	// set.  Sets the LOS Radius (per Ground).
#define AIR_LOS_RADIUS		86	// set.  Sets the LOS Radius (per Air).
#define RADAR_RADIUS		87 	// set or get, just like the Unit def.
#define JAMMER_RADIUS          	88 	// set or get, just like the Unit def.
#define SONAR_RADIUS		89 	// set or get, just like the Unit def.
#define SONAR_JAM_RADIUS       	90 	// set or get, just like the Unit def.
#define SEISMIC_RADIUS		91 	// set or get, just like the Unit def.
#define DO_SEISMIC_PING		92	// get (get DO_SEISMIC_PING(size)) Emits a Seismic Ping.
#define CURRENT_FUEL		93 	// set or get
#define TRANSPORT_ID		94	// get.  Returns ID of the Transport the Unit is in.  -1 if not loaded.
#define SHIELD_POWER		95	// set or get
#define STEALTH			96	// set or get
#define CRASHING		97	// set or get, returns whether aircraft isCrashing state
#define CHANGE_TARGET		98	// set, the value it's set to determines the affected weapon
#define CEG_DAMAGE		99	// set
#define COB_ID			100	// get
#define PLAY_SOUND		101	// get, http://spring.clan-sy.com/mantis/view.php?id=690
#define KILL_UNIT		102	// get KILL_UNIT(targetunitid) - kills unit calling it if no unitid specified
#define ALPHA_THRESHOLD		103	// set or get
#define SET_WEAPON_UNIT_TARGET	106	// get (fake set)
#define SET_WEAPON_GROUND_TARGET	107	// get (fake set)
#define SONAR_STEALTH		108	// set or get

#define LUA0			110
#define LUA1			111
#define LUA2			112
#define LUA3			113
#define LUA4			114
#define LUA5			115
#define LUA6			116
#define LUA7			117
#define LUA8			118
#define LUA9			119

#define FLANK_B_MODE		120	// set or get
#define FLANK_B_DIR		121	// set or get, set is through get for multiple args
#define FLANK_B_MOBILITY_ADD	122	// set or get
#define FLANK_B_MAX_DAMAGE	123	// set or get
#define FLANK_B_MIN_DAMAGE	124	// set or get

#define WEAPON_RELOADSTATE	125	// get (frame number of the next shot/burst)
#define WEAPON_RELOADTIME	126	// get (in frames)
#define WEAPON_ACCURACY		127	// get
#define WEAPON_SPRAY		128	// get
#define WEAPON_RANGE		129	// get
#define WEAPON_PROJECTILESPEED	130	// get

#define MIN			131	// get
#define MAX			132	// get
#define ABS			133	// get
#define GAME_FRAME		134	// get

#define UNIT_VAR_START		1024
#define TEAM_VAR_START		2048
#define ALLY_VAR_START		3072
#define GLOBAL_VAR_START	4096


//Special Commands, custom hacks
#define SPEED_CONSTANT 512
#define RADIAN_CONSTANT 256

#define SIG_AIM1		2
#define SIG_AIM2		4
#define SIG_AIM3		8
#define SIG_AIM4		16
#define SIG_AIM5		32
#define SIG_AIM6		64
#define SIG_AIM7		128
#define SIG_AIM8		256
#define SIG_AIM9		512
#define SIG_AIM10		1024
#define SIG_AIM11		2048
#define SIG_AIM12		4096
#define SIG_AIM13		8192
#define SIG_AIM14		16384
#define SIG_AIM15		32768
#define SIG_AIM16		65536
#endif // STANDARD_COMMANDS_H_