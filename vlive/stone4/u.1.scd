


(
SynthDef(\guitar, { arg out=0, freq=400, pan, rand, delayTime, delayTime2=1.4, noiseType=1, timeScale=1;

	var x, y, env;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var note = freq;

	env = Env.new([1, 1, 0], [1, 1/2]);
	// A simple exciter x, with some randomness.
	sig1 = WhiteNoise.ar;
	sig2 = LFNoise1.ar(10107) + LFSaw.ar(SinOsc.ar(freq/4) * 4 + 1 * freq * 2 );
	
	sig = SelectX.ar(\mix.kr(1), [sig1, sig2]);
	x = Decay.ar(Impulse.ar(0, 0, rand), 0.41+rand, sig); 
	x = CombL.ar(x, 0.05, note.reciprocal * [1,1.01,1.02], delayTime); 
	x = CombL.ar(x, 0.05, note.reciprocal * [1,1.01,1.02], delayTime2)/20; 
	env1 = EnvGen.kr(Env([1,2,1],[0.4,0.1]), 1, timeScale: [1,1.1,0.7,0.5] * timeScale);
	x = RLPF.ar(x, \lpf.ar(500) * [1,1.1,2,1.01] * env1, 0.1);
	x = Pan2.ar(x, pan * { LFNoise1.kr(1/2).range(0.0,1.0)}!x.size).flop;
	x = x * EnvGen.ar(env, doneAction:2, timeScale:timeScale);
	x = LeakDC.ar(x);
	Out.ar(out, x);

}).add;
);

(
Pdef(~name, 

	Pbind(\instrument, \guitar, // using our sine synthdef

		\note, Pseq([ \cm ].chordProg,inf),
		\ctranspose, Pstep(Pseq([0,4],inf),2),

		\dur, Pseq.new([0.25, 0.5, 0.25, 1], inf),  // dur arg
		\lpf, Pwhite(200,900.0),
		\mix, 1,
		\mix, Pseq([0,1],inf).stutter(4),

		\rand, Prand.new([0.2, 0.15, 0.15, 0.11], inf),  // dur arg
		\rand, 0.01,

		\pan, Pwhite(-1,1.0) * 0.5,
		\dur, 1/4,

		\delayTime, 2+1.0.rand,  // envdur arg
		\delayTime, Ptuple([
			Pwhite(0.5,1),
			Pwhite(0.5,1),
			Pwhite(0.5,1),
		])/1,
		\delayTime2, Ptuple([
			Pwhite(0.5,1),
			Pwhite(0.5,1),
			Pwhite(0.5,1),
		])/4,
		\timeScale, 0.1/1,
	)

);
)
