Ndef(\plop).play;
Ndef(\plop).put(0, { LFSaw.ar(Array.geom(16,\freq.kr(400),\mul.kr(1.01001))).sum !2 * 0.051});
Ndef(\plop).put(2, \filter ->{ arg in, ffreq=1000; RHPF.ar(in, 170,0.2) });
Ndef(\plop).put(1, \filter ->{ arg in, modamp=1; in * SinOsc.ar([8,4]*t,2/3).sum.range(0,1) * modamp.lag(0.05) });

(
Ndef(\plop).put(10, \set -> Pbind(
	\wet1, Pseq([
		1,0.51,1,1,
		0.1,0.91,1,1,
		0.81,0.51,0.81,0.81,
		0.8,0.91,0.81,0.51,
	],inf).coin.collect({ arg x;if(x) {1} {0} }),
	\dur, 1/4,
	\degree, ~stutter.(Pseq([0,7,0,14],inf).stutter(1),Pseq([0],inf)),
	\degree, ~stutter.(Pseq([0,7,0,14],inf).stutter(1),Pseq([0,0,0,0, 0,0,1,0, 0,0],inf).stutter(1)),
	\degree, ~stutter.(Pseq([1,4,7,2],inf),Pseq([0,0,0,0, 0,0,1,0, 0,0],inf)).stutter(2),
	\degree, ~stutter.(Pseq([
		1,0,0,0,
		4,0,0,0,
		4,0,7,0,
		4,14,7,0,
	],inf),Pseq([0,0,0,0, 0,0,1,0, 0,0],inf)).stutter(1),
	\mul, Pseg(Pseq([1.1,1.01,1.0001,0.999],inf),8),
	\modamp, Pseq([1,0,1,0],inf),
	\modamp, Pseq([
		1,1,1,0,
		1,0,1,0,
		1,1,1,1,
		1,1,0,1,
	],inf).stutter(2),
))
);

// END

Ndef(\plop, { SinOsc.ar({2800.0.rand}!16 * SinOsc.ar({4128.0.rand}!16).range(0.1,1) * XLine.kr(0.1,2.1,8)).sum !2 * 0.051}).play
Ndef(\plop).put(1, \filter ->{ arg in, ffreq=1000; RLPF.ar(in, ffreq,0.5) });
Ndef(\plop).set(\ffreq, Ndef(\ploplfo, {XLine.kr(1000,100,10)}).asMap)
Ndef(\plop).set(\ffreq, Ndef(\ploplfo, {SinOsc.kr(1).range(50,10000)}).asMap)
Ndef(\plop).fadeTime = 4
Ndef(\plop).fadeTime = 0.1
Ndef(\plop).put(0, { LFSaw.ar({1800.0.rand}!16 * SinOsc.ar({4.0.rand}!16).range(0.1,1)).sum !2 * 0.051}).play
Ndef(\plop).put(0, { LFSaw.ar(Array.series(16,1000,100) * SinOsc.ar({4.0.rand}!16).range(0.1,1)).sum !2 * 0.051}).play
Ndef(\plop).put(0, { LFSaw.ar(Array.geom(16,50,1.002)).sum !2 * 0.051}).play
1/1.02
Ndef(\plop).put(1, \filter ->{ arg in, ffreq=1000; RLPF.ar(in, ffreq.lag(0.1),0.2) });
Ndef(\plop).put(1, \filter ->{ arg in, ffreq=1000; RLPF.ar(in, 4700,0.2) });
Ndef(\plop).put(1, \filter ->{ arg in; in * SinOsc.ar([8,4]*t/2).sum.range(0,1) });
Ndef(\plop).put(1, nil)
Ndef(\plop).put(0, { SinOsc.ar(Array.geom(16,\freq.kr(400),1.001)).sum !2 * 0.051}).play
Ndef(\plop).put(0, { LFSaw.ar(Array.geom(16,\freq.kr(400),\mul.kr(1.01001))).sum !2 * 0.051}).play
Ndef(\plop).quant = 4
Ndef(\plop).put(10, \set -> Pbind(\ffreq, Pseq([5000,1000,200,300, 300,200,7100,210],inf), \dur, 1/2))
(
Ndef(\plop).put(10, \set -> Pbind(\wet1, Pseq([
	1,1,0,1
],inf), \dur, 1/4))
)

(
Ndef(\plop).put(10, \set -> Pbind(
	\wet1, Pseq([
		1,0.51,1,1,
		0.1,0.91,1,1,
		0.81,0.51,0.81,0.81,
		0.8,0.91,0.81,0.51,
	],inf).coin.collect({ arg x;if(x) {1} {0} }),
	\dur, 1/4,
	\degree, ~stutter.(Pseq([0,7,0,14],inf).stutter(1),Pseq([0],inf)),
	\degree, ~stutter.(Pseq([0,7,0,14],inf).stutter(1),Pseq([0,0,0,0, 0,0,1,0, 0,0],inf).stutter(1)),
	\degree, ~stutter.(Pseq([
		1,0,0,0,
		4,0,0,0,
		4,0,7,0,
		4,14,7,0,
	],inf),Pseq([0,0,0,0, 0,0,1,0, 0,0],inf)).stutter(1),
	\degree, ~stutter.(Pseq([1,4,7,2],inf),Pseq([0,0,0,0, 0,0,1,0, 0,0],inf)).stutter(2),
	\mul, Pseq([1.1,1.01,1.0001,0.999],inf),
	\modamp, Pseq([1,0,1,0],inf),
	\modamp, Pseq([
		1,1,1,0,
		1,0,1,0,
		1,1,1,1,
		1,1,0,1,
	],inf),
)
)
)

Ndef(\plop).unset(\ffreq)
Ndef(\plop).unset(\wet1)

1.div(4)

2* 4 clip( 0,2)
kkkkkkkkkkkkkkkkkkk

Ndef(\plop).put(1000, \filter ->{ arg in, amp=1; in * amp });

~set_macro.(\k1, Ndef(\plop), \wet1, \unipolar.asSpec);
~set_macro.(\s5, Ndef(\plop), \amp, \unipolar.asSpec);

(
~stutter = { arg pat, reppat;
	Prout({

		var oldval;
		pat = pat.asStream;
		reppat = reppat.asStream;
		10000.do {
			var val = pat.next;
			var repval = reppat.next;
			if(repval == 1 or: { repval == true }) {
				if(oldval.notNil) {
					oldval.yield;
				} {
					val.yield;
				}
			} {
				oldval = val;
				val.yield;
			};
		}
	})
}
)

Pgate
Prepeat
