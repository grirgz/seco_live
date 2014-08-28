

(
Ndef(~name+++\freq, { Duty.ar(1/2,0,Dseq([100,500,80,50],inf)) });
Ndef(~name+++\lfo1, { 
	var freq = Duty.ar(1,0,Dseq([2,5,8,4],inf));
	SinOsc.ar(freq);
});

Veco.do { arg name;

	Ndef(name+++\fx).put(0, \qsetsrc -> Pbind(

		\source, Pseq([
			{
				var sig; 
				sig = SinOsc.ar(Ndef.ar(name+++\freq).lag(0.14) * [1,1.01]);
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},
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
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},
			{
				var sig; 
				sig = LFSaw.ar(Ndef.ar(name+++\freq).lag(0.14)* [1,1.01]);
				sig = RLPF.ar(sig, Ndef.ar(name+++\lfo1).range(50,1000),0.1);
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

Ndef(~name+++\freq, { XLine.ar(10,8000,5)});
Ndef(~name+++\freq, { XLine.ar(10000,80,5)});
Ndef(~name+++\freq, { SinOsc.ar(1/4).range(40,100)});
Ndef(~name+++\freq, { SinOsc.ar(4).range(40,400) * [1,2,4]});
	Ndef(~name+++\freq).quant = 1

Ndef(~name+++\fx).play

(
Ndef(~name+++\freq, { Duty.ar(1,0,Dseq([100,500,80,50],inf)) });

Veco.do { arg name;

	Ndef(name+++\fx).put(0, \setsrc -> Pbind(

		\source, Pseq([
			{
				var sig; 
				sig = SinOsc.ar(Ndef.ar(name+++\freq).lag(0.14) * [1,1.01]);
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},
			{
				var sig; 
				sig = LFSaw.ar(Ndef.ar(name+++\freq).lag(0.14)* [1,1.01]);
				sig = Pan2.ar(sig, 0, 0.1);
				sig.flop.postln;
			},

		],inf),
		\dur, 2,
	));

};

);

(
	Ndef(~name+++\fx).quant = Pdef.defaultQuant;
	Ndef(~name+++\freq).quant = Pdef.defaultQuant;
);


Ndef.clear



(
Ndef(\x,
    \setsrc -> Pbind(\source,
        Pseq([
            { LFTri.ar(280 * Line.kr(1.1, 0.4, rrand(2, 3)) + [0,1]) * 0.1 },
            { Pulse.ar(40 + [0,1]) * 0.1 },
            { LFTri.ar(LFTri.kr(1).round(1.0.rand) + 1 * 180 + [0,1], 0.04) * 0.3 },
        ], inf),
        \dur, 1/2,
    )
).play;
)

(

TempoClock.default.play ({
	Ndef(\y).put(0,
		\setsrc -> Pbind(\source,
			Pseq([
				{ LFTri.ar(280 * Line.kr(1.1, 0.4, rrand(2, 3)) + [0,1]) * 0.1 },
				{ Pulse.ar(40 + [0,1]) * 0.1 },
				{ LFTri.ar(LFTri.kr(1).round(1.0.rand) + 1 * 180 + [0,1], 0.04) * 0.3 },
			], inf),
			\dur, 1/2,
		)
	).play;

}, Pdef.defaultQuant);
)
Ndef(\y).quant = 4;
Ndef(\y).quant = nil

a = Order.new
a[10] = 100
a[410] = 140
a.asCompileString
Order.newFromIndices( [ 100, 140  ], [ 10, 410  ]  )



Ndef(\b, { LFDNoise0.ar(500)});
Ndef(\c, { LFDNoise1.ar(0.3).range(5,15)});
Ndef(\d, { LFDNoise3.ar(SinOsc.kr(0.1, 0, 1000, 300), 200, 200)});
Ndef(\a, { Limiter.ar(GVerb.ar(SinOsc.ar(Ndef(\d), mul: Ndef(\b)), roomsize: Ndef(\c)  ) )});
Ndef(\a).play;Ndef(\b, { LFDNoise0.ar(500)});
Ndef(\c, { LFDNoise1.ar(0.3).range(5,15)});
Ndef(\d, { LFDNoise3.ar(SinOsc.kr(0.1, 0, 1000, 300), 200, 200)});
Ndef(\a, { Limiter.ar(GVerb.ar(SinOsc.ar(Ndef(\d), mul: Ndef(\b)), roomsize: Ndef(\c)  ) )});
Ndef(\a).play;



Ndef(\b, { LFDNoise0.ar(500)});
Ndef(\c, { LFDNoise1.ar(0.3).range(5,15)});
Ndef(\d, { LFDNoise3.ar(SinOsc.kr(0.1, 0, 1000, 300), 200, 200)});
Ndef(\a, { Limiter.ar(GVerb.ar(SinOsc.ar(Ndef(\d), mul: Ndef(\b)), roomsize: Ndef(\c)  ) ) ! 2});
Ndef(\a).play;
Ndef(\a).clear



(
	Ndef(\y).put(0,
		\qsetsrc -> Pbind(\source,
			Pseq([
				{ LFTri.ar(280 * Line.kr(1.1, 0.4, rrand(2, 3)) + [0,1]) * 0.1 },
				{ Pulse.ar(40 + [0,1]) * 0.1 },
				{ LFTri.ar(LFTri.kr(1).round(1.0.rand) + 1 * 180 + [0,1], 0.04) * 0.3 },
			], inf),
			\dur, 1/2,
		)
	).play;
)
Ndef(\y).stop
Ndef(\y).play

Ndef(\y).quant = nil;
Ndef(\y).quant = 4;
Ndef(\y).quant = 1/4;





a = MIDIOut(0)
a.noteOn(0,2, 0x0f)
