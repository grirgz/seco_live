
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,3,7,13 ],
				[ 0,3,8,12 ],
				[ 0,3,7,12 ],
				[ 0,4,7,12 ],
				[ 0,5,7,12 ],
				[ 0,5,7,13 ],
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Prout({ arg ev;
					Pseq([
						[ 0,3,7,13 ],
						[ 0,3,8,12 ],
						[ 0,3,7,12 ],
						[ 0,4,7,12 ],
						[ 0,5,7,12 ],
						[ 0,5,7,13 ],
					],inf).do { arg item, idx;
						ev = Pindex(item,Pseq([4,2,0,1, 0,3,2,3]), 4).embedInStream
					};
				}),
			],inf),
			\lpf, 200,
			\envamt, 6,
			\dur, 1/16,
			\octave, Pseq([3,6,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\amp, 0.1/2 * Pseq([
				Ppatlace( [
					Pseg(Pseq([0,1],inf),8),
					Pseg(Pseq([1,0],inf),8),
				] )
			],inf),
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,3,7,13 ],
				[ 0,3,8,12 ],
				[ 0,3,7,12 ],
				[ 0,4,7,12 ],
				[ 0,5,7,12 ],
				[ 0,5,7,13 ],
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Prout({ arg ev;
					Pseq([
						[ 0,3,7,13 ],
						[ 0,3,8,12 ],
						[ 0,3,7,12 ],
						[ 0,4,7,12 ],
						[ 0,5,7,12 ],
						[ 0,5,7,13 ],
					],inf).do { arg item, idx;
						ev = Pindex(item,Pseq([4,2,0,1, 0,3,2,3]), 4).embedInStream
					};
				}),
			],inf),
			\lpf, 200,
			\envamt, 6,
			\dur, 1/16,
			\octave, Pseq([3,6,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\amp, 0.1/2 * Pseq([
				Ppatlace( [
					Pseg(Pseq([0,1],inf),8),
					Pseg(Pseq([1,0],inf),8),
				] )
			],inf),
			\amp, 0.1/2,
		),
	])
)).play;
);

(
	// slow
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,3,7,13 ],
				[ 0,3,8,12 ],
				[ 0,3,7,12 ],
				[ 0,4,7,12 ],
				[ 0,5,7,12 ],
				[ 0,5,7,13 ],
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Prout({ arg ev;
					Pseq([
						[ 0,3,7,13 ],
						[ 0,3,8,12 ],
						[ 0,3,7,12 ],
						[ 0,4,7,12 ],
						[ 0,5,7,12 ],
						[ 0,5,7,13 ],
					],inf).do { arg item, idx;
						ev = Pindex(item,Pseq([4,2,0,1, 0,3,2,3]), 4).embedInStream
					};
				}),
			],inf),
			\lpf, 200,
			\envamt, 6,
			\dur, 1/8,
			\octave, Pseq([3,6,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\amp, 0.1/2 * Pseq([
				Ppatlace( [
					Pseg(Pseq([0,1],inf),8),
					Pseg(Pseq([1,0],inf),8),
				] )
			],inf),
			\amp, 0.1/2,
		),
	])
)).play;
);
