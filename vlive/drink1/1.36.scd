

//~insert_beat_quant.(\modclap, 1/2);
//currentEnvironment[\mod+++~name] = Pbind(\isRest, Pseq([false],1), \legato, 1/2);
(

~my = Pbind(
	\latency, 0,
	\legato, 0.5,
	\isRest, Pseq([false],1),
) <> Pdef(~name).source;

~my.play;
);
Veco(~namex).response_mode = \exec;
