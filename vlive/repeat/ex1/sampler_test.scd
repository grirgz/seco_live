(

ParamProto.init;

~drumkit = [
	Pbind(
		\instrument, \snapkick,
		\amp, 0.1
	),
	Pbind(
		\instrument, \snapsnare,
		\amp, 0.1
	),
	Pbind(
		\instrument, \snaphihat,
		\sustain, 0.2,
		\rel, 0.1,
		\amp, 0.1/3
	),
	Pbind(
		\instrument, \snaphihat,
		\sustain, 0.2,
		\rel, 1.1,
		\amp, 0.1/3
	),
];
)

~kitTimeline.new(\sampler).clear
~kitTimeline.new(\sampler, ~drumkit);
~kitTimeline.new(\sampler).edit;

(
~pg = ~kitTimeline.new(\sampler).wrapper;

MKtl(\lp, "novation-launchpad-s");
~pg.elDo({ arg player, idx;
	var pad = MKtl(\lp).elAt(\pad);
	player.debug("player");
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;
		player.stop;
	});
});

)

(
Pdef(\metronome, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pseq([400,200,250,200],inf),
			\dur, 1,
			\sustain, 0.01,
			\amp, 0.1/2,
		),
	//	Pbind(
	//		\instrument, \snaphihat,
	//		\dur, 1/4,
	//		\sustain, Pseq([1/16,Pn(1/32,3)],inf),
	//		\amp, 0.1/4
	//	);
	]),

)
)

/////////////////////////////

(

ParamProto.init;

~realdrumkit = [

	// ROW 1

	Pbind(
		\instrument, \player,
		\bufnum, ~bufs[\kick],
		\legato, 2,
		\dur, 1/8,
		\amp, 0.2
	),
	Pbind(
		\instrument, \player,
		\bufnum, ~bufs[\kick],
		\pos, 0.02,
		\legato, 1,
		\dur, 1/8,
		\amp, 0.2
	),
	Pbind(
		\instrument, \player,
		\bufnum, ~bufs[\snare],
		\degree, Pseq([0],inf),
		\dur, 1/8,
		\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
		\gain, 2,
	),
	Pbind(
		\instrument, \player,
		\bufnum, ~bufs[\snare],
		\degree, Pseq([0],inf),
		\pos, 0.04,
		\dur, 1/8,
		\legato, 1,
		\gain, 2,
		\amp, 0.1
	),

	//

	Pbind(
		\instrument, \player,
		\bufnum, ~bufs[\snare],
		\degree, Pseq([0],inf),
		\pos, 0.01,
		\dur, 1/8,
		\legato, 1,
		\gain, 2,
		\amp, 0.1
	),

	Pbind(
		\out, 0,
		\instrument, \playerbeat,
		\bufnum, ~bufs[\hat],
		\speed, 0.6,
		\degree, Pseq([0],inf),
		\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
		\dur, 1/8,
		\legato, Pseq([
			1/2,1/4,1/4,1/4,
			1/2,1/4,1,1/4,
			1/2,1/4,1/4,1/4,
			1/2,1/4,1/4,1/4,

			1/2,1/4,2,1/4,
			1/2,1/4,1/4,1/4,
			1/2,1/4,1/4,1/4,
			1/2,1/4,1/4,1/4,
		],inf),
		\amp, 0.1
	),
	Pbind(
		\out, 0,
		\instrument, \snaphihat,
		//\bufnum, ~bufs[\hat],
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.3,0.4) ],
		],inf),
		\speed, 0.6,
		\dur, 1/8,
		\gain, 1/2,
		\legato, Pseq([ 2
		],inf),
		\amp, 0.1/3,
	),
	Pbind(
		\out, 0,
		\instrument, \snaphihat,
		//\bufnum, ~bufs[\hat],
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.3,0.04) ],
		],inf),
		\speed, 0.6,
		\dur, 1/8,
		\gain, 1/2,
		\legato, Pseq([ 2
		],inf),
		\amp, 0.1/3,
	),

	// ROW 2


].collect({ arg x; x <> Pbind(\out, BusDef(\fx1))  });

~kitTimeline.new(\sampler, ~realdrumkit);
)

~kitTimeline.new(\sampler).clear
~kitTimeline.new(\sampler).edit;

(
~kitTimeline.new(\sampler, ~realdrumkit);
~pg = ~kitTimeline.new(\sampler).wrapper;

MKtl(\lp, "novation-launchpad-s");
~pg.elDo({ arg player, idx;
	var pad = MKtl(\lp).elAt(\pad);
	player.debug("player");
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;
		player.stop;
	});
});

)


(

MKtl(\lp, "novation-launchpad-s");
16.do { arg idx;
	var pad = MKtl(\lp).elAt(\pad);
	var name = \sampler;
	pad.elAt(idx).elAt(0).action_({
		var player = ~kitTimeline.new(name).wrapper.elAt(idx);
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		var player = ~kitTimeline.new(name).wrapper.elAt(idx);
		"off".debug;
		player.stop;
	});

};
)

MKtl(\lpy, "novation-launchpad-s").rebuild;
	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
ParamProto.init(true);


/////////////////////////////

// use BufDef
(

ParamProto.init;

~realdrumkit = [

	// ROW 1

	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\kick),
		\legato, 2,
		\gain, 1/4,
	),
	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\kick),
		\pos, 0.02,
		\legato, 1,
		\gain, 1/4,
	),
	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\snare),
		\degree, Pseq([0],inf),
		\dur, 1/8,
		\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
		\gain, 1/2,
	),
	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\snare),
		\degree, Pseq([0],inf),
		\pos, 0.04,
		\dur, 1/8,
		\legato, 1,
		\gain, 1/2,
	),

	//

	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\snare),
		\degree, Pseq([0],inf),
		\pos, 0.01,
		\dur, 1/8,
		\legato, 1,
		\gain, 1/2,
	),

	Pbind(
		\out, 0,
		\instrument, \playerbeat,
		\bufnum, BufDef(\hat),
		\speed, 0.6,
		\degree, Pseq([0],inf),
		\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
		\dur, 1/8,
		\legato, Pseq([
			1/2,1/4,1/4,1/4,
			1/2,1/4,1,1/4,
			1/2,1/4,1/4,1/4,
			1/2,1/4,1/4,1/4,

			1/2,1/4,2,1/4,
			1/2,1/4,1/4,1/4,
			1/2,1/4,1/4,1/4,
			1/2,1/4,1/4,1/4,
		],inf),
		\gain, 2,
	),
	Pbind(
		\out, 0,
		\instrument, \snaphihat,
		//\bufnum, ~bufs[\hat],
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.3,0.4) ],
		],inf),
		\speed, 0.6,
		\dur, 1/8,
		\gain, 1/2,
		\legato, Pseq([ 2
		],inf),
		\amp, 0.1,
	),
	Pbind(
		\out, 0,
		\instrument, \snaphihat,
		//\bufnum, ~bufs[\hat],
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.3,0.04) ],
		],inf),
		\speed, 0.6,
		\dur, 1/8,
		\gain, 1/2,
		\legato, Pseq([ 2
		],inf),
		\amp, 0.1,
	),

	// ROW 2

	Pbind(
		\instrument, \playerbeat,
		\bufnum, BufDef(\kick2),
		\adsr, Pseq([
			[ Env.adsr(0.001,0.0,1,0.4) ],
		],inf),
		\legato, 2,
		\dur, 1/8,
		\gain, 2
	),
	Pbind(
		\instrument, \playerbeat,
		\bufnum, BufDef(\snare2),
		\adsr, Pseq([
			[ Env.adsr(0.001,0.0,1,0.4) ],
		],inf),
		\pos, 0.02,
		\legato, 1,
		\dur, 1/8,
		\amp, 0.2
	),
	Pbind(
		\instrument, \playerbeat,
		\bufnum, BufDef(\hat2),
		\degree, Pseq([0],inf),
		\dur, 1/8,
		\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
		\gain, 1/2,
	),
	nil,

	nil,
	nil,
	nil,
	nil,

	// ROW 3

	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\kick_p2),
		\legato, 2,
		\gain, 1.5,
	),
	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\kick_p3),
		\legato, 2,
		\gain, 1.5,
	),


//].collect({ arg x; Pbind(\gain, Pkeyd(\gain, 1) / 2 ) <> x <> Pbind(\out, BusDef(\fx1))  });
].collect({ arg x; x !? {x <> Pbind(\out, BusDef(\fx1)) } });

~kitTimeline.new(\sampler, ~realdrumkit);
Ndef(\fx1).play;
)

~kitTimeline.new(\sampler).clear
~kitTimeline.new(\sampler).edit;
~kitTimeline.new(\sampler).getPresetCompileString

(

MKtl(\lp, "novation-launchpad-s");
32.do { arg idx;
	var pad = MKtl(\lp).elAt(\pad);
	var name = \sampler;
	pad.elAt(idx).elAt(0).action_({
		var player = ~kitTimeline.new(name).wrapper.elAt(idx);
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		var player = ~kitTimeline.new(name).wrapper.elAt(idx);
		"off".debug;
		player.stop;
	});

};
)

MKtl(\lpy, "novation-launchpad-s").rebuild;
	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifbdel).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play
Ndef(\fx1).edit

ParamProto.init(true);
~kitTimeline.new(\sampler).clear
~kitTimeline.new(\sampler, ~realdrumkit);
~kitTimeline.new(\sampler).edit;
~kitTimeline.new(\sampler).getPresetCompileString.editorInsert
~kitTimeline.new('sampler').eventList = XEventList.newFrom(Pseq([ Event.silent(0.375), Pbind(
	'midinote', Pseq([ 1, 1 ]),
	'dur', Pseq([ 0.375, 0.25 ]),
	'kitIndex', Pseq([ 4.0, 4.0 ]),
	'sustain', Pseq([ 0.1, 0.1 ]),
) ]));
~kitTimeline.new('sampler').eventList = 
XEventList.newFrom(Pseq([ Event.silent(0.375), Pbind(
	'midinote', Pseq([ 1, 1 ]),
	'dur', Pseq([ 0.375, 0.25 ]),
	'kitIndex', Pseq([ 4.0, 4.0 ]),
	'sustain', Pseq([ 0.1, 0.1 ]),
) ]));
~kitTimeline.new('sampler').eventLoop.list = XEventList.newFrom(Pseq([ Event.silent(0.25), Pbind(
	'midinote', Pseq([ 1, 1 ]),
	'dur', Pseq([ 0.25, 0.5 ]),
	'kitIndex', Pseq([ 2.0, 3.0 ]),
	'sustain', Pseq([ 0.125, 0.1 ]),
) ]));
~kitTimeline.new(\sampler).eventList.print
~kitTimeline.new(\sampler).recorder.eventLoop.list.print
~kitTimeline.new(\sampler).recorder.eventLoop.list
~kitTimeline.new(\sampler).recorder.getPresetCompileString

~kitTimeline.new(\sampler, ~drumkit);
~kitTimeline.new(\sampler).edit;
~kitTimeline.new(\sampler).getPresetCompileString.editorInsert
~kitTimeline.new('sampler').eventList = XEventList.newFrom(Pseq([ Event.silent(1.4360132879999), Pbind(
	'midinote', Pseq([ 1, 1, 1, 1, 1 ]),
	'dur', Pseq([ 0.41606392266669, 0.45190653733334, 0.39742866799998, 0.37056421600005, 1.4893527626666 ]),
	'kitIndex', Pseq([ 1, 0, 0, 0, 0 ]),
	'sustain', Pseq([ 0.30938267600004, 0.25454639999998, 0.26009596533333, 0.23588808133331, 0.18142428666658 ]),
) ]));
(
~kitTimeline.new('sampler2').eventList = XEventList.newFrom(Pbind(
	'midinote', Pseq([ 1, 1, 1, 1, 1, 1, 1, 1, 1 ]),
	'dur', Pseq([ 0.43867060533341, 0.46265465066654, 0.43199990133337, 0.54135873600001, 0.41606392266669, 0.45190653733334, 0.39742866799998, 0.37056421600005, 1.4893527626666 ]),
	'kitIndex', Pseq([ 0, 1, 2, 2, 1, 0, 0, 0, 0 ]),
	'sustain', Pseq([ 0.25343983866662, 0.2480127066666, 0.28941636533341, 0.2614241506667, 0.30938267600004, 0.25454639999998, 0.26009596533333, 0.23588808133331, 0.18142428666658 ]),
));
)

~kitTimeline.new(\sampler2, ~drumkit);
~kitTimeline.new(\sampler2).edit
~kitTimeline.new(\sampler2).eventList.print

~x = Set.new

~x.addAll([1,2,34])
~x

(

MKtl(\lp, "novation-launchpad-s");
32.do { arg idx;
	var pad = MKtl(\lp).elAt(\pad);
	var name = \sampler2;
	pad.elAt(idx).elAt(0).action_({
		var player = ~kitTimeline.new(name).wrapper.elAt(idx);
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		var player = ~kitTimeline.new(name).wrapper.elAt(idx);
		"off".debug;
		player.stop;
	});

};
)

(
		Pdef(\smpdrum1, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\kick),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 8,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\kick),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0.21, 1,0,0.3,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.02,
				\legato, 3,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\snare),
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16) * 2,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\snare),
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,1,0,0,
				],inf).coin.not,
				\pos, 0.04,
				\dur, 1/8,
				\legato, 4,
				\amp, 0.1
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\snare),
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\pos, 0.01,
				\dur, 1/8,
				\legato, 1,
				\amp, 0.1
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\hat),
				\speed, 0.6,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					0,0, 0,0, 1,0, 1,0,
					0,1, 1,0, 1,0, 1,0,
					0,0, 0,0, 1,0, 1,0,
					1,0, 1,0, 1,0.5, 1,0,
					0,0, 0,0, 1,0, 1,0,
					0.61,1, 1,0, 0,1, 1,0,
					0,0, 0,0, 1,0, 1,0,
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf),
				\amp, 0.1
			),

	]));
	Pdef(\smpdrum1).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum1)).play;
	Ndef(\fx1).play;
	)
