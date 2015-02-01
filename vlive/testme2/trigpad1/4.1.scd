
[~name, ~namex, Veco.main.project_name].debug("yiiiiiiiiiiiiihhhhhhhhhhaaaaaaaaa");
Veco(~namex).response_mode = \exec;
Pdef(~name+++\mod, Pbind(
	\freq, Pseq((1..8)*10+50,inf),
));

Veco(~namex).response_off_hook = {
	Veco.do { arg name;
		Pdef(name+++\mod, Pbind())
	}
};
