(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

(
FileSystemProject.load("libdef/launchpad.scd");
FileSystemProject.load("libdef/tracklist_extensions.scd");
FileSystemProject.loadOnce("libdef/controllers.scd");
ProtoDef(\launchpad_playergrid).startControl(TrackDef(\split, \PlayerGrid));
)


TrackDef(\split).edit
TrackDef(\split).sectionAt(0).splitAndAssignPattern
TrackDef(\split).sectionAt(1).isEmpty

k = MKtl(\lp, "novation-launchpad-s");
k.clear
k.reload
MKtl.find(\midi)
k.elAt(\pad).elAt(0).elAt(0).elAt(0).action = { "0 on pushed".postln; };
k.elAt(\pad).elAt(0).elAt(0).elAt(1).action = { "0 off pushed".postln; };
k.elAt(\pad)
k.postElements;
k.elAt(\pad,0,0,\on).value = 15/128;
k.elAt(\pad,0,0,\on).value = 45/128;
k.elAt(\arr,0,\on).value = 45/128;
k.elAt(\arr,0,\on).value = 0;
k.elAt(\arr,1,\on).value = 0;
k.elAt(\pad,0,0).value = 15/128;
k.elAt(\pad,0,0,\on).value = 2;
k.elAt(\pad,0,0).value = 15;
k.elAt(\bt, \mixer).value = 1
0x0f
k.elAt(\bt, \user2)
k.elAt(\bt).elAt(\mixer)
k.reload
1
~apc=MKtl(\apc, "akai-apc40mkii");
~apc.elAt(\bt,\clip, 2,2,\on).value = 15/127
~apc.elAt(\bt,\clip, 2,2,\on).value = 75/127

TrackDef(\split_extra).edit

(
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
)).play;
);
