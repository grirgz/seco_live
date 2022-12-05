
(
SynthDef(\guitar2, { arg out=0,freq, amp, pan = 0;
	var sig, pluck, period, string;
	freq = freq * [0.99,1,2,0.98];
	pluck = PinkNoise.ar(Decay.kr(Line.kr(1, 0, 0.05), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, 4);
	sig = LeakDC.ar(LPF.ar(string, 12000));
	sig = Splay.ar(sig, XLine.ar(0.1,1,0.3));
	sig = sig * XLine.ar(1,1/1000,4, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, amp) * 0.4);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\instrument, \guitar2,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\dur, 3,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[700].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1403].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1159].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

(
SynthDef(\magicdelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = DelayC.ar(in, 1, SinOsc.ar(\delayfreq.kr(1) + [0, \deltafreq.kr(0.01)]) * ( \delayfac.kr(1) + [0, \deltafac.kr(0.01)] ) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\magicdelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.91) ) + sig;

		isig = DelayC.ar(isig, 1, SinOsc.ar(\delayfreq.kr(1) + [0, \deltafreq.kr(0.01)]) * ( \delayfac.kr(1) + [0, \deltafac.kr(0.01)] ) );
	
		isig = Limiter.ar(isig, dur:0.001);
		isig;
	});
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	Out.ar(out, sig);
}).add;
Ndef(\fx1).source = \magicdelay;
);
Ndef(\fx1).source = \magicdelay;

(
	SynthDef(\dubecho,{|length = 1, fb = 0.8, sep = 0.012|
		var input = In.ar(0, 2);
		var output = input + Fb({

			arg feedback; // this will contain the delayed output from the Fb unit

			var left,right;
			var magic = LeakDC.ar(feedback*fb + input);
			magic = HPF.ar(magic, 400); // filter's on the feedback path
			magic = LPF.ar(magic, 5000);
			magic = magic.tanh; // and some more non-linearity in the form of distortion
			#left, right = magic; // let's have named variables for the left and right channels
			magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

		},length);
		ReplaceOut.ar(0, output);
	}).add;
)


	(
	RandDelayNetwork(\flanger).make_graph_({ arg in, code, rdnkey;
		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = RandDelayNetwork(rdnkey).ar(sig, code);

		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;
	});
	RandDelayNetwork(\flanger).grow = { 
		var block, algo;
		block = [
			[\dist, \dist2, \dist3]!1,
			\flanger!8,
		].flat.choose;
		algo = [
			\par, \seq
		].wchoose([0.1,0.9].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	};

	RandDelayNetwork(\flanger).dict = IdentityDictionary.newFrom([
		\flanger, { arg si;
			 DelayC.ar(si, 1, SinOsc.ar(\delayfreq.kr(0.01) * rrand(0.1,10) + [0, \deltafreq.kr(0.001)]) * ( \delayfac.kr(0.3) * rrand(0.1,10)+ [0, \deltafac.kr(0.01)] ) );
		},
		\dist, { arg si;
			(si * 10.0.rand * \distamp.kr).tanh / 2;
		},
		\dist2, { arg si;
			(si * 10.0.rand * \distamp2.kr).tanh / 2;
		},
		\dist3, { arg si;
			(si * 10.0.rand * \distamp3.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]);
	)
