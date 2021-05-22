
(
~t = 155/2/60; TempoClock.default.tempo = ~t;
~master = {
	//ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
};

~gengroups = {
			~b0 = BusDef(\b0,\audio,2);
			~b1 = BusDef(\b1,\audio,2);
			~b2 = BusDef(\b2,\audio,2);
			~b3 = BusDef(\b3,\audio,2);
			~b4 = BusDef(\b4,\audio,2);
			~b5 = BusDef(\b5,\audio,2);

			// use groups to ensure modulators are before carriers on the node tree:
			~g0 = GroupDef(\g0);
			~g1 = GroupDef(\g1, ~g0, \addAfter);
			~g2 = GroupDef(\g2, ~g1, \addAfter);
			~g3 = GroupDef(\g3, ~g2, \addAfter);
			~g4 = GroupDef(\g4, ~g3, \addAfter);
			~g5 = GroupDef(\g5, ~g4, \addAfter);

};
)

    (
	SynthDef(\pmOperator, {
		var sig, env, freq, vibrato, detune;
		env = Env.adsr(
			\atk.kr(0.01), \dec.kr(0.3), \sus.kr(0.5), \rel.kr(1.0),
			curve: \curve.kr(-4)).ar(2, \gate.kr(1));
		detune = LFNoise1.kr(\detuneRate.kr(0.2)!2).bipolar(\detuneAmt.kr(0.1)).midiratio;
		vibrato = SinOsc.kr(\vibRate.kr(2)).bipolar(\vibAmt.kr(0.2)).midiratio;
		freq = \freq.kr(440) * vibrato * detune;
		sig = SinOsc.ar(freq * \ratio.kr(1), In.ar(\in.kr(0), 2));
		sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), env);
		sig = LeakDC.ar(sig);
		Out.ar(\out.kr(0), sig * \amp.kr(0.3));
	}).add;
    )
(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[1113].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[2017].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2098].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2114].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[1311].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),

		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
	~gengroups.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[1113].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[2017].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2098].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2114].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[1311].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1311].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),

		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \pmOperator,
			\dur, 8,
			\root, -3,
			\octave, Pfunc{{rrand(2, 3)} ! 6},
			\degree, Ptuple(Pxrand((0..7), inf)!5),
			\harmonic, Pfunc{{rrand(1, 8)} ! 6},
			\group, [~g0, ~g1, ~g2, ~g3, ~g4, ~g5],
			\in, [~b0, ~b1, ~b2, ~b3, ~b4, ~b5],
			\out, [~b1, ~b2, 0, ~b4, ~b5, 0],
			\ratio, Pfunc{[1, 1, 2, 2, 3, 3].scramble},
			\vibAmt, Pfunc{{rrand(0.0, 0.2)} ! 6} * 0.3,
			\vibRate, Pfunc{[2, 3, 4, 4, 6, 8].scramble},
			\detuneAmt, Pfunc{{rrand(0.0, 0.2)} ! 6} * 0.2,
			\detuneRate, Pfunc{{rrand(0.1, 0.5)} ! 6},
			\legato, Pfunc{{rrand(0.4, 0.8)} ! 6} * 1.2,
			\atk, Pfunc{{rrand(1.5, 4.5)} ! 6},
			\dec, Pfunc{{rrand(0.9, 1.6)} ! 6},
			\sus, Pfunc{{rrand(0.4, 0.9)} ! 6},
			\rel, Pfunc{{rrand(1.5, 4.5)} ! 6} * 2.5,
			\curve, Pfunc{{rrand(-5, -1)} ! 6},
			\amp, [1.2, 1.4, 0.3, 1.4, 1.2, 0.3]/6/2,
			\pan, [-0.8, 0.8, -0.3, -0.8, 0.8, 0.3],
			\out, BusDef(\sendbus3, \audio),
		)
	])
)).play;
);

(
	~gengroups.();
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[1113].value,
				\isRest, Pseq([
					1,0,1,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[2017].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2098].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2114].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[1311].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1311].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),

		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \pmOperator,
			\dur, 8,
			\root, -3,
			\octave, Pfunc{{rrand(2, 3)} ! 6},
			\degree, Ptuple(Pxrand((0..7), inf)!5),
			\harmonic, Pfunc{{rrand(1, 8)} ! 6},
			\group, [~g0, ~g1, ~g2, ~g3, ~g4, ~g5],
			\in, [~b0, ~b1, ~b2, ~b3, ~b4, ~b5],
			\out, [~b1, ~b2, 0, ~b4, ~b5, 0],
			\ratio, Pfunc{[1, 1, 2, 2, 3, 3].scramble},
			\vibAmt, Pfunc{{rrand(0.0, 0.2)} ! 6} * 0.3,
			\vibRate, Pfunc{[2, 3, 4, 4, 6, 8].scramble},
			\detuneAmt, Pfunc{{rrand(0.0, 0.2)} ! 6} * 0.2,
			\detuneAmt, ~pmodenv.(Pseq([1,2,1,4],1), 1).loop,
			\detuneRate, Pfunc{{rrand(0.1, 0.5)} ! 6},
			\legato, Pfunc{{rrand(0.4, 0.8)} ! 6} * 1.2,
			\atk, Pfunc{{rrand(1.5, 4.5)} ! 6},
			\dec, Pfunc{{rrand(0.9, 1.6)} ! 6},
			\sus, Pfunc{{rrand(0.4, 0.9)} ! 6},
			\rel, Pfunc{{rrand(1.5, 4.5)} ! 6} * 2.5,
			\curve, Pfunc{{rrand(-5, -1)} ! 6},
			\amp, [1.2, 1.4, 0.3, 1.4, 1.2, 0.3]/6/2,
			\pan, [-0.8, 0.8, -0.3, -0.8, 0.8, 0.3],
			\out, BusDef(\sendbus3, \audio),
		)
	])
)).play;
);



(
SynthDef(\badfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr( ( SinOsc.kr(\fmfreq.kr(1)) * 1 + 1 ) ) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
(
SynthDef(\badfm2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), 1);
	sig2 = SinOsc.ar(freq * (0..10)).mean;
	sig = LFSaw.ar(freq * ( sig2 * env1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[964].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \badfm2,
			\root, -3,
			\note, Prand((0..7),inf) + Pseq((0..10).reverse,inf).stutter(16),
			//\scale, Scale.dorian,
			\octave, Prand([5,6,7],inf),
			\isRest, Pseq([
				1,0,1,0.5, 0.5,
			],inf).coin.not,
			\fmfreq, 0.01,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \badfm,
			\root, -3,
			\degree, 0,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \badfm,
			\fmfreq, 1*~t,
			\freq, 200,
			\dur, 8,
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
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[964].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \badfm2,
			\root, -3,
			\note, Prand((0..7),inf).stutter(16) + Pseq((0..10).reverse,inf),
			\note, Pseq([0,1,3,4,6,7,10,11],inf) + Prand((0..10),inf).stutter(8),
			//\scale, Scale.dorian,
			//\octave, Prand([5,6,7],inf),
			\octave, 7,
			\fmfreq, 0.01,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \badfm,
			\root, -3,
			\degree, 0,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \badfm,
			\fmfreq, 1*~t,
			\freq, 200,
			\dur, 8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Psched(8,
			Pbind(
				\instrument, \badfm,
				\root, -3,
				\degree, Pseq([1,0],2).stutter(8*8),
				\dur, 1/8,
				\amp, 0.1,
			),
		),
		Psched(0,
			Pbind(
				\instrument, \badfm,
				\fmfreq, 1*~t,
				\freq, Pseq([200,300],2),
				\dur, 8,
				\amp, 0.1,
			),
		),
		Psched(16,
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1311].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0,0,1,1],inf),Pseq([16,12,4],1)),
			),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(32, Pdef(\intro)),
		Pfindur(32, Pdef(\part1)),
		
	])
)).play;
)

///////////////////////

(
s.waitForBoot{
    SynthDef(\pmOperator, {
        var sig, env, freq, vibrato, detune;
        env = Env.adsr(
            \atk.kr(0.01), \dec.kr(0.3), \sus.kr(0.5), \rel.kr(1.0),
            curve: \curve.kr(-4)).ar(2, \gate.kr(1));
        detune = LFNoise1.kr(\detuneRate.kr(0.2)!2).bipolar(\detuneAmt.kr(0.1)).midiratio;
        vibrato = SinOsc.kr(\vibRate.kr(2)).bipolar(\vibAmt.kr(0.2)).midiratio;
        freq = \freq.kr(440) * vibrato * detune;
        sig = SinOsc.ar(freq * \ratio.kr(1), In.ar(\in.kr(0), 2));
        sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), env);
        sig = LeakDC.ar(sig);
        Out.ar(\out.kr(0), sig * \amp.kr(0.3));
    }).add;

    s.sync;

    // use busses to connect modulators to carriers:
    s.newBusAllocators;
    ~b0 = Bus.audio(s, 2);
    ~b1 = Bus.audio(s, 2);
    ~b2 = Bus.audio(s, 2);
    ~b3 = Bus.audio(s, 2);
    ~b4 = Bus.audio(s, 2);
    ~b5 = Bus.audio(s, 2);

    // use groups to ensure modulators are before carriers on the node tree:
    ~g0 = Group.new;
    ~g1 = Group.after(~g0);
    ~g2 = Group.after(~g1);
    ~g3 = Group.after(~g2);
    ~g4 = Group.after(~g3);
    ~g5 = Group.after(~g4);

    s.sync;

    // use arrays in Pbind to play multiple operators simultaneously:
    Pbind(
        \instrument, \pmOperator,
        \tempo, 1,
        \dur, Pwhite(3.0, 6.0),
        \root, -5,
        \octave, Pfunc{{rrand(2, 3)} ! 6},
        \degree, Pxrand((0..7), inf).stutter(5),
        \harmonic, Pfunc{{rrand(1, 8)} ! 6},
        \group, [~g0, ~g1, ~g2, ~g3, ~g4, ~g5],
        \in, [~b0, ~b1, ~b2, ~b3, ~b4, ~b5],
        \out, [~b1, ~b2, 0, ~b4, ~b5, 0],
        \ratio, Pfunc{[1, 1, 2, 2, 3, 3].scramble},
        \vibAmt, Pfunc{{rrand(0.0, 0.2)} ! 6} * 0.3,
        \vibRate, Pfunc{[2, 3, 4, 4, 6, 8].scramble},
        \detuneAmt, Pfunc{{rrand(0.0, 0.2)} ! 6} * 0.2,
        \detuneRate, Pfunc{{rrand(0.1, 0.5)} ! 6},
        \legato, Pfunc{{rrand(0.4, 0.8)} ! 6} * 1.2,
        \atk, Pfunc{{rrand(1.5, 4.5)} ! 6},
        \dec, Pfunc{{rrand(0.9, 1.6)} ! 6},
        \sus, Pfunc{{rrand(0.4, 0.9)} ! 6},
        \rel, Pfunc{{rrand(1.5, 4.5)} ! 6} * 2.5,
        \curve, Pfunc{{rrand(-5, -1)} ! 6},
        \amp, [1.2, 1.4, 0.3, 1.4, 1.2, 0.3],
        \pan, [-0.8, 0.8, -0.3, -0.8, 0.8, 0.3],
    ).play;
}
)


ProtoDef(\rdn2).presetCompileString.editorInsert
(
	// big 808
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-63BN-8Q5V", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.51260504201681,
	'fb', 0.00049866340900605,
	'delay', 0.0001,
	'delay2', 0.00080828221925227,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.6506816471033,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

