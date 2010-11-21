ChooseRandomHead() {
	#define RANDOMHEAD 1
	randHead = rand(1,3);
	hide head;
	hide head2;
	hide head3;
#ifdef HEADEXTRAS1
	HEADEXTRAS1
#endif
	if(randHead == 1 or randHead < 1 or randHead > 3) {
		show head;
		randHead = 1; //safety
	}
	if(randHead == 2) {
		show head2;
	}
	if(randHead == 3) {
		#ifdef HEADEXTRAS2
			HEADEXTRAS2
		#endif
		show head3;
	}
}