
// c joli, je garde!
(
Pdef(\quart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200 * Pseg(Pseq([1,1/2,3/4,2],inf),1/2) * Pseg(Pseq([1,2],inf),2),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)


~t = 235/4/60; TempoClock.default.tempo = ~t;


///////////////////////////::

(
SynthDef(\melo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Impulse.ar(0);
	sig = Ringz.ar(sig, freq * [1,2/3,5/7], \decay.kr(0.2) * [1,0.32,0.23]).sum;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


ProtoDef(\melordn, ProtoTemplateDef(\rdn)).edit

(
Pdef(\quart, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(

			\kitIndex, 0,
			\out, BusDef(\sendbus1, \audio),
			\isRest, Pseq({[
				1,0,0,0, 0,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, Pseq([0.1],inf),
			\speed, 1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \melo,
			\out, BusDef(\sendbus1, \audio),
			\freq, 200 + Pseq([50,10,150],inf) * Pseq([5/7,1,1/2,3/4,2],inf) * Pseq([1,2],inf),
			\freq, 200 + Pseq([
				50,10,150,50,10,110,
				1,1,1,1,1,1,
			],inf) * Pseq([5/7,1,1/2,3/4,2,1,1,1,1,1,1,1],inf) * Pseq([1,2],inf),
			\decay, Pwhite(0.1,1),
			\lag, Pseg(Pseq([0,0.1],inf),1) * Pseg(Pseq([0,1],inf),8),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)
