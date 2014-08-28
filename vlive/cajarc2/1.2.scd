

(
Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,500,80,50],inf)) });
Ndef(~name+++\lfo1, { 
	var freq = Duty.ar(1,0,Dseq([2,5,8,4],inf));
	SinOsc.ar(freq);
});

Veco.do { arg name;

	Ndef(name+++\fx).put(0, \qsetsrc -> Pbind(

		\source, Pseq([
			{
				var sig; 
				sig = LFPulse.ar(Ndef.ar(name+++\freq).lag(0.14) * [1,1.01]);
				sig = sig * Ndef.ar(name+++\lfo1).range(0,1);
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},
			{
				var sig; 
				sig = LFPulse.ar(Ndef.ar(name+++\freq).lag(0.14) * [1,1.01,2,4,0.5]);
				sig = sig * Ndef.ar(name+++\lfo1).range(0,1);
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},

		],inf),
		\dur, Pseq([1,1/2,1/2,1/4],inf),
	));

};

);

(
	Ndef(~name+++\fx).quant = Pdef.defaultQuant;
	Ndef(~name+++\freq).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
);

// END

