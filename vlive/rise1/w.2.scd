//BufDef(\moeten, "voices/")
BufDef(\moeten, "voices/02_moeten.flac");
Pdef(~name +++ \pre, Pbind(
	\instrument, \stereosampler,
	\bufnum, BufDef(\moeten),
	\dur, 1,
	\freq, 100,
));
