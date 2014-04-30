~name = '7';
~tbits3 = ~name;

Veco(~name).make_mixer;
~newfxmix.(\fx);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, 
	~dPdef.(~name+++\mod) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

(
Ndef(~name+++\fx).put(0, {
	var in = InFeedback.ar(BusDef(~name+++\fx), 2);
	//in = in * LFSaw.ar(100);
	in;
});
);

Veco(~name).lib.macros = [ [Pdef(~name+++\mod), \ffreq, \freq.asSpec] ]

// END

Ndef(~name+++\fx).play
Ndef(~name+++\fx).clear
s.quit
