(
SynthDef(\chovar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.01,1.3]), 1);
	sig = LFSaw.ar(freq * [1,1 + \det.kr(0.0001)]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
~t = 210/4/60; TempoClock.default.tempo = ~t;
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
};
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,3,7],
				[0,-5,-3],
			],inf).stutter(8),
			\legato, Pseq([
				0.4,1.2,
			],inf),
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\lag, Ptuple(
				Prand([

				Pwhite(0.0,0.051,1),
				1/8,
				],inf)
				!3),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)


Pdef(\part).clear;
Pdef(\zed).clear;




(
	~master.();
Pdef(\part, Pdef(\pdefgrid0_0, 
	Ppar([
		Pbind(
			\instrument, \chovar,
			\det, Ptuple (
				Pwhite(0.01,0.00001,inf)!3
			),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				Pfuncn({ arg ev;
					[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				}),
			],inf),
			\lpfr, Ptuple (
				Pwhite(0.41,2.50001,inf)!3
			),
			\note, Pseq([
				[ 2,6,-3, ],
				[ 2-3,6-2,-3-2, ],
				[ 2,6-12,-3, ],
				[ 2-3,6+1,-3, ],
			],inf).stutter(Pseq([7,9],inf)) + 
			Ptuple (
				Prand([0,0,0,0,0,0,12],inf)!3
			),
			\dur, 1/7,
			\amp, 0.1 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\pdefgrid0_1, 
	Ppar([
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf),
			\dur, 1/8,
			\amp, 0.1 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\pdefgrid0_2, 
	Ppar([
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\lpfr, 3.1,
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,rrand(0.01,0.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\lpfr, 3.1,
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf).collect({ arg x; x.choose }) + 12,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato,0.1,
			\dur, 1/8,
			//\amp, 0.1 * Ptuple(
				//Pwhite(0.1,1,inf)!3,
			//),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\sustain, 1/8,
			\speed, Pseq([
				1,1,1,1, 9/6,1,1,1,
			],inf),
			\pos, 0.03,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\lag, 0.08,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\pdefgrid0_3, 
	Ppar([
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\lpfr, 3.1,
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,rrand(0.01,0.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\lpfr, 3.1,
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf).collect({ arg x; x.choose }) + 12,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato,0.1,
			\dur, 1/8,
			//\amp, 0.1 * Ptuple(
				//Pwhite(0.1,1,inf)!3,
			//),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 2000 * Pseq([1,2,4],inf),
			\lpfmix, 1,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\sustain, 1/8,
			\speed, Pseq([
				1,1,1,1, 9/6,1,1,1,
			],inf),
			\pos, 0.03,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fac1,0.1 * Pseq([1,1,1,2],inf),
			//\lag, 1/20,
			\dur, 1/16,
			\amp, 0.02 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\lag, 0.01,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\pdefgrid0_4, 
	Ppar([
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\lpfr, 3.1,
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,rrand(0.01,0.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\lpfr, 3.1,
			\note, Pseq([
				Prand([
					[ 2,6,-3,-10 ],
					[ 2,6,-3, ],
					[ 2,6,-3, ],
					[ 2,7,-3, ],
				],7),
				Prand([
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,6-2,-3-2, ],
					[ 2-3,7,-3-2, ],
				],9),
			],inf).collect({ arg x; x.choose }) + 12,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato,0.1,
			\dur, 1/8,
			//\amp, 0.1 * Ptuple(
				//Pwhite(0.1,1,inf)!3,
			//),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 2000 * Pseq([1,2,4],inf),
			\lpfmix, 0.1,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\sustain, 1/8,
			\speed, Pseq([
				1,1,1,1, 9/6,1,1,1,
			],inf),
			\pos, 0.03,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fac1,0.1 * Pseq([1,1,1,2],inf),
			//\lag, 1/20,
			\dur, 1/16,
			\amp, 0.02 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\lag, 0.01,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\pdefgrid0_5, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 2000 * Pseq([1,2,4],inf),
			\lpfmix, 0.1,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\sustain, 1/8,
			\speed, Pseq([
				1,1,1,1, 9/6,1,1,1,
			],inf),
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
				1,1,1,0, 1,1,1,1,
				0,1,0,0, 1,0,1,1,
				1,1,1,1, 0,1,1,1,
				1,1,0,0, 1,1,1,1,
				0,1,0,1, 1,1,0,0,
				1,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\pos, 0.03,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fac1,0.1 * Pseq([1,1,1,2],inf),
			//\lag, 1/20,
			\dur, 1/16,
			\amp, 0.02 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		
	])
)).play;
)


TrackDef(\pdefgrid).edit
TrackDef(\pdefgrid).clear

ProtoDef(\rdn2).edit
ProtoDef(\rdn).edit
ProtoDef(\rdn2).outBus = 0

