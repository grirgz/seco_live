
RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
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


//////////////////////////////////////////////////////////////// allpass


(
~primes = [ 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063,
	1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153,
	1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237,
	1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319,
	1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429, 1433,
	1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499,
	1511, 1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, 1597,
	1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669,
	1693, 1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777,
	1783, 1787, 1789, 1801, 1811, 1823, 1831, 1847, 1861, 1867, 1871, 1873,
	1877, 1879, 1889, 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979,
	1987, 1993, 1997, 1999, 2003, 2011, 2017, 2027, 2029, 2039, 2053, 2063,
	2069, 2081, 2083, 2087, 2089, 2099
]; 
~t = 1;

Ndef(\plop, { arg freq=200, pan=0, amp=0.1, lpf=100, fb=0.2, decay=0.2, fspread=0.1, delay=0.1, dpa=1;
	var sig;
	var tr = Dust.kr(4);
	var in;
	var count;
	tr = TDuty.kr(1/8/~t, 0, Dseq([
		1,0,1,1,
		1,1,1,0,
	],inf));
	freq = 440 / 2 * Duty.kr(1/~t, 0, Dseq([
		1,0,4,0,
	],inf)).midiratio;


	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq*1/4) * 1 )));
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*4/8 * ( 1 + ( SinOsc.ar(freq * 2/3) * 0.1 ))) * 1 )));
	sig = sig * EnvGen.kr(Env.perc(TExpRand.kr(0.01,0.1, tr),0.45), tr);
	in = sig;
	in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio, 2)), 2);
	sig = in;
	sig = { 
		LPF.ar(
			AllpassC.ar(sig, 0.05, ~primes.choose / 50000 * ( 1 + ( SinOsc.kr(1/4) * 0 )), 50 ) ,
			10000,
		).tanh;
	} ! 4;
	sig = sig.sum;
	sig.debug("midlesig");
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	count = 7;
	count.do{ arg i;
		//sig = AllpassN.ar(sig, 0.05, {~primes.choose!2}!2 / 200000 * ( 1 + ( SinOsc.ar((i+1)/2) * 0 )),0.1).sum + sig; 
		var fbn;
		fbn = FbNode(4);
		sig = sig + (fbn  * fb);
		sig = AllpassC.ar(sig, 0.05, 
			( ~primes.choose!2 / 140000 * delay ).debug("prime") ,
			decay * ((0..count)[i]/count - 0.5 * fspread + 1)
		) - sig; 
		//sig = sig.clip2(0.4) * 0.6;
		sig = sig.tanh * dpa;
		sig = Limiter.ar(sig);
		sig = sig.debug("isig");
		fbn.write(sig);
		sig = BPF.ar(sig, lpf, 4);
	};
	sig = sig * 1;
	sig = LeakDC.ar(sig);
	sig.debug("sig");
	sig = Limiter.ar(sig);
	sig = SelectX.ar(\mix.kr(0.98), [in, sig]);
	//{ sig = AllpassN.ar(sig, 0.05, 0.05.rand, 5 ) + sig } ! 6;
	sig.debug("endsig");

	sig = Pan2.ar(sig, pan, amp).sum;
}).play;
);
Ndef(\plop).clear
Ndef(\plop).edit
Spec.add(\lpf, \freq)


//////////////////////////////////////////

Proto
BP

Ndef(\greyhole).stop
Ndef(\freeverb).edit
(
Ndef(\freeverb, {
	var sig, in;
	in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2);
	sig = in;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig;
}).play
)
