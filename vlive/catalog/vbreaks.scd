
~t = 150/4/60; TempoClock.default.tempo = ~t;

			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\bufnum, BufDef.stereo('vbreaks/Head West - Attention.wav'),
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\bufnum, BufDef.stereo('vbreaks/FBI - FBI.wav'),
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),

(
Pdef(\vbreaks_drums, Ppar([
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.2,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.21,
	),

]));
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
	// broken
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Head West - Attention.wav'),
			\legato, 1,
			\st, 162/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
	// broken
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/FBI - FBI.wav'),
			\legato, 1,
			\st, 104/1/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Augusto Alguero - Ballet Del Arbitro Bueno.wav'),
			\legato, 1,
			\st, 105/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);
