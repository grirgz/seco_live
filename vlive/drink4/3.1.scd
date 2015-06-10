
Veco(~namex).response_mode = \exec;

(

	(
	'instrument': 'drink4-3c',
	'levelScale': 0.900000,
	'degree': 5,
	'dur': 0.150000,
	'lpfenv2': [ Env([ 1, 0.4 ], [ 0.01 ]) ],
	'amp': 0.007684,
	'lpfenv1': [ Env([ 1, 0.1 ], [ 0.06 ], -5) ],
	//'out': Bus('audio', 344, 2, s),
	'lpfenv3': [ Env([ 1, 0.1 ], [ 0.01 ]) ],
	'sig1rel': 0.120000,
	'freq': 100,
	'sig2rel': 0.100000,
	'latency': Ref(nil),
	).play;
)


// END

Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\c,
	\lpfenv1, Pseq([
		[ Env([1,0.1],[0.16], -5) ],
	],inf),
	\lpfenv2, Pseq([
		[ Env([1,0.4],[0.01]) ],
	],inf),
	\lpfenv3, Pseq([
		[ Env([1,0.7],[0.01]) ],
	],inf),
	\levelScale, 0.5,
	//\sig2rel, Pseq([
	//	0.1,0.07, 0.2,0.1
	//],inf).stutter(1),
	\sig1rel, 0.22,
	\sig2rel, 0.2,
	\freq, 100,
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,1,0,0, 1,0,0,0,
	],inf).coin.not,
));


Pdef(~name).asStream.next(Event.default).keysValuesDo({ arg k,v; "%: %,".format(k.asCompileString, v.asCompileString).postln })

Pdef(~name).clear
