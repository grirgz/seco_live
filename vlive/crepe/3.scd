~name = '3';

Veco(~name).make_mixer;

BufDef.mono(\crepe, "field/crepe.flac");
Sdef(~name, \mypreset, \preset, \zegrainer2);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \zegrainer2,
	\degree, Pseq([0],inf),
	\mbufnum, BufDef.mono(\crepe),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
