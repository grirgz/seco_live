
(
// init
	s.waitForBoot {
		
		~t = 215/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
		FileSystemProject.load("ex3/lib.scd");
		FileSystemProject.load("ex3/barlokkit.scd");
		FileSystemProject.load("ex3/part1_ndefs.scd");
		FileSystemProject.load("ex3/part2_ndefs.scd");
		FileSystemProject.load("ex3/part2_pdefs.scd");
	};
)
(
TrackDef(\part2, TrackDef(\playergrid)).source = [
	8.collect { arg x; KitTimeline(\part2_perc+++x, PatKitDef(\part2)); },
	8.collect { arg x; Ndef(\gradubid+++x); },
	[
		Ndef(\part2_treb),
		Ndef(\part2_treb_b),
		Ndef(\part2_treb_c),
		Ndef(\part2_zip),
	],
	[
		nil,
	],
	[
		nil,
	],
	8.collect { arg x; ProtoDef(\part2_vardelaydist_preset+++x, ProtoDef(\NdefPreset).new(Ndef(\vardelaydist))); },
	8.collect { arg x; KitTimeline(\part2_perc_b+++x, PatKitDef(\part2_b)); },
	8.collect { arg x; NoteTimeline(\part2_bass+++x, Param(Pdef(\part2_bass), \midinote)); },
];
TrackDef(\part2).resources = [
	PatKitDef(\part2),
	PatKitDef(\part2_b),
];

TrackDef(\part2_fx, TrackDef(\playergrid)).source = [
	[
		ProtoDef(\part2_rdn, ProtoTemplateDef(\rdn))
	],
	[
		ProtoDef(\part2_rdn2, ProtoTemplateDef(\rdn))
	],
	[
		Ndef(\vardelay),
		Ndef(\vardelaydist),
	],

];
TrackDef(\part2).initFromPresetDir("ex3/part2_data/");
TrackDef(\part2_fx).initFromPresetDir("ex3/part2_data/");

)
ClipTimeline(\part2).edit
WindowDef(\multigrid).front;

	PatKitDef(\part2).presetCompileStringSavePath
	PatKitDef(\part2).savePresetCompileString
	PatKitDef(\part2).edit;
	PatKitDef(\part2).clear

	8.collect { arg x; ProtoDef(\part2_vardelaydist_preset+++x).clear; }
TrackDef(\part2).edit
TrackDef(\kit_workspace).edit;
TrackDef(\kit_workspace_rdn).edit;
TrackDef(\part2).clear
TrackDef(\part2).presetCompileStringSavePath = "ex3/part2_data/"
TrackDef(\part2).presetCompileStringSavePath
TrackDef(\part2).savePresetCompileStringDialog
(
/////////// saving!
TrackDef(\part2).savePresetCompileString;
TrackDef(\part2_fx).savePresetCompileString;
)

(
//////// WARNING: loading, lose all !!!!
TrackDef(\part2).loadPresetCompileString;
TrackDef(\part2_b).loadPresetCompileString;
)
1+1

ProtoDef(\part2_rdn2).presetCompileStringSavePath
ProtoDef(\part2_rdn).presetCompileString
ProtoDef(\part2_rdn2).asPresetCompileString
RandDelayNetwork(\deldefault).presetCompileString(\part2_rdn)


(
Ndef(\vardelay, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig = in;
	sig = DelayC.ar(in.flop, 8, \delays.kr((1..16)/16));
	sig = sig * \amps.kr((1..16)/16);
	sig.postln;
	sig = sig.sum;
	sig;
});
Ndef(\vardelay).set(\inbus, BusDef(\sendbus1))
Ndef(\vardelay).addSpec(\delays, XArraySpec( ControlSpec(0,8,\lin)));
Ndef(\vardelay).addSpec(\amps, XArraySpec(\amp))
)
(
Ndef(\vardelaydist, { arg postdistamp=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig0, sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig = in;
	sig = DelayC.ar(in.flop, 1, \delays.kr((1..16)/16));
	sig = sig * \amps.kr((1..16)/16);
	sig = sig.sum;
	sig0 = sig*\predistamp.kr(1);
	sig1 = sig0.clip2(1)*postdistamp;
	sig2 = sig0.distort(1)*postdistamp;
	sig3 = sig0.tanh(1)*postdistamp;
	sig = SelectX.ar(\distmix.kr(0.5)*3, [sig, sig1, sig2, sig3]);
	sig = sig * \gain.kr(1);
	sig.postln;
	sig;
});
Ndef(\vardelaydist).set(\inbus, BusDef(\sendbus1));
Ndef(\vardelaydist).addSpec(\delays, XArraySpec( ControlSpec(0,1,\lin)));
Ndef(\vardelaydist).addSpec(\amps, XArraySpec(\amp));
Ndef(\vardelaydist).addSpec(\distmix, \unipolar.asSpec);
)
Ndef(\vardelaydist).clear
Ndef(\vardelaydist).set(\inbus, BusDef(\sendbus0))

TrackTimeline(\tt, TrackDef(\part2)).edit


MenuSpecFuncDef(\hello, { 10.rand.collect({ arg x; x.debug("xx"); "..%..".format(x) -> "keyy: %".format(x) }) })
MenuSpecFuncDef(\hello).valueList
MenuSpecFuncDef(\hello).labelList
MenuSpecFuncDef(\hello).list
MenuSpecFuncDef(\hello).source
MenuSpecDef(\hello, [ "kj" ->45, "az"->12 ])
MenuSpecDef(\hello).list
MenuSpecDef(\hello).valueList

(
	
)
