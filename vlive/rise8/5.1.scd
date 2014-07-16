
~event1 = ( 
	'freqC': 41.62291273107, 
	'amp': 1.0, 
	'gate': 1.0, 
	'pan': 0.035294117647059,   
	'ampB': 0.56024850365639, 
	'ampC': 0.74663926073474, 
	'freqB': 55.470564558996, 
	'spread': 0.42352941176471,   
	'freq': 62.394691638252, 
	'adsr': [ Env([ 0.0, 1.0, 0.80000001192093, 0.0  ], [ 0.0031425622071483, 8.0, 0.045371512863826  ], -4.0, 2)  ] 
);

(

~event2 = Pbind(*[ 
	'gate': 1.0, 
	'pan': 0.035294117647059,   
	'ampB': 0.26024850365639, 
	'ampC': 4.94663926073474, 
	'freqB': 95.470564558996, 
	'spread': 0.42352941176471,   
	//'freq': 22.394691638252, 
	\degree, 0,
	'freqC': Pkey(\freq) * 41.62291273107/62, 
]);

Pdef(~name +++ \pre, 
	Pbind(
		\dur, 1,
		\amp, Pkey(\amp) * 4,
		\degree, Pseq([
			Pseq([0,4,2,7],4).stutter(2),
			Pseq([0,4,2,6],4).stutter(2),
		],inf),
		\degree, 0,
		\detune, Pseq([
			0,0,0,0,
			0,0,0,Pwhite(0.0,10),
			0,0,0,0,
			0,0,0,Pwhite(0.0,4),
			0,0,0,0,
			0,0,0,Pwhite(0.0,2),
		],inf).stutter(2),
		\octave, 4,
		\legato, Pseq([0.71,0.2,0.4,0.2],inf),
		\legato, 1,
		\freqB, Pkey(\freq) * 2/6 * 8,
		\freqC, Pkey(\freq) * 5/6 * 8,
		\ampB, Pseq([1,0.7],inf),
		\ampC, Pseq([
			2,0.2,0.2, 2,
			0.2,0.2, 0.4,1,
			0.8,
		],inf) * 10,

	) 
);

)

// END

	Pseq([ ~event2 ],inf) <>
	~dPdef.(\mod) <>
	Pbind(
	
	\freqB, 40,
	\freqC, 400,
	\degree, Pseq([0],inf).stutter(8),
	\freq, 70,
	\octave, 2,
	\ampC, 1,
	\ampB, 5,
	\dur, 1/8,
	\legato, 0.71,

	) <>
	Pbind(
		//\freq, Pseq([10])400,
		\degree, Pseq([0],inf).stutter(8),
		\freqC, ~envNdefq.(~name+++\env1, Env([100,2000,500],[1,4])),
		\freqC, Pkey(\freq),
		\freqB, ~envNdefq.(~name+++\env2, Env([1000,200,500],[3,4]/10)),
		\ampC, ~envNdefq.(~name+++\env3, Env([1,2,0.5],[3,4])),
		\ampB, Pseq([10,3]/10,inf).stutter(2),
		\ampB, ~envNdefq.(~name+++\env4, Env([10,2,0.5],[3,4])),
		//\amp, 2 * Pkey(\amp),
		\dur, 1/8,
		\legato, 0.71,

	)

Pdef(\mod).asRack.keys
Pdef(\mod).asRack.controllers
a= Pdef(\mod).asStream
~event1 = ( 
	'areqC': 41.62291273107, 
	'amp': 1.0, 
	'aate': 1.0, 
	'aan': 0.035294117647059,   
	'ampB': 0.56024850365639, 
	'ampC': 0.74663926073474, 
	'aoneAction': 2.0, 
	'areqB': 55.470564558996, 
	'apread': 0.42352941176471,   
	'areq': 62.394691638252, 
	'adsr': [ Env([ 0.0, 1.0, 0.80000001192093, 0.0  ], [ 0.0031425622071483, 8.0, 0.045371512863826  ], -4.0, 2)  ] 
)
Pdef(\mod).addHalo(\instrument, ~name+++\2)
Pdef(\mod).set(\freq, 100)
Pdef(\mod).set(\freqB, 400)
