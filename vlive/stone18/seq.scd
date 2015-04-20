
(
~kick = Veco('1').uname;
~snare = Veco('5').uname;
~hat = Veco('6').uname;
~pulse = Veco('z').uname+++\fx;
~pulsepat = Veco('z').uname;
)

Ndef(~pulse).play;
(
Ndef(~pulse).put(10, \set -> Pbind(
	\sweepfreq, Pseq([
		8,8,8,8,
		8,8,8,8,
		8,8,8,8,
		1,1,4,4,
	],inf),
	//\vol, Pseq([
	//	1,1,1,1,
	//	2,1,1,0,
	//],inf),
	\dur, 1/4,
))
)

(
Ndef(~pulse).put(12, \set -> Pbind(
	\lpf, Pseq([1000,1200],inf),
	\xfreq, Pseq([37,36],inf).midicps,
	\combdecay, Pseq([0,0,0,0,0.7,0.7,0.1,0.7],inf),
	\combfreq, Pseq([80,80,40,40],inf),
	\dur, 4,
))
)

(
Ndef(~pulse).put(11, \set -> Pbind(
	\vol, Pseq([
		0,0,1,1, 1,1,0,0,
		0,1,1,0, 0,1,1,0,
	],inf),
	\dur, 1/4,
))
)

(
Ndef(~pulse).put(11, \set -> Pbind(
	\vol, Pseq([
		Pser([
			1,0,
			1,0,
			1,0,
			1,0,
			1,0,
			1,0,
			1,1,
			1,1,
		],24),
		Pser([
			1,1,
		],8),
	],inf),
	\dur, 1/8,
))
)


(
~a = Pbind(
	\bla, Pseq([\bla, \rah, \nia],inf),
	\dur, 1,
);
~b = Pselect({ arg ev; ev[\bla] == \rah }, ~a);
~b.trace.play;
)

(
~pdispatch = { arg keys, chans;
	chans.do { arg chan, x;
		Pdef(keys[x],
			chan
		)
	};
};
~pclear = { arg keys;
	keys.do { arg key;
		Pdef(key, Pbind())
	}
};
~pchan = { arg ... pairs;
	pairs.clump(2).collect { arg pair;
		var key = pair[0];
		var val = pair[1];
		Pbind(\channel, key) <> val;
	}
};
~pxfindur = { arg dur, chans;
	chans.collect({  arg chan;  Pfindur(dur, chan)   })
};
~pxseq = { arg chanslist, rep=inf;
	chanslist.debug("iinit").flop.debug("flopped").collect { arg chans; Pseq(chans, rep) };
	//chanslist.debug("iinit").debug("flopped").collect { arg chans; Pseq(chans, rep) };
};
~mydisp1 = { arg in;

}
)

(
	~pclear.(
		[
			~kick+++\score,
			~snare+++\score,
		],

	)
)

(
Ndef(~pulse).put(10, \set -> Pdef(~pulsepat+++\10));
Pdef(~pulsepat+++\10, Pbind(
	\vol, Pseq([
		0,0,1,1, 1,1,0,0,
		0,1,1,0, 0,1,1,0,
	],inf),
	\dur, 1/4,
))
)

(
	~a = ~pdispatch.(
		[
			~kick+++\score,
			~snare+++\score,
			~pulsepat+++\10,
		],
		~pxseq.([
			~pxfindur.(4, [
				Pbind(
					\isRest, Pseq([1,0,1,0],inf).coin.not,
				),
				Pbind(
					\isRest, Pseq([0,0,1,0],inf).coin.not,
				),
				Pbind(
					\vol, Pseq([
						0,0,1,1, 1,1,0,0,
						0,1,1,0, 0,1,1,0,
					],inf),
					\dur, 1/8,
				)
			]).debug("what"),
			~pxfindur.(4, [
				Pbind(
					\isRest, Pseq([0,1,1,0],inf).coin.not,
				),
				Pbind(
					\isRest, Pseq([1,0,1,0],inf).coin.not,
				),
				Pbind(
					\vol, Pseq([
						0,0,1,1, 0,0,1,0,
						0,0,1,0, 1,1,1,1,
					],inf),
					\dur, 1/8,
				)
			])
		])
	)
)

(
	~a = ~pdispatch.(
		[
			~kick+++\score,
			~snare+++\score,
			~pulsepat+++\10,
		],
		[
			Pbind(
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
			),
			Pbind(
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
			),
			Pbind(
				\vol, Pseq([
					0,0,0,0, 1,1,0,0,
					0,1,1,0, 0,1,1,0,
				],inf),
				\dur, 1/8,
			)
		]
	)
)

(
~b = Pfindur(2, 
				[
					Pbind(
						\isRest, Pseq([1,0,1,0],inf).coin.not,
					),
					Pbind(
						\isRest, Pseq([1,1,0,1],inf).coin.not,
					)
				]
)
)

~as = ~b.asStream;
~as = ~a[0].asStream
~as = ~a[1].asStream
~as.next(Event.default)
~as.next(Event.default)

(
Pdef(~kick+++\score, 
	Pbind(
		\isRest, Pseq([1,0,1,0],inf).coin.not,
	)
)
)

(
Pdef(~snare+++\score, 
	Pbind(
		\isRest, Pseq([0,0,1,0],inf).coin.not,
	)
)
)

(
Pdef(~kick+++\mod,  Pbind())
)

(
Pdef(~kick +++ \a, Pbind(
	\env0, [ Env.new([0.0, 1, 0.1, 0], [0.005, 0.16, 0.1], [-4, -2, 4]) ],
	\env1, Pfunc({
		[ Env.new([110, 46, 28+3.rand], [0.015, 0.19], [-4, -5]) ]
	}),
	//\env3, [ Env.new([1.0, 2, 1.5, 0], [0.005, 0.016, 0.04], [-4, -2, -4]) ],
	\env3, Env([0, 0, 0.5, 0], [0.005, 0.016, 00.011], [-4, -2, -4]),
	\timeScale, 1,

	\freqpan, 0.001,
	\oscmix, 0.71261261261261,
	\osc2mix, 0.1,
	\fratio1, 0.772042493417,
	\fratio2, 0.8249932448162,
	\amp, Pkey(\amp) * 1.72,
	\distlim, 1.4,
	\distmix, 0.0,
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([
		0.21,0.52,
		0.21,0.72,
		0.31,0.52,
		0.11,0.72,
	],inf).stutter(8),
	\fratio, 1/2,
	\dur, 1/8,
	//\isRest, Veco(~namex).isrest(16),
	\isRest, Veco(~namex).isrest(8),
	\isRest, Pseq([
		Pser([
			1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 
			1,0,0,0, 0,0,0,0, 0,1,0,0, 1,0,0,0, 
			//1,0,0,1, 0,0,1,0, 
			//0,1,0,0, 1,0,0,0, 
		],inf),
	],inf).coin.not,
));
)
