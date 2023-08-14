
TempoClock.default.tempo = 1;

(
	// bug
	// adding a number to a Pseg make it repeat infinitely
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+50,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// Solution
	// always add inside the Pseg, never add two Pseg
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1) + 100,2),
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

////////////// more manifestation of bug

(
	// bug
	// Pseg and Pseq conflict each other, the addition just make a Pseq like
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseq([
				100,200
			],8),
			Pseg(Pseq([100,200],1),2),
			Pseq([
				400,200
			],8),
			Pseg(Pseq([300,200],1),2),
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// bug
	// some kind of strange reset here
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseq([
				100,200
			],4),
			//Pseg(Pseq([100,200],1),2),
			Pseq([
				400,200
			],4),
			Pseg(Pseq([300,200],1),2),
			Pseq([
				700,750
			],4),
			Pseg(Pseq([700,200],1),2),
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

Main.version

/////////////////////////////////////
///// investigation

(
	// no bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),4),
			Pseg(Pseq([600,500],1),4),
		],inf),
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// no bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2),
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+50,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// bug
	// adding a Pseg do not fix
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+Pseg(Pseq([100,10,300],1),2),
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// bug
	// a wrong length of the added seq terminate the pseg early
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+Pn(100,1),
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// Solution
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1) + 100,2),
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)



/// origin of bug
(
	// BUG
Pdef(\bugpseg,
	Pbind(
		\instrument, \playersec,
		//\bufnum, BufDef('loop/pigs.flac'),
		//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\legato, 1,
		//\st, 272/8/60,
		\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\st, 272/1/60,
		\gain, 0.1,
		\speed, 3.5/Pstep(Pseq([
			1,1,1,1, 1,1,1,1,
			1,1,1,1, 1,1,1,1,
			1,1,1,1, 1,1,1,1,
			1,0.7,1.2,1.2, 1,1,1,1,
		],inf),1/4) * ~t / Pkey(\st),
		\pos, Pseq([
			Pseg(Pseq([
				0, 4,
			],1),1),
			Pseg(Pseq([
				0, 4,
			],1),1)+4,
		],inf) / Pkey(\st),
		\dur, PdurStutter(Pseq([1,4 ],inf), 1/2),
		\gain, 0.1* Pstep(Pseq([
			1,1,1,1, 1,1,1,1,
		],inf),1/8),
		//\legato, Pseq([1,0.5,0.7,1],inf),
		//\dur, 1/8,
	),
).play;
)

(
	// BUG
Pdef(\bugpseg,
	Pbind(
		\instrument, \playersec,
		//\bufnum, BufDef('loop/pigs.flac'),
		//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\legato, 1,
		//\st, 272/8/60,
		\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\st, 272/1/60,
		\gain, 0.1,
		//\speed, 3.5/Pstep(Pseq([
			//1,1,1,1, 1,1,1,1,
			//1,1,1,1, 1,1,1,1,
			//1,1,1,1, 1,1,1,1,
			//1,0.7,1.2,1.2, 1,1,1,1,
		//],inf),1/4) * ~t / Pkey(\st),
		\pos, Pseq([
			Pseg(Pseq([
				0, 4,
			],1),1),
			Pseg(Pseq([
				0, 4,
			],1),1)+4,
		],inf).trace / Pkey(\st),
		//\dur, PdurStutter(Pseq([1,4 ],inf), 1/2),
		\dur, 1/8,
		//\gain, 0.1* Pstep(Pseq([
			//1,1,1,1, 1,1,1,1,
		//],inf),1/8),
		//\legato, Pseq([1,0.5,0.7,1],inf),
		//\dur, 1/8,
	),
).play;
)

(
	// no bug
	// bug found: addition to Pseg
Pdef(\bugpseg,
	Pbind(
		\instrument, \playersec,
		//\bufnum, BufDef('loop/pigs.flac'),
		//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\legato, 1,
		//\st, 272/8/60,
		\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\st, 272/1/60,
		\gain, 0.1,
		//\speed, 3.5/Pstep(Pseq([
			//1,1,1,1, 1,1,1,1,
			//1,1,1,1, 1,1,1,1,
			//1,1,1,1, 1,1,1,1,
			//1,0.7,1.2,1.2, 1,1,1,1,
		//],inf),1/4) * ~t / Pkey(\st),
		\pos, Pseq([
			Pseg(Pseq([
				0, 4,
			],1),1),
			Pseg(Pseq([
				4, 8,
			],1),1),
		],inf).trace,
		//\dur, PdurStutter(Pseq([1,4 ],inf), 1/2),
		\dur, 1/8,
		//\gain, 0.1* Pstep(Pseq([
			//1,1,1,1, 1,1,1,1,
		//],inf),1/8),
		//\legato, Pseq([1,0.5,0.7,1],inf),
		//\dur, 1/8,
	),
).play;
)


///// more investigation
// does it repeat or skip the first ? 

(
	// bug
	// adding a number to a Pseg make it skip the first
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([400,410],1),2),
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+50,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// bug
	// the Pseq are ignored, only Pseg are skipped
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseq([1000,2000,3000],1),
			Pseg(Pseq([400,410],1),2),
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+50,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// bug
	// some time from Pseg is stolen by Pseq
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseq([1000,2000,3000],1),
			Pseg(Pseq([400,410],1),2),
			Pseq([1000,2000,3000],1),
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1),2)+50,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

///////////// more investigation
// can i divide the whole Pseq ?

(
	// yes
	// no bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseg(Pseq([600,500],1) + 100,2),
		],inf).trace / 2,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseq([
				Pseg(Pseq([600,500],1),2),
			],1) + 100,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// proof that Pseq does not act like this : FAIL
	// bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseq([
				Pseq([600,500],4),
			],1) + 100,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)

(
	// proof that Pseq does not act like this : FAIL
	// bug
	// no PdurStutter
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseq([
				Pseq([600,500],4),
			],1) + 100,
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// proof that is the addition that cause bug : FAIL
	// bug
	// no PdurStutter
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseq([
				Pseq([600,500],4),
			],1),
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// proof that is the addition that cause bug : FAIL
	// bug
	// no nested Pseq
	// no PdurStutter
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			Pseq([600,500],4),
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// proof that is the addition that cause bug : FAIL
	// the Pseg is ignored if duration of Pseq is equal or more than the Pseg
	// bug
	// no nested Pseq
	// no PdurStutter
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			//Pseq([600,500],7), // last note of Pseg heard
			Pseq([300,500],9), // no Pseg heard
			//Pseq([300,500],8), // no Pseg heard
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// proof that is the addition that cause bug : FAIL
	// total length of all Pseq is accounted
	// bug
	// no nested Pseq
	// no PdurStutter
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,200],1),2),
			//Pseq([300,500],3), // Pseg heard
			Pseq([300,500],4), // no Pseg heard

			Pseq([600,500],4), 
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// proof that is the addition that cause bug : FAIL
	// total length of all Pseq is accounted
	// bug
	// no nested Pseq
	// no PdurStutter
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseq([100,80],4), // last note of Pseg heard
			Pseg(Pseq([100,200],1),2),
			Pseq([300,500],3), // no Pseg heard
			Pseq([600,500],4), // last note of Pseg heard
			Pseg(Pseq([1]),2),
			Pseg(Pseq([1000,100]),2),
			//Pseq([300,500],9), // no Pseg heard
		],inf).trace,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// proof that Pseq does not act like this : FAIL
	// bug
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseq((1..8)*100,1),
			Pseq([
				Pseq((1..8).reverse*10+100,1),
			],1) + 100,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
	// bug
	// adding a number make it repeat infinitely
	// in this case, the first is not skipped
Pdef(\bugpseg,
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,800],1),2),
			Pseg(Pseq([700,800],1),2),
			Pseq([
				Pseg(Pseq([100,200],1),2),
				Pseg(Pseq([400,200],1),2),
				Pseg(Pseq([600,500],1),2),
			],1) + 100,
		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
).play;
)


////////////////// crap

(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		
	Pbind(
		\instrument, \default,
		\freq, Pseq([
			Pseg(Pseq([100,800],1),2),
			Pseg(Pseq([700,800],1),2),
			Pseq([
				Pseg(Pseq([100,200],1),2),
				Pseg(Pseq([400,200],1),2),
				Pseg(Pseq([600,500],1),2),
			],1) + 100,

		],inf).trace,
		\dur, PdurStutter(Pseq([1,4],inf), 1/2),
		\amp, 0.1,
	),
	])
)).play;
);
