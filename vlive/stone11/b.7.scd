
Ndef(~albert+++\freq, {
	Ndef(~roger+++\freq)* SinOsc.ar(8 * ~t).range(1/8,1/4)
});

// END

Ndef(~roger+++\freq).fadetime = 1/8;
Ndef(~roger+++\freq).quant = 1/4;
Ndef(~roger+++\fx).fadeTime = 1/8;
