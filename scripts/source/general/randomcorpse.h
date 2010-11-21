/* randomcorpse.h - general purpose Killed() library for random corpses
Written by Gnome for use with lua functions by Maelstrom
License: Creative Commons Attribution-Noncommercial 3.0 Unported
	 http://creativecommons.org/licenses/by-nc/3.0/

Usage:
Put the following #defines in your script:

//REQUIRED//
#define MIN_CORPSENUM		445
	//the first corpse sequence's definition number
#define MAX_CORPSENUM		448
	//the last corpse sequence's def number. If this is not set, then only MIN_CORPSENUM will ever
	//be used.
#define USES_CORPSE_HEADING	1
	//sets the heading the corpse should be spawned at. For example, a random buildangle performed in
	//Create().
#define USES_BMOVING		1
	//if the unit uses bMoving, it will be set to false in the Killed function if this is set to true
#define STOP_UNIT		1
	//sets MAX_SPEED to 1 (basically immobile). This is to fix occasional corpse alignment glitches
	//caused by brakerate
#define RAND_HEAD		1
	//several rebel infantry have random faces. This invokes a formula which creates a corpse with the
	//proper face. It requires the static-var "randHead" to be 1, 2, or 3.

#define PRE_ANIMATION	turn torso to y-axis <0> speed <70>;\
			turn head to x-axis <0> speed <70>;
	//Anything else you want done before ANY animation starts playing should be done here

#define ANIMATION0	move pelvis to y-axis [2.5] speed [2.5];\
			turn torso to x-axis <30> speed <90>;
#define ANIMATION1	move pelvis to y-axis [-2.5] speed [2.5];\
			turn torso to x-axis <70> speed <90>;\
			explode head type BITMAPONLY | BITMAP1;
//up to #define ANIMATION31
	//The number of animations you include should match the number of animations implied by
	//the values of MIN_CORPSENUM and MAX_CORPSENUM. So if I have five death animations, each
	//ending in a different corpse, ANIMATION0's final resting position should match the corpse
	//defined as MIN_CORPSENUM's value, and ANIMATION4's final position should match MAX_CORPSENUM's
	//corpse.


#include "general/randomcorpse.h"
	//include the file AFTER your #defines

*/

lua_SpawnFeature(featureNum, headingOffset) { return 0; }

Killed(severity, corpsetype) {
	signal SIG_DYING;
	var corpsenum, corpsenum2, corpseheading;

	#ifdef USES_BMOVING
		bMoving = 0;
	#endif
	#ifdef STOP_UNIT
		set MAX_SPEED to 1;
	#endif
	#ifdef USES_CORPSE_HEADING
		corpseheading = buildangle;
	#else
		corpseheading = <0>;
	#endif
	#ifdef MAX_CORPSENUM
		corpsenum = rand(MIN_CORPSENUM, MAX_CORPSENUM);
	#else
		corpsenum = MIN_CORPSENUM;
	#endif
	#ifdef RAND_HEAD
		if(randHead > 1) {
			corpsenum2 = corpsenum - MIN_CORPSENUM + corpsenum + 8 + randHead;
		}
	#endif

	#ifdef ANIMATION0
		if(corpsenum == (MIN_CORPSENUM)) {
			ANIMATION0
		}
	#endif
	#ifdef ANIMATION1
		if(corpsenum == (MIN_CORPSENUM + 1)) {
			ANIMATION1
		}
	#endif
	#ifdef ANIMATION2
		if(corpsenum == (MIN_CORPSENUM + 2)) {
			ANIMATION2
		}
	#endif
	#ifdef ANIMATION3
		if(corpsenum == (MIN_CORPSENUM + 3)) {
			ANIMATION3
		}
	#endif
	#ifdef ANIMATION4
		if(corpsenum == (MIN_CORPSENUM + 4)) {
			ANIMATION4
		}
	#endif
	#ifdef ANIMATION5
		if(corpsenum == (MIN_CORPSENUM + 5)) {
			ANIMATION5
		}
	#endif
	#ifdef ANIMATION6
		if(corpsenum == (MIN_CORPSENUM + 6)) {
			ANIMATION6
		}
	#endif
	#ifdef ANIMATION7
		if(corpsenum == (MIN_CORPSENUM + 7)) {
			ANIMATION7
		}
	#endif
	#ifdef ANIMATION8
		if(corpsenum == (MIN_CORPSENUM + 8)) {
			ANIMATION8
		}
	#endif
	#ifdef ANIMATION9
		if(corpsenum == (MIN_CORPSENUM + 9)) {
			ANIMATION9
		}
	#endif
	#ifdef ANIMATION10
		if(corpsenum == (MIN_CORPSENUM + 10)) {
			ANIMATION10
		}
	#endif
	#ifdef ANIMATION11
		if(corpsenum == (MIN_CORPSENUM + 11)) {
			ANIMATION11
		}
	#endif
	#ifdef ANIMATION12
		if(corpsenum == (MIN_CORPSENUM + 12)) {
			ANIMATION12
		}
	#endif
	#ifdef ANIMATION13
		if(corpsenum == (MIN_CORPSENUM + 13)) {
			ANIMATION13
		}
	#endif
	#ifdef ANIMATION14
		if(corpsenum == (MIN_CORPSENUM + 14)) {
			ANIMATION14
		}
	#endif
	#ifdef ANIMATION15
		if(corpsenum == (MIN_CORPSENUM + 15)) {
			ANIMATION15
		}
	#endif
	#ifdef ANIMATION16
		if(corpsenum == (MIN_CORPSENUM + 16)) {
			ANIMATION16
		}
	#endif
	#ifdef ANIMATION17
		if(corpsenum == (MIN_CORPSENUM + 17)) {
			ANIMATION17
		}
	#endif
	#ifdef ANIMATION18
		if(corpsenum == (MIN_CORPSENUM + 18)) {
			ANIMATION18
		}
	#endif
	#ifdef ANIMATION19
		if(corpsenum == (MIN_CORPSENUM + 19)) {
			ANIMATION19
		}
	#endif
	#ifdef ANIMATION20
		if(corpsenum == (MIN_CORPSENUM + 20)) {
			ANIMATION20
		}
	#endif
	#ifdef ANIMATION21
		if(corpsenum == (MIN_CORPSENUM + 21)) {
			ANIMATION21
		}
	#endif
	#ifdef ANIMATION22
		if(corpsenum == (MIN_CORPSENUM + 22)) {
			ANIMATION22
		}
	#endif
	#ifdef ANIMATION23
		if(corpsenum == (MIN_CORPSENUM + 23)) {
			ANIMATION23
		}
	#endif
	#ifdef ANIMATION24
		if(corpsenum == (MIN_CORPSENUM + 24)) {
			ANIMATION24
		}
	#endif
	#ifdef ANIMATION25
		if(corpsenum == (MIN_CORPSENUM + 25)) {
			ANIMATION25
		}
	#endif
	#ifdef ANIMATION26
		if(corpsenum == (MIN_CORPSENUM + 26)) {
			ANIMATION26
		}
	#endif
	#ifdef ANIMATION27
		if(corpsenum == (MIN_CORPSENUM + 27)) {
			ANIMATION27
		}
	#endif
	#ifdef ANIMATION28
		if(corpsenum == (MIN_CORPSENUM + 28)) {
			ANIMATION28
		}
	#endif
	#ifdef ANIMATION29
		if(corpsenum == (MIN_CORPSENUM + 29)) {
			ANIMATION29
		}
	#endif
	#ifdef ANIMATION30
		if(corpsenum == (MIN_CORPSENUM + 30)) {
			ANIMATION30
		}
	#endif
	#ifdef ANIMATION31
		if(corpsenum == (MIN_CORPSENUM + 31)) {
			ANIMATION31
		}
	#endif

	#ifdef RAND_HEAD
		if(randHead > 1) {
			call-script lua_SpawnFeature(corpsenum2, corpseheading);
			return 0;
		}
	#endif
	call-script lua_SpawnFeature(corpsenum, corpseheading);
	return 0;
}