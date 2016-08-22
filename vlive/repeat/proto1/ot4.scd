
FileSystemProject(\proto1).open;

TrackDef(\ot4).clear
(
	TrackDef(\ot4, TrackDef(\playergrid));
	TrackDef(\ot4).source = [
		[
			Pdef(\ot4kick),
		],
		[
			Pdef(\ot4snare),
		],
		[
			Pdef(\ot4hat),
		],
		[
			Ndef(\myrdn),
		],
		[
			Ndef(\rdneq),
		],
	];
);

TrackDef(\ot4).activate
TrackDef(\ot4).edit
BusDef(\sendbus1, \audio).scope
x = BusDef(\sendbus1, \audio).play
x.stop
(
	Ndef(\ot4fx1, {
		var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
		var sig;
		sig = in;
		//sig = sig * SinOsc.ar(330, add:0.3);
		//sig = sig * WhiteNoise.ar(1, add:1.0);
		sig = sig.neg + Fb { arg fb;
			var isig;
			isig = ( fb * \fb.kr(0.09) ) + sig;
		
			isig = ( sig * 100 ).tanh / 1;
			isig = isig * 2;
			isig = AllpassL.ar(isig, 0.1,0.01) + isig;
			isig = AllpassL.ar(isig, 0.1,0.001) + isig;
			//isig = Limiter.ar(isig);
			isig;
		};
		sig = sig /16;
		sig = Limiter.ar(sig, 0.2);
		sig;
	}).play;
)

Ndef()
Rand
RandDelayNetwork(\default).make(\rdn1, "5--")
Ndef(\rdn1).play
Ndef(\rdn1).stop
Ndef(\rdn1).edit
Ndef(\rdn1).set(\inbus, BusDef(\sendbus0, \audio))

(
Ndef(\myrdn, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	var sig;

	sig = in * \gain.kr(1);
	//sig = sig / 10;
	sig = sig + Fb { arg fb;
		var isig;
		var pitch;
		var isig1, isig2, isig3;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig = RandDelayNetwork(\default).ar(isig, "5--");
		isig = LeakDC.ar(isig);
		pitch = Pitch.kr(isig).flop[0].lag(\pitchlag.kr(1));
		//pitch.poll;
		isig1 = isig;
		isig1 = BRF.ar(isig1, pitch);
		isig1 = BRF.ar(isig1, pitch);
		isig = SelectX.ar(\pitchmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	};
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(0.1), \damp.kr(0.4));
	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(4.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = sig / 8;
	sig = sig * \amp.kr(1);
	sig = sig * \postamp.kr(1);
	sig = Limiter.ar(sig);

	sig;
}).play
)

Ndef(\rdneq, Ndef(\myrdn).source).set(\inbus, BusDef(\sendbus1, \audio, 2)).edit
Ndef(\myrdn).edit

(
Pdef(\ot4kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\isRest, Pseq([
		1,0.5,1,0, 0,0,1,0,
		0,0.5,0,1, 0,0,1,0,

		1,1,0,0, 1,0,0,1,
		0,0,0,1, 1,0,0,0,

		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,1,0,1,

		1,0,0,1, 0,0,1,0,
		0,1,0,0, 1,0,0,0,
	],inf).coin.not,
	\amp, 0.15,
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.61,0.5,
		0.7,0.5,0.6,0.5,
	],inf),
));

Pdef(\ot4hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pser([
			0,0,1,0, 1,0,1,0,
			0,1,1,0, 1,0.5,1,0,
			0,0,1,1, 1,1,1,0,
		],16 * 3),
		Pser([
			1,0,
		],16),
		Pser([
			0,0,1,0, 1,0,1,0,
		],16 * 3),
		Pser([
			1,0,
		],16),
	],inf).coin.not,
	\ampm, Ndef(\hat_lfo_ampm, { SinOsc.kr(2.1*~t).range(0.6,1) }),
	\hpf, Ndef(\hat_lfo_lpf, { SinOsc.kr(2.05*~t).range(1500,7000) }),
	\rel, Pseq([0.01,0.1,0.1,0.2],inf).stutter(Prand([1,1,1,2,3,4,1,1,1,1,1,1,1,1],inf)),
	\rel, Pseq([
		Pser([0.1],16),
		Pser([0.07],16),
		Pser([0.04],16),
		Pser([
			Pseq([
				0.04,
			],4),
			0.2,
			Pseq([
				0.01,
			],3),
		],16),
	],inf),
	\amp, 0.1/8,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
		0.3,0.15,1,0.5,
		0.1,0.55,0.41,0.8,
	],inf),
));

Pdef(\ot4snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],3),

			Prand([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
				],1),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1),
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.2
));
)

// END

Veco.main.fadeout_time = 16;

(
Ndef('hatty.2', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	sig = LPF.ar(sig, 17000 * LFPulse.kr(1).range(1,1/3.3) * [1,1.2]);
	sig = HPF.ar(sig, 2000 * [1,1.2] * SinOsc.kr(1/2).range(1.10,1));
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.03]), DelayL.kr(Impulse.kr( Duty.kr(1/~t, 0, Dseq([
		8,4,4,2,4
	],inf))),1/8));
	sig = sig / 8;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.4, amp).mean;
}).play;
)
