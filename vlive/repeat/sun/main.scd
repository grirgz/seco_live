
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
