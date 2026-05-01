
/////////////////////////////
// first note drop in amplitude when changing Pdef content

//// no bug

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\default,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\default,
			\note, Pseq([
				0,4,3,1,
			],inf)+12,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


//// bug!!!

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\hoo) <>
		Pmono(\default,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef(\hoo, Pbind())
Pdef(\hoo, Pbind(\note, Pseq([0,2,3,4]+12,inf)))
Pdef(\part).clear


///// bug!!!

(
Pdef(\part, 
		Pdef(\hoo) <>
		Pmono(\default,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
).play;
);

Pdef(\hoo, Pbind())
Pdef(\hoo, Pbind(\note, Pseq([0,2,3,4]+12,inf)))

////// no bug when Pdef is coming after

(
Pdef(\part, 
		Pmono(\default,
			\dur, 1,
			\amp, 0.1,
		)
		<> Pdef(\hoo)
		<> Pbind(
			\note, Pseq([
				0,4,3,1,
			],inf),
		)
		
).play;
);

Pdef(\hoo, Pbind())
Pdef(\hoo, Pbind(\note, Pseq([0,2,3,4]+12,inf)))
