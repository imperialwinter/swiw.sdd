static-var aa_1, aa_2;

#define SIG_AIM_5	64
#define SIG_AIM_6	128

RestoreAA() {
	sleep 5000;
	turn l2aa1base to y-axis <-90> speed <300>;
	turn l2aa1turret to x-axis <0> speed <50>;
	turn l2aa2base to y-axis <90> speed <300>;
	turn l2aa2turret to x-axis <0> speed <50>;
}

//first turret
AimFromWeapon9(piecenum) {
	piecenum = l2aa1turret;
}

QueryWeapon9(piecenum) {
	if(!aa_1) {
		piecenum = l1aa1f1; }
	if(aa_1) {
		piecenum = l1aa1f2; }
}

FireWeapon9() {
	if(!aa_1) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa1f1;
		move l2aa1b1 to z-axis [-7.5] now;
		sleep 150;
		move l2aa1b1 to z-axis [0] speed [37.5];
	}
	if(aa_1) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa1f2;
		move l2aa1b2 to z-axis [-7.5] now;
		sleep 150;
		move l2aa1b2 to z-axis [0] speed [37.5];
	}
	aa_1 = !aa_1;
}

AimWeapon9(heading, pitch) {
	signal SIG_AIM_5;
	set-signal-mask SIG_AIM_5;
	turn l2aa1base to y-axis heading speed <500>;
	turn l2aa1turret to x-axis <0> - pitch speed <250>;
	wait-for-turn l2aa1base around y-axis;
	wait-for-turn l2aa1turret around x-axis;
	start-script RestoreAA();
	return 1;
}

//second turret

AimFromWeapon10(piecenum) {
	piecenum = l2aa2turret;
}

QueryWeapon10(piecenum) {
	if(!aa_2) {
		piecenum = l2aa2f1; }
	if(aa_2) {
		piecenum = l2aa2f2; }
}

FireWeapon10() {
	if(!aa_2) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa2f1;
		move l2aa2b1 to z-axis [-7.5] now;
		sleep 150;
		move l2aa2b1 to z-axis [0] speed [37.5];
	}
	if(aa_2) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa2f2;
		move l2aa2b2 to z-axis [-7.5] now;
		sleep 150;
		move l2aa2b2 to z-axis [0] speed [37.5];
	}
	aa_2 = !aa_2;
}

AimWeapon10(heading, pitch) {
	signal SIG_AIM_6;
	set-signal-mask SIG_AIM_6;
	turn l2aa2base to y-axis heading speed <500>;
	turn l2aa2turret to x-axis <0> - pitch speed <250>;
	wait-for-turn l2aa2base around y-axis;
	wait-for-turn l2aa2turret around x-axis;
	start-script RestoreAA();
	return 1;
}