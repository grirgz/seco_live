
// imaginary platform game
// level x: sweet morning

~t = 105/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\ether, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env = EnvGen.kr(Env([0,1,2],[1.1,1.8]), 1);
	mod1 = SinOsc.ar(freq) * LFNoise1.ar(0.1,mul:70,add:10); 
	mod1 = mod1 + mod1.fold2(0.2);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) * env + 1) + mod1);
	sig = BRF.ar(sig, freq * LFNoise1.kr(0.11,mul:0.4,add:1),0.7);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\etheram, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([0,1,2],[1.1,1.8]), 1);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) * env + 1));
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0,0.1,0.08]*0.5), Impulse.kr(12+Rand(0,0.1)*~t), levelBias:0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \etheram,
			\note, Pseq([
				[-5,0,4],
				[-5,2,5],
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \ether,
			\note, Pseq([
				-5,Pseq([[0,4]],7),
				-5,Pseq([[2,5]],7),
			],inf),
			\octave, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\fspread, Pseg(Pseq([0.001,0.9],inf),8,\exp),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\ether, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ether, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar([
			Pbind( \note, -5,),
			Pbind( \note, Pstep([0,2],4)).loop,
			Pbind( \note, Pstep([4,5],4)).loop,
		].collect({ arg pat;
			pat <> Pbind(
				\instrument, \ether,
				\octave, 5,
				\lag, 3.0.rand,
				\fspread, 0.001,
				\adsr, Pseq([
					[ Env.adsr(1.1,0.1,0.8,1.1) ],
				],inf),
				\dur, Pwhite(2,6),
				\amp, 0.1/4,
			)

		})),
		Ppar([
			Pbind( \note, -5,),
			Pbind( \note, Pstep([0,2],4)).loop,
			Pbind( \note, Pstep([4,5],4)).loop,
		].collect({ arg pat;
			pat <> Pbind(
				\instrument, \ether,
				\octave, 4,
				\lag, 3.0.rand,
				\fspread, 0.001,
				\adsr, Pseq([
					[ Env.adsr(1.1,0.1,0.8,1.1) ],
				],inf),
				\dur, Pwhite(2,6),
				\amp, 0.1/4,
			)

		})),
		Pbind(
			\instrument, \etherpiano,
			\degree, Pseq([
				Plazy({ arg ev;
					Pseq((0..rrand(5,8)),1) + rrand(-4,4)
				}).loop,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,1.1) ],
			],inf),
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
SynthDef(\etherpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env = EnvGen.kr(Env([0,1,2],[1.1,1.8]), 1);
	mod1 = SinOsc.ar(freq) * LFNoise1.ar(0.1,mul:70,add:10); 
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) * env + 1) + mod1);
	sig = BRF.ar(sig, freq * LFNoise1.kr(0.11,mul:0.4,add:1),0.7);
	mod1 = mod1 + mod1.fold2(0.2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\ronron, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq*4.midiratio) * 100;
	sig = SinOsc.ar(freq* LFNoise1.ar(0.1,mul:0.04,add:1) + mod1);
	sig = sig * SinOsc.ar(0.1,mul:0.4,add:0.5); 
	//sig = sig.clip2(0.5);
	//sig = sig + ( sig.clip2(0.5) * 0.2 ) * 0.8;
	sig = sig + DelayC.ar(sig, 0.1,0.1 *LFNoise1.ar(0.1,mul:0.4,add:1) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\ronron,
			\note, -5,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////////////
// level 0: village

(
SynthDef(\ether2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var lpenv, lpfreq;
	sig = LFPulse.ar(freq * LFNoise1.kr(0.1!num,mul:\fspread.kr(0.01),add:1));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(1.01,0.4,0.1,0.2),spec:ParamEnvSpec.adsr), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(730) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = HPF.ar(sig, \hpf.kr(800));
	sig = sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

SynthDesc(\ether2).controls[6].dump
SynthDesc(\ether2).controls[6].defaultValue.asEnv
[1,2,3,4].asEnv
(0..16).asEnv
SynthDesc(\ether2).controlDict[\lpadsr].dump
ControlName
SynthDesc(\ether2).def.allControlNames[6]
SynthDesc(\ether2).def.metadata
SynthDesc(\ether2)

(
Pdef(\part, Pdef(\mel1, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[5,9],
				[7,11],
			],inf).stutter(4),
			\dur, 1/4,
			\lpf, 700,
			\legato, 0.1,
			\lag, Pseg(Pwhite(0,0.021,inf), 4),
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,0.4) ],
			],inf),
			\amp, 0.1/3 * Pwhite(0.5,1,inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([11,12],inf),1),
			],inf),
			\dur, 1/4,
			\lpf, Pseg(Pseq([300,3001],inf),8),
			\lag, 0.1 + Pseg(Pwhite(0,0.021,inf), 4),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,0.4) ],
			],inf),
			\amp, 0.1/3 * Pwhite(0.5,1,inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \ether2,
			\note, Pseq([
				5,9,12,16,
				7,11,14,17,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,1.0) ],
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Ptpar([
			8, Pdef(\mel1)
		]),
		
	])
)).play;
);




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\melbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \ether2,
				\note, Pseq([
					5,9,12,16,
					7,11,14,17,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.4,0.1,0.8,1.0) ],
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \etherpiano2,
				\note, Pseq([
					0,Pseq([9-12],7),
					0,Pseq([11-12],7),
					0,Pseq([5],7),
					0,Pseq([7],7),
				],inf),
				\octave, 4,
				//\lag, Pseq([0, Pn(0.02,7)],inf),
				//\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
				\dur, 1/8,
				\amp, 0.1 * Pwhite(0.7,1),
			),
			Pbind(
				\instrument, \etherpiano3,
				\note, Pseq([
					4,2,0,-1,\r,
					-3,0,2,-1,\r,
				],inf),
				\octave, 6,
				\dur, 1/8 * Pseq([6,1,1,1,7],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.5) ],
				],inf),
				\amp, 0.1/3,
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\melbus, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, 0.1,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
// chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		
			Pbind(
				\instrument, \ether2,
				\note, Pseq([
					5,9,12,16,
					7,11,14,17,
					5,9,12,16,
					7,11,14,17,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.4,0.1,0.8,1.0) ],
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/2,
			),
	])
)).play;
);

(
SynthDef(\etherpiano2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-2), 1);
	mod1 = SinOsc.ar(freq * [1.01,1/2,2,2.01,1/2,1]) * [1,0.20,1,2] * 100 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = HPF.ar(sig, \hpf.kr(400));
	sig = sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\etherpiano3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-2), 1);
	mod1 = SinOsc.ar(freq * [1.01,1/2,2,2.01,1/2,1]) * [1,0.20,1,2] * 40 * env1;
	mod2 = ( SinOsc.ar(freq * 1 * [1,1/2,1.01] + mod1) * XLine.kr(1,1000,1) ).tanh * 150;
	sig = SinOsc.ar(freq * 1 + mod1 + mod2);
	sig = HPF.ar(sig, \hpf.kr(800));
	sig = sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))
(
	ControllerDef(\chord_piano, { arg def, target;
		var playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
		MIDIdef.noteOn(\piano, { arg velocity, noteNum, channel, deviceId;
			[ velocity, noteNum, channel, deviceId ].debug;
			playergroup.elAt(midinote).play((velocity:velocity));
		});
	})
)
ControllerDef(\)
MIDIdef.freeAll

(
ControllerDef(\piano_chord, { arg def, target; 
	var playergroup;
	var chord = [0,4,7,11,14];
	if(target.isNil) {
		MIDIdef.noteOff(\piano).remove;
		MIDIdef.noteOff(\piano_off).remove;
	} {
		playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			var velocity = args[0];
			args.debug("generic on");
			( chord+midinote ).do { arg note, idx;
				playergroup.elAt(note).play((velocity:velocity));
			};
		}).fix;
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			args.debug("generic off");
			( chord+midinote ).do { arg note, idx;
				playergroup.elAt(note).stop;
			};
		}).fix;
	};
}, [ \piano ]);
)



