
Ndef(~fernand+++\freq, { 
	500 ! 2 * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,1,4,3,
	],inf)).midiratio
});
