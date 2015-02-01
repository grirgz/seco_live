
Veco(~namex).response_mode = \exec;
Pdef(~name+++\mod, Pbind(
	\freq, Pseq([70,80],inf),
	\isRest, false,
));

Veco(~namex).response_off_hook = { arg self, name;
	Pdef(name+++\mod, Pbind())
};
