
(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * EnvGen.kr(Env([1.5,1,1],[0.01,0.8]), 1);
	freq = freq * ( 1 + ( SinOsc.ar(freq/ [1,1/2]) * 0.11 ));
	sig = LFSaw.ar(freq * [1/2,1,1.01 + Rand(0,0.01)]);
	sig = sig + LFPulse.ar(freq * [1/2,1]);
	sig = ( sig * 20 * freq.log ).tanh / 2;
	sig = ( sig * 1 * freq.log ).fold2(0.7) * 2;
	sig = sig * LFSaw.ar(freq*2, mul:1, add:1);
	sig = sig + LPF.ar(sig, 200, mul: freq.log/2);
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq, \rq.kr(0.5)) + ( sig/4 );
	sig = RLPF.ar(sig, \lpfr2.kr(4) * freq, \rq.kr(0.5));
	sig = BRF.ar(sig, 3000, 0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.0001,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 1;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\baz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, freq2=0, freq3=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	var ton;
	var env1;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	env1 = EnvGen.kr(Env([1,20,100],[ExpRand(0.01,0.021),0.01]), 1);
	ton = LFSaw.ar( [ freq, freq2, freq3 ] );
	ton = (ton * 100 * env1).tanh / 4;
	ton = (ton * 100 * env1).fold2(0.8) * 1;
	ton = BRF.ar(ton, 10200 * Rand(1,1.1));
	ton = BRF.ar(ton, 7200 * Rand(1,1.5));
	ton = ton * EnvGen.kr(Env([0,1,0],[0.01,ExpRand(0.2,0.4)]), 1);

	osc = SinOsc.ar( EnvGen.kr(Env([400,50,41],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.70], -4), 1);
	osc = osc * 2;
	//osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([1400,7852,5451],[0.01,0.1]), 1) * Rand(1,1.1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,3452,3451],[0.01,0.1]), 1) * Rand(1,1.5));
	snare = snare * EnvGen.kr(Env([0,1,1,0],[0.001,0.01,0.08], -4), 1) * \snareamp.kr(1);

	sig = click + osc + snare + ton;
	sig = LPF.ar(sig, 10000);

	sig = sig * 1;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\bazo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, freq2=0, freq3=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	var ton;
	var env1;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	env1 = EnvGen.kr(Env([1,20,100],[ExpRand(0.01,0.1),0.01]), 1);
	ton = LFSaw.ar( [ freq, freq2, freq3 ] );
	ton = (ton * 100 * env1).tanh / Rand(1,8);
	ton = (ton * 100 * env1).fold2(0.8) * 1;
	ton = BRF.ar(ton, 10200 * Rand(1,1.1));
	ton = BRF.ar(ton, 7200 * Rand(1,1.5));
	ton = ton * EnvGen.kr(Env([0,1,0],[0.01,Rand(0.1,0.4)]), 1);

	osc = SinOsc.ar( EnvGen.kr(Env([400,50,41],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.70], -4), 1);
	osc = osc * 2;
	//osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([1400,7852,5451],[0.01,0.1]), 1) * Rand(1,1.5));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,3452,3451],[0.01,0.1]), 1) * Rand(1,1.5));
	snare = snare * EnvGen.kr(Env([0,1,1,0],[0.001,0.01,0.08], -4), 1);

	sig = click + osc + snare + ton;

	sig = sig * 1;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef.defaultQuant = 4;

Pdef(\k1, 
	Pbind(
		\isRest, Pseq([
			1,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\amp, 0.12,
	) <>
	Pdef(\kick)
);

Pdef(\h1, 
	Pbind(
		\isRest, Prout({ arg in;
			var str;
			var pat = Pseq([
				0,1,1,1, 0,1,1,1,
			],inf);
			str = pat.asStream;
			loop ({
				16.do { arg i;
					1.do {
						16.do { arg j;
							var next = str.next(in);
							if(j == i) {
								in = 0.yield;
							} {
								in = next.yield;
							}
						}
					}
				}
			})

		}).trace.coin.not
	) <>
	Pdef(\hat)
);


Pdef(\h1, 
	Pbind(
		\instrument, \baz,
		\degree, Pseq([ [0,2,4] ],inf),
		\root, Pstep(Pseq([0,0,5-12,7-12],inf),2),
		\legato, Prand([0.1,1.5,1,2],inf),
		\snareamp, Pseq([1,0.8,0.7,0.6,0.5,0.4],inf).stutter(1),
		\dur, 1/8,
		\isRest, Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],4),
			Pseq([
				1,0,1,0,
			],8),
			Pseq([
				0,0,0,0, 1,1,0,0,
			],4),
			Pseq([
				1,0,0,0,
			],8),
			Pseq([
				0,0,0,0,
				1,0,0,0,
			],4),
			Pseq([
				1,0,0,1,
			],8),
			Pseq([
				0,1,0,1,
			],8),
		],inf).coin.not.stutter(1),
	) <>
	Pdef(\hat)
);

Pdef(\bass, Pbind(
	\instrument, \bass,
	\degree, Pseq([0],inf),
	\legato, Pseq([Prand([0.1,1]),0.3,0.7],inf),
	\root, Pstep(Pseq([0,0,5,7-12],inf),2),
	\octave, 4,
	\dur, 1/2,
	\amp, 0.1
));

Pdef(\part1, Ppar([
	Pdef(\k1),
	Pdef(\h1),
	Pdef(\bass),
]));

TrackDef(\part1, TrackDef(\trackgroup));
TrackDef(\part1).childAt(0).source = Pdef(\bass);
TrackDef(\part1).childAt(1).source = Pdef(\k1);
)
Pdef(\part1).play;
WindowDef(\playergrid).front(TrackDef(\part1))
TrackDef(\part1).children.asArray.do(_.keys)
TrackDef(\part1).children.asArray.do({ arg x; x.label })
TrackDef(\part1).children
TrackDef(\part1).childAt(0)

[100,1000].log.log

TrackDef(\part1).childAt(1).play
TrackDef(\part1).childAt(0).play
TrackDef(\part1).childAt(0).stop
TempoClock.default.tempo = 140/60


(
TrackDef(\playerwrapper, (
	label: { arg self; "%: %".format(self.key, self.proxy.label) },

	new: { arg self;
		self = self.copy;

		self.selectChild(0);
		self;
	},

	source_: { arg self, val;
		self.proxy = PlayerWrapper(val);
	},

	source: { arg self;
		self.proxy;
	},

	childAt: { arg self, idx;
		if(idx == 0) {
			ProtoClass((
				parent: self,
				childAt: { nil },
				children: { nil },
				selectChild: { nil },
				index: 0,
			))
		}
	},

	selectChild: { arg self, idx;
		self.selectedChild = idx; // to be deprecated, should be an object instead an index
		self.selectedIndex = idx;
		self.activeIndex = idx; // this one is the good one
		self.childProxy.source = self.childAt(idx).asPattern;
	},


	play: { arg self;
		self.proxy.play;
		if(self.mixer.notNil) {
			self.mixer.play;
		};
		self.changed(\play, self.proxy.quant);
	},

	stop: { arg self;
		self.proxy.stop;
		if(self.mixer.notNil) {
			//self.mixer.stop; // never stop mixers!
		};
		self.changed(\stop, self.proxy.quant);
	},

	quant: { arg self;
		self.proxy.quant;
	},

	quant_: { arg self, val;
		self.proxy.quant = val;
	},

	isPlaying: { arg self;
		self.proxy.isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},

	mixer: { arg self;
		if(self.mixer_obj.isNil) {
			self.mixer_obj = ~trackMixerDef.new(self.key);
			self.mixer_obj.define_mixer;
			self.init_mixer_busses;
		};
		self.mixer_obj;
	},
));
TrackDef(\trackgroup, (
	parent: TrackDef(\playerwrapper),

	source_: { arg self, val;
		self.children = val;
	},

	source: { arg self;
		self.children;
	},

	proxy: { arg self;
		PlayerWrapperGroup(self.children);
	},

	childAt: { arg self, idx;
		self.children = self.children ?? { SparseArray.new };
		self.children[idx] ?? { 
			self.children[idx] = TrackDef(\playerwrapper).new;
			self.children[idx];
		}
	},

	mixer:nil,

))
)

TrackDef(\playerwrapper).new



//////////////////////////////////////////////////


(
Ndef(\kap, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var trig = Impulse.kr(8);
	env1 = EnvGen.kr(Env([2,1,0.1,1.2],[0.0001,0.0008, 0.1]), trig);
	env1 = LFSaw.kr(4) + SinOsc.kr(16).range(0,0.21);
	sig = SinOsc.ar(freq * env1 * [1,1.001]);
	env2 = EnvGen.kr(Env([420,420,32,40],[0,0.01,0.2]), trig);
	env3 = EnvGen.kr(Env([0,0,1,0],[0,0.001,0.2]), trig);
	sig = SinOsc.ar( env2 * [1,4] ) * env3 * [1,0.2]; 
	sig = (sig * 10).tanh;
	sig = RLPF.ar(sig, \lpf.kr(4700), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\kap).put(0, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//var trig = Impulse.kr(8);
	var trig = \trig.tr(1);
	env1 = EnvGen.kr(Env([2,1,0.1,1.2],[0.0001,0.0008, 0.1]), trig);
	env1 = LFSaw.kr(4) + SinOsc.kr(16).range(0,0.21);
	sig = SinOsc.ar(freq * env1 * [1,1.001]);
	env2 = EnvGen.kr(Env([420,420,32,20],[0,0.01,0.02]), trig);
	env3 = EnvGen.kr(\env3.kr(Env([0,0,1,0],[0,0.001,0.02])), trig);
	sig = SinOsc.ar( env2 * [1,4] ) * env3 * [1,0.2]; 
	sig2 = LFSaw.ar( env2 * [1,4] ) * env3 * [1,0.2]; 
	sig = SelectX.ar(\mix.kr(0.1), [sig, sig2]);
	sig = (sig * \distamp.kr(100)).tanh;
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\kap)[1] = \set -> Pbind(
	\env3, Pseq([
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4),
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4 ),
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.22]) ],
		],8 * 4),
		Pser([
			[ Env([0,0,1,0],[0,0.101,0.22]) ],
		],8 * 4),
	],inf),
	\trig, Pseq([
		Pser([
			1,0,0,0
		],16 * 4),
		Pser([
			1,0,1,0
		],16 * 4),
		Pser([
			1,1,1,1
		],16 * 7),
		Pser([
			1,0,0,0
		],16),
	],inf),
	\dur, 1/16,
);
);

(
Ndef(\kap).put(0, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//var trig = Impulse.kr(8);
	var trig = \trig.tr(1);
	env1 = EnvGen.kr(Env([2,1,0.1,1.2],[0.0001,0.0008, 0.1]), trig);
	env1 = LFSaw.kr(4) + SinOsc.kr(16).range(0,0.21);
	sig = SinOsc.ar(freq * env1 * [1,1.001]);
	env2 = EnvGen.kr(Env([420,420,32,20],[0,0.01,0.02]), trig);
	env3 = EnvGen.kr(\env3.kr(Env([0,0,1,0],[0,0.001,0.02])), trig);
	sig = SinOsc.ar( env2 * [1,1] ) * env3 * [1,0.2]; 
	sig2 = LFSaw.ar( env2 * [1,1] ) * env3 * [1,0.2]; 
	sig = SelectX.ar(\mix.kr(0.1), [sig, sig2]);
	sig = (sig * \distamp.kr(100)).tanh;
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\kap)[1] = \set -> Pbind(
	\env3, Pseq([
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4),
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4 ),
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.22]) ],
		],8 * 4),
		Pser([
			[ Env([0,0,1,0],[0,0.101,0.22]) ],
		],8 * 4),
	],inf),
	\trig, Pseq([
		Pser([
			1,0,0,0
		],16 * 4),
		Pser([
			1,0,1,0
		],16 * 4),
		Pser([
			1,1,1,1
		],16 * 7),
		Pser([
			1,0,0,0
		],16),
	],inf),
	\trig, Pseq([
		Pser([
			1,0,1,0,
			1,1,1,0,
			1,0,1,0,
			0,1,1,0,
			1,0,1,1,
			1,0,1,0,0,
		],16 * 7),
		Pser([
			1,0,0,0
		],16 * 4),
		Pser([
			1,0,1,0
		],16 * 4),
		Pser([
			1,0,0,0
		],16),
	],inf),
	\dur, 1/8,
);
);
Ndef(\kap).clear
Pdef(\k1).play
Pdef(\snare).play
Pdef(\k1).set(\amp, 0.051)
Pbindef(\k1, \amp, 0.1)
TempoClock.default.tempo = 1
(
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
)

(
Pdef(\mk1, Pbind(
	\instrument, \zkick,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
);)
)

(
Pdef(\part1, Ppar([
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\hat),
])).play
)

(
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,1,0, 0,0,1,0,
		1,0,0,0, 0,1,0,0,
		0,0,0,0, 0,1,0,0,
		1,0,1,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.2
));

)

///////////////////////////////////////////////////////::
(
Ndef(\kap).put(0, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//var trig = Impulse.kr(8);
	var trig = \trig.tr(1);
	env1 = EnvGen.kr(Env([2,1,0.1,1.2],[0.0001,0.0008, 0.1]), trig);
	env1 = LFSaw.kr(4) + SinOsc.kr(16).range(0,0.21);
	sig = SinOsc.ar(freq * env1 * [1,1.001]);
	env2 = EnvGen.kr(Env([420,420,32,20],[0,0.01,0.02]), trig);
	env3 = EnvGen.kr(\env3.kr(Env([0,0,1,0],[0,0.001,0.02])), trig);
	sig = SinOsc.ar( env2 * [1,1] ) * env3 * [1,0.2]; 
	sig2 = LFSaw.ar( env2 * [1,1] ) * env3 * [1,0.2]; 
	sig = SelectX.ar(\mix.kr(0.1), [sig, sig2]);
	sig = (sig * \distamp.kr(100)).tanh;
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\kap)[1] = \set -> Pbind(
	\env3, Pseq([
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4),
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4 ),
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.22]) ],
		],8 * 4),
		Pser([
			[ Env([0,0,1,0],[0,0.101,0.22]) ],
		],8 * 4),
	],inf),
	\trig, Pseq([
		Pser([
			0,1,1,1, 1,1,1,1,
			0,0,0,0, 0,0,0,0,
		],16 * 7),
	],inf),
	\dur, 1/8,
);
);
Ndef(\kap).clear
Pdef(\k1).play
Pdef(\snare).play
Pdef(\k1).set(\amp, 0.051)
Pbindef(\k1, \amp, 0.1)
(
TempoClock.default.tempo = 1;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
)

Ndef(\hatap).clear
(
Ndef(\hatap).put(0, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//var trig = Impulse.kr(8);
	var trig = \trig.tr(1);
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100) , \rq.kr(0.5) * SinOsc.kr(1 * SinOsc.kr(1/16).range(0,4)).range(0.1,1));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),trig,doneAction:0);
	sig = sig ! 2 * 0.1 * SinOsc.kr(7.1).range(0,1);

	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\hatap)[1] = \set -> Pbind(
	\env3, Pseq([
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4),
	],inf),
	\trig, Pseq([
		Pser([
			0,0,0,0, 0,0,0,0,
			0,1,1,1, 1,1,1,1,
		],16 * 7),
	],inf),
	\dur, 1/8,
);
)

(
Pdef(\mk1, Pbind(
	\instrument, \zkick,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
);)
)

(
Pdef(\test,
Pbind(
	\dur, 1/4,
	\isRest, false,

) <>
PtimeGate(~noteTimeline.new(\bass).asPattern)
).play
)

(
Pdef(\part1, Ppar([
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\hat),
	Pdef(\bass),
	//~noteTimeline.new(\bass).asPattern,
])).play;
Ndef(\hatap).play;
Ndef(\kap).play;
)
Ndef(\kap).stop;
Pdef(\kick).play
Pdef(\bass).stop
Pdef('bass.0').stop

(
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,1,0, 0,0,1,0,
		1,0,0,0, 0,1,0,0,
		0,0,0,0, 0,1,0,0,
		1,0,1,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/1,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.2
));

)

Pdef(\bass).play
Pdef(\bass).stop
(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\note, Pstep(Pseq([
		3,\r,0,-1,
		3,3,3,-1,
		3,3,3,-1,
		-1,0,\r,-1,
	],inf),1),
	\note, Pstep(Pseq([
		Pseq([
			0,0,0,-1,
			3,3,3,-4,
		],2),
		0,-1,0,-1,
		-4, 0,-4,\r,
		0,\r,0,\r,
		-4,-4,-4,-1,
		Pseq([
			0,0,0,0,
			3,3,-4,-1,
			0,0,0,0,
			3,3,-1,-4,
		],1),
	],inf),1),
	\legato, Pseq([Prand([0.1,1]),0.3,0.7],inf),
	//\root, Pstep(Pseq([0,0,5,7-12],inf),2),
	\octave, 4,
	\dur, 1/8,
	\amp, 0.1
));
)
(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\note, Pstep(Pseq([
		3,\r,0,-1,
		3,3,3,-1,
		3,3,3,-1,
		-1,0,\r,-1,
	],inf),1),
	\note, Pstep(Pseq([
	],inf),1),
	\legato, Pseq([Prand([0.1,1]),0.3,0.7],inf),
	//\root, Pstep(Pseq([0,0,5,7-12],inf),2),
	\octave, 4,
	\dur, 1/8,
	\amp, 0.1
));
)

Pdef(\bass).play
Pdef(\metronome, Pbind(\isRest, false, \dur, 1/4, \amp, Pseq([1,0.5,0.8,0.5]/5,inf), \fratio, 7, \timeScale, 0.2) <>Pdef(\kick)).play

(
Pdef(\plop, Pbind(
	\instrument, \default,
	//\freq, 200,
	\dur, 1,
	\amp, 0.1
));
)
~noteTimeline.new(\bass, Param(Pdef(\bass), \midinote)).edit
~noteTimeline.new(\bass).clear
~noteTimeline.new(\plop, Param(Pdef(\plop), \midinote)).edit
ParamProto.init

(
MKtl(\lp, "novation-launchpad-s");
~event_factory = ~noteTimeline.new(\bass).eventFactory;
MKtl(\lp).elAt(\pad).do ({ arg pad, idx;
	idx = idx+24;
	pad.elAt(\on).action = { arg me; me.value = 40.754; idx.debug("LPplay"); ~event_factory.childAt(idx).play };
	pad.elAt(\off).action = { arg me; me.value = 0.754; idx.debug("LPstop"); ~event_factory.childAt(idx).stop };
});
)

////////////
(
Ndef(\hatap).put(0, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//var trig = Impulse.kr(8);
	var trig = \trig.tr(1);
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100) , \rq.kr(0.5) * SinOsc.kr(1 * SinOsc.kr(1/16).range(0,4)).range(0.8,2));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),trig,doneAction:0);
	sig = sig ! 2 * 0.1 * SinOsc.kr(7.1).range(0,1);

	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\hatap)[1] = \set -> Pbind(
	\env3, Pseq([
		Pser([
			[ Env([0,0,1,0],[0,0.001,0.02]) ],
		],8 * 4),
	],inf),
	\lpf, Pseq([
		Pser([
			7000,3000,5000,2000,
		],16),
		Pser([
			7000,6000,6100,6400,
		],16),
	],inf),
	\rel, Pseq([
		Pser([0.051,0.1,0.1,0.1], 1),
		Pser([0.6,0.1,0.1,0.1], 1),
		Pser([0.1,0.1,0.1,0.1], 1),
		Pser([0.1,0.1,0.6,0.1], 1),

		Pser([0.051,0.1,0.1,0.1], 1),
		Pser([0.1,0.1,0.2,0.1], 1),
		Pser([0.1,0.1,0.1,0.1], 1),
		Pser([0.1,0.1,0.6,0.6], 1),
	],inf),
	\trig, Pseq([
		Pser([
			0,0,0,0, 0,0,0,0,
			0,1,1,1, 1,1,1,1,
		],16 * 8),
		Pser([
			1,0,
		],16 * 3),
		Pser([
			1,1,
		],16 * 1),
		Pser([
			1,0, 1,0, 1,0, 1,0,
			1,1, 1,1, 1,0, 1,0,
		],16 * 3),
		Pser([
			1,1,
		],16 * 1),
		Pser([
			0,0, 0,0, 0,0, 0,0,
			1,1, 1,1, 1,0, 1,0,
		],16 * 3),
		Pser([
			1,1,
		],16 * 1),
	],inf),
	\dur, 1/8,
);
)


///////////////////////////


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * \freqtab.kr([1,2,3,4,5,6,7]) * EnvGen.kr(\freqenv.kr(Env([1,2,1,0.2]/2,[0.1,0.08,0.2])), 1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	freqenv: XEnvSpec(\sustain, \sustain),
	freqtab: XArraySpec(ControlSpec(0.01,5,\exp)),
	duration: ControlSpec(0.001,4,\lin, 0, 1)
))).add;
);

(
Pdef(\kick, Pbind(
	\instrument, \plop,
	\degree, Pfin(16,Pseq([0,2,0,2,Prand((0..7), Prand(( 1..8 ))).stutter(Prand((1..8)))],inf)).loop,
	\octave, 3,
	\dur, 1/8,
	\isRest, Pseq([
		1,0,1,0, 0,0,0,0,
		1,1,1,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,0,0,0, 0,1,1,0,
	],inf).coin.not,
	\amp, 0.4
));
);

Param(Pdef(\kick), \freqenv, XEnvSpec(\sustain, \amp)).edit
Param(Pdef(\kick), \freqtab, XArraySpec(\amp)).edit
Pdef(\kick).asParamGroup.edit

\amp.asSpec
Param(Pdef(\plop), \freqtab).spec
Param(Pdef(\plop), \freqtab).edit
Param(Pdef(\plop), \freqenv, XEnvSpec(\sustain, \amp)).edit
Param(Pdef(\plop), \freqenv, XEnvSpec(\sustain.asSpec, \sustain.asSpec)).set(nil)
Param(Pdef(\plop), \freqenv, XEnvSpec([\freq])).edit
WindowDef(\test, {Param(Pdef(\plop), \freqtab, XArraySpec(ControlSpec(0,10,\lin))).asView}).front
Param(Pdef(\plop), \freqtab, XArraySpec(ControlSpec(0,10,\lin))).edit
Param(Pdef(\plop), \freqtab, XArraySpec([ControlSpec(0,10,\lin)])).edit
Param(Pdef(\plop), \freqtab, XArraySpec([ControlSpec(0,10,\lin)])).edit
Pdef(\plop).unset(\freqtab)

Pdef(\snare).play

(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * EnvGen.kr(Env([1.5,1,1],[0.01,0.8]), 1);
	freq = freq * ( 1 + ( SinOsc.ar(freq/ [1,1/2]) * 0.11 ));
	sig = LFSaw.ar(freq * [1/2,1,1.01 + Rand(0,0.01)]);
	sig = sig + LFPulse.ar(freq * [1/2,1]);
	sig = RLPF.ar(sig, \lpfr.kr(1/2) * freq, \rq.kr(0.01)) + ( sig/4 );
	sig = RLPF.ar(sig, \lpfr2.kr(3) * freq, \rq2.kr(0.701));
	sig = ( sig * 12 * freq.log ).tanh / 2;
	sig = ( sig * 1 * freq.log ).fold2(0.7) * 2;
	sig = sig * LFSaw.ar(freq*1, mul:1, add:1);
	sig = RLPF.ar(sig, \lpfr3.kr(1/2) * freq, \rq3.kr(0.04)) + ( sig/4 );
	sig = RLPF.ar(sig, \lpfr4.kr(2) * freq, \rq4.kr(0.04));
	sig = sig.tanh/1.5 + Limiter.ar(sig);
	sig = sig + LPF.ar(sig, 200, mul: freq.log/2);
	sig = BRF.ar(sig, 3000, 0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.0001,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 1;
	sig = Pan2.ar(sig, SinOsc.kr(1/42.1 + (0..2))*0.1+pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

Ndef(\snare).clear
(
	Ndef(\snare, { arg amp=0.1, pan=0, freq=200;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var click=0, osc=0, snare=0;
		//var trig = Impulse.ar(148 * SinOsc.kr(1/8).range(0,1));
		var trig = Impulse.ar(1);
		click = WhiteNoise.ar;
		click = click * EnvGen.ar(Env([0,1,0],[0.001,0.004]), trig) * 1;

		osc = SinOsc.ar( EnvGen.ar(\oscfreqenv.kr(Env([0,800,40,41],[0,0.01,0.18])), trig) );
		osc = osc * EnvGen.ar(\oscampenv.kr(Env([0,0,1,0],[0,0.001,0.20], -4)), trig);
		osc = osc * 2;
		osc = HPF.ar(osc, 10);

		snare = WhiteNoise.ar;
		snare = LPF.ar(snare, EnvGen.ar(\lpenv.kr(Env([0,14700,4852,3451],[0,0.01,0.1])), trig) * SinOsc.kr(1/4).range(0,1));
		snare = HPF.ar(snare, EnvGen.ar(\hpenv.kr(Env([0,9700,4452,3451],[0,0.01,0.1])), trig) * SinOsc.kr(1/4.1).range(0,1));
		snare = snare * EnvGen.ar(\snareampenv.kr(Env([0,0,1,0],[0,0.001,0.48], -2)), trig);

		sig = click + osc + snare;

		sig = sig * EnvGen.ar( Env([0,0,1,0],[0,0.021,0.8]),trig,doneAction:0);
		sig = Pan2.ar(sig, pan, amp);
	} ).play
)

SynthDef(\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(\oscfreqenv.kr(Env([400,150,151],[0.01,0.08])), 1) );
	osc = osc * EnvGen.kr(\oscampenv.kr(Env([0,1,0],[0.001,0.20], -4)), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(\lpenv.kr(Env([14700,4852,3451],[0.01,0.1])), 1));
	snare = HPF.ar(snare, EnvGen.ar(\hpenv.kr(Env([9700,4452,3451],[0.01,0.1])), 1));
	snare = snare * EnvGen.kr(\snareampenv.kr(Env([0,1,0],[0.001,0.18], -2)), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscfreqenv: XEnvSpec(\freq!3),
	oscampenv: XEnvSpec(\amp!3),
	lpenv: XEnvSpec(\freq!3),
	hpenv: XEnvSpec(\freq!3),
	snareampenv: XEnvSpec(\amp!3),
	adsr: XEnvSpec.adsr,
))).add;
