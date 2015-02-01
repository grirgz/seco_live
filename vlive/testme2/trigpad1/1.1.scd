
Veco(~namex).response_mode = \exec;
Pdef(~name+++\mod, Pbind(
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0005, 0.16, 1.1], [-4, -2, -4]) ],
));

Veco.do { arg name;
	Veco(~namex).response_off_hook = {
			Pdef(name+++\mod, Pbind())
	};
}
