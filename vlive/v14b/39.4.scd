
(
Ndef(~name+++\fx,{|amp = 1, mix=0.5, ffreq=500, rq=0.3|
	var input = InFeedback.ar(BusDef(~name+++\fx), 2);
	var output;
	output = input;
	output = RLPF.ar(output, ffreq, rq);
	output = SelectX.ar(mix,[input, output]);
	output = output * amp;
	output
});
)

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).quant=2
