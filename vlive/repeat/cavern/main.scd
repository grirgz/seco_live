
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("cavern/lib.scd"); };
)


/////////////////////////////////////////////////////////////////////////
// END

Ndef(\bla, { SinOsc.ar(ExpRand(100,4000))!2*0.1  })
Ndef(\bla).play
Ndef(\bla).spawn
Ndef(\bla).stop


s.boot
s.quit
TreeSnapshotViewo
TreeSnapshotView().front.autoUpdate();
Quarks.install("NodeSnapshot")
Quarks.install("https://github.com/scztt/IconSet.quark")
Main.version
Quarks.update

ProtoDef(\rdn4).edit
ProtoDef(\rdn3, \rdn)

ServerTreeGui.makeWindow(s)
Insp.insp


TagSpecDef
FileSystemProject.load("capsule/fxheavy.scd");

FileSystemProject(\simpleProject).mainTimeline
WindowDef(\Mai)
ParamProto.init(true)

SCVim.generateTagsFile
Help.gui
SCDoc.findHelpFile("Pdef")
SCDoc.findHelpFile("Param")
HelpBrowser.openHelpFor("Pdef")
SCDoc.indexAllDocuments(clearCache: false) // regenerate
SCDoc.indexAllDocuments(clearCache: true) // regenerate
Param
SCDoc.renderAll(true)
ParamViewToolBox

ExpandView
{arg base=400, amount=0.5; base * (SinOsc.kr(1) * amount + 1) }.plot(1);
{ SinOsc.ar(500) ! 2 * 0.1}.play;


Log(\Param).level = \error

///////////// auto generate a GUI for a synth controlled by keyboard
// 1) what system is used to listen to piano
//		- synth array with MIDIdef
//		- SeqPlayerGroup
// 2) need to put everything in busmode
// 3) need to reset the stream when changing the Pdef (or setting bus mode) ???
// 4) need to filter unwanted params

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\mysynth, 
	Pbind(
		\instrument, \saw,
		\lpfr, Pkeyd(\velocity, 1.1)
	)
);
);

ParamProto.init
~pgroup = ProtoTemplateDef(\SeqPlayerGroup).new(Pdef(\mysynth));

WindowDef(\PdefEditor).front(Pdef(\mysynth))

(
MIDIdef.noteOn(\piano, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).play;
});
MIDIdef.noteOff(\piano_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).stop;
});
)


	~pgroup.elAt(60).play((velocity:0.7));
	~pgroup.elAt(60).stop;

//////////

~p = Pdef(\mysynth).asStream;
~p = Pdef(\mysynth).asPattern.asStream;
Pdef(\mysynth).asPattern
Pdef(\mysynth).isKindOf(Pattern)
~p.next(())

(
Pdef(\mysynth, 
	Pbind(
		\instrument, \default,
	)
);
);




//////////////

// init quark prototypes, this is not class code. Needed for SeqPlayerGroup and PdefEditor
ParamProto.init; 

// define a pattern
(
Pdef(\mysynth, 
	Pbind(
		\instrument, \default,
	)
);
);

// edit it with the PdefEditor
WindowDef(\PdefEditor).front(Pdef(\mysynth))

// control it with MIDI
(
~pgroup = ProtoTemplateDef(\SeqPlayerGroup).new(Pdef(\mysynth));
MIDIdef.noteOn(\piano, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).play;
});
MIDIdef.noteOff(\piano_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).stop;
});
)

Bus.control

[1,1,1,1].plot

({ 1.0.rand }!4).plot

[0,3,1,2].plot




///////////

(
SynthDef(\tone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, atone=1, utone=1;
	var sig;
	sig = SinOsc.ar(freq * atone / utone);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
	~mintime = 0.05;
	~time = TempoClock.default.beats;
Tdef(\utone, {
	var pat = Prand((1..9),inf).asStream;
	loop {
		0.3.wait;
		if(TempoClock.default.beats - ~time < ~mintime) {
			~mintime.wait;
		};
		~synth.release;
		~utone = pat.next.debug("utone");
		~synth = Synth(\tone, [ \utone, ~utone, \atone, ~atone ]);
		~time = TempoClock.default.beats;
	}
	
}).play;
Tdef(\atone, {
	var pat = Prand((1..9),inf).asStream;
	loop {
		0.46.wait;
		if(TempoClock.default.beats - ~time < ~mintime) {
			~mintime.wait;
		};
		~synth.release;
		~atone = pat.next.debug("atone");
		~synth = Synth(\tone, [ \utone, ~utone, \atone, ~atone ]);
		~time = TempoClock.default.beats;
	}
	
}).play;
)

(
	~mintime = 0.05;
	~time = TempoClock.default.beats;
Tdef(\bla, {
	
	10.do {
		
		if(TempoClock.default.beats - ~time < ~mintime) {
			~mintime.wait;
		};
		~synth.release;
		~synth = Synth(\tone);
		~time = TempoClock.default.beats;
	}
}).play;
)




(
	~synthqueue = List.new;
Tdef(\utone, {
	var pat = Prand((1..9),inf).asStream;
	var oldsynth;
	loop {
		0.3.wait;
		if(~synthqueue.size > 0) {
			oldsynth = ~synthqueue.removeAt(0);
			{
				0.05.wait;
				oldsynth.debug("releasing synth");
				oldsynth.release;
			}.fork;
		};
		~utone = pat.next.debug("utone");
		~synthqueue.add(Synth(\tone, [ \utone, ~utone, \atone, ~atone ]));
	}
}).play;
Tdef(\atone, {
	var pat = Prand((1..9),inf).asStream;
	var oldsynth;
	loop {
		0.46.wait;
		if(~synthqueue.size > 0) {
			oldsynth = ~synthqueue.removeAt(0);
			{
				0.05.wait;
				oldsynth.release;
			}.fork;
		};
		~atone = pat.next.debug("atone");
		~synthqueue.add( Synth(\tone, [ \utone, ~utone, \atone, ~atone ]) );
	}
	
}).play;
)
~synthqueue.removeAt(0)
~synthqueue
{ 1.wait; "bla".postln; }.fork

(
Tdef(\utone, {
	var pat = Prand((1..9),inf).asStream;
	var oldsynth;
	loop {
		0.3.wait;
		oldsynth = ~synth;
		{
			0.05.wait;
			oldsynth.debug("releasing utone synth");
			oldsynth.release;
		}.fork;
		~utone = pat.next.debug("utone");
		~synth = Synth(\tone, [ \utone, ~utone, \atone, ~atone ]);
	}
}).play;
Tdef(\atone, {
	var pat = Prand((1..9),inf).asStream;
	var oldsynth;
	loop {
		0.46.wait;
		oldsynth = ~synth;
		{
			0.05.wait;
			oldsynth.debug("releasing atone synth");
			oldsynth.release;
		}.fork;
		~atone = pat.next.debug("atone");
		~synth = Synth(\tone, [ \utone, ~utone, \atone, ~atone ]);
	}
	
}).play;
)


(
Tdef(\utone, {
	var pat = Prand((1..9),inf).asStream;
	var oldsynth;
	loop {
		0.3.wait;
		oldsynth = ~synth;
		{
			0.05.wait;
			oldsynth.debug("releasing utone synth");
			oldsynth.release;
		}.fork;
		~utone = pat.next.debug("utone");
		~synth = (instrument: \tone, \utone: ~utone, \atone: ~atone, \sustain: inf).play;
	}
}).play;
Tdef(\atone, {
	var pat = Prand((1..9),inf).asStream;
	var oldsynth;
	loop {
		0.46.wait;
		oldsynth = ~synth;
		{
			0.05.wait;
			oldsynth.debug("releasing atone synth");
			oldsynth.release;
		}.fork;
		~atone = pat.next.debug("atone");
		~synth = (instrument: \tone, \utone: ~utone, \atone: ~atone, \sustain: inf).play;
	}
	
}).play;
)

~bla = (instrument: \tone, \sustain: inf).play
~bla.release


/////

(
	var base = 2.6;
	thisThread.randSeed = 1000000.rand.postln;
	f = { |out = 0|
		var sig = Pan2.ar(
			Pluck.ar(
				Mix.ar(
					SinOsc.ar(Array.geom(10,rand(140,200),10.1),[0.0,0.4])
				)*8,
				Impulse.kr(SinOsc.kr(LFNoise1.kr(0.5,500*Dust.kr(0.1,200,100),600*Impulse.kr),0,1.0,1.0)),
				Dust.kr(0.1,0.1,0.1)
			)
			*
			SinOsc.kr(
				Demand.kr(Impulse.kr(base / 0.116), 100, Dxrand(Array.geom(12, base / 4, 2), 8)),
				mul:0.1 * A2K.kr(GbmanL.ar(Array.geom(10,1/8,12).choose, 183.0.rand2, 3.0.rand2)), add:0.1
			),
			LFTri.kr(base / (0.5,10..24).choose, mul: 0.7.rrand(0.6), add: 0.3.rand)
		);
		Out.ar(out, sig );
	};
	g = { ReplaceOut.ar(0, Limiter.ar(CombC.ar(In.ar(0,2), 1.0.rrand(0.02,16.001),Pulse.kr(LFNoise1.kr(10.1),1,1),LFNoise0.kr(10.01)
))) }.play( addAction:\addToTail );
~synths = { f.play(args:[out:0]) } ! 4.rrand(118);
)
~synths.do(_.free);
(
Tdef(\go, {
	loop  {
		~synths = { f.play(args:[out:0]) } ! 4.rrand(118);
		60.wait;
		~synths.do(_.free);
	}
}).play
)
~bla = { f.play(args:[out:0]) } ! 1;
~bla.do(_.release)
~bla[1].release
~bla[0].release
~bla[0].stop
~bla[0].free
~bla[0].ends

NoteTimeline(\bla).edit
NoteTimeline(\bla).hash
NoteTimeline(\bla).identityHash
NoteTimeline.allChildren
NoteTimeline(\bla).play
NoteTimeline(\bla).stop
ProtoClassDef(\NoteTimeline).all[\bla].identityHash
ProtoClassDef(\NoteTimeline).new(\bla).identityHash
FileSystemProject.current.addResource(NoteTimeline(\bla))
FileSystemProject.current.removeResource(NoteTimeline(\bla))
FileSystemProject.current.resources.remove(NoteTimeline(\bla))
FileSystemProject.current.resources.collect(_.hash)
FileSystemProject.current.resources = nil
FileSystemProject.current.resources
FileSystemProject.defaultProject.resources
FileSystemProject("repeat/simpleProject").resources
IdentitySet
FileSystemProject.changed(\project)
~is = IdentitySet[1,4,2]
~is.add(4)
~is.add(NoteTimeline(\bla))
(
~is.collect { arg item, idx;
	item.postln;
};
)
~is.collect(_.hash)



////////

Ndef.ar(\fx, numChannels: 2);
Ndef(\fx).fadeTime = 2.0;
Ndef(\fx, { LPF.ar(LFNoise1.ar(100!2), 1000) }); // play stereo input with a low-pass filter
// The NDef is *not* yet audible!
Ndef(\fx).play; // start consuming resources
Ndef(\fx).pause

// redefine what \fx is doing
Ndef(\fx, { HPF.ar(SoundIn.ar([1, 0]), 500) });

// reset to silence
Ndef(\fx, nil); // silence, still consuming resources
Ndef(\fx).source = nil


Ndef(\fx2).prime({ LPF.ar(LFNoise1.ar(100!2), 1000) })
Ndef(\fx2)[10] = { SinOsc.ar(100)!2 * 0.1  }
Ndef(\fx2).prime[10] = { SinOsc.ar(100)!2 * 0.1  }
Ndef(\fx2).prime = { SinOsc.ar(100)!2 * 0.1  }
Ndef(\fx2).prime
Ndef(\fx2).sources[0].prime({ LPF.ar(LFNoise1.ar(100!2), 1000) })
Ndef(\fx3).sources[0] = { LPF.ar(LFNoise1.ar(100!2), 1000) }
Ndef(\fx2).play
Ndef(\fx2).stop
Ndef(\fx2).free
Ndef(\fx2).end
Ndef(\fx2).fadeTime = 1.0;

Ndef(\bla, { SinOsc.ar(100) * 0.1 ! 2  }).play
Ndef(\bla2, { SinOsc.ar(100) * 0.1 ! 5  }).play
Ndef(\bla2, { SinOsc.ar(100) * 0.1 ! 5  }).release.free
Ndef(\bla2, { SinOsc.ar(100) * 0.1 ! 5  }).free
Ndef(\bla2, { SinOsc.ar(100) * 0.1 ! 5  }).end(0.1)
WindowDef(\win).asCompileString
WindowDef(\win)
(
WindowDef(\win, { arg def;
	
	Button.new
}).front;
)


~notes = [1,2,3,4]
~notes = [1,2,3,4]+10
~dir = 1
~pa = Pwalk([Pfunc{~notes}], 1, 1).flatten
~pa = Pwalk([Pfunc{~notes}], 1, 1)
~pa = Pwalk([Pfunc{~notes}], 1, Pfunc{~dir})
~pa = Pwalk(Pfunc{~notes}, 1, Pfunc{~dir})
~pa.asStream.nextN(10,())
~pas = ~pa.asStream
~pas.next
~pa.asStream.next

~pa = Pwalk([Pseq([1,2]), Pseq([4,5])], 1, 1).flatten
~pa = Pwalk([Pseq([1,2]), Pseq([4,5]), Pseq([10,11])], 1, Pseq([1,-1,1],inf))

~pa = Pwalk([Pfunc{~notes}], 1, -1).flatten
Pindex
Plazy({  })
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
),
Prout({ arg ev;
	var idx = 0;
	100.do {
		ev = ~notes[idx].yield;
		idx = idx + ~dir;
	}
}),

(
~notes = [48, 50, 51, 53];
~dir = 1;
x = Pbind(
	\dur, 0.5, 
	\midinote, Prout({ arg ev;
		var idx = 0;
		inf.do {
			ev = ~notes[idx].yield;
			idx = idx + ~dir % ~notes.size;
		}
	})
).play
)
~dir = -1
~notes = [48, 50, 51, 53]+10;


~pairs = Prout({ arg ev; loop { ev = ( ev*100 ).yield } });
Pbind(\freq, ~pairs <> Pseq((1..10)) ).trace.play;
~pat.asStream.nextN(20,())

(
~pairs = {arg ratio;
    var difference = 40, result = [1, 1];
    [difference + (difference / (ratio-1)), difference / (ratio-1)];
};
)

~pairs = {arg ratio;
    var difference = 40, result = [1, 1];
    difference + (difference / (ratio-1))
};

(//works
Pbind(
    \freq, ~pairs.(61/38),
    \dur, 0.5
).trace.play;
)

(//doesn't work
Pbind(
    \freq, (~pairs.(
        Pseq([61/38, 23/22], inf).poll
    )
    ),
    \dur, 0.5
).trace.play;
)

Pbind(
    \freq, Ptuple(~pairs.(
        Pseq([61/38, 23/22], inf).poll
    )
    ),
    \dur, 0.5
).trace.play;

{Mix.ar(SinOsc.ar(Array.rand(100,30,20000),0.0,0.01)*0.5)!2}.play
{Mix.ar(SinOsc.ar(Array.rand(100,30.0,20000),0.0,0.01)*0.5)!2}.play
{Mix.ar(SinOsc.ar(Array.rand(100,30,10000)*2,0.0,0.01)*0.5)!2}.play
{Mix.ar(SinOsc.ar(Array.rand(100,30,20000),0.0,0.01)*0.5)!2}.play
{Mix.ar(SinOsc.ar([100,200],0.0,0.01)*0.5)!2}.play
{Mix.ar(SinOsc.ar([400,402],0.0,0.01)*0.5)!2}.play

Envoyer un message dans #ugens


/////////////


Ndef(\a, {|freq=300|    SinOsc.ar(freq * [1, 1.2]) * 0.1 });
Ndef(\a).play;

Ndef(\a).set(\gate, 0);
Ndef(\a).set(\gate, 1);

(
Ndef(\a)[1] = \pset -> Pbind(
    \dur, 1/2,
    \gate, Pseq([1,0],inf),  
	\freq, Pseq([300, 200, 500, 700], inf),
);
)


{ Amplitude.kr(SinOsc.ar(500) ! 2 * 2.1).softclip }.plot(1);
{ SinOsc.ar(500) ! 2 * 0.1 }.plot(1);

WindowDef(\PdefEditor).asCompileString



(
~buf = Buffer.alloc(s, 2048);
~plot = Signal.newClear(2048/2).plot;
//~plot.editMode = true; //Causes plot not to update until mouse lifted unlike e
~synth = {Osc.ar(~buf.bufnum, 110, mul: 0.1)}.scope;
~rout = {
 loop{
 ~buf.sendCollection(Signal.newFrom(~plot.value).asWavetable);
 0.1.wait; //change this to change the audio update frequency
 };
}.r.play;
)

~plot = Signal.sineFill(2048/2, [1])
~plot = Signal.sineFill(2048/2, [0,1])
~plot.plot
