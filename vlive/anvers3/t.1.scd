
(

Ndef(~name+++\fx).quant = Pdef.defaultQuant;

Ndef(~name+++\fx).put(0,

	Ppar([
		Pbind(
			\instrument, \hat,
			\amp, 4.3 * Pkey(\amp),
			\dur, 1,
		),
		Pbind(
			\instrument, \clap,
			\bpfreq1, 100,
			\hpfreq1, 10,
			\hpfreq2, 1000,
			\timeScale1, 0.13,
			\timeScale2, 0.13,
			\bpfreq1, 100,
			\amp, 0.3 * Pkey(\amp),
			\dur, 1,
			//\lag, 1/8 / t
		),

	])
	<> Pdef(~name+++\base) 
);
);

(

Ndef(~name+++\fx).put(1, \filter -> { arg in;
	var sig;
	sig = in;
	sig = CombC.ar(sig, 0.1,0.1,1);
	//sig = sig * SinOsc.ar(100);
	sig;
	
});

)


// END

Pdef(~name).clear;
