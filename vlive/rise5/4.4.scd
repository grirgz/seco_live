
(
~rests = Plazy({Pseq([
	0,0.9,0.9,0.9,
	0.5,0.9,0.9,0.9,
].collect(_.coin),1) }).loop;
Pdef(~tdrum1+++\mod, Pbind(
	\isRest, ~rests,
));
Pdef(~tdrum2+++\mod, Pbind(
	\isRest, Plazy({
		~rests
	}).loop,
	\isRest, ~rests,
));
Pdef(~tdrum3+++\mod, Pbind(
	\isRest, Plazy({
		~rests
	}).loop,
	\isRest, ~rests,
));
);
