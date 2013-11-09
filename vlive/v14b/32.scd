~name = \32;

BufDef(\kick, "../hydrogenkits/Roland TR-808/808 Kick_short.flac");
//~mixfx.(~name, ~fx1);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler,
	\bufnum, BufDef(\kick).bufnum,
	\degree, Pseq([0],inf),
	//\out, BusDef(~name+++\fx),
	//\out, ~fx1,
	//\out, BusDef(~name+++\mixer),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
