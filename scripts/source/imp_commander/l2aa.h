static-var aa_1, aa_2;

RestoreAA() {
	sleep 5000;
	turn l2aa1base to y-axis <-90> speed <300>;
	turn l2aa1turret to x-axis <0> speed <50>;
	turn l2aa2base to y-axis <90> speed <300>;
	turn l2aa2turret to x-axis <0> speed <50>;
}

//first turret
AimFromWeapon5(piecenum) {
	piecenum = l2aa1base;
}

QueryWeapon5(piecenum) {
	if(aa_1 == 0) {
		piecenum = l2aa1f1; }
	if(aa_1 == 1) {
		piecenum = l2aa1f3; }
	if(aa_1 == 2) {
		piecenum = l2aa1f2; }
	if(aa_1 == 3) {
		piecenum = l2aa1f3; }
}

Shot5() {
	++aa_1;
	if(aa_1 > 3) {
		aa_1 = 0;
	}
	if(aa_1 == 0) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa1f1;
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa1f3;
		move l2aa1b1 to z-axis [-7.5] now;
		move l2aa1b3 to z-axis [-7.5] now;
		sleep 150;
		move l2aa1b1 to z-axis [0] speed [37.5];
		move l2aa1b3 to z-axis [0] speed [37.5];
	}
	if(aa_1 == 2) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa1f2;
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa1f4;
		move l2aa1b2 to z-axis [-7.5] now;
		move l2aa1b4 to z-axis [-7.5] now;
		sleep 150;
		move l2aa1b2 to z-axis [0] speed [37.5];
		move l2aa1b4 to z-axis [0] speed [37.5];
	}
}

FireWeapon5() {
}

AimWeapon5(heading, pitch) {
	signal SIG_AIM5;
	set-signal-mask SIG_AIM5;
	turn l2aa1base to y-axis heading speed <500>;
	turn l2aa1turret to x-axis <0> - pitch speed <250>;
	wait-for-turn l2aa1base around y-axis;
	wait-for-turn l2aa1turret around x-axis;
	start-script RestoreAA();
	return 1;
}



//second turret

QueryWeapon6(piecenum) {
	if(aa_2 == 0) {
		piecenum = l2aa2f1; }
	if(aa_2 == 1) {
		piecenum = l2aa2f3; }
	if(aa_2 == 2) {
		piecenum = l2aa2f2; }
	if(aa_2 == 3) {
		piecenum = l2aa2f3; }
}

Shot6() {
	++aa_2;
	if(aa_2 > 3) {
		aa_2 = 0;
	}
	if(aa_2 == 0) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa2f1;
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa2f3;
		move l2aa2b1 to z-axis [-7.5] now;
		move l2aa2b3 to z-axis [-7.5] now;
		sleep 150;
		move l2aa2b1 to z-axis [0] speed [37.5];
		move l2aa2b3 to z-axis [0] speed [37.5];
	}
	if(aa_2 == 2) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa2f2;
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from l2aa2f4;
		move l2aa2b2 to z-axis [-7.5] now;
		move l2aa2b4 to z-axis [-7.5] now;
		sleep 150;
		move l2aa2b2 to z-axis [0] speed [37.5];
		move l2aa2b4 to z-axis [0] speed [37.5];
	}
}

FireWeapon6() {
}

AimWeapon6(heading, pitch) {
	signal SIG_AIM6;
	set-signal-mask SIG_AIM6;
	turn l2aa2base to y-axis heading speed <500>;
	turn l2aa2turret to x-axis <0> - pitch speed <250>;
	wait-for-turn l2aa2base around y-axis;
	wait-for-turn l2aa2turret around x-axis;
	start-script RestoreAA();
	return 1;
}