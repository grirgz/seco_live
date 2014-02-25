(
Ndef(~name+++\fx).put(100, \filter -> { arg in, distamp=0.5, drive=10;
	var freq = 400;
	var sig;
	//freq = ZeroCrossing.ar(in);
	//freq.poll;
	//in * SinOsc.ar(SinOsc.ar(1)*0.1+1*freq); 
	//in * SinOsc.ar(freq); 
	//freq = LPF.ar(freq, 100);
	//sig = (in*drive).clip(-1,1) * distamp;
	sig = (in*drive).clip2(1) * distamp;
	//sig = LFTri.ar(freq) * Amplitude.ar(in); 
	//sig = sig + in;
})
);


// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop
