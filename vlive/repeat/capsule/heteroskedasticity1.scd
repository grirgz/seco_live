~t = 150/2/60; TempoClock.default.tempo = ~t;

(
~master = {
	ProtoDef(\vin31_mainMixer).play;
	Ndef(\fx2).play;
	Ndef(\fx3).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	ProtoDef(\rdn4).play;
};
~master.();
)

(
SynthDef(\darkyoct, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.5,0.9,0.4,0.1)), gate, doneAction:0);
	env2 = EnvGen.kr(\fmenv.kr(Env.adsr(0.1,0.9,0.4,0.1)), gate, doneAction:0);
	sig1 = SinOsc.ar(freq * ( LFCub.kr([1+Rand(0,0.1),1.1]/100) * 0.1 + 1 ) * ( SinOsc.ar(freq) * 0.1 + 1 ));
	sig4 = SinOsc.ar(freq * 2 * ( LFCub.kr([1+Rand(0,0.1),1.1]/Rand(1,10.0)) * 0.1 + 1 ) * ( SinOsc.ar(freq) * 0.1 + 1 )) * 0.4;
	sig5 = SinOsc.ar(freq * 2 * ( LFCub.kr([1+Rand(0,0.1),1.1]/100) * 0.1 + 1 ) * ( SinOsc.ar(freq*2/3) * 0.1 + 1 )) * 0.3;
	sig2 = LFSaw.ar(freq/2 * ( SinOsc.kr([1+Rand(0,0.1),1.1]/100) * 0.1 * env2 + 1 ) )*0.2;
	sig2 = RLPF.ar(sig2, \lpfr.kr(2.1) * freq * (env1 + 1), \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1.01*2] *.t ( (1..20)/4 +1 )).flop.mean.debug("k") * EnvGen.kr(Env([0,1,0.7,0],[0.01,0.78,1]), 1);
	sig3 = RLPF.ar(sig3, \lpfr2.kr(2.1) * freq * (env1 + 1), \rq.kr(0.5));
	sig = [sig1,sig2, sig3, sig4, sig5].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig.debug("sig");
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\envtab, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = 20.collect({ arg x;
		EnvGen.kr(Env([0,1,0],[0.1+(x/17),3.8]).circle, 1);
	});
	sig = LFSaw.ar(freq * ( SinOsc.ar(env1 * 0.04 + 1 * freq) * env1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 *3.4 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

/////// mixer

ProtoDef(\vin31_mainMixer).tracks[0].name = "drums";
ProtoDef(\vin31_mainMixer).tracks[1].name = "hi1";
ProtoDef(\vin31_mainMixer).tracks[2].name = "hi2";
ProtoDef(\vin31_mainMixer).tracks[3].name = "harddrums";
ProtoDef(\vin31_mainMixer).tracks[4].name = "bass";

/////// trackgrid
(
TrackDef('vin31_mainTrackGrid').elAt(0).source = [
	Pdef(\introdrums),
	Pdef(\drums1),
	Pdef(\drums2),
	Pdef(\drums3),
	Pdef(\drumsf1),
	Pdef(\drumsf2),
	nil,
	nil,
	nil,
];
);

(
TrackDef('vin31_mainTrackGrid').elAt(1).source = [
	Pdef(\harddrums),
	Pdef(\harddrums2),
	Pdef(\harddrums3),
	Pdef(\harddrums4),
	Pdef(\harddrums5),
	Pdef(\fulldrums),
	nil,
	nil,
	nil,
];
);


(
TrackDef('vin31_mainTrackGrid').elAt(2).source = [
	Pdef(\bass_long),
	Pdef(\bass_long2),
	Pdef(\bass_short),
	Pdef(\bass_short2),
	Pdef(\bass_rand),
	Pdef(\bass_bip),
	nil,
	nil,
	nil,
	nil,
];
);

(
TrackDef('vin31_mainTrackGrid').elAt(3).source = [
	Pdef(\hi_const),
	Pdef(\hi_const2),
	nil,
	nil,
	nil,
];
);

(
TrackDef('vin31_mainTrackGrid').elAt(7).source = [
	Pdef(\drumhi1),
	Pdef(\drumhi2),
	Pdef(\drumhi3),
	Pdef(\drumhi4),
	Pdef(\drumhi5),
];
);

ProtoDef(\vin31_mainMixer).tracks.size
ProtoDef(\vin31_mainMixer).trackCount
ProtoDef(\vin31_mainMixer).trackCount = 13


/////////

(
Pdef(\part, Pdef(\introdrums, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],3+8),
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumhi1, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				0,-1,-2,-3,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				0,-1,-2,-3,
			],inf)+3,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.3,1.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1*0.3,
			\out, BusDef(\mixer1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumhi2, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				4,0,0,0, 2,0,0,1,
				4,0,0,0, 2,0,0,1,
				4,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				4,0,0,0, 0,0,2,0,
				1,0,1,0, 0,0,1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumhi3, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				4,0,0,0, 0,0,2,0,
				1,0,1,0, 0,0,1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumhi4, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,1,
					0,1,1,1, 1,0,0,1,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,1,1,
					0,0,1,1, 1,1,0,1,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0, 
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumhi5, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,1,0,


					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,

					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],1),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,1,1, 0,0,0,1,
						],1),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,1, 0,0,0,1,
						],1),
						Pseq([
							0,1,0,1, 1,0,0,0,
							0,0,0,0, 1,1,0,0,
						],1),
						Pseq([
							0,0,0,0, 0,1,0,0,
							1,0,0,1, 0,0,0,1,
						],1),
					],8),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,

					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,


					Prand([
						0,0,1,0, 0,1,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,1,
						0,0,1,0, 0,1,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					].clump(8).collect(Pseq(_)),8),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				0,-1,-2,-3,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				0,-1,-2,-3,
			],inf)+3,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.3,1.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1*0.3,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				4,0,0,0, 0,0,2,0,
				1,0,1,0, 0,0,1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\harddrums, 
	Ppar([
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,1, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		
		]),
	])
)).play;
);

(
Pdef(\part2, Pdef(\harddrums2, 
	Ppar([
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,1,
					0,0,1,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],1),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		
		]),
	])
)).play;
);

(
Pdef(\part2, Pdef(\harddrums3, 
	Ppar([
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,1,
					0,0,1,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],1),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[243].value,
				\bufnum, ~buflib.hat[61].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 1,0,1,1,
					1,0,0,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		
		]),
	])
)).play;
);

(
Pdef(\part2, Pdef(\harddrums4, 
	Ppar([
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[243].value,
				\bufnum, ~buflib.hat[61].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		
		]),
	])
)).play;
);

(
Pdef(\part2, Pdef(\harddrums5, 
	Ppar([
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,1,
					0,0,1,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],1),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\fulldrums, 
	Ppar([
		
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,1, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		
		]),
	])
)).play;
);

////////////////



(
Pdef(\part, Pdef(\bass_long, 
	Ppar([
		Pbind(
			\instrument, \envtab,
			\out, BusDef(\mixer4, \audio),
			\note, Pseq([
				0,1,10,20,
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bass_long2, 
	Ppar([
		Pbind(
			\instrument, \envtab,
			\out, BusDef(\mixer4, \audio),
			\note, Pseq([
				0,1,-2,-4,
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bass_short, 
	Ppar([
		Pbind(
			\instrument, \envtab,
			\out, BusDef(\mixer4, \audio),
			\note, Pseq([
				0,1,10,20,
			],inf),
			\sustain, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bass_bip, 
	Ppar([
		Pbind(
			\instrument, \envtab,
			\out, BusDef(\mixer4, \audio),
			\note, Pseq([
				0,1,10-12,20-12,
			],inf),
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bass_short2, 
	Ppar([
		Pbind(
			\instrument, \envtab,
			\out, BusDef(\mixer4, \audio),
			\note, Pseq([
				0,1,10,20-12,
			],inf).stutter(4*4),
			\legato, Pseq([
				Prand([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						4,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],1),
					Pseq([
						2,0,1,0, 0,1,0,0,
						0,0,1,0, 1,0,0,1,
					],1),
					Pseq([
						2,0,0,1, 0,0,1,0,
						0,0,1,0, 0,1,0,0,
					],1),
					Pseq([
						1,0,0,1, 3,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
				],inf),
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bass_rand, 
	Ppar([
		Pmono(\envtab,
			\note, Pseq([
				Pbrown(0,10,1),
			],inf),
			\out, BusDef(\mixer4, \audio),
			\octave,3,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1,0.1],inf), 4.8),
			\dur, Pseq([1,2,3,4]).stutter(41),
			\dur, Pseg(Pseq([1,1/7],inf),8),
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////////////:

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
			
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1 * Pseq([
					//1,0.2,0.5,0.3,
					Pseq([ 1,0.2,0.5,0.3, ],1) * Pwhite(0.7,1.2,1).stutter(4),
				],inf).stutter(2),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1100].value,
				\isRest, Pseq([
					1,0,0, 0,0,0,
					1,0,0, 0,0,0,
					1,0,0, 1,0,0,
					1,0,0, 0,0,1,

					1,0,0, 1,0,0,
					1,0,0, 1,0,0,
					1,0,0, 1,0,1,
					1,0,1, 1,0,1,

					1,0,0, 1,0,1,
					0,0,0, 1,0,0,
					1,0,0, 0,0,1,
					1,0,0, 1,0,1,

					1,0,0, 0,0,0,
					1,0,0, 0,0,0,
					1,0,0, 1,0,0,
					1,0,0, 0,0,1,

				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/12,
				\gain, 0.1 * Pseq([
					//1,0.2,0.5,0.3,
					Pn(1/4,inf),
					Pseq([ 1,0.2,0.5,0.3, ],1) * Pwhite(0.7,1.2,1).stutter(4),
				],inf).stutter(2),
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,1,0,


					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,

					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],1),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,1,1, 0,0,0,1,
						],1),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,1, 0,0,0,1,
						],1),
						Pseq([
							0,1,0,1, 1,0,0,0,
							0,0,0,0, 1,1,0,0,
						],1),
						Pseq([
							0,0,0,0, 0,1,0,0,
							1,0,0,1, 0,0,0,1,
						],1),
					],8),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,

					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,


					Prand([
						0,0,1,0, 0,1,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,1,
						0,0,1,0, 0,1,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					].clump(8).collect(Pseq(_)),8),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		])
	])
)).play;
);

(
Pdef(\part, Pdef(\drums3, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,1,
					0,1,1,1, 1,0,0,1,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,1,1,
					0,0,1,1, 1,1,0,1,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0, 
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
				\isRest, true,
			),
		]),
	]),
)).play;
);

(
Pdef(\part, Pdef(\drumsf1, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
			
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],7),
						0,0,0,1, 0,1,0,0,
						1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51,
			),
		]),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\drumsf2, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[670].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[465].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[832].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,0,
					],inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.51 * Pseq([
					1,1,1,1, 4,1,1,1,
				],inf)/3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[126].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				//\speed, 0.9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,0,0, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					1, 0.7, 0.9, 0.5,
					Plazy({ Pseq([
						1, 0.7, 0.9, 0.5,
					].scramble,1) }),
				],inf).stutter(1),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[125].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\sustain, Pseq([
					0.05, 0.02, 0.05, 0.02,
					0.05, 0.02, 1/6/~t, 0.02,
				],inf).stutter(2)*4,
				\gain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					1, 0.7, 0.9, 0.5,
					Plazy({ Pseq([
						1, 0.7, 0.9, 0.5,
					].scramble,1) }),
				],inf).stutter(2),
			),
		]),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\hi_const, 
	Ppar([
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,

				1,0,0,0, 2,0,0,1,
				1,0,0,1, 2,0,0,0,
				1,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				4,0,0,0, 0,0,2,0,
				4,0,0,1, 0,0,0,0,
				4,0,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,1,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\hi_const2, 
	Ppar([
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,0,0, 2,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,0,0,0,-1,-1,-2,1,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				4,0,0,0, 0,0,2,0,
				1,0,1,0, 0,0,1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\hi_const3, 
	Ppar([
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
				 1,0,1,0,
				 1,0,1,0,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3,
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				2,0,0,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				Pseq([
					0,1,-2,1,
					0,0,0,0,
				],3),
				Pseq([ 4-12 ],8),
				//-3,0,-3,0,-3,-1,-3,-3,
			],inf)+3-3,
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				4,0,0,0, 0,0,2,0,
				4,0,0,1, 0,0,0,0,
				4,0,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,1,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.3,0.4) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1*0.7,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

///////////: RDN Automatisation

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
	Pbind(
		\out, BusDef(\sendbus3, \audio),
		\instrument, \default,
		\degree, Pseq([0,5,14],inf),
		\octave, 3,
		\legato, 0.15,
		\dur, 2,
		\amp, 0.1/10,
	)
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			
			
		]),
	])
)).play;
);

(
Ndef(\rdn3)[100] = \pset -> Pbind(
	\delay2, Pseq([0,0.8],inf),
	\dur, 8,
);
)

(
Ndef(\rdn3)[100] = \pset -> Pbind(
	\delay2, Pseq([0,Pwhite(0,0.001,1)],inf),
	\dur, 4,
);
)

(
Ndef(\rdn3)[100] = \pset -> Pbind(
	\delay2, Pseq([Pwhite(0,0.001,1),0],inf),
	\dur, Pseq([3/4,1/4],inf)*4*2,
);
)
Ndef(\rdn3).quant = 1


ClipTimeline(\vin31_aux1).edit
ClipTimeline(\vin31_aux1).clear


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr(12 * ( SinOsc.kr(1/10) * 1 + 1 )) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
PlayerWrapper(Ndef(\zed)).outBus = BusDef(\sendbus1)
PlayerWrapper(Ndef(\zed)).outBus
Param(Message(PlayerWrapper(Ndef(\zed))), \outBus).get

/////////// draft




(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				0,-1,-2,-3,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \darkyoct,
			\note, Pseq([
				0,-1,-2,-3,
			],inf)+3,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.3,1.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1*0.3,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);


~t = 185/4/60; TempoClock.default.tempo = ~t;
(
	// jazz drums
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1277].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1916].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1128].value,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,0, 1,0,1
			],inf).coin.not,
			\accent, Pseq([
				1,0,0, 5,0,0, 1,0,0, 5,0,0
			],inf),
			\dur, 1/12,
			\gain, 0.31 * ( Pkey(\accent)/5+1 / 2 ),
		),
		
	])
)).play;
);

(
	// jazz drums + hiphop
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0, 0,0,1, 0,0,0, 1,0,0,
				0,0,1, 1,0,0, 1,0,0, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1916].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1128].value,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,0, 1,0,1
			],inf).coin.not,
			\accent, Pseq([
				1,0,0, 5,0,0, 1,0,0, 5,0,0
			],inf),
			\dur, 1/12,
			\gain, 0.31 * ( Pkey(\accent)/5+1 / 2 ),
		),
		
	])
)).play;
);

(
	// jazz drums + hiphop
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0, 0,0,1, 0,0,0, 1,0,0,
				0,0,1, 1,0,0, 1,0,0, 1,0,1,
			],inf).coin.not,
			\dur, 1/12*2,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1916].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8*2,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1128].value,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,0, 1,0,1
			],inf).coin.not,
			\accent, Pseq([
				1,0,0, 5,0,0, 1,0,0, 5,0,0
			],inf),
			\dur, 1/12*2,
			\gain, 0.31 * ( Pkey(\accent)/5+1 / 2 ),
			\out, BusDef(\mixer0, \audio),
		),
		
	])
)).play;
);
ProtoDef('vin31_mainMixer').tracks[0].proxy.asParamGroup

Ndef(\fx3).asParamGroup.getSetCompileString

/////////////


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1363].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[943].value,
				\sustain, 0.1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[224].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
		]),
		
	])
)).play;
);
ClipTimeline(\vin31_aux1).edit
