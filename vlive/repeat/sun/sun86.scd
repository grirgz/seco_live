
// transform pdefpart into playergrid

TrackDef(\split).clear
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.loadOnce("sun/lib.scd"); };
TrackDef(\split, \PlayerGrid);
FileSystemProject.loadOnce("libdef/controllers.scd");
FileSystemProject.loadOnce("libdef/apc.scd");
~splitpart = { arg prefix, pat;
	var list = [];
	if(pat.source.isKindOf(Pdef)) {
		pat = pat.source;
	};
	if(pat.source.isKindOf(Ppar)) {
		list = pat.source.list;
		list = list.collect { arg item, idx;
			Pdef("%_%".format(prefix, idx).asSymbol, item);
		};
	};
	list;


};

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
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
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
));
~assign_splitpart = { arg tl, pat, idx, prefix;
	prefix = prefix ?? { \split };
	tl.sectionAt(idx).source = ~splitpart.("%%".format(prefix, idx), Pdef(\part));
}


)
~assign_splitpart.(TrackDef(\split), Pdef(\part), 4)
Pdef.defaultQuant = 4
TrackDef(\split).sectionAt(0).source = ~splitpart.(\s1, Pdef(\part));
TrackDef(\split).sectionAt(4).source = ~splitpart.(\s1, Pdef(\part));

TrackDef(\split).edit;
TrackDef(\split).key
TrackDef(\split).trackKey



~splitpart.(\s1, Pdef(\part))
Pdef(\part1).source
TrackDef(\split).elAt(0,0).source = Pdef(\part)
TrackDef(\split).elAt(0,0).source = nil
TrackDef(\split).elAt(0,0).source
TrackDef(\split).elAt(1,0).source
TrackDef(\split).elAt(0).source = [ Pdef(\part) ]
TrackDef(\split).sectionAt(0).source
TrackDef(\split).sectionAt(0).source = [ Pdef(\part), Pdef(\part2) ]
(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\pad).elAt(0).elAt(0).elAt(0)
k.elAt(\pad).elAt(0).elAt(0).elAt(0).action = { "0 on pushed".postln; };
k.elAt(\pad).elAt(0).elAt(0).elAt(1).action = { "0 off pushed".postln; };
k.postElements;
k.elAt(\pad).elAt(0).elAt(0).elAt(0).value = 0.05;
MKtl.find
FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));

ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2]);
ProtoDef(\apc40).activate_bank_selector
MKtl.find(\midi); // when was not connected
k=MKtl(\apc, "akai-apc40mkii");
MKtl(\apc).gui
k.elAt(\bt, \clip, 0,1)
k.elAt(\bt, \clip, 0,0, \on).action
k.elAt(\bt, \shift)
k.elAt(\bt, 8, \up)
k.elAt(\bt)
k.elAt(\bt, \clipS)
k.elAt(\bt, \device)
k.elAt(\bt, \track, \activ, 0, \on)
k.elAt(\sl, \master)
k.elAt(\sl,0,0)
k.elAt(\kn,\t, 0, 4)
k.elAt(\kn,\t, 2, 3)
k.elAt(\kn,\d, 0)

k.elAt(\bt, \clipColor, 0,0,\blink).value = 123/127
k.gui
k.reload
k.sendSpecialMessage(\abletonLiveMode)
k.trace
MKtl.paths
MKtl.postLoadedDescs
MKtlDesc.userFolder.openOS;
MKtlDesc.writeCache;
(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	
});
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
PlayerWrapper(Pdef(\zed)).doWithQuant { "hello".debug; 0 }
