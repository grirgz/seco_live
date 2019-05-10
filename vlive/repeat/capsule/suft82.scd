
~t = 135/4/60; TempoClock.default.tempo = ~t;

(
	///// from draft6

SynthDef(\evol, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]/1), 1);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(72 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * env4 )));
	sig = sig * (LFSaw.ar(freq)*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\evoltreb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = 16/10;
	sig = SinOsc.ar(freq * [1,1] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = 16/10;
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = SelectX.kr( SinOsc.kr(1/16).exprange(0.0001,1), [1, 16/10]);
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdefn(\chords, Pstep(Pseq([
	0,-1,0,-1,
	0,-1,-2,-1,
],inf),4));
Pdef(\evoltreb, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				\evoltreb,
				\evoltreb2,
				\evoltreb3,
				\evoltreb3,
			],inf).stutter(8*4*4),
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([

				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,1, 0,2,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				10,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1.8,0,1,
				7,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
		);
	])
).play;
Pdef(\evolbass, 
	Ppar([
		Pbind(
			\instrument, \evol,
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		);
	])
).play;
~master.();
Pdef(\main).play;
);


(
SynthDef(\devol, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]/1), 1);
	lfo1 = SinOsc.ar(30 * env3).range(1/2,1);
	lfo2 = LFTri.ar(10 * env2).range(2,1);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(lfo2 *72 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * env4 )));
	sig = sig * (LFSaw.ar(freq)*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3 * lfo1, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\devoltreb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = SelectX.kr( SinOsc.kr(1/6 * env1).exprange(0.0001,1), [1, 16/10]);
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\env, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig1.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\envshifter, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig1.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);
	sig = CombL.ar(sig, 0.3,0.03,1)+sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\devolbass, 
	Ppar([
		Pbind(
			\instrument, \devol,
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \devoltreb,
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords)+7,
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\env, \audio),
			\octave, 5,
			\dur, 1/8,
		),
		Pmono( \envshifter,
			\inbus, BusDef(\env, \audio),
			\isustain, 0.1 * Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				8,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\itrig, Pkey(\isustain),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
				[ Env.adsr(0.1,0.1,0.8,0.04) ],
				[ Env.adsr(0.1,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)

	(
	SynthDef(\cymbalsimple2, { | out = 0, pan = 0.0 |
		var sig, env;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		var freqs;
		env = EnvGen.ar(Env.perc(0.01, 2, curve: -4), doneAction: 2);
		env1 = EnvGen.kr(Env([0,1,0],[0.01,0.08]), 1);
		freqs = {exprand(30, 20000)}.dup(50) ++ {exprand(1020, 10000)}.dup(50);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), freqs).mean, ( 1.1- env1 )*4000);
		sig = sig + EnvGen.ar(Env.perc(0.001,0.001,1), levelScale:1/2);
		sig = sig + LPF.ar(WhiteNoise.ar(0.1),EnvGen.ar(Env.perc(\att.kr(0.5),\rel.kr(5),1))* 20000+10,mul:2);
		sig = sig / 3;
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;
	)

(
SynthDef(\devol2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0.001,1/18,8],[2,2.4,2.8]/1), 1)+\bias1.kr(0);
	env5 = EnvGen.kr(Env([0,0.001,0.01,1/8],[2,4.1,2.8]/1), 1)+\bias2.kr(0);
	lfo1 = SinOsc.ar(\lfo1.kr(3) * env3).range(1/2,1);
	lfo2 = LFTri.ar(\lfo2.kr(1) * env2).range(2,1);
	freq = [1,1.0001]*freq;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(lfo2 *72 * ( 1 + ( SinOsc.ar(12) * env4 ))) * env5 )));
	sig2 = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(lfo2 *72 * ( 1 + ( SinOsc.ar(12) * env4 ))) * env5 )));
	sig = SelectX.ar( SinOsc.ar(freq/1000), [sig, sig2]); 
	//sig = sig * (LFSaw.ar(freq)*env1+1);
	//sig = RLPF.ar(sig, freq * \lpfr.kr(1.2) * env2, \rq.kr(0.5)) + ( sig );
	//sig = RLPF.ar(sig, 1000 * env3 * lfo1, 0.5) + ( sig/4 );

	//sig2 = LFSaw.ar(freq);
	sig2 = sig;
	sig2 = RLPF.ar(sig2, freq * \lpfr.kr(1.2), \rq.kr(0.5));
	sig = sig2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/5,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.9,
			\gain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\speed, 0.9,
			\gain, 0.05,
			\dur, 1/8/2,
		)),

		[
			[0,3,14,11,0+24],
			[0,3,14,11,0+24]+4,
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
		].flop.collect({ arg no, idx;
			no.debug("nooo");

			Pseq([
				Pmono( \devol2,
					\lfo1, Pwhite(1.0,50),
					\lfo2, Pwhite(1.0,50),
					\bias1, Pwhite(0.0,0.50),
					\bias2, Pwhite(0.0,0.50),
					\note, Pseq([
						Pseq(no)
					],1),
					\dur, 1 + (idx *0.02),
					\amp, 0.1/7,
				),
				Pbind(\instrument, \devol2,
					\lfo1, Pwhite(1.0,50),
					\lfo2, Pwhite(1.0,50),
					\note, Pseq([
						Pseq(no)
					],1),
					\dur, 1 + (idx *0.02),
					\amp, 0.1/7,
				),
			],4);
		})
		
	].flat)
)).play;
)

{ SinOsc.ar(200) ! 2 * 0.1}.play;
		(
		Pseq([
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
		].flop,1).asStream.nextN(100,()).collect(_.postln)
		)
		(
		Pseq([
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
		].flop,1).asStream.nextN(100,()).collect({ Pbind() })
		)
		(
		Pseq([
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
		].flop,1).iter.collect({ Pmono(\default) }).play
		)
		Pseq([1,2],0).asStream.asArray.collect({ arg x; x.postln; x})

(
SynthDef(\longrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var ofreq = freq;
	sig = SinOsc.ar();
	freq = freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 );
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2 * SinOsc.kr(Rand(3,1/4)).range(0,1), [sig1, sig2, sig3]);
	env1 = EnvGen.kr(Env([1/2,1.2,1.2],[0.01,0.8]), 1);
	sig = RLPF.ar(sig, \lpfr.kr(1/2) * ofreq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\castle, 
	Ppar([
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,1),
				Pseries(1,10,100),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,1/8,1/2,1],1).keep(1).repeat(inf) * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
		)}!3),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
		)}!3),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 1,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\echoer, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0,1,1],[0.0,0.4,0.8]), \itrig.tr(1));
	sig = in;
	sig = sig * SinOsc.ar(300);
	sig = CombL.ar(sig, 0.1,\delay.kr(0.011),\decay.kr(10)) + sig;
	sig = SelectX.ar(\mix.kr(1) * env1, [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\castle_nude, 
	Ppar([
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,4).stutter(Pseq([4,3],inf)),
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, rrand(1/2,1/16),
			\lag, rrand(0,0.3),
			\amp, 0.1,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\dur, 1,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\castle_perc, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,1, 1,0,0,1,

				1,0,0,0, 0,0,1,1,
				0,0,0,1, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq([1,2,10,1/101,4]/11,inf), 8),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],16),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\velamp,4,
			\dur, 1/16,
		)),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,4).stutter(Pseq([4,3],inf)),
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, rrand(1/2,1/16),
			\lag, rrand(0,0.3),
			\amp, 0.1 * 0.8,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\gain, 0.8,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\castle_dist, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.18], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/4,
			\dur, 1/16,
			//\out, BusDef(\limiter2, \audio),
		)),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq(1/[10,101,1,504,60,20,1,70]/2,inf), 1.712),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
			\out, BusDef(\limiter2,\audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq(1/[10,101,204,60,20,1,70],inf), 1.412),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
			\out, BusDef(\limiter2,\audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq(1/[10,101,504,60,20,1,70],inf), 1),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
			\out, BusDef(\limiter2,\audio),
		),
		Pmono(\fx_limiter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\limiter2, \audio),
			\level, 0.1/2,
			\limdur, 0.001,
			\gain, 1,
			\dur, 1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],16),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\velamp,4,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,4).stutter(Pseq([4,3],inf)),
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, rrand(1/2,1/16),
			\lag, rrand(0,0.3),
			\amp, 0.1 * 0.4,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\gain, 0.8,
			\dur, 1,
			\out, BusDef(\limiter, \audio),
		),
		Pmono(\fx_limiter,
			\inbus, BusDef(\limiter, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\level, 0.1/2,
			\limdur, 0.001,
			\gain, 1,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\castle_calme, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,1, 1,0,0,1,

				1,0,0,0, 0,0,1,1,
				0,0,0,1, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\isRest, true,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq([1/101,1/54]/11,inf), 8),
			\itrig,Pseq([0,1],inf),
			\gain, 0.4,
			\mix, 0.4,
			\dur, 1/2,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],16),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\velamp,4,
			\dur, 1/16,
			\isRest, true,
		)),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				0,
				1,
			],inf).stutter(8).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\lag, rrand(0,0.3),
			\amp, 0.1 * 0.8,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\decay, 1,
			\itrig,1,
			\gain, 0.8,
			\dur, 1,
		),
	])
)).play;
);

Pseq([
],inf),

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\evolbass),
		//Pdef(\devolbass),
		Pdef(\castle_perc),
		//Pdef(\castle_calme),
		
	])
)).play;
);
		Pdef(\devolbass).play

TrackDef(\keyer, TrackTemplateDef(\keyer)).source



(
	Pdef(\part, Pdef(\zed, 
		Ppar([
		Pdef(\evolbass),
		Pdef(\evoltreb),
			Plazy({ arg ev;
				Pfindur([4,2,8,1,6,3].choose,
					PatKitDef(\rim).asPattern(Pbind(
						\kitIndex, [0,1,2,4,5,8].choose,
						\isRest, Pseq([
							1,
						],inf).coin.not,
						\sustain, 0.1,
						\gain, 0.2,
						\dur, (1..8).choose/8,
						\speed, Pseq([
							rrand(0.4,1.4)
						],inf),
					)),
				);
			}).loop!8,
		].flat,20),
	)).play;
);






(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1, 
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1, 0,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1, 

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,1, 1,0,0,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,1,0,0,
				0,0,0,0, 1,0,1,0, 0,0,1,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,1,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.06,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/6,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,1, 0,1,1,0, 0,0,0,1, 1,0,1,0,
				0,0,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 221.85797297904,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,1,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,1,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,1,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)


~inline_editor = { arg ...args; args.debug("args") }


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\gain, 1,
		)
	])
)).play;
);


(
SynthDef(\drodro, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig = sig * SinOsc.ar(freq*( 3/2 ) * ( SinOsc.ar(sig.abs+0.1 * freq) * 1 + 1 ));
	//sig = sig * LFSaw.ar(313 * ( SinOsc.ar(sig) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\drodro, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * ( SinOsc.ar(Rand(0.01,0.1)) * 1 + 1 ) + 1)); 
	sig = sig + sig.fold2( SinOsc.ar(0.1 * [1,1.1])  ).mean / 2;
	//sig = sig * LFSaw.ar(313 * ( SinOsc.ar(sig) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig.clump(4), pan, amp).mean;
	sig.mean.debug("sig");
	Out.ar(out, sig);
}).add;
SynthDef(\comby, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = CombL.ar(sig, 0.4, 1/8/~t,1/~t) + sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zed, 
	Pseq([
		Pfindur(4,
			Ppar([
				Psched([0,3.5], Ppar([
					{ arg x;
						Pbind(
							\instrument, \drodro,
							\note, Pseq([
								Pseq((1..3+x),1),
								Pseq((1..3+x).reverse,x+1),
							],inf),
							\dur, 1/7,
							\lag, x/3,
							\octave, x+4,
							\legato, 1,
							\adsr, Pseq([
								[ Env.adsr(0.1,0.1,0.8,4.1) ],
							],inf),
							\amp, 0.1,
							\out, BusDef(\fxbus1, \audio),
						)
					}!4,
					Pmono(\comby,
						\inbus, BusDef(\fxbus1, \audio),
						\dur, 1,
					),
				].flat)),
				Psched([3.5,4],
					Pbind(
						\instrument, \default,
						\freq, [
							3250,
							1151,
							2202,
							2720,
						],
						\dur, 1/2,
						\amp, 0.1,
					),
				)
			].flat),
		),
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,0,1, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
			)),
			Pmono(\drodro,
				\note, Pseq([
					0
				],inf),
				\octave, 6,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\drodro,
				\note, Pseq([
					5,9,
				],inf),
				\octave, 6,
				\dur, Prand([1/8,1/3],inf),
				\amp, 0.1,
			),
		])
	],1),
)).play;
);
