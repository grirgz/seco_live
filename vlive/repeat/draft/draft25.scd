// continue idea of draft24 with mixers, rdn and controllers !

///////////////// LIB


(
~t = 185/4/60; TempoClock.default.tempo = ~t;
SynthDef(\noiser, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,10000],[1.1,2.8],2), 1);
	env2 = EnvGen.kr(Env([1,1,1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([100,100,17000],[0.01,2/~t], 4), 1);
	env4 = EnvGen.kr(Env([1,2,13],[0.1,1.8]), 1);
	sig = WhiteNoise.ar;
	sig = sig + SinOsc.ar([1,3,5,7]*10 * Rand(1,2.0) * env4 * ( 1 + ( SinOsc.ar(199.1234) * 10 * env4 ))) ;
	sig = HPF.ar(sig, env1);
	sig = BPF.ar(sig, env2)+sig/2;
	sig = LPF.ar(sig, env3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\snapsnare, { |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, \rel.kr(0.15)), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig/1.6;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * AmpComp.kr(freq, exp:0.9)/4 / 2;
	Out.ar(out, sig);
}).add;
SynthDef(\pad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,0.8,1]), 1);
	env2 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,2.8,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2]);
	sig1 = LFSaw.ar(freq*2);
	sig = sig + sig1;
	sig = sig.fold2(env1);
	sig1 = RLPF.ar(sig1, \lpfr.kr(2.1) * freq * env2, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean / 2;
	Out.ar(out, sig);
}).add;
SynthDef(\piano, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,0.8,1]), 1);
	env2 = EnvGen.kr(Env([3.1,1,2.51,0.1],[0.01,0.02,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2,4] * ( 1 + ( SinOsc.ar(freq*2) * 10 )));
	sig1 = LFSaw.ar(freq*[1,1/2,2,4]) * [1,env2,1];
	sig1 = RLPF.ar(sig1, \lpfr.kr(3.1) * freq * env2, \rq.kr(0.5));
	sig = sig + sig1;
	//sig = sig.fold2(env1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean / 2;
	Out.ar(out, sig);
}).add;
SynthDef(\piano2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.01,0.8,1]), 1);
	env2 = EnvGen.kr(Env([3.1,1,2.51,0.1],[0.01,0.02,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2,4] * ( 1 + ( SinOsc.ar(freq*2) * 10 )));
	sig1 = LFSaw.ar(freq*[1,1/2,2,4]) * [1,env2,1];
	sig = SinOsc.ar(freq * [1,1/2] * ( 1 + ( SinOsc.ar(freq * [1,1.001]) * 0.71 ))) * [1,env1] ;
	sig = sig  + ( sig1*env1*1/8 );
	//sig1 = RLPF.ar(sig1, \lpfr.kr(3.1) * freq * env2, \rq.kr(0.5));
	//sig = sig + sig1;
	//sig = sig.fold2(env1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean / 2;
	Out.ar(out, sig);
}).add;
SynthDef(\glitch, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fac = 400;
	sig = SinOsc.ar(freq) + Saw.ar(freq) / fac; 
	sig = MarkovSynth.ar(sig, 1, 0, 2) * fac;
	//sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp) / 2;
	Out.ar(out, sig);
}).add;
SynthDef(\busgroup, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);

(

	// define channels
	Pdef(\kick, Pbind(
		\gain, 1/2,
		\out, BusDef(\mixer0, \audio),
	));
	Pdef(\snare, Pbind(
		\gain, 1/2,
		\out, BusDef(\mixer1, \audio),
	));
	Pdef(\hat, Pbind(
		\gain, 1/3,
		\out, BusDef(\mixer2, \audio),
	));
	Pdef(\bass, Pbind(
		\out, BusDef(\mixer3, \audio),
	));
	Pdef(\pad, Pbind(
		\out, BusDef(\mixer4, \audio),
	));
	Pdef(\piano, Pbind(
		\out, BusDef(\mixer5, \audio),
	));
);


(

	ProtoDef(\simpleMixer).tracks[0].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[1].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[2].proxy.set(\send0, 1);
	ProtoDef(\rdn).outBus = BusDef(\mixer7);
	ProtoDef(\rdn).inBus = BusDef(\sendbus1);

	7.do { arg idx;
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\prefader, 1);
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\postdelay, 0.04);
	};

	~master = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};

		~startControl_mixer = {
			var k = MKtl('icon', "icon-icontrols");
			k[\sl].do({ arg knob, idx; 
				knob.action = { arg kn, val; 
					ProtoDef(\simpleMixer).tracks[idx].asParam(\postfader).normSet(kn.value)
				} 
			});
			k[\kn].do({ arg knob, idx; 
				knob.action = { arg kn, val; 
					ProtoDef(\simpleMixer).tracks[idx].asParam(\send1).normSet(kn.value)
				} 
			});

		};
		~startControl_rdn = {
			var k = MKtl('icon', "icon-icontrols");
			var params = [
				\fb,
				\delay,
				\delay2,
				\delay3,

				\distamp,
				\distamp2,
				\distamp3,
				\shiftmix,
				\shift,
			].collect({ arg key;
				Param(ProtoDef(\rdn).proxy, key)
			});
			//params = params ++ [ Param(s, \volume) ];
			params.do({ arg param, idx; 
				k[\sl][idx].action = { arg kn, val; 
					params[idx].normSet(kn.value)
				} 
			});
		};
	~startControl = {
		var k = MKtl('icon', "icon-icontrols");
		~startControl_mixer.();
		k[\tr][0][\on].action = {
			"Mixer mode".debug;
			~startControl_mixer.();
		};
		k[\tr][1][\on].action = {
			"Fx mode".debug;
			~startControl_rdn.();
		};

	};


);


~startControl.()
	ProtoDef(\simpleMixer).tracks[2].proxy.edit
	ProtoDef(\simpleMixer).edit;
//////////// SCORE

(
	Pdef(\endsnare, Pbind(
		\instrument, \snapsnare,
		\speed, 1,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,
			1,0,1,1, 1,1,1,1,
		],inf).coin.not,
		\sustain, 0.1,
		\rel, 0.1  * Pseg(Pseq([2,1],inf),2),
		\dur, 1/8,
		\amp, 0.1,
	));
	Pdef(\noiser1, Pbind(
		\instrument, \noiser,
		\degree, Pseq([0],inf),
		\legato, 1,
		\dur, Pseq([2],1),
		\amp, 0.1,
	));
);

(
	~master.();
Pdef(\part,Pdef(\intro, 
	Pseq([
		Ptpar([
			0, Pdef(\pad) <> Pseq([
				Pfindur(16/4, PmonoArtic( \pad,
					\legato, Pseq([
						1,1,1,0.8,
					],inf),
					\degree, Pseq([
						0,0,0,-1,
					],inf),
					\dur, 1,
					\amp, 0.2
				)),
				Pfindur(15/4, PmonoArtic( \pad,
					\legato, Pseq([
						1,1,1,0.8,
					],inf),
					\degree, Pseq([
						0,0,0,-1,
					],inf),
					\dur, 1,
					\amp, 0.2
				)),
				Pfindur(1/4, PmonoArtic( \pad,
					\legato, Pseq([
						0.81,
					],inf),
					\degree, Pseq([
						0,
					],inf),
					\dur, 1/4,
					\amp, 0.2
				)),
			],inf),
			4,	Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					1,0,1,0, 1,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),

			8, Pdef(\bass) <> Pbind(
				\instrument, \fmgbass,
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\fratio, 1,
				\octave, 3,
				\dur, 1,
				\amp, 0.2
			),
			12, Pdef(\kick) <> PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		]),

	],1),
)).play;
);

Pdef(\part).clear
(
	~master.();
Pdef(\part,Pdef(\verse1, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pdef(\pad) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pdef(\endsnare),
		Pseq([Rest(14), Pdef(\noiser1)],inf),
		
	])
)).play;
);

(
Pdef(\part,Pdef(\break, 
	Ppar([
		Pdef(\piano) <> PmonoArtic( \glitch,
			\degree, Pseq([2,2],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\dur, 1,
			\amp, ~pmodenv.(Pseq([0,0.1,0.2],inf), 8),
		),
		Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\pad) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pseq([
			Rest(12),
			Pdef(\piano) <> Pbind(
				\instrument, \piano,
				\degree, Pseq([
					Pser([
						2s,
					],12),
					Pser([
						-1,-1,1,1,
					],4),
				],inf),
				\legato, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/4,
				\octave, 6,
				\amp, 0.1 * Pseg(Pseq([0,1],inf),4),
				//\isRest, true,
			),
		],1),
		Pdef(\endsnare),
		Pseq([Rest(14), Pdef(\noiser1)],inf),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\chorus, 
	Ppar([
		Pdef(\snare) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\kick) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pdef(\pad) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pdef(\piano) <> Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,
				],12),
				Pser([
					-1,-1,1,1,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),
		Pdef(\endsnare),
		Pseq([Rest(14), Pdef(\noiser1)],inf),

	])
)).play;
);

(
Pdef(\part, Pdef(\bridgeprep, 
	Ppar([
		Pdef(\snare) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\kick) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\legato, 0.4,
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pdef(\pad) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pdef(\piano) <> Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,2s,\r,\r,
				],12),
				Pser([
					\r,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),
		Pdef(\piano) <> Pbind(
			\instrument, \piano2,
			\degree, Pseq([
				Pser([
					4,2s,
				],16),
				Pser([
					\r,
				],0),
			],inf),
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1 * Pseg(Pseq([0,0,0,0,1],inf),4),
			//\isRest, true,
		),
		Pdef(\endsnare),
		Pseq([Rest(14), Pdef(\noiser1)],inf),

	])
)).play;
);

(
Pdef(\part,Pdef(\bridge, 
	Ppar([
		Pdef(\snare) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\kick) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\legato, 0.4,
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pdef(\pad) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pdef(\piano) <> Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,2s,\r,\r,
				],12),
				Pser([
					\r,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),
		Pdef(\piano) <> Pbind(
			\instrument, \piano2,
			\degree, Pseq([
				Pser([
					4,2s,
				],16),
				Pser([
					\r,
				],0),
			],inf),
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),
		Pdef(\endsnare),
		Pseq([Rest(14), Pdef(\noiser1)],inf),

	])
)).play;
);

(
Pdef(\part, Pdef(\verse2, 
	Ppar([
		Pdef(\snare) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\kick) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pdef(\pad) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pdef(\endsnare),
		Pseq([Rest(14), Pdef(\noiser1)],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\outro, 
	Pseq([
		Ppar([
			Pdef(\pad) <> Pfindur(16, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,0,
				],inf),
				\dur, 2,
				\amp, 0.2
			)),
			Pfindur(8,
				Pdef(\hat) <> PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq({[
						1,0,1,0, 1,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			),

			Pfindur(12,
				Pdef(\bass) <> Pbind(
					\instrument, \fmgbass,
					\degree, Pseq([
						0,0,0,0,
					],inf),
					\fratio, 1,
					\octave, 3,
					\dur, 2,
					\amp, 0.2
				),
			),
		]),

	],1),
)).play;
);

/////////////////// MAIN

(
	~master.();
Pdef(\main, 
	Pseq([
		Ptask({ "======= intro".debug; }),
		Pfindur(16,Pdef(\intro)),
		Ptask({ "======= part1".debug; }),
		Pfindur(16,Pdef(\verse1)),
		Pfindur(16,Pdef(\break)),
		Pfindur(16,Pdef(\verse1)),
		Pfindur(16,Pdef(\verse1)),
		Ptask({ "======= break prechorus".debug; }),
		Pfindur(16,Pdef(\break)),
		Ptask({ "======= chorus".debug; }),
		Pfindur(16,Pdef(\chorus)),
		Pfindur(16,Pdef(\chorus)),
		Ptask({ "======= start big void".debug; }),
		Pfindur(16,Pdef(\outro)),
		Rest(16),
		Pfindur(16,Pdef(\intro)),
		Pfindur(16,Pdef(\bridgeprep)),
		Pfindur(16,Pdef(\bridgeprep)),
		Pfindur(16,Pdef(\bridge)),
		Pfindur(16,Pdef(\bridge)),
		Ptask({ "======= break prechorus".debug; }),
		Pfindur(16,Pdef(\break)),
		Ptask({ "======= chorus".debug; }),
		Pfindur(16,Pdef(\chorus)),
		Pfindur(16,Pdef(\chorus)),
		Pfindur(16,Pdef(\verse2)),
		Pfindur(16,Pdef(\verse2)),
		Pfindur(16,Pdef(\outro)),
	])
).play;
);

/////////////////// CONTROL


ProtoDef(\simpleMixer).edit;
ProtoDef(\rdn).edit;
ProtoDef(\rdn).edit;
~startControl.()
	ProtoDef(\simpleMixer).tracks[2].proxy.edit
	ProtoDef(\simpleMixer).edit;


////////////////// DRAFT

(
Pdef(\idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,
				],12),
				Pser([
					-1,-1,1,1,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),

	])
).play;
)

(
Pdef(\draft, 
	PmonoArtic( \glitch,
	\degree, Pseq([2,2],inf),
	\legato, Pseq([
		1,1,1,0.9,
	],inf),
	\dur, 1,
	\amp, 0.1,
)
).play;
);

(
Pdef(\idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pbind(
			\out, BusDef(\fx1, \audio),
		) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,
				],12),
				Pser([
					-1,-1,1,1,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),

	])
).play;
)


(

);

(
Pdef(\noiser1, Pbind(
	\instrument, \noiser,
	\degree, Pseq([0],inf),
	\legato, 1,
	\dur, Pseq([2],1),
	\amp, 0.1,
)).play;
);
