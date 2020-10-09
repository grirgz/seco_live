
////////////////// half-steps

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,1,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,1],
			],inf),
			\octave, 6,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

////////////////// pitch bend

(
SynthDef(\bender, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, tsustain=1;
	var sig;
	var harms, num = 16;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env.kr(Env([1,1,( -2 ).midiratio],[0.1,0.3]/~t, 2)), gate, timeScale:tsustain);
	freq = freq * env1;
	//sig = SinOsc.ar(freq * ( SinOsc.kr(freq * \fmfr.kr(2) * ( SinOsc.ar(freq/2 * env1) * 0.005 + 1 ) ) * \fmamp.kr(0.5) + 1 ));
	harms = Array.series(num, 1, 1) * Array.exprand(num, 0.995, 1.001);
	sig = SinOsc.ar(freq * SinOsc.kr(Rand(2.0,5.0),0,Rand(0.001, 0.01),1) * harms, mul:Array.geom(num, 1, 0.63));
	sig = Splay.ar(sig);
	sig = BBandPass.ar(sig, freq * XLine.kr(0.1,4,0.01), 2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \bender,
			\note, Pseq([
				4,
			],inf),
			\tsustain, 4/~t,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);



//////////////// unrelated minor chords


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 1,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);


