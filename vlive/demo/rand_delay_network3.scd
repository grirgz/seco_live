///////// test new class !!!

(
Spec.add(\lpf, \freq.asSpec);
Spec.add(\hpf, \freq.asSpec);
Spec.add(\plpf, \freq.asSpec);
Spec.add(\phpf, \freq.asSpec);
Spec.add(\prelpf, \freq.asSpec);
Spec.add(\prehpf, \freq.asSpec);
Spec.add(\delay2, \delay.asSpec);
Spec.add(\shift, ControlSpec(-5,5,\lin));
Spec.add(\shift2, \shift.asSpec);
Spec.add(\pitchmix, \unipolar.asSpec);
Spec.add(\pitchlag, ControlSpec(0.001,1,\exp));

Spec.add(\wet10, \unipolar.asSpec);
Spec.add(\wet20, \unipolar.asSpec);

	BusDef(\fx1, \audio, 2);
	BusDef(\fx2, \audio, 2);
	Pdef(\kick).set(\out, BusDef(\fx1));
	Pdef(\kick1).set(\out, BusDef(\fx1));
	Pdef(\kick2).set(\out, BusDef(\fx1));
	Pdef(\hat2).set(\out, BusDef(\fx2));
	Pdef(\snare).set(\out, BusDef(\fx2));
)
	(
	Pdef(\kick).set(\out, BusDef(\fx1));
	Pdef(\kick1).set(\out, BusDef(\fx1));
	Pdef(\kick2).set(\out, BusDef(\fx1));
	Pdef(\hat2).set(\out, BusDef(\fx1));
	Pdef(\snare).set(\out, BusDef(\fx1));
	)

(
	// remove larsen
	// generate new random delay network each time
	
	~myrdn = { arg in, code;
		var sig;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag = \pitchlag.kr(0.1) / ~t;
		code = code ? "4--";
		sig = in;
		del = \delay.kr(1,0.1);
		del2 = \delay2.kr(1,0.1);
		shi = \shift.kr(1);
		shi2 = \shift2.kr(1);
		distamp = \distamp.kr(1);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * \fb.kr(0.01));
		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = RandDelayNetwork.ar(sig, code);
		// cool bass : 4-1K4Q-NO5T
		//sig = RandDelayNetwork.ar(sig, 4);
		sig = sig.tanh / 2.1;
		sig = Limiter.ar(sig);
		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1.debug("sig")).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1.debug("sig")).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(\pitchmix.kr(0.5), [sig, sig1]);
		LocalOut.ar(sig);
		sig = LPF.ar(sig, \plpf.kr(17000));
		sig = HPF.ar(sig, \phpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \poamp.kr(1);
		sig.debug("end sig");
		sig;
	};

	~mkrdn = { arg name, code, bus;
		if(bus.notNil) {
			Ndef(name).set(\inbus, bus);
		};
		Ndef(name)[0] = { InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio,2)), 2);  };
		Ndef(name).put(10, \filter -> { arg in;
			~myrdn.(in, code)
		});
		Ndef(name).put(20, \filter -> { arg in;
			// master volume
			in * \mamp.kr(1)
		});
	};

	~mkrdn.(\echo1, "4-R9RB-DCVB");
	//~mkrdn.(\echo2, "4--");

)

Ndef(\echo1).edit
Ndef(\echo2).edit

	(
		Ndef(\echo1).play;
//		Ndef(\echo2).play;
	Pdef(\main, Ppar(
		[
			Pdef(\kick1),
			Pdef(\kick2),
			Pdef(\hat2),
			Pdef(\snare),
		]
	)).play;
	)

	Ndef(\echo1).asParamGroup.getPbindCompileString

	Ndef(\echo1).put(50, nil)
	Ndef(\echo1).edit
	(

	//~mkrdn.(\echo1, "4-R9RB-DCVB").play;
	~mkrdn.(\echo1, "4--").play;
	Ndef(\echo1).put(50, \pset -> 
		Pbind(
			'inbus', Bus('audio', 20, 2, s),
			'wet10', 0.47777777777778,
			'pitchlag', 0.030432198871077,
			'delay', 0.0000938136638046,
			'delay2', 0.000228478497974223,
			'shift', 0,
			'shift2', 0.0,
			'distamp', 03.41403173849 * Pseg(Pseq([0,1,0.5,0.1],inf),8),
			'prelpf', 17000,
			'prehpf', 720.0,
			'fb', 0.001266353203942,
			'lpf', 17000,
			'hpf', 17,
			'pitchmix', 1.0,
			'plpf', 10415.896657191,
			'phpf', 20.0,
			'poamp', 0.23899938304018,
			'wet20', 1.0,
			'mamp', 8.7022744261654,
		)
	);
	Pdef(\main, Ppar(
		[
			Pdef(\kick1),
			Pdef(\kick2),
			Pdef(\hat2),
			Pdef(\snare),
		]
	)).play;
	)



	/////////////////////////////////////
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RandDelayNetwork.ar(sig, 4);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

1.ratiocps
3.midiratio
[3,7,10].midiratio

(
Pdef(\kick1, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 30, 30], [0.015, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.005, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.152
)).play;
)



(
Ndef(\yoyote, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,2,0,4,
	],inf)).midiratio * Duty.kr(1/~t, 0, Dseq([
		[3,5,7]
	],inf)).midiratio;
	sig = SinOsc.ar(freq);
	sig = sig.wrap2( SinOsc.kr(1/14 * [1,1.2,1.3]).range(0.7,1) );
	sig = RLPF.ar(sig, freq * 2);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);
BusDef(\fx1).debug
Ndef(\yoyote).clear
Ndef(\yoyote).play(BusDef(\fx1).index, 2)
Ndef(\yoyote).play(0)
Ndef(\yoyote).stop
Ndef(\echo1).play
Ndef(\echo1).edit
Ndef(\echo1).put(50, nil);
Ndef(\echo1).clear
~mkrdn.(\echo1, "4--", BusDef(\fx1)).play;

(
Ndef(\yoyote, { arg freq=400, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,2,0,4,
	],inf)).midiratio * Duty.kr(1/~t, 0, Dseq([
		[3,5,7]
	],inf)).midiratio *.x [1,1.001];
	sig = WhiteNoise.ar;
	//sig = SinOsc.ar(freq);
	//sig = BPF.ar(sig, freq, 0.7);
	sig = BPF.ar(sig, freq, 0.2);
	//sig = BPF.ar(sig, freq, 0.2) * 13;
	sig = Ringz.ar(sig, freq, 0.1) / 50;
	//sig = sig.wrap2( SinOsc.kr(1/14 * [1,1.2,1.3]).range(0.7,1) );
	//sig = RLPF.ar(sig, freq * 2);
	sig = sig* Duty.kr(8/~t, 0, Dseq([
		1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
	//"4-QBCB-F4V0"
	~mkrdn.(\echo1, "4-QBCB-F4V0");
Ndef(\yoyote, { arg freq=400, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,2,0,4,
	],inf)).midiratio * Duty.kr(1/~t, 0, Dseq([
		[3,5,7]
	],inf)).midiratio *.x [1,1.001];
	sig = WhiteNoise.ar;
	sig = SinOsc.ar(freq);
	//sig = sig.wrap2( SinOsc.kr(1/14 * [1,1.2,1.3]).range(0.7,1) );
	//sig = RLPF.ar(sig, freq * 2);
	sig = sig* Duty.kr(8/~t, 0, Dseq([
		1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
Ndef(\echo1).put(50, \pset ->
	Pbind(
		'inbus', Bus('audio', 20, 2, s),
		'wet10', 1.0,
		'pitchlag', 1.0,
		'delay', 1.0,
		'delay2', 0.054116952654646,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.1424141018717,
		'prelpf', 11686.82826747,
		'prehpf', 20.0,
		'fb', 0.15324379021007,
		'lpf', 796.21434110699,
		'hpf', 20.0,
		'pitchmix', 1.0,
		'plpf', 12619.146889604,
		'phpf', 35.565588200778,
		'poamp', 1.9458877175764,
		'wet20', 1.0,
		'mamp', 1.6475489724421,
	).keep(1)

)

);


	Ndef(\echo1).asParamGroup.getPbindCompileString
(
Ndef(\echo1).put(50, \pset ->
 Pbind(
'inbus', Bus('audio', 20, 2, s),
		'wet10', 1.0,
		'pitchlag', 1.0,
		'delay', 0.00030823992397451,
		'delay2', 0.00015058363542798,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.1424141018717,
		'prelpf', 11686.82826747,
		'prehpf', 20.0,
		'fb', 0.0060696223100292,
		'lpf', 796.21434110699,
		'hpf', 20.0,
		'pitchmix', 1.0,
		'plpf', 12619.146889604,
		'phpf', 35.565588200778,
		'poamp', 1.9458877175764,
		'wet20', 1.0,
		'mamp', 0.4475489724421,
)
)
)
