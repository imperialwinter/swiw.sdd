/* scaffolds.h - Build animation handler for Rebel buildings
Written by Gnome, based partially on code by smoth
License: Creative Commons Attribution-Noncommercial 3.0 Unported
	 http://creativecommons.org/licenses/by-nc/3.0/

Usage:
Put the following #defines in your script:

//REQUIRED//
#define SCAFFOLD_PIECE scaffolds
	//the name of the scaffold piece
#define SCAFFOLD_BELOW_GROUND_DIST [-20]
	//used for when the scaffold rises out of the ground/sinks back in
#define BUILDING_ROOT base
	//the primary parent piece of the building itself
#define BUILDING_BELOW_GROUND_DIST [-15]
	//how far underground the building should start out. used in rising calculation
#define BUILDING_RISE_SPEED [0.7]
	//the speed to rise the building during the calculation. this is necessary because
	//too high a speed looks jerky, and too slow a speed means the building is only partially
	// risen upon completion, depending on its buildtime. The general value here is [0.5]-[3]

//OPTIONAL//
#define DUSTFX 1024+7 
	//the fbi-set sfx type to use for the dust clouds. Optional.
#define DUST_ROOT dustrotator
	//this will spin the designated piece around randomly so the dust doesn't always emit from the same
	//place. Make the DUSTFXPT pieces a child of this if you use it. Optional.
#define DUSTFXPT1 dust1
	//up to four dust emitter points can be defined. All are optional
#define DUSTFXPT2 dust2
#define DUSTFXPT3 dust3
#define DUSTFXPT4 dust4
#define EXTRA spin fans around y-axis speed <10>*rand(1,10);
	//any extra commands to run after the build process finishes so you don't need a second loop
	//to delay them. Spinning fans, radars, whatever. Optional.

#include "general/scaffolds.h"
	//include the file AFTER your #defines

Create() {
	[your script stuff]
	start-script ConstructionAnim(); //make sure you add this line to Create() so the animation runs
}

*/


ConstructionAnim() {
	var hp, randspin;
	show SCAFFOLD_PIECE;
	move BUILDING_ROOT to y-axis BUILDING_BELOW_GROUND_DIST now;
	move SCAFFOLD_PIECE to y-axis [150] + SCAFFOLD_BELOW_GROUND_DIST now;
	sleep 10;
	move SCAFFOLD_PIECE to y-axis [150] speed [25];
	while(get BUILD_PERCENT_LEFT) {
		hp = get BUILD_PERCENT_LEFT;
		move BUILDING_ROOT to y-axis ((BUILDING_BELOW_GROUND_DIST * hp)/100) speed BUILDING_RISE_SPEED;
		#ifdef DUSTFX
			#ifdef DUST_ROOT
				randspin = rand(0,32767);
				turn DUST_ROOT to y-axis randspin now;
			#endif
			#ifdef DUSTFXPT1
				emit-sfx DUSTFX from DUSTFXPT1;
			#endif
			#ifdef DUSTFXPT2
				turn DUSTFXPT2 to y-axis randspin / rand(4,8) now;
				emit-sfx DUSTFX from DUSTFXPT2;
			#endif
			#ifdef DUSTFXPT3
				turn DUSTFXPT3 to y-axis randspin / rand(4,8) now;
				emit-sfx DUSTFX from DUSTFXPT3;
			#endif
			#ifdef DUSTFXPT4
				turn DUSTFXPT4 to y-axis randspin / rand(4,8) now;
				emit-sfx DUSTFX from DUSTFXPT4;
			#endif
		#endif
		sleep rand(500, 1100);
	}
	move SCAFFOLD_PIECE to y-axis [150] + SCAFFOLD_BELOW_GROUND_DIST speed [25];
	wait-for-move SCAFFOLD_PIECE along y-axis;
	hide SCAFFOLD_PIECE;
	#ifdef EXTRA
	EXTRA
	#endif
}