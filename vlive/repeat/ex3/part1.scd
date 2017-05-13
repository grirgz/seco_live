
(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

ClipTimeline(\part1).edit
ClipTimeline(\part1).asPattern.play
ClipTimeline(\part1).clear
ParamProto.init(true)
ClipTimeline(\part1).presetCompileString
KitTimeline(\part1_perc).asPatternEvent
KitTimeline(\part1_perc0).edit
KitTimeline(\part1_perc0).clear
KitTimeline(\part1_perc).kit.edit
KitTimeline(\part1_perc).clear
PatKitDef(\part1).edit
PatKitDef(\part1).clear

(
// init
	s.waitForBoot {
		
		~t = 285/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
		FileSystemProject.load("ex3/lib.scd");
		FileSystemProject.load("ex3/barlokkit.scd");
		FileSystemProject.load("ex3/part1_PatKitDef.scd");
		FileSystemProject.load("ex3/part1_ClipTimeline.scd");
		FileSystemProject.load("ex3/part1_KitTimeline_0.scd");
		FileSystemProject.load("ex3/part1_ndefs.scd");
	};
)
(
TrackDef(\part1, TrackDef(\playergrid)).source = [
	8.collect { arg x; KitTimeline(\part1_perc+++x, PatKitDef(\part1)); },
	8.collect { arg x; Ndef(\gradubid+++x); },
	[
		Ndef(\police)
	],
	[
		ProtoDef(\rdn)
	],
	[
		Ndef(\vardelay),
		Ndef(\vardelaydist),
	],
	8.collect { arg x; KitTimeline(\part1_perc_b+++x, PatKitDef(\part1_b)); },
	8.collect { arg x; NoteTimeline(\part1_bass+++x, Param(Pdef(\part1_bass), \midinote)); },

]
)
TrackDef(\part1).edit;


TrackDef(\part1).presetCompileStringSavePath = "ex3/part1_data/"
TrackDef(\part1).presetCompileStringSavePath
TrackDef(\part1).savePresetCompileString
TrackDef(\part1).savePresetCompileString
TrackDef(\part1).loadPresetCompileString
KitTimeline(\part1_perc0).presetCompileStringSavePath
KitTimeline(\part1_perc0).presetCompileStringSavePath = nil
KitTimeline(\part1_perc0).savePresetCompileString
KitTimeline('part1_perc0').presetCompileStringSavePath = "ex3/part1_data/part1_KitTimeline_0.scd";
PlayerWrapper(Ndef(\police)).presetCompileStringSavePath
PlayerWrapper(Ndef(\plop)).savePresetCompileString
PlayerWrapper(TrackDef(\plop)).targetClass
TrackDef(\part1).children[1].children[0].proxy

(
	/// saving system
	TrackDef(\part1).source.
)

TrackDef(\part1)
Ndef.defaultQuant = 0
Ndef.defaultQuant
PlayerWrapper(Ndef(\pllop))

PlayerWrapper(Ndef(\gradubid0)).play
PlayerWrapper(Ndef(\gradubid0)).playNow
PlayerWrapper(Ndef(\gradubid0)).stopNow
PlayerWrapper(Ndef(\gradubid0)).stop

PlayerWrapper(Ndef(\gradubid0)).asPlayerEvent.play

(
Ndef(\vardelay, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig = in;
	sig = DelayC.ar(in.flop, 8, \delays.kr((1..16)/16));
	sig = sig * \amps.kr((1..16)/16);
	sig.postln;
	sig = sig.sum;
	sig;
})
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
})
)
Ndef(\vardelay).set(\inbus, BusDef(\sendbus1))
Ndef(\vardelay).addSpec(\delays, XArraySpec( ControlSpec(0,8,\lin)));
Ndef(\vardelay).addSpec(\amps, XArraySpec(\amp))

Ndef(\vardelaydist).set(\inbus, BusDef(\sendbus1))
Ndef(\vardelaydist).addSpec(\delays, XArraySpec( ControlSpec(0,1,\lin)));
Ndef(\vardelaydist).addSpec(\amps, XArraySpec(\amp))
Ndef(\vardelaydist).addSpec(\distmix, \unipolar.asSpec)
WindowDef(\NdefEditor).front(Ndef(\vardelay))


(
SynthDef(\part1_bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig + SinOsc.ar(freq/2); 
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part1_bass, Pbind(
	\instrument, \part1_bass,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));
);

SynthDesc(\playersec).addSpec(\pos, ControlSpec(0.0,4,\lin))
