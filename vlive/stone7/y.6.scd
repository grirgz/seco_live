(
Ndef(~name+++\source).put(0, { 
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(400 * SinOsc.kr(1/42).range(1.1,1)* [1,1.23,1.24896,1.12547]);
	sig = SinOsc.ar(50, sig1 * LFNoise1.kr(1/10).range(4,0.1));
	sig = SinOsc.ar(50, sig * LFNoise1.kr(1/32).range(0,4));
	sig = SinOsc.ar(50, sig * SinOsc.kr(1/52).range(0,4));
});

)
