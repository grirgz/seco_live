~name = '2';

Sdef(~name, \myaudio, \audio, 8);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \audiotrack,
	//\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	\bufnum, Sdef(~name.debug("bufnumname"), \myaudio).pbufnum,
	\dur, Sdef(~name, \myaudio).pdur,
	//\bufnum, Sdef(~name, \myaudio).bufnum,
	//\dur, Sdef(~name, \myaudio).dur,
	\legato, 1,
	//\sustain, 8 / Ptempo(),
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Pdef.defaultQuant = 2;
Sdef(~name, \myaudio, \audio, 8);
Sdef(~name, \myaudio);
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
