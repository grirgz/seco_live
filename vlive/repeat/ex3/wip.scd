
PatKitDef(\ex3).edit


// barlok kit

FileSystemProject.load("ex3/barlokkit.scd");

PatKitDef(\barlok1).edit
PatKitDef(\barlok1).clear
PatKitDef(\barlok1).presetCompileString
PatKitDef(\barlok1).startControl

KitTimeline(\remix, PatKitDef(\loop1));
KitTimeline(\remix).edit;
KitTimeline(\remix).outBus = BusDef(\fx1, \audio);

KitTimeline(\bb, PatKitDef(\barlok1));
KitTimeline(\bb).edit

KitTimeline(\bb2, PatKitDef(\barlok1));
KitTimeline(\bb2).edit
KitTimeline(\bb2).outBus = BusDef(\fx1, \audio)
KitTimeline(\bb).outBus = BusDef(\fx1, \audio)

ProtoDef(\rdn).edit
Ndef(\fx1).edit
Ndef(\fx1).play(BusDef(\recbus).index, 2)
Ndef(\fx1).play(0, 2)
ProtoDef(\basicrecorder).edit

BufDef(\tmp16, s.sampleRate/~t*16)

/////////////////////// recording
(
ProtoDef(\trackrecorder, ProtoDef(\basicrecorder));
ProtoDef(\recrdn, ProtoDef(\rdn));
BufDef(\tmp4, s.sampleRate*4);

Pdef(\reckick, Pbind(
	\instrument, \snapkick,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
));

TrackDef(\recgrid, TrackDef(\playergrid));
)

(

TrackDef(\recgrid).source = [
	[
		Pdef(\reckick),
		Pdef(\recsnare),
		Pdef(\rechat),
	],
	[
		ProtoDef(\recrdn)
	],
	[
		ProtoDef(\trackrecorder)
	],
];
)
TrackDef(\recgrid).edit
WindowDef(\mixerView).front(TrackDef(\recgrid).childAt(0))
~mx = TrackDef(\recgrid).childAt(0).mixer;
~mx.asParam(\postfader)
~mx.asParam(\send0)
~mx.build_sender(0)

~mx.proxy.rebuild
~mx.proxy.sourcesp
~mx.proxy.objects
		(
		~mx.proxy.put(1100, \filter -> { arg in;
			var idx = 0;
			Out.ar(( \sendbus+++idx ).kr(0), in * \send0.kr(0));
			in;
		}, now:false);
		//});
		)
		~mx.proxy.isPlaying

		~mx.proxy.get(\sendbus0);
		~mx.proxy.get(\send0);

///////////////////// rdn debug


ProtoDef(\recrdn).edit;
ProtoDef(\rdn).edit;
WindowDef(\vertical_paramgroup)


///////////////////// trackdef debug

(
Pdef(\test, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);
TrackDef(\testgrid, TrackDef(\playergrid));
(

TrackDef(\testgrid).source = [
	[
		Pdef(\test),
	],
	[
		KitTimeline(\bb),
	],
];
)
TrackDef(\testgrid).edit
~trackMixerDef.new('testgrid.0').clear

/////////////////////// multiscore editor gui

TrackDef(\score, TrackDef(\playergrid));
(
~prefix = 'ex3score1.';
~kit = PatKitDef(\barlok1);
TrackDef(\score).source = [
	8.collect({ arg idx;
		idx.debug("idx");
		~prefix.debug("ezr");
		( ~prefix+++idx ).asCompileString.debug("kkk");
		idx.debug("iidx");
		KitTimeline( ~prefix+++idx , ~kit);
	}).debug("fl")
	,
];
)
TrackDef(\score).edit
TrackDef(\recgrid).edit
TrackDef(\score).clear
TrackDef(\score).startControl

///////////////////////////////// skank
(
SynthDef(\skank, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lpenv, lprqenv;
	sig = LFSaw.ar(freq);
	lpenv = EnvGen.kr(Env([1,50,1],[0.1,0.08]), gate);
	lprqenv = EnvGen.kr(Env([0.8,0.1,0.5],[0.01,0.08]), gate);

	sig = RLPF.ar(sig, \lpf.kr(100) * lpenv, \rq.kr(0.5) * lprqenv);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\skank, Pbind(
	\instrument, \skank,
	\degree, Pseq([0,0,-4,-3],inf).stutter(4) + [0,2,4],
	\isRest, Pseq([
		0,1,0,1, 0,1,0,1,
		0,1,0,1, 0,1,0,1,
		0,1,0,1, 0,1,0,1,
		0,1,0,1, 0,1,0,1,
	],inf).coin.not,
	\dur, 1/4,
	\sustain, 0.08,
	\att, 0.0,
	\amp, 0.1
)).play;
);

Pdef(\skank).stop



PlayerWrapper(Pdef(\test)).outBus = BusDef(\bla, \audio)
PlayerWrapper(KitTimeline(\bb)).outBus = BusDef(\bla, \audio)
PlayerWrapper(0).outBus = BusDef(\bla, \audio)

TrackDef(\score).children.collect({ arg x, idx; idx.debug("idx=========");x.children.collect({ arg y, idx2; y.proxy.wrapper.debug("pro", idx, idx2)  }) });


(
SynthDef(\skank, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(800), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\skank, Pbind(
	\instrument, \skank,
	\degree, Pseq([3,0],inf).stutter(16) + [0,2b,4],
	\scale, Scale.dorian,
	\lpf, Ndef(\lfolpf, { SinOsc.kr(1/2*~t).range(2340,231) }),
	\isRest, Pseq([
		0,0,1,0, 0,0,1,0,
		0,0,1,0, 0,0,1,0,
		0,0,1,0, 0,0,1,0,
		0,0,1,0, 0,0,1,0,

		0,0,1,0, 0,0,1,0,
		0,0,1,1, 0,0,1,0,
		0,1,1,0, 0,0,1,0,
		0,0,1,0, 0,0,1,0,

		0,1,1,1, 0,0,0,0,
		0,0,1,1, 0,0,0,1,
		0,1,1,1, 0,0,0,0,
		0,1,1,1, 0,0,1,1,
	],inf).coin.not,
	\dur, 1/4,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
	],inf),
	\sustain, Pseq([0.02,0.2,0.1,0.1, Prand([0.5,0.1,0.01,0.05],1)],inf),
	\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);

(
Pdef(\bass, Pbind(
	\instrument, \skank,
	\degree, Pseq([0,0,3,0],inf),
	\scale, Scale.dorian,
	\isRest, Pseq([
		1,0,1,1, 0,0,1,1,
		1,1,1,1, 1,0,1,1,
	],inf).coin.not,
	\lpf, Ndef(\bass_lfolpf, { SinOsc.kr(1/4*~t* SinOsc.kr(1/22).range(1/8,4)).range(8340,231) }),
	\octave, 3,
	\dur, 1/4,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
	],inf),
	\sustain, Pseq([0.02,0.2,0.1,0.1, Prand([0.5,0.1,0.01,0.05],1)],inf),
	//\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);

(
Pdef(\bass, Pbind(
	\instrument, \skank,
	\degree, Pseq([
		0,0,0,0, 0,0,0,0,
		2,0,2,0, 0,0,3,0,
	],inf),
	\scale, Scale.dorian,
	\isRest, Pseq([
		1,0,1,1, 1,1,1,1,
		1,0,1,0, 1,1,1,1,
	],inf).coin.not,
	\lpf, Ndef(\bass_lfolpf, { SinOsc.kr(1/8*~t* SinOsc.kr(1/22).range(1/8,4)).range(8340,7231)/4 }),
	\octave, 3,
	\dur, 1/4,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
	],inf),
	\legato, Pseq([
		2,1,1,1, 1,1,1,1,
		4,2,4,2, 1,1,1,1,
	]/3,inf),
	\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);

ProtoDef(\rdn).play




