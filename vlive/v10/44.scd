~name = '44';

Sdef(~name, \myaudio, \audio, 8);

~newfx.(\fx);

Ndef(~name+++\fx, {
	var in;
	var sig;
	var spread = 0.8, amp=1, pan=0;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = RLPF.ar(in, SinOsc.ar([64,64.1,64.11]).range(100,19000));
	sig = FreqShift.ar(in, SinOsc.ar([0.4,0.41,0.42]).range(100,-100));
	sig = DelayC.ar(in, 0.1,[0.1,0.11,0.12]);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \audiotrack_expander2,
	\fadeout, 0.05,
	\fadein, 0.05,
	//\out, BusDef(~name+++\fx),
	//\lag, -0.01,
	//\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	//\bufnum, Pfunc {  Sdef(~name, \myaudio).bufnum },
	//\dur, Pfunc { inEnvir(Sdef(~name, \myaudio)).dur },
	//\bufnum, Pfunc { {Sdef(~name, \myaudio).bufnum}.inEnvir.value },
	//\bufnum, Sdef(~name.debug("bufnumname"), \myaudio).pbufnum,
	//\dur, Sdef(~name, \myaudio).pdur,
	\bufnum, Sdef(~name.debug("bufnumname"), \myaudio).get(0).pbufnum,
	\dur, Sdef(~name, \myaudio).get(0).pdur,
	//\dur, 2,
	//\bufnum, Sdef(~name, \myaudio).bufnum,
	//\dur, Sdef(~name, \myaudio).dur,
	//\sustain, Sdef(~name, \myaudio).get(0).psustain + 0.2,
	//\sustain, Sdef(~name, \myaudio).get(0).psustain + 0.0,
	\sustain, 8,
	//\sustain, 4.4,
	//\sustain, 8 / Ptempo(),
	\amp, 0.2 * Pkey(\amp),
).trace <> Veco(~name).mixer)
);

// END

Pdef.defaultQuant = 2;
Sdef(~name, \myaudio, \audio, 8);
Sdef(~name, \myaudio).get(0).dur;
Sdef(~name, \myaudio).record;
"~/seco/seco/synth.scd".standardizePath.load
~index = 1;
~score_storage.all[\1][\myaudio].at_current_clip
~score_storage.all[\1][\myaudio].get(0)
~score_storage.all[\1][\myaudio].all.do { arg x; x.postln; "".postln; }
~score_storage.all[\1][\myaudio].all.put(0, ~a)
~score_storage.all[\1][\myaudio].all.at(0).bufnum
~score_storage.all[\1][\myaudio].get(1)
~a = ~score_storage.all[\1][\myaudio].score_class.new
~index


(


		Pbind(
			\instrument, \audiotrack,
			\sustain, 8,
			\dur, 8,
			\bufnum, Sdef(~name, \myaudio).bufnum,
		).play(quant:Pdef.defaultQuant);
)


~buf = Buffer.alloc(s, s.sampleRate * 1, 2);


{ RecordBuf.ar(SoundIn.ar([0,1]), ~buf, 1, loop:0, doneAction:2) }.play

{ PlayBuf.ar(2, ~buf, 1, doneAction:2) }.play

(
// allocate a Buffer
b = Buffer.alloc(s, 44100 * 1.2, 2); // a four second 1 channel Buffer
)
b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

// record for four seconds
(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0, gate=1;
	var formant;
	//formant = SoundIn.ar(0);
	formant = SinOsc.ar(100);
	//formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125) ! 2;
	RecordBuf.ar(formant, bufnum, doneAction: 2, loop: 0);
	EnvGen.ar(Env.asr, gate)
}).play(s,[\out, 0, \bufnum, b]);
)

(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0, gate=1;
	var formant;
	//formant = SoundIn.ar(0);
	formant = SinOsc.ar(100) ! 2;
	//formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125) ! 2;
	EnvGen.ar(Env.asr, gate, doneAction:2);
	RecordBuf.ar(formant, bufnum, doneAction: 2, loop: 0);
}).add;
)


SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction:2)
	)
}).play(s, [\out, 0, \bufnum, b]);

SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	Out.ar(out,
		PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), doneAction:2)
	)
}).add;

b.write("plop.wav", "wav")
b = Buffer.read(s, "plop.wav")

(
Pbind(
	\instrument, \help_RecordBuf,
	\bufnum, b,
	\dur, Pn(1.2,1),
	\amp, 0.1
).play;
)
(
Pbind(
	\instrument, \help_PlayBuf,
	\delay, 0,
	\fadein, 0,
	\fadeout, 0,
	\pos, 0,
	\sustain, 1,
	\bufnum, b,
	\dur, 1,
	\amp, 0.1
).play;
)
(
Pbind(
	\instrument, \audiotrack_expander2,
	//\delay, 0,
	\fadein, 0.05,
	\fadeout, 0.05,
	\pos, 0,
	\sustain, 8,
	//\bufnum, b,
	\bufnum, 26,
	\dur, 8,
	\amp, 0.1
).play;
)

(
Pbind(
	\instrument, \audiotrack_expander2,
	//\delay, 0,
	\fadein, 0.05,
	\fadeout, 0.05,
	\pos, 0,
	\sustain, 1,
	\bufnum, b,
	//\bufnum, 26,
	\dur, 1,
	\amp, 0.1
).play;
)
