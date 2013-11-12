~name = 'z';

BufDef(\snare, "../hydrogenkits/Roland TR-808/808 Snare_lo1.flac");
//~mixfx.(~name, ~fx1);

Veco(~name).make_mixer;
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler,
	\bufnum, BufDef(\snare),
	\degree, Pseq([0],inf),
	//\out, BusDef(~name+++\mixer),
	//\out, BusDef(~name+++\fx),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Dialog.openPanel({ arg path; path.postln; },{ "cancelled".postln; });
BufDef(\snare, "../hydrogenkits/Roland TR-808/808 Snare_lo2.flac");
BufDef(\snare, "../hydrogenkits/Roland TR-808/808 Snare_lo3.flac");
