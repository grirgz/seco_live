
eadgbe
4927I4

abcdefg
9I02457
I=11
	\note, [4,9,2+12,7+12,11+12,4+12+12] 
		[1,3,3,2,1,1].coin

(
Pdef(\guitar, Pbind(
	\instrument, \default,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pseq([
			[1,3,3,2,1,1],
			[0,1,3,3,2,1],
			[1,3,3,2,1,1]+1,
			[0,1,3,3,2,1],
		],1),
	],inf),
	\octave, 4,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/4,
	\amp, 0.1 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		[0,1,0,0,1,0],
		[0,1,0,0,1,0].rotate(rrand(0,6)),
		[0,1,0,0,1,0].rotate(rrand(0,6)),
		[0,1,0,0,1,0].rotate(rrand(0,6)),
		[0,1,0,0,1,0],
	],inf),
)).play;
)

(
SynthDef(\guitar0, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.001,[1,1.2,1.8]]), 1);
	env2 = EnvGen.kr(Env([1,Rand(0.5,3),1]/3,[0.1,1.8]), 1);
	sig = LFSaw.ar(freq *  [1,2,1/2] *.t [1,1.0001] * ( 1 + ( SinOsc.kr(Rand(0.0,20)) * Rand(0.0,0.01) )));
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(1.2) * [1,1.001,1.1] * env1 * freq, \rq.kr(0.5) * env2);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.31,0.1,0.8,0.4)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\guitar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var afreq = freq *  [1,2,1/2];
	env1 = EnvGen.kr(Env([1,2,1],[0.001,[1,1.2,1.8]]), 1);
	env2 = EnvGen.kr(Env([1,Rand(0.5,3),1]/3,[0.1,1.8]), 1);
	sig = LFSaw.ar(afreq *.t [1,1.0001] * ( 1 + ( SinOsc.kr(ExpRand(0.00001,20) * [1,1.01]) * ExpRand(0.000001,0.051) )));
	sig = CombL.ar(sig, 1/20, 1/afreq,0.0) + sig / 1;
	sig = sig.tanh / 2;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(1.2) * [1,1.001,1.1] * env1 * freq, \rq.kr(0.5) * env2);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\guitar, Pbind(
	\instrument, \guitar,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pseq([
			[1,3,3,2,1,1].rotate(rrand(0,6)),
			[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
			[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
			[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
			[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
			[1,3,3,2,1,1].rotate(rrand(0,6)),
			[1,3,3,2,1,1].rotate(rrand(0,6)),
			[1,3,3,2,1,1].rotate(rrand(0,6)),
		].scramble,1) - 5,
	],inf).stutter(4),
	\octave, 4,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/4,
	\amp, 0.1/2 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		[0,1,0,0,1,0],
		[0,1,0,0,1,0],
		[0,1,0,0,1,0],
		[0,1,0,0,1,0],
		[0,1,0,0,1,0].rotate(rrand(0,6)),
		[0,1,0,0,1,0].rotate(rrand(0,6)),
		[0,1,0,0,1,0].rotate(rrand(0,6)),
		[0,1,0,0,1,0],
	],inf),
)).play;
)


(
Ndef(\siren, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 50*8*2 * -5.midiratio;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(1/2*~t,2/4 * 2pi) * 1 )));
	sig = RLPF.ar(sig, \lpfr.kr(1.5) * freq, \rq.kr(0.5));
	sig = sig * 0.8;
	sig = Pan2.ar(sig, pan, amp);
//}).play(BusDef(\sendbus0, \audio).index, 2);
}).play(BusDef(\sendbus0, \audio).index, 2);
);
Ndef(\siren).end

(
Pdef(\guitar, Pbind(
	\instrument, \guitar,
	\adsr, Pseq([
		{
			Env.adsr(rrand(0.001,0.3),0.1,0.8,rrand(0.01,1.5)) 
		}.dup(6)
	],inf),
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pseq([
			{
				//[
				//	[1,3,3,2,1,1],
				//	[1,1,3,3,2,1],
				//].choose + [0,1,-1,-2,2,-4,4].choose;
				Pseq([
					Pseq([
						[1,3,3,2,1,1],
						[1,1,3,3,2,1],
					],4),
					Pseq([
						[1,3,3,2,1,1]+1,
						[1,1,3,3,2,1],
					],4),
				],1);
			}.dup(8)
		].flat,1),
	],inf).stutter(4),
	\octave, 3,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/1,
	\legato, 1,
	\amp,  0.1 * Pseq([
		Pser([
			[0,1,0,0,1,0],
			[0,1,0,0,1,0],
			[0,1,0,0,1,0].scramble,
			[0,1,0,0,1,0].scramble,
			[0,1,0,0,1,0].rotate(rrand(0,6)),
			[0,1,0,0,1,0].rotate(rrand(0,6)),
			[1,1,1,0,1,0].scramble,
			[1,1,1,0,1,0].scramble,
			//[0,0,0,0,0,0],
			//[0,0,0,0,0,0],
			//[0,0,0,0,0,0],
			[1,0,0,0,0,0].scramble,
			[1,0,0,0,0,0].scramble,
			[1,0,0,0,0,0].scramble,
		].scramble.debug("x"),16)
	],inf),
	//\amp, 0.1 * Pser
	//	//[\rest,\rest,\rest,\rest,\rest],
)).play;
)

(
WindowDef(\doublerdn, { arg def, rdnlist;
	HLayout(*
		rdnlist.collect({ arg rdn;
			WindowDef(\rdngui).asView(rdn);
		})
	)

}).front([ProtoDef(\rdn), ProtoDef(\rdn2)]);
)

(
WindowDef(\quatrordn, { arg def, rdnlist;
	VLayout (
		*rdnlist.clump(2).collect { arg subrdnlist, idx;
			HLayout(
				*subrdnlist.collect({ arg rdn;
					WindowDef(\rdngui).asView(rdn);
				})
			);
		},
	)

}).front([ProtoDef(\rdn), ProtoDef(\rdn2), ProtoDef(\rdn3), ProtoDef(\rdn4)]);
)

ProtoDef(\rdn).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn)).edit
ProtoDef(\rdn2).edit
ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn2).loadDefaultPreset
Pdef(\guitar).set(\out, BusDef(\sendbus1))
Pdef(\guitar).stop
Pdef(\drums).set(\out, BusDef(\sendbus0))
Pdef(\drums).set(\out, BusDef(\sendbus1))
Pdef(\drums).set(\out, BusDef(\sendbus2, \audio))
