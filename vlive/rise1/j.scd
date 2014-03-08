~name = 'j';

BufDef(\ukraine, "bruit1/07_ukraine.flac");
Veco(~name).make_mixer;

Sdef(~name, \mypreset, \preset, \stereosampler_stutter);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
if(Pdef(~name +++ \mod).source.isNil) { Pdef(~name +++ \mod, Pbind()) };
Pdef(~name, 
	~patfx.(~name+++\patfx) <>
	Pdef(~name+++\mod) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler_stutter,
	\degree, Pseq([0],inf),
	//\buf, BufDef(\ukraine),
	\bufnum, BufDef(\ukraine),
	\pos, 0.2,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 1.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

