
RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx2, \audio));
RandDelayNetwork(\comp).make(\fx1, "4--", BusDef(\fx1, \audio));
// 5-1OHQ-LH5N cool reverb
Ndef(\fx1).play;
Ndef(\fx1).edit;
RandDelayNetwork(\default).make(\fx1, "5-T1KJ-J6JA5", BusDef(\fx1, \audio)); // cool distobass


MIDIMap(\k1, Param(Ndef(\fx1), \fb));
MIDIMap(\k2, Param(Ndef(\fx1), \delay));
MIDIMap(\k3, Param(Ndef(\fx1), \delay2));
MIDIMap(\k4, Param(Ndef(\fx1), \shift));
MIDIMap(\k4, Param(Ndef(\fx1), \shift));
(
[
	\fb,
	\delay,
	\delay2,
	\distamp,

	\pitchmix,
	\pitchlag,
	\shift,
	\shift2,

	\mamp,

	\prelpf,
	\prehpf,
	\lpf,
	\hpf,

	\postlpf,
	\posthpf,
	\fbdistamp,
	\fbdistmix,
].collect({ arg key, x; 
	var tt = (1..9).collect({ arg x; \k+++x }) ++ (1..9).collect({ arg x; \s+++x });
	MIDIMap(tt[x].debug("fdf"), Param(Ndef(\fx1), key));
});

MIDIMap(\a1, { Ndef(\fx1).set(\shift, 0, \shift2, 0) });
MIDIMap(\a2, { Pdef(\main, Pdef(\part1_dry)).play; });
MIDIMap(\a3, {
	Ndef(\fx1).play;
	Pdef(\main, Pdef(\part2_wet)).play;
});
MIDIMap(\a4, {
	Pdef(\main, Ppar([Pdef(\part1_dry), Pdef(\part2_wet)])).play;
});
MIDIMap(\a5, {
	Pdef(\main, Ppar([Pdef(\part1_wet), Pdef(\part2_dry)])).play;
});
MIDIMap(\a6, {
	Pdef(\main, Ppar([Pdef(\part3_dry), Pdef(\part2_wet)])).play;
});
MIDIMap(\a7, {
	Pdef(\main, Ppar([Pdef(\part3_wet), Pdef(\part2_dry)])).play;
});
MIDIMap(\loop, {
	RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
});
MIDIMap(\c1, {
	RandDelayNetwork(\default).make(\fx1, "5-FIN-A7H1", BusDef(\fx1, \audio));
});
MIDIMap(\c2, {
	RandDelayNetwork(\default).make(\fx1, "5-33RR-LVPC", BusDef(\fx1, \audio));
});
MIDIMap(\c3, {
	RandDelayNetwork(\default).make(\fx1, "5-7F1H-7PLR", BusDef(\fx1, \audio));
});
	
)
MIDIMap(\a1, { "hello" })
RandDelayNetwork(\default).code
Ndef(\fx1).set(\delay, 0)
Param(Ndef(\fx1), \delay).set(1)

MIDIdef.cc(\m1, { arg x; x.debug("hello") })
MIDIdef.cc(\test3, {arg ...args; args.postln}, (1..100)); // match cc 1-10

Pdef(\part1).stop
Pdef(\part1).play
Pdef(\part2_wet).play
Pdef(\part1).stop



Ndef(\greyhole).edit
Ndef(\greyhole).clear
Ndef(\fx1).stop
(
Ndef(\greyhole).put(0, { InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio, 2)), 2) });
Ndef(\greyhole).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = SelectX.ar(\inmix.kr(1,0.1), [DC.ar(0), in]);
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4) / ~t,\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2)*~t
	);
	sig = SelectX.ar(\mix.kr(0.5,0.1), [in, sig]);

	sig;
}).play;
Ndef(\greyhole).set(\wet50, 1);
)

(
	Ndef(\greyhole).put(60, \pset -> Pbind(
		\dur, 1/2,
		\damp, 0.11,
		\feedback, 0.8,
		\diff, Pseq([0.1,0.9],inf),
		\size, Pseq([0.01,3.4,3.4,0.01],inf).stutter(8),
		\delay, 1/4,
		\mix, 0.5,
		\inmix, Pseq([
			0,0,0,0,
			0,0,0,0,
			1,0,0,0,
			0,0,0,0,
		],inf),
	))
)

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,0,0, -2b, -2b,-3,-2,-2],inf).stutter(1),
	\isRest, Pseq([
		Plazy({ arg ev;
			var ss;
			
			ss = {
				Pseq([
					0,1,1,1, 1,1,1,1,
				].scramble.debug("ekk"),1);
			} ! 4;

			Pseq([0,0,1,1, 0,1,0,2].collect({ arg x; ss[x] }),1);

		},1),
	],inf).coin.not,
	//\scale, Scale.dorian,
	\legato, 0.1,
	\out, BusDef(\fx2),
	\ctranspose, 1,
	\octave, Prand([3,3,3,3,4,5],inf),
	\dur, 1/2,
	\amp, 0.1
)).play;
);

100.do { arg x; Spec.add(\wet+++x, \unipolar.asSpec) }

/////////////

(
RandDelayNetwork(\comp).make_graph = { arg in, code, rdnkey;
	var sig;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb;
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	fb = \fb.kr(0.01);
	del = \delay.kr(1,0.1);
	del2 = \delay2.kr(1,0.1);
	shi = \shift.kr(1);
	shi2 = \shift2.kr(1);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0.5);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	sig = RandDelayNetwork(rdnkey).ar(sig, code);

	sig1 = sig.tanh * \fbdistamp.kr(1/2.1);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));

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
	sig = Compander.ar(sig, in, \cpt2.kr(0.4), \cpbelow2.kr(1.001), \cpabove2.kr(0.9), \cpclamp2.kr(0.01), \cprelax2.kr(0.1));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);
	//sig.debug("end sig");
	sig;
};
)

RandDelayNetwork(\comp).make(\fx1, "5--", BusDef(\fx1, \audio));
