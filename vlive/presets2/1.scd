~name = 'presets2-1';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
Veco(~name).make_mixer;

Sdef(~name, \mypreset, \preset, \zegrainer2);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, 
	
	~patfx.(~name+++\patfx) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, \zegrainer2,
	\degree, Pseq([0],inf),
	\mbufnum, BufDef.mono(\ukraine),
	\pos, 0.2,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 1.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);
