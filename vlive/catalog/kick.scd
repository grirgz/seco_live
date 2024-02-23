(
// acid kick
// lfsaw + rlpf with dropping env in filter freq
SynthDef(\bigkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.ar(Env([1101,60,55],[0.001,0.1]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, env1, \rq.kr(0.01));
	sig = sig / 2;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\bigkick, Pbind(
	\instrument, \bigkick,
	\degree, Pseq([0],inf),
	\sustain, 0.1,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
// acid kick
// very small rq variation
// add a compander to shape overblowing
SynthDef(\bigkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.ar(Env([0801,109,60],[0.01,0.1]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, env1, \rq.kr(0.0001));
	sig = RLPF.ar(sig, env1, \rq.kr);
	sig = RLPF.ar(sig, env1, \rq.kr);
	sig = sig / 4;
	sig = Compander.ar(sig, sig, \cpt.kr(0.5), \cpbelow.kr(1.001), \cpabove.kr(0.2), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig / 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bigkick, Pbind(
	\instrument, \bigkick,
	\degree, Pseq([0],inf),
	\sustain, 0.1,
	\dur, 1,
	\amp, 0.1
)).play;
);

///

// stolen from sccode
(
SynthDef (\sc303 , {  arg  out=0, freq=440, wave=0, ctf=100, res=0.2,
		sus=0, dec=1.0, env=1000, gate=1, vol=0.1;
		var  filEnv, volEnv, waves;
		volEnv =  EnvGen .ar( Env .new([10e-10, 1, 1, 10e-10], [0.01, sus, dec],  'exp' ), gate, doneAction:2)-10e-10;
		filEnv =  EnvGen .ar( Env .new([10e-10, 1, 10e-10], [0.01, dec],  'exp' ), gate)-10e-10;
		waves = [ Saw .ar(freq),  Pulse .ar(freq, 0.5)];
		Out .ar(out,  RLPF .ar(  SelectX .ar(wave, waves), ctf + (filEnv * env), res).dup * vol * volEnv);
}).add;
)

(
Pdef(\demo, Pdef(\zed, 
	Ppar([
		Pdef(\303, 
			Pbind(
				\instrument, \sc303,
				\dur, 1,
				\amp, 0.1,
			),
		),
		
	])
)).play;
)

WindowDef(\PdefEditor).front(Pdef(\303))


//////////////

(
SynthDef(\basickick, { arg out=0, amp=0.1, pan=0, freq=200;
	var sig;
	var env = EnvGen.kr(Env([400,70,50],[0.02,0.08]), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basickick,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////////


(
SynthDef(\kick808, {arg out = 0, freq1 = 240, freq2 = 60, amp = 0.1, ringTime = 100, rel = 10000, dist = 1.5, pan = 0, tott=0.1, durr=0.001, gate=1;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, \glisdur.kr(0.1)),
		decaytime: ringTime);
	//env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env * \gain.kr(0.2);
	snd = Limiter.ar(snd, tott, durr) * 1.5 *(1/tott);
	snd = snd * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:0);
	//snd = Clip.ar(snd, -1 * tott, tott);
	//	snd = Fold.ar(snd, -1 * tott, tott);
	//	snd = Wrap.ar(snd, -1 * tott, tott);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

~t = 75/1/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,5,2,10,9,7,5,
						],1)+12,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,10,9, 5,4,5+12,4+12,
						],1)+12,
					],1),1/4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1.2,1.2,1,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.9,
				\ringTime, 100,
				//\durr, 0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\amp, 0.1,
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1236].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.051,
			\out, BusDef(\chainside, \audio),
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,5,2,10,9,7,5,
						],1)+12,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,10,9, 5,4,5+12,4+12,
						],1)+12,
					],1),1/4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1.2,1.2,1,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.9,
				\ringTime, 100,
				//\durr, 0.01,
				\lag, -0.04,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\amp, 0.1,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			//\lag, 0.0009,
			\cprelax, 0.3,
			\cpt, 0.005,
			\cpabove, 0.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
		
	])
)).play;
);
