
Ndef(~roger+++\freq, {
	var fspread = 0.00000001;
	((0..15)/15 - 0.5 * fspread + 1) * 500;
	Duty.kr(1/2/~t, 0, Dseq([
		0,-12,6,6,
		0,0,12,-12,
	],inf)).midiratio.lag(
		Duty.kr(1/2/~t, 0, Dseq([
			0.5,0,0.2,0.2,
			0,0,0.2,1.2,0
		],inf))
	) * 500 * [1,1/2,1/4,2] * (1!16);
});

// END

Ndef(~roger+++\freq).fadetime = 1/8;
Ndef(~roger+++\freq).quant = 2;
Ndef(~roger+++\fx).fadeTime = 1/8;
