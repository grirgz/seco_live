~name = '42';

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
	\instrument, \audiotrack_expander,
	\fadeout, 0.01,
	\fadein, 0.01,
	\out, BusDef(~name+++\fx),
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
	\sustain, Sdef(~name, \myaudio).get(0).psustain + 0.0,
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
