/*
crashcontrol2.h
by Evil4Zerggin

Description: For aircraft. 
When the aircraft is crashing, it has a chance of popping off the designated piece,
 emitting a designated sfx from it each frame, and spinning the aircraft.
This one allows for two pieces, each with its own sfx.

Instructions:
1. Put the following line near the top of the file but below the COB constants include:

#include "general/crashcontrol.h"
	
2. ABOVE this line put the following lines:

#define CRASHCONTROL_BASE		//piece to spin, MUST specify this explicitly
#define CRASHCONTROL_PIECE0		//piece to pop, MUST specify this explicitly
#define CRASHCONTROL_PIECE1		//piece to pop, MUST specify this explicitly
#define CRASHCONTROL_SFX0		//sfx to emit, MUST specify this explicitly
#define CRASHCONTROL_SFX1		//sfx to emit, MUST specify this explicitly
#define CRASHCONTROL_SFXSMOKE	//sfx to emit, optional
#define CRASHCONTROL_SFXSMOKE_PROBABILITY 50 //probability of emitting smoke, optional, default 25, in percent
#define CRASHCONTROL_SPIN_SPEED0 720	//maximum spin speed from first piece, optional, default 720; in degrees
#define CRASHCONTROL_SPIN_SPEED1 720	//maximum spin speed from second piece, optional, default 720; in degrees
#define CRASHCONTROL_PROBABILITY0 25	//probability of first piece popping, optional, default 25; in percent
#define CRASHCONTROL_PROBABILITY1 25	//probability of second piece popping, optional, default 25; in percent

3, In Create() put the following line:

start-script CrashControl();

4. In Killed(), don't explode CRASHCONTROL_PIECEX if crashcontrol_activatedX is true.
This means that CrashControl() has already exploded that piece.
Alternately, you can use

call-script CrashKilled();

which will explode the appropriate pieces for you.
*/

//default values
#ifndef CRASHCONTROL_SPIN_SPEED0
	#define CRASHCONTROL_SPIN_SPEED0 720
#endif

#ifndef CRASHCONTROL_SPIN_SPEED1
	#define CRASHCONTROL_SPIN_SPEED1 720
#endif

#ifndef CRASHCONTROL_PROBABILITY0
	#define CRASHCONTROL_PROBABILITY0 25
#endif

#ifndef CRASHCONTROL_PROBABILITY1
	#define CRASHCONTROL_PROBABILITY1 25
#endif

#ifndef CRASHCONTROL_SFXSMOKE_PROBABILITY
	#define CRASHCONTROL_SFXSMOKE_PROBABILITY 25
#endif

static-var crashcontrol_activated0, crashcontrol_activated1;

CrashControl() {
	var crash0, crash1, crashsmoke, spin_speed;
	crash0 = 0;
	crash1 = 0;
	crashsmoke = 0;
	crashcontrol_activated0 = 0;
	crashcontrol_activated1 = 0;
	//check at beginning to avoid unnecessary for-loop
	if (rand(0, 100) < CRASHCONTROL_PROBABILITY0) {
		if (rand(0, 2)) crash0 = CRASHCONTROL_SFX0;
		else crash0 = CRASHCONTROL_SFX1;
	}
	if (rand(0, 100) < CRASHCONTROL_PROBABILITY1) {
		if (rand(0, 2)) crash1 = CRASHCONTROL_SFX0;
		else crash1 = CRASHCONTROL_SFX1;
	}
	#ifdef CRASHCONTROL_SFXSMOKE
		if (rand(0, 100) < CRASHCONTROL_SFXSMOKE_PROBABILITY) {
			crashsmoke = 1;
		}
	#endif
	
	if (!crash0 && !crash1 && !crashsmoke) return;
	
	//wait for it...
	while (!GET CRASHING) sleep 500;
	spin_speed = 0;
	
	if (crash0) {
		spin_speed = spin_speed + rand(0, CRASHCONTROL_SPIN_SPEED0);
		explode CRASHCONTROL_PIECE0 type FALL | SMOKE | FIRE;
		hide CRASHCONTROL_PIECE0;
		crashcontrol_activated0 = 1;
	}
	
	if (crash1) {
		spin_speed = spin_speed - rand(0, CRASHCONTROL_SPIN_SPEED1); //opposite direction
		explode CRASHCONTROL_PIECE1 type FALL | SMOKE | FIRE;
		hide CRASHCONTROL_PIECE1;
		crashcontrol_activated1 = 1;
	}
	
	spin CRASHCONTROL_BASE around z-axis speed spin_speed * 182;
	while (1) {
		if (crash0) emit-sfx crash0 from CRASHCONTROL_PIECE0;
		if (crash1) emit-sfx crash1 from CRASHCONTROL_PIECE1;
		#ifdef CRASHCONTROL_SFXSMOKE
			if (crashsmoke) emit-sfx CRASHCONTROL_SFXSMOKE from CRASHCONTROL_BASE;
		#endif
		sleep 30;
	}
}

CrashKilled() {
	if (!crashcontrol_activated0) explode CRASHCONTROL_PIECE0 type FALL | SMOKE | FIRE;
	if (!crashcontrol_activated1) explode CRASHCONTROL_PIECE1 type FALL | SMOKE | FIRE;
}
