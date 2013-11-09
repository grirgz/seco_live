
(
Ndef(~name+++\fx,{|amp = 1, mix=0.5, maxdelay=0.1, delay=0.1, decay=0.5|
	var input = InFeedback.ar(BusDef(~name+++\fx), 2);
	var output;
	output = input;
	output = CombL.ar(output, maxdelay, delay, decay);
	output = SelectX.ar(mix,[input, output]);
	output = output * amp;
	output
});
)

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).quant=2
