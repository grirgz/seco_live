
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

// END


ParamProto.init
Document.current.path
(
[
"ddwCommon",
"wslib",
"crucial-library",
"Feedback",
"Modality-toolkit",
"Log",
"JITLibExtensions",
"WindowViewRecall",
"https://github.com/muellmusik/EQui",
].do { arg quark;
	Quarks.install(quark);
}
)


////////////////////////////////////////////////////////////////////

FileSystemProject.load("sndlib/synthbasic.scd")

 
NoteTimeline('simpleProject_mainTrackList.0.0score').eventList.select({ arg x; x.type != nil })
NoteTimeline('simpleProject_mainTrackList.4.0score').eventList.select({ arg x; x.type != nil })
NoteTimeline('simpleProject_mainTrackList.4.0score').eventList.setEndPosition(8)

TagSpecDef(\TrackList).list
TrackDef('simpleProject_mainTrackList').existingSections
TrackDef('simpleProject_mainTrackList').edit

TrackDef(\bla, \PlayerGrid).edit
TrackDef(\bla, \TrackList).edit

{ SinOsc.ar(500) ! 2 * 0.1}.play;

(
{
    var sig = LFNoise2.ar(1);
    sig = (sig.abs * 4).floor;
    sig.poll;
    Silent.ar;
}.play;
)

SelectX.ar
Scale.minor.degrees
(
{
    var sig = LFNoise2.ar(1);
	var freq;
	var pitches = [1,3,10,20] + 60;
    freq = Select.kr(sig.abs * pitches.size, pitches).midicps;
	sig = SinOsc.ar(freq) * 0.1;
    freq.poll;
	sig;
}.play;
)

(
Ndef(\quant,{
    //var sig = LFNoise2.ar(1);
	var sig = MouseX.kr(0,21);
	var freq;
	var pitches = [0,1,3,4,10,20];
	var quantized;

    quantized = IEnvGen.kr(Env.step(pitches, pitches.differentiate), sig);
	[sig, quantized].poll;
	freq = quantized.midiratio * 60.midicps;
	sig = SinOsc.ar(freq) * 0.1;
    //freq.poll;
	sig;
}).play;
)
~p = (0..12)
~p.pop
~p[1..]
Main.version

Durn

(
var multiChannelDswitch = { |triggers, reset, arrayOfItems, index|
    var demand = Dswitch1(arrayOfItems, index);
    triggers.collect{ |localTrig|
        Demand.ar(localTrig + reset, reset, demand)
    };
};

var arrayOfRatios = Tuning.new((0..12) * (3.ratiomidi / 13), 3.0, "Bohlen-Pierce").ratios;

{
    var numChannels = 8;
    var numSpeakers = 2;

    var reset, tFreq;
    var events, voices;
    var grainWindows, index, ratios, grainFreqs, grainPhases, grainOscs;
    var grains, sig, pan;

    RandSeed.kr(\seedtrg.kr(1), \seed.kr(1000));

    reset = Trig1.ar(\reset.tr(0), SampleDur.ir);
    tFreq = \tFreq.kr(10);

    events = SchedulerCycle.ar(tFreq, reset);

    voices = VoiceAllocator.ar(
        numChannels: numChannels,
        trig: events[\trigger],
        rate: events[\rate] / \overlap.kr(4),
        subSampleOffset: events[\subSampleOffset],
    );

    grainWindows = ExponentialWindow.ar(
        phase: voices[\phases],
        skew: \skew.kr(0.05),
        shape: \shape.kr(0)
    );

    index = Durn(\chance.kr(0.5), \size.kr(8), inf);
    ratios = multiChannelDswitch.(
        voices[\triggers],
        reset,
        arrayOfRatios,
        index
    );

    grainFreqs = \freqA.kr(440) * ratios;

    grainPhases = RampIntegrator.ar(
        trig: voices[\triggers],
        rate: grainFreqs,
        subSampleOffset: events[\subSampleOffset]
    );
    grainOscs = SinOsc.ar(DC.ar(0), grainPhases * 2pi);

    grains = grainOscs * grainWindows;

    pan = UnitWalk.ar(voices[\phases]);
    grains = PanAz.ar(
        numChans: numSpeakers,
        in: grains,
        pos: pan.linlin(0, 1, -1 / numSpeakers, (2 * numSpeakers - 3) / numSpeakers);
    );
    sig = grains.sum;

    sig = LeakDC.ar(sig);
    sig * 0.1;
}.play;
)


PdefGu
g = PdefGui();            // make a PdefGui
g.object = Pdef(\a);        // show when a Pdef is put in
Pdef(\a, Pbind(\note, 12));     // show whether it has a source
Pdef(\a).play;             // show whether playing, stopped, or ended, and pausable
Pdef(\a).set(\dur, 0.25);     // show whether the Pdef has an envir
g.close;

g = PdefGui(Pdef(\a), 3);    // with an envirgui for 3 items
Pdef(\a).set(\lofreq, [1, 10], \str, "someString", \oops, \oneSymbolTooMany);
Pdef(\a).clear;
Pdef(\a).envir.clear;
g.close;

(                // put it in an existing window - margin is 0@0
w = Window("my win", Rect(200, 200, 300, 200)).front;
w.addFlowLayout;
PdefGui(Pdef(\a), 0, w);
PdefGui(Pdef(\a), 3, w);
)


Pdef(\a, Pbind(\freq, Prand((1..16) * 55, inf)));
Pdef(\a).play;
Pdef(\a).edit
t = PdefGui(Pdef(\a), 4);
Pdef(\a).set(\dur, 0.125, \amp, 0.05);

Pdef(\a).stop;
Pdef(\a).play;
Pdef(\a).pause;
Pdef(\a).resume;

t.object_(nil);
t.object_(Pdef(\a));

(
w = Window("put it in a selfmade window").front;
w.addFlowLayout;
w.view.decorator.shift(50, 50);
PdefGui(Pdef(\a), 12, w);
)

Pdef(\b, Pbind(\note, Pxrand((0..7), inf), \dur, 0.125));
Pdef(\b).play;
PdefGui(Pdef(\b));

    // see all Pdefs:
PdefAllGui(16);

Pdef(\a).asParamGroup.edit
param.asMultiSlider

Pfin

~s = Pfin(1,Pseq((0..10)))
~s = Pfin(Pfunc({ 2 }),Pseq((0..10)))
~s = Pfin({ 2 },Pseq((0..10)))
~s = Pseq([Pfin(Pfunc({ 2 }),Pseq((0..10))), 1000]);
~s.asStream.nextN(10)


/////////////



Ndef(\xxx, { arg amp=1; SinOsc.ar(100 * amp.poll)*0.1!2;  }).play

(
SynthDef(\xzed, { arg out=0, gate=1, amp, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	amp.poll;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Ndef(\aze).source = \xzed
Ndef(\aze).play


(
Ndef(\zed, { arg out=0,freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(2, sig);
	Out.ar(out, sig);
}).play;
);


(
Ndef(\bass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp.poll(100));
}).play;
);

Ndef(\bass).set(\amp, 0.1);
(
s.bind {
	var env = Ndef(\env, { Line.kr(0.1, 0.0, 1)  });
	s.sync;
	Ndef(\bass).set(\amp, env);
}
)

Ndef(\env).fadeTime
Ndef(\env).fadeTime = 0
(
s.bind {
	Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0, 1)  }).asMap);
}
)
(
s.bind {
	Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0.01, 1)  }).asMap);
}
)

(
s.bind {
	Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0.2, 1)  }).asMap);
}
)
Ndef(\bass).set(\amp, 0.1);
Ndef(\bass).set(\amp, 0.3);
Ndef(\bass).quant = 1
Ndef(\env).quant = 1;

	Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0.2, 1)  }).asMap);
	Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0.2, 1)  }));
	Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0.1, 1)  }));


(
	TempoClock.default.schedAbs(TempoClock.default.nextTimeOnGrid(1), {
		Ndef(\bass).set(\amp, Ndef(\env, { Line.kr(0.1, 0.2, 1)  }));
	})

)

Ndef(\env, { Line.kr(0.1, 0, 1)  }).getBundle
MixedBundle
(

s.bind {
	a = Ndef(\env, { Line.kr(0.1, 0.01, 1)  }).getBundle;
	a.send(s);
	Ndef(\bass).set(\amp, Ndef(\env));
}
)

//I can't get the code to work when I use busses via variables

~verbL = Bus.audio;
~verbR = Bus.audio;

(
SynthDef(\sinesine, {
    arg bus, freq = 440, dur = 1, level = 0.2;
    Out.ar(bus, SinOsc.ar(freq, 0, EnvGen.kr(Env.sine(dur, level), doneAction: 2)))}).add;
)

(
Tdef(\sinesinetdef, {
    var freq = PdegreeToKey(Pbrown.new(-2, 12, 1, inf), Scale.major, 12).asStream;
    loop{
        var dur = exprand(0.1, 1);
        var bus = [~verbL, ~verbR].choose;
        Synth(\sinesine, [dur: dur, bus: bus, freq: (freq.next + 60).midicps]);
        dur.wait;
    }
}).play;
);

{FreeVerb.ar(In.ar(~verbL), 1, 5)}.play;
{Out.ar(1, FreeVerb.ar(In.ar(~verbR), 1, 5))}.play

//However when I specify the bus by index it works fine.

(
Tdef(\sinesinetdef, {
    var freq = PdegreeToKey(Pbrown.new(-2, 12, 1, inf), Scale.major, 12).asStream;
    loop{
        var dur = exprand(0.1, 1);
        var bus = {[8, 9].choose};
        Synth(\sinesine, [dur: dur, bus: bus, freq: (freq.next + 60).midicps]);
        dur.wait;
    }
}).play;
);

{FreeVerb.ar(In.ar(8), 1, 5)}.play;
{Out.ar(1, FreeVerb.ar(In.ar(9), 1, 5))}.play


(
{
    var freq = PdegreeToKey(Pbrown(0, 7, 1, inf), Scale.major, 12).asStream; 
	var sig = 5.collect {
		SinOsc.ar((freq.next + 60).midicps, 0, EnvGen.kr(Env.perc, Impulse.kr(1)));
	};
	Splay.ar(sig, 0.8, 0.1, 0);
}.play;
)


(
~rhythmRoutine = Prout({
    var a = [
    Pseq([0.5, 0.5], 1),
    Pseq([0.25, 0.25, 0.5], 1),
    Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5], 1),
    Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25], 1),
    Pseq([0.5, 0.25, 0.25], 1)
    ].choose.asStream;
    a.do{
        arg item;
        item.postln;
        item.wait;
    }
});


(
Routine({
    loop{
        ~rhythmRoutine.embedInStream;
        1.wait;
    }
}).play;
)
)

(
~rhythmRoutine = Routine({
    var a = [
    Pseq([0.5, 0.5], 1),
    Pseq([0.25, 0.25, 0.5], 1),
    Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5], 1),
    Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25], 1),
    Pseq([0.5, 0.25, 0.25], 1)
    ].choose.asStream;
    a.do{
        arg item;
        item.postln;
        item.wait;
    }
});
)


(
Routine({
    loop{
        ~rhythmRoutine.reset.embedInStream;
        1.wait;
    }
}).play;
)


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pitch_sets= [
        Drand([18, 18, 18, 18, 18, 18, 18, 18, 24, 24], inf),
        Drand([12, 12, 12, 12, 12, 12, 18, 18, 18, 24], inf),
        Drand([ 18, 18, 12, 12, 12, 12, 12, 6, 6, 6], inf)
    ];
	freq = Demand.ar(Impulse.ar(1), 0, pitch_sets.at(0));
	sig = SinOsc.ar(( freq+50 ).midicps.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Synth(\zed)


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pitch_sets= [
        Drand([20,19], inf),
        Drand([10,9], inf),
        Drand([ 18, 18, 12, 12, 12, 12, 12, 6, 6, 6], inf)
    ];
	freq = Demand.ar(Impulse.ar(1), 0, Dswitch1(pitch_sets, \idx.kr(0)));
	sig = SinOsc.ar(( freq+50 ).midicps);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

~a = Synth(\zed)
~a.set(\idx, 1)

thisThread.randSeed = 1
thisThread.randSeed
thisThread.randData
