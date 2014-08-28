

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
				sig = LFSaw.ar(Ndef.ar(name+++\freq).lag(0.14)* [1,1.01]);
				sig = RLPF.ar(sig, Ndef.ar(name+++\lfo1).range(150,1000),0.1);
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},

		],inf),
		\dur, Pseq([1,1/2,1/2,1/4],inf),
	));

	Ndef(name+++\fx).put(100, \setsrcfx -> Pbind(

		\source, Pseq([
			{ arg in;
				in;
			},
			{ arg in;
				AllpassL.ar(in, 1/2,1/2,4);
			},
			{ arg in;
				AllpassL.ar(in, 1/8,1/8,4);
			},
			//{ arg in;
			//	in = in + LFSaw.ar(Ndef.ar(name+++\freq).lag(0.8.rand) * [0.25,0.5,1,2,4].choose);
			//	in = in * 0.051;
			//},

		],inf),
		\dur, Pseq([4],inf),
	));

};

);

(
	Ndef(~name+++\fx).quant = Pdef.defaultQuant;
	Ndef(~name+++\freq).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
);

// END

Ndef(~name+++\freq, { XLine.ar(10,8000,5)});
Ndef(~name+++\freq, { XLine.ar(10000,80,5)});
Ndef(~name+++\freq, { SinOsc.ar(1/4).range(40,100)});
Ndef(~name+++\freq, { SinOsc.ar(2).range(40,100)});
Ndef(~name+++\freq, { SinOsc.ar(4).range(40,400) * [1,2,4]});
	Ndef(~name+++\freq).quant = 1
Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,500,80,50],inf)) });
Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,200,120,150],inf)) });

