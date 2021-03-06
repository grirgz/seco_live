~name = '39';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
Veco(~name).make_mixer;
//Veco(~name)[\master_bus] = BusDef(~masterfx+++\fx, \audio);

Sdef(~name, \mypreset, \preset, \zegrainer2);

Pdef(~name+++\mod).quant = 0;
Pdef(~name+++\pre).fadeTime = 4;
Pdef(~name+++\mod).fadeTime = 4;

(
Veco(~name).lib.macros = [
	[ Sdef(~name, \mypreset), \pitch_stretch ],
	[ Sdef(~name, \mypreset), \pos ],
];
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
if(Pdef(~name +++ \mod).source.isNil) { Pdef(~name +++ \mod, Pbind()) };
Pdef(~name, 
	~patfx.(~name+++\patfx) <>
	Pdef(~name+++\mod) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, \zegrainer2,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\degree, Pseq([0],inf),
	\mbufnum, BufDef.mono(\ukraine),
	\pos, 0.2,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 1.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);
