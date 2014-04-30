
Pdef(~tdrum1+++\mod, Pbind(
	\isRest, Plazy({
		Pseq([0.2,0.5,0.3,0.4].collect(_.coin),1)
	}).loop,
));
Pdef(~tdrum2+++\mod, Pbind(
	\isRest, Plazy({
		Pseq([0.2,0.5,0.3,0.4].collect(_.coin),1)
	}).loop,
));
Pdef(~tdrum3+++\mod, Pbind(
	\isRest, Plazy({
		Pseq([1,0].collect(_.coin),1)
	}).loop,
));
