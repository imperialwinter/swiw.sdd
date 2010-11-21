/* infantry.h - Infantry script handler for SWS
Written by Gnome including work from scripts by Argh and animations by Nemo
License: Creative Commons Attribution-Noncommercial 3.0 Unported
	 http://creativecommons.org/licenses/by-nc/3.0/
*/

/*
#define USE_PISTOL_STANCE1
#define USE_ROCKET_STANCE1
#define USE_RIFLE_STANCE1
#define NORMAL_SPEED
#define NORMAL_MAX_ANGLE
#define SLOW_SPEED
#define SLOW_MAX_ANGLE
#define CLOAK_MAX_SPEED
#define CLOAK_SPEED
#define CLOAK_MAX_ANGLE
#define QUERY_PIECENUM1
#define BURST1
#define BURST_RATE1
#define MUZZLEFLASH1

static-var bMoving, runSpeed, maxAngle, alreadyEngaged, inBunker, idleAnim, maxSpeed;
*/

#define SIG_DYING	4
#define SIG_IDLE	8

WeaponReady() {
	alreadyEngaged = FALSE;
	#ifdef USE_PISTOL_STANCE1
		turn head	to y-axis <0>		speed <200>;
		turn chest	to y-axis <0>		speed <200>;
		turn torso	to x-axis <-15>		speed <200>;
		turn torso	to y-axis <0>		speed <200>;
		turn shoulders	to x-axis <0>		speed <200>;

		turn ruparm	to x-axis <-30>		speed <50>;
		turn ruparm	to y-axis <0>		speed <50>;
		turn ruparm	to z-axis <-15>		speed <50>;

		turn rloarm	to x-axis <-20>		speed <50>;
		turn rloarm	to y-axis <15>		speed <50>;
		turn rloarm	to z-axis <0>		speed <50>;

		turn gun	to x-axis <4>		speed <50>;
		turn gun	to y-axis <-4>		speed <50>;
		turn gun	to z-axis <19>		speed <50>;

		turn luparm	to x-axis <-30>		speed <50>;
		turn luparm	to y-axis <0>		speed <50>;
		turn luparm	to z-axis <21>		speed <50>;

		turn lloarm	to x-axis <-20>		speed <50>;
		turn lloarm	to y-axis <-15>		speed <50>;
		turn lloarm	to z-axis <0>		speed <50>;

		turn head	to x-axis <10>		speed <100>;
		turn head	to y-axis <0>		speed <100>;
		turn head	to z-axis <0>		speed <100>;
	#endif
	#ifdef USE_ROCKET_STANCE1
		turn head	to y-axis <0>		speed <200>;
		turn chest	to y-axis <0>		speed <200>;
		turn torso	to x-axis <-15>		speed <200>;
		turn torso	to y-axis <0>		speed <200>;
		turn shoulders	to x-axis <0>		speed <200>;

		turn ruparm	to x-axis <-45>		speed <500>;
		turn ruparm	to y-axis <35>		speed <500>;
		turn ruparm	to z-axis <0>		speed <500>;

		turn rloarm	to x-axis <0>		speed <500>;
		turn rloarm	to y-axis <-90>		speed <500>;
		turn rloarm	to z-axis <-17>		speed <500>;

		turn gun	to x-axis <0>		speed <500>;
		turn gun	to y-axis <0>		speed <500>;
		turn gun	to z-axis <0>		speed <500>;
		move gun	to x-axis [0]		speed [1250];

		turn luparm	to x-axis <45>		speed <500>;
		turn luparm	to y-axis <-20>		speed <500>;
		turn luparm	to z-axis <0>		speed <500>;

		turn lloarm	to x-axis <0>		speed <500>;
		turn lloarm	to y-axis <0>		speed <500>;
		turn lloarm	to z-axis <0>		speed <500>;

		turn head	to x-axis <10>		speed <100>;
		turn head	to y-axis <0>		speed <100>;
		turn head	to z-axis <0>		speed <100>;
	#endif
	#ifdef USE_RIFLE_STANCE1
		turn chest	to y-axis <0>		speed <200>;
		turn torso	to x-axis <-15>		speed <200>;
		turn torso	to y-axis <0>		speed <200>;
		turn shoulders	to x-axis <0>		speed <200>;

		turn ruparm	to x-axis <-50>		speed <200>;
		turn ruparm	to y-axis <0>		speed <200>;
		turn ruparm	to z-axis <0>		speed <200>;

		turn rloarm	to x-axis <-70>		speed <100>;
		turn rloarm	to y-axis <20>		speed <100>;
		turn rloarm	to z-axis <-50>		speed <100>;

		turn luparm	to x-axis <10>		speed <200>;
		turn luparm	to y-axis <0>		speed <200>;
		turn luparm	to z-axis <0>		speed <200>;

		turn lloarm	to x-axis <0>		speed <100>;
		turn lloarm	to y-axis <90>		speed <100>;
		turn lloarm	to z-axis <125>		speed <100>;

		turn gun	to x-axis <0>		speed <100>;
		turn gun	to y-axis <0>		speed <100>;
		turn gun	to z-axis <0>		speed <100>;
		turn head	to x-axis <10>		speed <100>;
		turn head	to y-axis <0>		speed <100>;
		turn head	to z-axis <0>		speed <100>;
		wait-for-turn torso	around y-axis;
	#endif
	#ifdef USE_RIFLE_STANCE2
		turn chest	to y-axis <0>		speed <200>;
		turn torso	to x-axis <0>		speed <200>;
		turn torso	to y-axis <0>		speed <200>;
		turn shoulders	to x-axis <0>		speed <200>;

		turn ruparm	to x-axis <-60>		speed <200>;
		turn ruparm	to y-axis <0>		speed <200>;
		turn ruparm	to z-axis <0>		speed <200>;

		turn rloarm	to x-axis <-30>		speed <100>;
		turn rloarm	to y-axis <20>		speed <100>;
		turn rloarm	to z-axis <-75>		speed <100>;

		turn luparm	to x-axis <-10>		speed <200>;
		turn luparm	to y-axis <0>		speed <200>;
		turn luparm	to z-axis <0>		speed <200>;

		turn lloarm	to x-axis <-85>		speed <100>;
		turn lloarm	to y-axis <0>		speed <100>;
		turn lloarm	to z-axis <0>		speed <100>;

		turn gun	to x-axis <0>		speed <100>;
		turn gun	to y-axis <0>		speed <100>;
		turn gun	to z-axis <0>		speed <100>;
		turn head	to y-axis <0>		speed <100>;
		turn head	to x-axis <0>		speed <100>;
		turn head	to z-axis <0>		speed <100>;
		wait-for-turn torso	around y-axis;
	#endif
	#ifdef USE_WOOKIEE_STANCE
		turn chest	to y-axis <0>		speed <200>;
		turn torso	to x-axis <0>		speed <200>;
		turn torso	to y-axis <0>		speed <200>;
		turn shoulders	to x-axis <0>		speed <200>;

		turn ruparm	to x-axis <-60>		speed <200>;
		turn ruparm	to y-axis <0>		speed <200>;
		turn ruparm	to z-axis <0>		speed <200>;

		turn rloarm	to x-axis <-40>		speed <100>;
		turn rloarm	to y-axis <20>		speed <100>;
		turn rloarm	to z-axis <-60>		speed <100>;

		turn luparm	to x-axis <-10>		speed <200>;
		turn luparm	to y-axis <0>		speed <200>;
		turn luparm	to z-axis <0>		speed <200>;

		turn lloarm	to x-axis <0>		speed <100>;
		turn lloarm	to y-axis <90>		speed <100>;
		turn lloarm	to z-axis <85>		speed <100>;

		turn gun	to x-axis <0>		speed <100>;
		turn gun	to y-axis <0>		speed <100>;
		turn gun	to z-axis <0>		speed <100>;
		turn head	to y-axis <0>		speed <100>;
		turn head	to x-axis <0>		speed <100>;
		turn head	to z-axis <0>		speed <100>;
		wait-for-turn torso	around y-axis;
	#endif
	#ifdef USE_SBD_STANCE
 		turn ruparm to x-axis <-20> speed <500>;
 		turn ruparm to y-axis <0> speed <500>;
 	 	turn ruparm to z-axis <0> speed <500>;

 	 	turn rloarm to x-axis <0> speed <500>;
 	 	turn rloarm to y-axis <-90> speed <500>;
  	 	turn rloarm to z-axis <-120> speed <500>;

  	 	turn luparm to x-axis <0> speed <500>;
  	 	turn luparm to y-axis <0> speed <500>;
  	 	turn luparm to z-axis <0> speed <500>;

  	 	turn lloarm to x-axis <-10> speed <500>;
  	 	turn lloarm to y-axis <0> speed <500>;
  	 	turn lloarm to z-axis <0> speed <500>;
	#endif
	runSpeed = NORMAL_SPEED;
	set MAX_SPEED to maxSpeed;
	maxAngle = NORMAL_MAX_ANGLE;
	return 0;
}

Run() {
	//set-signal-mask SIG_DYING;
	//while(1) {
		if(bMoving) {	
			turn pelvis	to x-axis (<8>    * maxAngle) / 100	speed <80>   * runSpeed;
			turn torso	to x-axis (<4>    * maxAngle) / 100	speed <80>   * runSpeed;
			turn torso	to y-axis (<-20>  * maxAngle) / 100	speed <10>   * runSpeed;
			move pelvis	to y-axis [0.0]				speed <200>  * runSpeed;
		}
		if(bMoving) {
			turn rleg	to x-axis (<85>   * maxAngle) / 100	speed <30>   * runSpeed;
			turn lleg	to x-axis (<25>   * maxAngle) / 100	speed <40>   * runSpeed;
			turn rthigh	to x-axis (<-45>  * maxAngle) / 100	speed <20>   * runSpeed;
			turn rthigh	to y-axis (<0>    * maxAngle) / 100	speed <20>   * runSpeed;
			turn rthigh	to z-axis (<0>    * maxAngle) / 100	speed <20>   * runSpeed;
			turn lthigh	to x-axis (<20>   * maxAngle) / 100	speed <20>   * runSpeed;
			turn lthigh	to y-axis (<0>    * maxAngle) / 100	speed <20>   * runSpeed;
			turn lthigh	to z-axis (<0>    * maxAngle) / 100	speed <20>   * runSpeed;

			wait-for-move	pelvis		along y-axis;
			move pelvis	to y-axis [1.75]			speed <160>  * runSpeed;
		}

		if(bMoving) {
			turn rleg	to x-axis (<55>   * maxAngle) / 100	speed <60>   * runSpeed;
			wait-for-turn	lthigh		around x-axis;

			turn torso	to y-axis (<20>   * maxAngle) / 100	speed <10>   * runSpeed;
			move pelvis	to y-axis [0.0]				speed <300>  * runSpeed;

			turn lleg	to x-axis (<85>   * maxAngle) / 100	speed <30>   * runSpeed;
			turn rleg	to x-axis (<25>   * maxAngle) / 100	speed <40>   * runSpeed;
			turn lthigh	to x-axis (<-45>  * maxAngle) / 100	speed <20>   * runSpeed;
		}
		if(bMoving) {
			turn rthigh	to x-axis (<20>   * maxAngle) / 100	speed <30>   * runSpeed;

			wait-for-move pelvis along y-axis;

			move pelvis	to y-axis [1.75]			speed <160>  * runSpeed;
			turn lleg	to x-axis (<55>   * maxAngle) / 100	speed <60>   * runSpeed;
			wait-for-turn	rthigh		around x-axis;
		}
		sleep randomSeed;
	//}
}

StartMoving() {
	bMoving = TRUE;
}

StopMoving() {
	bMoving = FALSE;
}

IdleAnim01() {
	set-signal-mask SIG_IDLE;
	idleAnim = 1;
	var randvar;
	randvar = rand(8,20);
	turn torso to y-axis <1> * randvar speed <50>;
	turn head to y-axis <1> * randvar speed <90>;
	sleep 12 * randvar;
	turn torso to y-axis <1> * randvar speed <50>;
	turn head to y-axis <1> * randvar speed <90>;
	wait-for-turn torso around y-axis;
	idleAnim = 0;
}

IdleAnim02() {
	set-signal-mask SIG_IDLE;
	idleAnim = 1;
	var randvar;
	randvar = rand(8,20);
	turn torso to y-axis <-1> * randvar speed <50>;
	turn head to y-axis <-1> * randvar speed <90>;
	sleep 12 * randvar;
	turn torso to y-axis <-1> * randvar speed <50>;
	turn head to y-axis <-1> * randvar speed <90>;
	wait-for-turn torso around y-axis;
	idleAnim = 0;
}

MotionControl() {
	set-signal-mask SIG_DYING;
	var randIdleAnimation;
	while(1) {
		#ifdef CLOAK_MAX_SPEED
			if(!alreadyEngaged) {
				var cloaked;
				cloaked = get CLOAKED;
				if(cloaked) {
					set MAX_SPEED to CLOAK_MAX_SPEED;
					maxAngle = CLOAK_MAX_ANGLE;
					runSpeed = CLOAK_SPEED;
				}
				if(!cloaked) {
					set MAX_SPEED to maxSpeed;
					maxAngle = NORMAL_MAX_ANGLE;
					runSpeed = NORMAL_SPEED;
				}
			}
		#endif
		if(!bMoving) {
			move pelvis	to y-axis [0.0]		speed <1000>	* runSpeed;
			turn pelvis	to x-axis <10>		speed <50>	* runSpeed;
			turn pelvis	to y-axis <0>		speed <50>	* runSpeed;
			turn torso	to x-axis <-15>		speed <200>;

			#ifdef REBEL
				turn lthigh	to x-axis <-5>		speed <100>;
				turn lthigh	to y-axis <15>		speed <100>;
				turn lthigh	to z-axis <-3>		speed <100>;
				turn lleg	to x-axis <0>		speed <100>;

				turn rthigh	to x-axis <-5>		speed <100>;
				turn rthigh	to y-axis <-15>		speed <100>;
				turn rthigh	to z-axis <4>		speed <100>;
				turn rleg	to x-axis <0>		speed <100>;
			#else
				turn lthigh	to x-axis <-10>		speed <100>;
				turn lthigh	to y-axis <5>		speed <100>;
				turn lleg	to x-axis <0>		speed <100>;

				turn rthigh	to x-axis <-10>		speed <100>;
				turn rthigh	to y-axis <-5>		speed <100>;
				turn rleg	to x-axis <0>		speed <100>;
			#endif
			if(!alreadyEngaged) {
				turn head	to x-axis <10>		speed <100>;
				if(!idleAnim) {
					randIdleAnimation = rand(0,50);
					if(randIdleAnimation == 1) {
						start-script IdleAnim01();
					}
					if(randIdleAnimation == 2) {
						start-script IdleAnim02();
					}
					//if(randIdleAnimation == 3) {
					//	start-script IdleAnim03();
					//}
					//if(randIdleAnimation == 2) {
					//	start-script AimPose(<2>*randomSeed,<10>);
					//}
				}
			}
			sleep 80;
		}
		if(bMoving) {
			call-script Run();
		}
	}
}

HitByWeaponId(z,x,id,damage) {
	if(inBunker) { return 0; }
	if(!inBunker) { return 100; }
}

setSFXoccupy(level) {
	if(level == 0) {
		var transport, tid;
		tid = get TRANSPORT_ID;
		transport = get COB_ID(tid);
		if(transport == 25) { //imp bunker
			inBunker = 1;
		}
		if(transport == 104) { //imp pillbox
			inBunker = 1;
		}
		if(transport == 2) { //imp LAAT
			var laatseat;
			signal SIG_DYING;
			inBunker = 2;
			laatseat = get UNIT_VAR_START+0(tid);
			if(laatseat < 4) {
				turn base to y-axis <-90> now;
			}
			if(laatseat > 3) {
				turn base to y-axis <90> now;
			}
			move base to y-axis [-10.5] now;
			turn lthigh to x-axis <-90> now;
			turn rthigh to x-axis <-90> now;
			turn lleg to x-axis <90> now;
			turn rleg to x-axis <90> now;
		}
		if(transport == 99) { //rebel APC
			inBunker = 3;
			hide pelvis; hide lthigh; hide lleg; hide rthigh; hide rleg;
			hide chest; hide head;
			hide ruparm; hide rloarm; hide gun; hide flare;
			hide luparm; hide lloarm;
			#ifdef RANDOMHEAD
				hide helmet;
				if(randHead == 2) { hide head2; }
				if(randHead == 3) { hide head3; }
				#ifdef HEADEXTRAS1
					HEADEXTRAS1
				#endif
			#endif
		}
	}
	if(level != 0) {
		if(inBunker == 2 or inBunker == 3) {
			show pelvis; show lthigh; show lleg; show rthigh; show rleg;
			show chest; show head;
			show ruparm; show rloarm; show gun; show flare;
			show luparm; show lloarm;
			#ifdef RANDOMHEAD
				show helmet;
				if(randHead == 2) { show head2; hide head; }
				if(randHead == 3) {
					show head3; hide head;
					#ifdef HEADEXTRAS2
						HEADEXTRAS2
					#endif
				 }
			#endif

			turn base to y-axis <0> now;
			move base to y-axis [0] now;
			turn lthigh to x-axis <0> now;
			turn rthigh to x-axis <0> now;
			turn lleg to x-axis <0> now;
			turn rleg to x-axis <0> now;
			start-script WeaponReady();
			start-script MotionControl();
		}
		inBunker = 0;
	}
}

RestoreAfterDelay() {
	sleep 500;
	call-script WeaponReady();
	return 0;
}

AimFromWeapon1(piecenum) {
	piecenum = head;
}

QueryWeapon1(piecenum) {
	piecenum = QUERY_PIECENUM1;
}

FireWeapon1() {
	#ifdef BURST_RATE1
		var counter;
		while(counter <= BURST1) {
			emit-sfx MUZZLEFLASH1 from QUERY_PIECENUM1;
			++counter;
			sleep BURST_RATE1;
		}
	#else
		emit-sfx MUZZLEFLASH1 from QUERY_PIECENUM1;
	#endif
}

AimWeapon1(heading, pitch) {
	signal SIG_IDLE;
	signal SIG_AIM1;
	set-signal-mask SIG_AIM1;

if(inBunker != 1) {
	if(!alreadyEngaged) {
		runSpeed = SLOW_SPEED;
		set MAX_SPEED to maxSpeed / 2;
		maxAngle = SLOW_MAX_ANGLE;
		#ifdef USE_PISTOL_STANCE1
			turn ruparm	to x-axis <-70>		speed <500>;
			turn luparm	to x-axis <-70>		speed <500>;
			wait-for-turn	ruparm		around y-axis;
			wait-for-turn	rloarm		around x-axis;
		#endif
		#ifdef USE_ROCKET_STANCE1
			turn ruparm	to x-axis <-70>		speed <500>;
			turn ruparm	to y-axis <20>		speed <500>;
			turn ruparm	to z-axis <0>		speed <500>;

			turn rloarm	to x-axis <0>		speed <500>;
			turn rloarm	to y-axis <-45>		speed <500>;
			turn rloarm	to z-axis <-50>		speed <500>;

			turn luparm	to x-axis <0>		speed <500>;
			turn luparm	to y-axis <0>		speed <500>;
			turn luparm	to z-axis <0>		speed <500>;
			wait-for-turn	ruparm		around x-axis;
		#endif
		#ifdef USE_RIFLE_STANCE1
			turn head	to y-axis <35>		speed <200>;
			turn chest	to y-axis <-35>		speed <200>;

			turn ruparm	to x-axis <-15>		speed <500>;
			turn ruparm	to y-axis <45>		speed <500>;
			turn ruparm	to z-axis <0>		speed <500>;

			turn rloarm	to x-axis <-90>		speed <500>;
			turn rloarm	to y-axis <0>		speed <500>;
			turn rloarm	to z-axis <0>		speed <500>;

			turn gun	to x-axis <15>		speed <500>;
			turn gun	to y-axis <0>		speed <500>;
			turn gun	to z-axis <10>		speed <500>;
			move gun	to x-axis [0]		speed [1250];

			turn luparm	to x-axis <-35>		speed <500>;
			turn luparm	to y-axis <15>		speed <500>;
			turn luparm	to z-axis <0>		speed <500>;

			turn lloarm	to x-axis <0>		speed <500>;
			turn lloarm	to y-axis <60>		speed <500>;
			turn lloarm	to z-axis <80>		speed <500>;

			wait-for-turn	ruparm		around y-axis;
			wait-for-turn	rloarm		around x-axis;
		#endif
		#ifdef USE_RIFLE_STANCE2 //rebel stance, they have shorter forearms
			turn head	to y-axis <35>		speed <200>;
			turn chest	to y-axis <-35>		speed <200>;

			turn ruparm	to x-axis <-15>		speed <500>;
			turn ruparm	to y-axis <45>		speed <500>;
			turn ruparm	to z-axis <20>		speed <500>;

			turn rloarm	to x-axis <-90>		speed <500>;
			turn rloarm	to y-axis <0>		speed <500>;
			turn rloarm	to z-axis <0>		speed <500>;

			turn gun	to x-axis <15>		speed <500>;
			turn gun	to y-axis <0>		speed <500>;
			turn gun	to z-axis <0>		speed <500>;
			move gun	to x-axis [0]		speed [1250];

			turn luparm	to x-axis <-55>		speed <500>;
			turn luparm	to y-axis <5>		speed <500>;
			turn luparm	to z-axis <10>		speed <500>;

			turn lloarm	to x-axis <0>		speed <500>;
			turn lloarm	to y-axis <60>		speed <500>;
			turn lloarm	to z-axis <45>		speed <500>;

			wait-for-turn	ruparm		around y-axis;
			wait-for-turn	rloarm		around x-axis;
		#endif
		#ifdef USE_WOOKIEE_STANCE
			turn head	to y-axis <35>		speed <200>;
			turn chest	to y-axis <-35>		speed <200>;

			turn ruparm	to x-axis <-15>		speed <500>;
			turn ruparm	to y-axis <45>		speed <500>;
			turn ruparm	to z-axis <20>		speed <500>;

			turn rloarm	to x-axis <-90>		speed <500>;
			turn rloarm	to y-axis <0>		speed <500>;
			turn rloarm	to z-axis <0>		speed <500>;

			turn gun	to x-axis <15>		speed <500>;
			turn gun	to y-axis <0>		speed <500>;
			turn gun	to z-axis <0>		speed <500>;
			move gun	to x-axis [0]		speed [1250];

			turn luparm	to x-axis <-55>		speed <500>;
			turn luparm	to y-axis <5>		speed <500>;
			turn luparm	to z-axis <10>		speed <500>;

			turn lloarm	to x-axis <30>		speed <500>;
			turn lloarm	to y-axis <90>		speed <500>;
			turn lloarm	to z-axis <45>		speed <500>;

			wait-for-turn	ruparm		around y-axis;
			wait-for-turn	rloarm		around x-axis;
		#endif
		#ifdef USE_SBD_STANCE
			move pelvis to y-axis [-0.2] speed [500];

			turn torso to x-axis <5> speed <500>;

			turn ruparm to x-axis <-86> speed <500>;
			turn ruparm to y-axis <0> speed <500>;
			turn ruparm to z-axis <0> speed <500>;

			turn rloarm to x-axis <-2> speed <500>;
			turn rloarm to y-axis <94> speed <500>;
			turn rloarm to z-axis <0> speed <500>;

			turn luparm to x-axis <6> speed <500>;	
			turn luparm to y-axis <10> speed <500>;
			turn luparm to z-axis <-28> speed <500>;

			turn lloarm to x-axis <-90> speed <500>;
			turn lloarm to y-axis <0> speed <500>;
			turn lloarm to z-axis <0> speed <500>;

			turn torso to y-axis heading speed <300>;
		#endif
		alreadyEngaged = TRUE;
	}

	turn torso	to y-axis heading		speed <300>;
	turn shoulders	to x-axis <0> - pitch		speed <300>;
	turn head	to x-axis <0> - pitch / 2	speed <300>;
	wait-for-turn	shoulders	around x-axis;
	wait-for-turn	torso		around y-axis;

	start-script RestoreAfterDelay();
		return 1;
	}
return 0;
}

CanCapture(capture) {
	capture = 1;
	if(alreadyEngaged) {
		capture = 0;
	}
	return 1;
}