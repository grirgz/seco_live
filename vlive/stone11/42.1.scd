
Ndef(~fernand+++\freq, { 
	500/2 * Duty.kr(2/~t, 0, Dseq([
		0,12,4,0,
	],inf)).midiratio ! 2
});
