
(
	// basic
	~transfert = { arg x, a, b, c;
		//2**(x * a);
		//x.gaussCurve(a*4, b*4, c*4)
		//a * (exp(squared(x - b) / (-2.0 * squared(c))))
		var val;
		//x = x + 0.5;
		val = x;
		val = val * a * 4;
		//val = val + b;

		val = val * 2 - 1;
		val = val**3;
		val = ( val*c ) + ( ( val**3 ) * (1-c) );
		[val, ( val-0.5 ).softclip(0,1)+0.5].debug("bb,aa");
		val = val + (b*2-1);
		val = val.softclip;
		val = val +1 / 2 - 0.0625;
		//val = (x**3);
		//val = ( x*a*4 )**(3) + 0.5;
		//val.softclip(0,1);
		val
	};
	RandDelayNetwork(\multifb, {
		var block, algo;
		block = [
			\delay!16,
			\shift!2,
			\shift2!2,
			\dist!2,
			\fbnode!2,
			\fbnode2!2,
			\pan,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.1,0.9].normalizeSum);
		switch(algo,
			\par, {
				\par -> [2,4].choose.collect({
					\seq -> [ block, \end ]
				})
			},
			\seq, {
				\seq -> ([block] ++ (\end ! [1,2].choose))
			},
		)
	},
	IdentityDictionary.newFrom([
		\fbnode, { arg si, env;
			if(env.fbnode.isNil) {
				// in
				env.fbnode = FbNode(2);
				env.fbnode * \fb1.kr(0) + si;
			} {
				// out
				env.fbnode.write(Limiter.ar(si));
				env.fbnode = nil;
				si;
			};
		},
		\fbnode2, { arg si, env;
			if(env.fbnode.isNil) {
				// in
				env.fbnode = FbNode(2);
				env.fbnode * \fb2.kr(0) + si;
			} {
				// out
				env.fbnode.write(Limiter.ar(si));
				env.fbnode = nil;
				si;
			};
		},
		\pan, { arg si;
			Pan2.ar(si, rrand(-1,1)*0.1, 1).mean;
		},
		\delay, { arg si;
			var delay = [\delay, \delay2].choose.kr;
			DelayL.ar(si, 0.8, ~transfert.(rrand(0.01,0.8), \deltran1.kr, \deltran2.kr, \deltran3.kr) * [1, 1+0.01.rand] * delay) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\shift2, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			[
				{
					"endamp1".debug;
					si * \endamp1.kr(1)
				},
				{
					"endamp2".debug;
					si * \endamp2.kr(1)
				},
			].choose.value;
			si;
		}
	]));

)

//////////////////////////////////////////////////////////////////////

	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));

	RandDelayNetwork(\multifb).tree
	Ndef(\fx1).play
	Ndef(\fx1).edit
	{ Ndef(\fx1).sources[1].value.value(In.ar(2)) }.draw
	Ndef(\fx1).sources[1].value.def.dump

	(
	Ndef(\fx1).play;
	Pdef(\main,
		Ppar([
			Pdef(\kick),
			Pdef(\snare),
			Pdef(\hat),
		].collect({ arg x; Pbind(\out, BusDef(\fx1,\audio,2)) <> x }))
	).play;
	)
Pdef(\main).stop

(
Ndef(\tard, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * SinOsc.kr(1/2).range(1/8,2);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(123 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * 1 )));
	sig = Pan2.ar(sig, pan, amp);
//}).play(BusDef(\fx1).index, 2);
}).play(BusDef(\fx1, \audio,2).index, 2);
);

(
Ndef(\tard, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,4/5,1/2,1/3,
	],inf));
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(123 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * 1 )));
	sig = sig * EnvGen.kr(\env.kr(Env([0,0,1,0],[0.0,0.08,0.1])), Impulse.kr(4), timeScale:1);
	sig = Pan2.ar(sig, pan, amp);
//}).play(BusDef(\fx1).index, 2);
}).play(BusDef(\fx1, \audio,2).index, 2);
);

(
Ndef(\tard, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,3,2,1,
	],inf)).midiratio  / [1,2];
	//sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(123 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * 1 )));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpffac.kr(1.6) * freq, \rq.kr(0.5));
	sig = BPF.ar(sig, \bpffac.kr(1/2) * freq, \rq.kr(0.5)) + (sig/2);
	sig = SinOsc.ar(freq).mean; 
	sig = sig * EnvGen.kr(\env.kr(Env([0,0,1,0],[0.0,0.01,0.08])), Impulse.kr(4), timeScale:1);
	sig = Pan2.ar(sig, pan, amp);
//}).play(BusDef(\fx1).index, 2);
}).play(BusDef(\fx1, \audio,2).index, 2);
);

(
Pdef(\snapkick, Pbind(
	\instrument, \snapkick,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snapsnare, Pbind(
	\instrument, \snapsnare,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snaphihat, Pbind(
	\instrument, \snaphihat,
	\isRest, Pseq([
		1,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1/2
));

Pdef(\main, Ppar([
	Pdef(\snapkick),
	Pdef(\snapsnare),
	Pdef(\snaphihat),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\main).play;
Ndef(\fx1).play;
	
)

(
Pdef(\snapkick, Pbind(
	\instrument, \snapkick,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0,1, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snapsnare, Pbind(
	\instrument, \snapsnare,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,1,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snaphihat, Pbind(
	\instrument, \snaphihat,
	\isRest, Pseq([
		1,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1/2
));

Pdef(\main, Ppar([
	Pdef(\snapkick),
	Pdef(\snapsnare),
	Pdef(\snaphihat),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\main).play;
Ndef(\fx1).play;
	
)


(
Pbind(
	\instrument, \snaphihat,
	\freq, 200,
	\dur, 1/4,
	\amp, 0.1
).play;
)

Pdef(\main).clear
{ SinOsc.ar(200) ! 2 * 0.1}.play;

// Two delay lines with cross talk. This would be quite awkward to do with Fb.
Ndef(\tard).stop
Pdef(\main).stop

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,4,0,0,0,12,-12],inf),
	\dur, 1,
	\legato,0.1,
	\out, BusDef(\fx1),
	\amp, 0.1/2
)).play;
);

(
Pdef(\plop2, Pbind(
	\instrument, \default,
	\degree, Pseq([0,4,12,-12,0,0,0,0]+3,inf),
	\dur, 1/3,
	\legato,0.1,
	\out, BusDef(\fx1),
	\amp, 0.1/2
)).play;
);

	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));

	//////////////////////////////////////////////
(

{

	var in = WhiteNoise.ar*Line.kr(1,0,0.1);


	// create two FbNodes with different delay times

	var fbNode1 = FbNode(1,9/8/10);

	var fbNode2 = FbNode(1,1/10);


	var sig1 = in + (fbNode1.delay * 0.9) + (fbNode2.delay * 0.1);

	var sig2 = in + (fbNode1.delay * 0.1) + (fbNode2.delay * 0.9);


	fbNode1.write(sig1);

	fbNode2.write(sig2);


	Pan2.ar(sig1, -0.8) + Pan2.ar(sig2, 0.8);

}.play;

)
