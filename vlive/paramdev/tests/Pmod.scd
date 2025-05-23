// test Pmod class by scztt in param/Classes/experimental/Pmod.sc
(
SynthDef(\saw, {
	var env, sig;

	sig = Saw.ar(
		\freq.kr(440) * (\fmod.ar(0).midiratio * [-1, 1]),
		\amp.kr(1)
	);
	env = Env.adsr(releaseTime: \release.kr(1));
	env = env.kr(
		gate: \gate.kr(1),
		timeScale: \sustain.kr,
		doneAction: 2
	);

	sig = \lpf.kr([100, 3000]).collect {
		|lpf, i|
		RLPF.ar(
			sig[i],
			lpf,
			0.6
		)
	};
	sig = LeakDC.ar(sig);
	sig = Rotate2.ar(sig[0], sig[1], pi + (SinOsc.kr(1/2) * 0.2));
	sig = env * sig;

	sig = Balance2.ar(
		sig[0], sig[1],
		\pan.kr(0)
	);

	Out.ar(\out.ir, sig);
}).add;

Pdef(\base, Pbind(
	\instrument, \saw,
	\octave, [4, 4],
	\dur, 1/6,
	\release, Pwhite(1, 2.9),
	\legato, Pwhite(0.7, 1.9),
	\scale, Scale.harmonicMinor,
	\degree, Ptuple([
		0,
		Pseq([
			Pseq([-2, 3, 7, 3, -4], 8),
			Pseq([-2, 3, 7, 3, -4] + [-3, 0], 8),
		], inf)
	], inf),
));
)

// Basic kr
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod({
		SinOsc.kr(1/8, [0, 0.3]).exprange(420, 5000)
	}),
) <> Pdef(\base)).play;
)

// Explicit rate
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod.kr({
		SinOsc.kr(1/8, [0, 0.3]).exprange(420, 5000)
	}),
) <> Pdef(\base)).play;
)

// Explicit rate and channels, with coercion
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod.kr2({
		SinOsc.ar(1/8, 0).exprange(420, 5000)
	}),
) <> Pdef(\base)).play;
)

// Single values with lag
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		Pseq([300, 800, 4000], inf).stutter(3),
		\paramLag, 0.1
	),
) <> Pdef(\base)).play;
)

// Resend
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ SinOsc.kr(Rand(4, 12)).exprange(100, 1000) },
		\resend, Pseq([false, false, false, true], inf)
	),
) <> Pdef(\base)).play;
)

// Resend with fadeTime
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ SinOsc.kr(Rand(1, 8)).exprange(100, 5000) },
		\resend, Pseq([true] ++ (false ! 10), inf),
		\fadeTime, 4
	),
) <> Pdef(\base)).play;
)



// Basic ar
(
Pdef(\basicMod, Pbind(
	\fmod, Pmod({
		SinOsc.ar(1/8) * SinOsc.ar(200).range(-0.5, 0.5)
	}),
) <> Pdef(\base)).play;
)

// Pattern kr
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ \f.kr(100).lag3([0.01, 1]) },
		\f, Pexprand(120, 8000).stutter(3)
	)
) <> Pdef(\base)).play;
)

// Pattern kr with two filters
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ \f.kr(100).lag3([0.01, 1]) },
		\f, Ptuple([
			Pexprand(120, 8000).stutter(4),
			Pexprand(120, 8000).stutter(6)
		], inf)
	)
) <> Pdef(\base)).play;
)

// Pattern kr as fixed values
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ \f.kr(100).lag3([0.01, 1]) },
		\f, Ptuple([
			Pexprand(120, 8000).stutter(4),
			Pexprand(120, 8000).stutter(6)
		], inf)
	).asValues
) <> Pdef(\base)).play;
)


// Pmod modulating Pmod
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ \f.kr(100).lag3([0.01, 1]) },
		\f, Pmod.kr({
			LFDNoise3.kr(1).exprange(80, 12000)
		})
	)
) <> Pdef(\base)).play;
)

// 2 Pmods modulating Pmod
// Note: expand converts a 2-channel modulator into an arrayed value.
//       This causes channel expansion when event processing - it is
//       equivalent to eg. \freq, [100, 200] spawning two events,
//       rather than \freq, [[100, 200]] passing an array value to a
//       single synth arg.
(
Pdef(\basicMod, Pbind(
	\lpf, Pmod(
		{ \f.kr(100).lag3([0.01, 1]) },
		\f, Pmod.kr({
			LFDNoise3.kr([1, 6]).exprange(80, 12000)
		}).expand
	)
) <> Pdef(\base)).play;
)



// Pmono
(
Pdef(\basicMod, Pmono(
	\saw,
	\degree, Pfunc({ |e| e.degree +.x [0, 0.02] }),
	\fmod, Pmod({
		Decay.kr(\trig.tr, 0.2) * SinOsc.ar(200).range(-15, 15)
	}, \trig, Pseq([1, 0, 0, 1, 0, 0, 0], inf)),
	\lpf, Pmod(
		{ \f.kr(100).lag3([0.01, 1]) },
		\f, Pmod.kr({
			LFDNoise3.kr([1, 6]).exprange(80, 12000)
		}).expand
	)
) <> Pdef(\base)).play;
)


// \type, \set
// requires a previous Pmod to be defined
(
Ndef(\basicMod, \saw).play;

Pdef(\set, Pbind(
	\type, \set,
	\args, [\pan, \freq],
	\id, Ndef(\basicMod).group,
	\group, Ndef(\basicMod).group,
	\pan, Pmod({
		LFPulse.kr(1/3).range(-0.5, 0.5).lag(0.1)
	})
) <> Pdef(\base)).play
)



/////////////////////////////
// my tests

(
	// does not work when the pmod is multichannel
Pdef(\basicMod, Pbind(
	\lpf, Pmod({
		SinOsc.kr(1/8, 0.3).range(100,1000)
	}),
) <> Pdef(\base)).play;
)

(
	// ok
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pmod(Pseq([200,4000,300],inf)),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// ok
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbind(
			\instrument, \default,
			\freq, Pmod(Pseq([200,4000,300],inf)),
			\dur, Pn(1,2),
			\amp, 0.1,
		),
		
	],100)
)).play;
);
