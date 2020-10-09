~t = 150/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\fmbassx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var tick;
	freq = freq / 4;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1; 
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * \mod2amt.kr(2.5) + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * \mod4amt.kr(2.5) + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * \mod5amt2.kr(2.5) + 1 ) * (sig4 * \mod5amt4.kr(2.5) + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	tick = Decay.ar(Impulse.ar(1), 0.01, mul:WhiteNoise.ar(1));
	tick = HPF.ar(tick, 700);
	tick = LPF.ar(tick, 10100);
	tick = tick * 0.1;
	sig = sig + tick;
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;
)

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \fmbassx,
			\note, Pseq([
				0,0,0,0,
				-1,-1,1,1,
			],inf).stutter(2),
			\mod2amt, ~pmodenv.(Pseq([0,4],inf), 2),
			\mod4amt, ~pmodenv.(Pseq([0,4],inf), 4),
			\legato, Pseq([
				Pseq([
					2,0,
					1,1,
				],8+4+16),
				2,0,
				1,0,
				0,1,
				1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),

		),
		
		Pfuncn({
			
			"set rdn fx".postln;
			Ndef(\rdn).set(\delay, Ndef(\swing1, { SinOsc.kr(1/100).exprange(0.0001,0.01)  }));
			Ndef(\rdn).set(\delay2, Ndef(\swing2, { SinOsc.kr(1/130).exprange(0.0001,0.01)  }));
			Ndef(\rdn2).set(\delay, Ndef(\swing3, { SinOsc.kr(1/70).exprange(0.0001,0.01)  }));
			Ndef(\rdn2).set(\delay2, Ndef(\swing4, { SinOsc.kr(1/30).exprange(0.0001,0.01)  }));
			Event.silent;
		})
	
		
	])
)).play;
);

Pdef(\part).clear;
Ndef(\rdn).set(\delay, Ndef(\swing1, { SinOsc.kr(1/100).exprange(0.0001,0.01)  }));
Ndef(\rdn).set(\delay2, Ndef(\swing2, { SinOsc.kr(1/130).exprange(0.0001,0.01)  }));
Ndef(\rdn2).set(\delay, Ndef(\swing3, { SinOsc.kr(1/70).exprange(0.0001,0.01)  }));
Ndef(\rdn2).set(\delay2, Ndef(\swing4, { SinOsc.kr(1/30).exprange(0.0001,0.01)  }));

(
Ndef(\fx1).set(\lpf, Ndef(\lfo1, { 
	LFSaw.ar(1/2*~t).exprange(SinOsc.kr(1/7*~t).range(100,10099),10000).lag(0.1)  
}));
)
(
Ndef(\fx1).set(\lpf, Ndef(\lfo1, { 
	LFSaw.ar(4 * ( SinOsc.kr(1/13 * ( SinOsc.kr(1/20) * 0.58 + 1 )) * 0.71 + 1 )*~t).exprange(SinOsc.kr(1/7*~t).range(400,2099),7000).lag(0.1)  
}));
)


RandDelayNetwork(\deldefault).define_specs[\posthpf]
RandDelayNetwork.default_specs.()

Spec.specs[\posthpf]
Spec.specs

(
Ndef(\rdn).set(\delay, nil);
Ndef(\rdn).set(\delay2, nil);
Ndef(\rdn2).set(\delay, nil);
Ndef(\rdn2).set(\delay2, nil);
)

(
	//~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1776].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1505].value,
			\isRest, Pseq([
				Prand([
					1,0,1,0, 1,0,1,0,
				].clump(8).collect(Pseq(_)),1),
				Prand([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,1, 1,0,1,0,
				].clump(8).collect(Pseq(_)),2),
				Prand([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,1,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,1, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				].clump(8).collect(Pseq(_)),1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.01,
			\out, BusDef(\sendbus1, \audio),
		),
		Pseq([
			Pmono(
				 \playersec,
				\bufnum, SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer,
				\pos, Pseq([
					Pseq([ 0,1, ],8),
					Pseq([ 2,2, ],4),
					Pseq([ 3,3, ],4),
				],2)/2/~t,
				\dur, Pn(1/2,128),
				\trigger, Pseq([1],inf),
				\out, BusDef(\filterbus1,\audio,2),
				\gain, 1,
			),
			Pmono(
				 \playersec,
				\bufnum, SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer,
				\pos,0,
				\dur, Pn(1/2,128),
				\trigger, Pseq([1,Pn(0,inf)],inf),
				\out, BusDef(\filterbus1,\audio,2),
				\gain, 1,
			),
		],1),
		
	
		
	])
)).play;
Ndef(\fx1).play;
);

(
	//~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1776].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1505].value,
			\isRest, Pseq([
				Prand([
					1,0,1,0, 1,1,1,0,
				].clump(8).collect(Pseq(_)),1),
				Prand([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,1, 1,0,1,0,
				].clump(8).collect(Pseq(_)),2),
				Prand([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,1,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,1, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				].clump(8).collect(Pseq(_)),1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.01,
			\out, BusDef(\sendbus1, \audio),
		),
		Pseq([
			Pmono(
				 \playersec,
				\bufnum, SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer,
				\pos, Pseq([
					Pseq([ 0,1, ],8),
					Pseq([ 2,2, ],4),
					Pseq([ 3,3, ],4),
				],2)/2/~t,
				\speed, ~pmodenv.(Pseq([1,4],inf), 8),
				\dur, Pn(1/2,128),
				\trigger, Pseq([1],inf),
				\out, BusDef(\filterbus1,\audio,2),
				\gain, 1,
			),
			Pmono(
				 \playersec,
				\bufnum, SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer,
				\pos,0,
				\dur, Pn(1/2,128),
				\trigger, Pseq([1,Pn(0,inf)],inf),
				\out, BusDef(\filterbus1,\audio,2),
				\gain, 1,
			),
		],1),
		
	
		
	])
)).play;
Ndef(\fx1).play;
);
SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer
SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer
ClipTimeline('vin30_mainTimeline').eventList
ClipTimeline('vin30_mainTimeline').label
ClipTimeline('vin30_mainTimeline').presetCompileStringSavePath = "capsule/vin30/data/vin30_mainTimeline.scd"


