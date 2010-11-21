static-var isBuilding, isBuildingNow;

#define SIG_ACTIVATE			2

BuildStarted(unitID) {
	var unitprog;
	while(get UNIT_BUILD_PERCENT_LEFT(unitID)) {
		unitprog = get UNIT_BUILD_PERCENT_LEFT(unitID);
		if(unitprog <= 10) {
			move door1 to x-axis [12.5] speed [12.5];
			move door2 to x-axis [-12.5] speed [12.5];
			sleep 1000;
			move wdoor1 to x-axis [37.5] speed [12.5];
			move wdoor2 to x-axis [-37.5] speed [12.5];
		}
		sleep 100;
	}
	sleep 3000;
	move wdoor1 to x-axis [0] speed [12.5];
	move wdoor2 to x-axis [0] speed [12.5];
	sleep 1000;
	move door1 to x-axis [0] speed [12.5];
	move door2 to x-axis [0] speed [12.5];
}

BuildScript() {
	isBuilding = 0;
	isBuildingNow = 0;
	while(TRUE) {
		if(isBuilding) {
			sleep 100;
			set BUGGER_OFF to 1;
			set YARD_OPEN to 1;
			set INBUILDSTANCE to 1;
			isBuildingNow = TRUE;		
		}
		if(isBuilding) {
			sleep 100;
		}	
		while(!isBuilding) {
			sleep 500;
			isBuildingNow = FALSE;
			sleep 1;
			set BUGGER_OFF to 0;
			set YARD_OPEN to 0;
			set INBUILDSTANCE to 0;
		}
	}
}

QueryNanoPiece(piecenum) {
	piecenum = bpt;
}

Activate() {
	signal SIG_ACTIVATE;
	isBuilding = TRUE;
}

Deactivate() {
	signal SIG_ACTIVATE;
	set-signal-mask SIG_ACTIVATE;
	isBuilding = FALSE;
}

QueryBuildInfo(piecenum) {
	piecenum = bpt;
}