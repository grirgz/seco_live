
Veco(~namex).response_mode = \exec;
Pdef(~name+++\mod, Pbind(
	//\pos, 0.5,
	\range, 0.000001,
	//\bufnum, BufDef(\moeten),
));

Veco(~namex).response_off_hook = { arg self, name;
	name.debug("what");
	Pdef(name+++\mod, Pbind())
};
