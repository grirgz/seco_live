
Ndef(~roger+++\freq, {
	var fspread = 0.00000001;
	((0..15)/15 - 0.5 * fspread + 1) * 500;
	 500 * XLine.ar(1,4,8) * [1,1/2,1/4,2] * (1!16);
});

// END

Ndef(~roger+++\freq).fadetime = 1/8;
Ndef(~roger+++\freq).quant = 1/4;
Ndef(~roger+++\fx).fadeTime = 1/8;
