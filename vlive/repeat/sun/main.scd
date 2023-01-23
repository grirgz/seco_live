
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

// END


(..40)


(
Tdef(\bla, {
	SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(rrand(100,1000));
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	s.sync;
	Synth(\zed)
});
)

Tdef(\bla).play
Tdef(\bla).isPlaying

Quarks.install("https://github.com/madskjeldgaard/PolyBuf.git")


SampleTimeline(\bla).edit
{ SinOsc.ar(500) ! 2 * 0.1}.play;

b = BufFiles(s, "/tmp/sn/")

PathName("/tmp/sn").entries
PathName("/tmp/sn").entries[0].isFolder
PathName("/tmp/sn").entries[0].isFile
PathName("/tmp/sn").entries[0].pathMatch
String

(
SynthDef(\trig2, {
    arg in=0, out=0;
    var mic, amp, trig, timer, filteredTrig, tog;
    
    mic = SoundIn.ar(in);
	//mic.poll;
    trig = DetectSilence.ar(mic, 0.05, time:1);
	//trig.poll;
    filteredTrig = Changed.ar(trig);
	//filteredTrig.lagud(0,1).poll;
    SendTrig.ar(filteredTrig, 0, trig);
    //Out.ar(out, mic);
}).add;
Pdef(\part).reset;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\trig2,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
o = OSCFunc({ arg msg, time;
	[time, msg].postln;
},'/tr', s.addr);
)


r = Routine({ "bla".yield }); 
r.next
