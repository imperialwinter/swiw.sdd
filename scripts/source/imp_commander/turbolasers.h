static-var tl_1, tl_2, tl_3, tl_4;

#define MED_MUZZLE_FLASH_FX_GREEN 1024+1

#define SIG_AIM_1	4
#define SIG_AIM_2	8
#define SIG_AIM_3	16
#define SIG_AIM_4	32

RestoreTurbolasers() {
	sleep 5000;
	turn tl1turret to y-axis <-45> speed <150>;
	turn tl1sleeves to x-axis <0> speed <135>;
	turn tl2turret to y-axis <45> speed <150>;
	turn tl2sleeves to x-axis <0> speed <135>;
	turn tl3turret to y-axis <-135> speed <150>;
	turn tl3sleeves to x-axis <0> speed <135>;
	turn tl4turret to y-axis <135> speed <150>;
	turn tl4sleeves to x-axis <0> speed <135>;
}

//front left turbolaser
AimFromWeapon1(piecenum) {
	piecenum = tl1sleeves;
}

QueryWeapon1(piecenum) {
	if(!tl_1) {
		piecenum = tl1f1; }
	if(tl_1) {
		piecenum = tl1f2; }
}

FireWeapon1() {
	if(!tl_1) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl1f1;
	}
	if(tl_1) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl1f2;
	}
	tl_1 = !tl_1;
}

AimWeapon1(heading, pitch) {
	signal SIG_AIM_1;
	set-signal-mask SIG_AIM_1;
	turn tl1turret to y-axis heading speed <150>;
	turn tl1sleeves to x-axis <0> - pitch speed <135>;
	wait-for-turn tl1turret around y-axis;
	wait-for-turn tl1sleeves around x-axis;
	start-script RestoreTurbolasers();
	return 1;
}



//front right turbolaser
AimFromWeapon2(piecenum) {
	piecenum = tl2sleeves;
}

QueryWeapon2(piecenum) {
	if(!tl_2) {
		piecenum = tl2f1; }
	if(tl_2) {
		piecenum = tl2f2; }
}

FireWeapon2() {
	if(!tl_2) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl2f1;
	}
	if(tl_2) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl2f2;
	}
	tl_2 = !tl_2;
}

AimWeapon2(heading, pitch) {
	signal SIG_AIM_2;
	set-signal-mask SIG_AIM_2;
	turn tl2turret to y-axis heading speed <150>;
	turn tl2sleeves to x-axis <0> - pitch speed <135>;
	wait-for-turn tl2turret around y-axis;
	wait-for-turn tl2sleeves around x-axis;
	start-script RestoreTurbolasers();
	return 1;
}



//rear left turbolaser
AimFromWeapon3(piecenum) {
	piecenum = tl3sleeves;
}

QueryWeapon3(piecenum) {
	if(!tl_3) {
		piecenum = tl3f1; }
	if(tl_3) {
		piecenum = tl3f2; }
}

FireWeapon3() {
	if(!tl_3) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl3f1;
	}
	if(tl_3) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl3f2;
	}
	tl_3 = !tl_3;
}

AimWeapon3(heading, pitch) {
	signal SIG_AIM_3;
	set-signal-mask SIG_AIM_3;
	turn tl3turret to y-axis heading speed <150>;
	turn tl3sleeves to x-axis <0> - pitch speed <135>;
	wait-for-turn tl3turret around y-axis;
	wait-for-turn tl3sleeves around x-axis;
	start-script RestoreTurbolasers();
	return 1;
}



//rear right turbolaser
AimFromWeapon4(piecenum) {
	piecenum = tl4sleeves;
}

QueryWeapon4(piecenum) {
	if(!tl_4) {
		piecenum = tl4f1; }
	if(tl_4) {
		piecenum = tl4f2; }
}

FireWeapon4() {
	if(!tl_4) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl4f1;
	}
	if(tl_4) {
		emit-sfx MED_MUZZLE_FLASH_FX_GREEN from tl4f2;
	}
	tl_4 = !tl_4;
}

AimWeapon4(heading, pitch) {
	signal SIG_AIM_4;
	set-signal-mask SIG_AIM_4;
	turn tl4turret to y-axis heading speed <150>;
	turn tl4sleeves to x-axis <0> - pitch speed <135>;
	wait-for-turn tl4turret around y-axis;
	wait-for-turn tl4sleeves around x-axis;
	start-script RestoreTurbolasers();
	return 1;
}