
////////////////
// set fx by pattern

(
SynthDef(\myfx, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(0), 2); 
	sig = in;
	sig = sig * SinOsc.ar(\amfreq.kr(400));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
	~mygroup = Group();
	~mybus = Bus.audio(s,2);
	~myfx = Synth(\myfx, [ \inbus:~mybus ], target:~mygroup);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\group, ~mygroup,
			\dur, 1,
			\out, ~mybus,
			\amp, 0.1,
		),
		Pbind(
			\type, \set,
			\id, ~myfx.nodeID,
			\args, [\amfreq],
			\amfreq, Pseq([1000,300],inf),
			\dur, 1/8,
		),
		
	])
)).play;
);

//////////////////// set pattern fx by pattern

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\out, ~mybus,
			\amp, 0.1,
		),
		Pmono(\myfx,
			\inbus, ~mybus,
			\addAction, \addToTail,
			\dur, 1,
			\mix, Pseq([1,0.3],inf),
			\callback, { Pdefn(\fxid, ~id.debug("id")) },
		),
		Pbind(
			\type, \set,
			\id, Pdefn(\fxid),
			\lag, 0.001,
			\args, [\amfreq],
			\amfreq, Pseq([1000,300],inf),
			\dur, 1/8,
		),
		
	])
)).play;
);

///// ndef fx


Ndef(\pat)[0] = Pbind();
Ndef(\pat).play(~mybus, 2);
Ndef(\fx)[0] = \myfx;
Ndef(\fx)[1] = \pset -> Pdef(\fx, Pbind(\inbus, ~mybus, \amfreq, Pseq([1000,300],inf), \dur, 1/8));
Ndef(\fx).play;
Pbindef(\fx, \dur, 1/4);
Ndef(\fx)[1] = \pset -> Pdef(\fx, Pbind(\inbus, ~mybus, \amfreq, Pseq([100,200,300],inf), \dur, 1/8));

///// control bus feedback

(
~mycontrolbus = Bus.control(s, 1);
~mybus = Bus.audio(s,2);
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~mycontrolbus.asMap,
			\dur, 1,
			\amp, 0.1,
			\out, ~mybus,
		),
		Pmono(\envfollow,
			\dur, 1,
			\amp, 0.1,
			\mul, 10000,
			\add, 300 * Pseq([0,3,7],inf).midiratio,
			\inbus, ~mybus,
			\krout, ~mycontrolbus,
		),
		
	])
)).play;
);


(
SynthDef(\envfollow, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = EnvFollow.ar(sig.mean);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	sig = sig * \mul.kr(1) + \add.kr(0);
	Out.kr(\krout.kr(0), sig.poll);
	Out.ar(out, in);
}).add;
);
