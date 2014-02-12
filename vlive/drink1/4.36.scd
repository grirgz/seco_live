

(

~my = Pbind(
	\latency, 0,
	\isRest, Pseq([false],1),
) <> Pdef('4').source;

~my.play;
);
Veco(~namex).response_mode = \exec;
