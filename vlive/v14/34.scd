~name = '34';

BufDef(\hihat, "../hydrogenkits/Roland TR-808/808 Hat_closed.flac");

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler,
	\bufnum, BufDef(\hihat),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Dialog.openPanel({ arg path; path.postln; },{ "cancelled".postln; });
BufDef(\snare, "../hydrogenkits/Roland TR-808/808 Snare_lo2.flac");
BufDef(\snare, "../hydrogenkits/Roland TR-808/808 Snare_lo3.flac");
