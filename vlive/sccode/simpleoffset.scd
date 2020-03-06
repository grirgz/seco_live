(
SynthDef.new(
	\synth_simpleSine,
	{
		arg freq=220, rate=0.1, pan=0.0, amp=1.0, dur=1.0, lfor1=0.08, lfor2=0.05, nl=0.5, filt=5000;
		var sig, sub, lfo1, lfo2, env, noise;

		lfo1  = SinOsc.kr(lfor1, 0.5, 1, 0);
		lfo2  = SinOsc.kr(lfor2, 0, 1, 0);
		sig   = SinOscFB.ar(freq, lfo1, 1, 0);
		sub   = SinOscFB.ar(freq*0.25, lfo2, 1, 0);
		env   = Line.kr(1, 0, dur*4.0, doneAction: Done.freeSelf);
		noise = PinkNoise.ar(nl, 0);
		sig   = (sig + sub + noise) * env;
	  //sig   = BLowPass4.ar(sig, filt);
		sig   = MoogFF.ar(sig, filt * 0.5, 0, 0, 1, 0);
		sig   = Pan2.ar(sig, pan, amp);
	    sig   = FreeVerb2.ar(sig[0], sig[1], 0.5, 0.99, 0.9);
		Out.ar(0, sig * 0.6);
	}
).add;
"Synth Added!".postln;
)

(
Pdef (
	\seq1,
	Pbind(
		\instrument, \synth_simpleSine,
		\dur     , 4.0,
		\amp     , Pwhite(0.7, 0.8, inf),
		\midinote, Pseq([60, 62, 64, 67, 60, 62, 64, 71, 72], inf),
		\harmonic, Pseq([1, 2, 4], inf),
		\pan     , Pwhite(-1.0, 1.0, inf),
		\lfor1   , Pwhite(0.001, 5.5, inf),
		\lfor2   , Pwhite(0.001, 0.1, inf),
		\nl      , Pwhite(0.3, 0.9, inf),
		\filt    , Pwhite(250, 1000, inf),
	);
).play;
"Sequence 1 Started".postln;

Pdef (
	\seq2,
	Pbind(
		\instrument, \synth_simpleSine,
		\dur     , 0.8,
		\amp     , Pwhite(0.01, 0.4, inf),
		\midinote, (Pseq([60, 62, 64, 67, 60, 62, 64, 71, 74], inf)+24),
		\harmonic, Pseq([1, 2, 4], inf),
		\pan     , Pwhite(-1.0, 1.0, inf),
		\lfor1   , Pwhite(0.001, 10.1, inf),
		\lfor2   , Pwhite(0.001, 0.1, inf),
		\nl      , Pwhite(0.8, 1.0, inf),
		\filt    , Pwhite(500, 2500, inf),
	);
).play;
"Sequence 2 Started".postln;

Pdef (
	\seq3,
	Pbind(
		\instrument, \synth_simpleSine,
		\dur     , 8.0,
		\amp     , Pwhite(0.01, 0.4, inf),
		\midinote, (Pxrand([60, 62, 64, 67, 60, 62, 64, 71, 74], inf)),
		\harmonic, Pseq([1, 2, 2], inf),
		\pan     , Pxrand([-1.0, 1.0], inf),
		\lfor1   , Pwhite(0.001, 0.1, inf),
		\lfor2   , Pwhite(0.001, 0.2, inf),
		\nl      , Pwhite(0.8, 1.0, inf),
		\filt    , Pwhite(500, 2500, inf),
	);
).play;
"Sequence 3 Started".postln;
)

////////////////


(
SynthDef.new(
	\synth_simpleSine,
	{
		arg freq=220, rate=0.1, pan=0.0, amp=1.0, dur=1.0, lfor1=0.08, lfor2=0.05, nl=0.5, filt=5000, gate=1;
		var sig, sub, lfo1, lfo2, env, noise;

		lfo1  = SinOsc.kr(lfor1, 0.5, 1, 0);
		lfo2  = SinOsc.kr(lfor2, 0, 1, 0);
		sig   = SinOscFB.ar(freq, lfo1, 1, 0);
		sub   = SinOscFB.ar(freq*0.25, lfo2, 1, 0);
		//env   = Line.kr(1, 0, dur*4.0, doneAction: Done.freeSelf);
		env = EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)), gate, doneAction:2);
		noise = PinkNoise.ar(nl, 0);
		sig   = (sig + sub + noise);
	  //sig   = BLowPass4.ar(sig, filt);
		sig   = MoogFF.ar(sig, filt * 0.5, 0, 0, 1, 0);
		sig   = Pan2.ar(sig, pan, amp);
	    sig   = FreeVerb2.ar(sig[0], sig[1], 0.5, 0.99, 0.9);
		sig = sig * env;
		Out.ar(0, sig * 0.6);
	}
).add;
"Synth Added!".postln;
)

ProtoDef(\piano).startControl(Pdef(\piapi))



Pdef (
	\piapi,
	Pbind(
		\instrument, \synth_simpleSine,
		\dur     , 4.0,
		\amp     , Pwhite(0.7, 0.8, inf),
		//\midinote, Pseq([60, 62, 64, 67, 60, 62, 64, 71, 72], inf),
		\harmonic, Pseq([1, 2, 4], inf),
		\pan     , Pwhite(-1.0, 1.0, inf),
		\lfor1   , Pwhite(0.001, 5.5, inf),
		\lfor2   , Pwhite(0.001, 0.1, inf),
		\nl      , Pwhite(0.3, 0.9, inf),
		\filt    , Pwhite(250, 1000, inf),
	);
).play;


//////////////////////////////

(
SynthDef.new(
	\synth_simpleSine_dry,
	{
		arg freq=220, rate=0.1, pan=0.0, amp=1.0, dur=1.0, lfor1=0.08, lfor2=0.05, nl=0.5, filt=5000, gate=1;
		var sig, sub, lfo1, lfo2, env, noise;

		lfo1  = SinOsc.kr(lfor1, 0.5, 1, 0);
		lfo2  = SinOsc.kr(lfor2, 0, 1, 0);
		sig   = SinOscFB.ar(freq, lfo1, 1, 0);
		sub   = SinOscFB.ar(freq*0.25, lfo2, 1, 0);
		//env   = Line.kr(1, 0, dur*4.0, doneAction: Done.freeSelf);
		env = EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)), gate, doneAction:2);
		noise = PinkNoise.ar(nl, 0);
		sig   = (sig + sub + noise);
	  //sig   = BLowPass4.ar(sig, filt);
		sig   = MoogFF.ar(sig, filt * 0.5, 0, 0, 1, 0);
		sig   = Pan2.ar(sig, pan, amp);
	    //sig   = FreeVerb2.ar(sig[0], sig[1], 0.5, 0.99, 0.9);
		sig = sig * env;
		Out.ar(\out.kr(0), sig * 0.6);
	}
).add;
"Synth Added!".postln;
)

(
Pdef(\partfx, Pdef(\fxx, 
	Ppar([
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\rev1, \audio),
			\verbmix, 0.4,
			\room, 0.9,
			\damp, 0.9,
			\mix, 1,
			\gain, 1,
			\dur, 2,
		),
		
	])
)).play;
);

Pdef (
	\piapi,
	Pbind(
		\instrument, \synth_simpleSine_dry,
		\out, BusDef(\rev1, \audio),
		\dur     , 4.0,
		\amp     , Pwhite(0.7, 0.8, inf),
		//\midinote, Pseq([60, 62, 64, 67, 60, 62, 64, 71, 72], inf),
		\harmonic, Pseq([1, 2, 4], inf),
		\pan     , Pwhite(-1.0, 1.0, inf),
		\lfor1   , Pwhite(0.001, 5.5, inf),
		\lfor2   , Pwhite(0.001, 0.1, inf),
		\nl      , Pwhite(0.3, 0.9, inf),
		\filt    , Pexprand(250, 1000*15, inf),
	);
);

NoteTimeline(\piapi, Pdef(\piapi)).edit
