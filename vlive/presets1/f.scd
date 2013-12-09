~name = 'f';


BufDef.mono(\moeten, "voices/02_moeten.flac");
BufDef.mono(\woodshop, "vipere/woodshop.flac");

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \zegrainer2,
	\mbufnum, BufDef.mono(\moeten),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
	) <> Veco(~name).mixer)
);
