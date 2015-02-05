
Ndef(~roger+++\freq, {
	var fspread = 0.00000001;
	((0..15)/15 - 0.5 * fspread + 1) * 500;
	Duty.kr(1/2/~t, 0, Dseq([
		0,0,-2,-2,-7,-7,-4,-4,
		0,0,-9,-9,-7,-7,-4,-4,
	],inf)).midiratio.lag(0.9) * 500 * [1,1/2,1/4,2] * (1!16);
});

// END

Ndef(~roger+++\freq).fadetime = 1/8;
Ndef(~roger+++\freq).quant = 1/4;
Ndef(~roger+++\fx).fadeTime = 1/8;

[1,2] * (1!8)
