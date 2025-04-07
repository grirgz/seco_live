
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
1*~t/( 176/4/60 )
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bacao Rhythm & Steel Band - Bacao Suave.wav'),
			\legato, 1,
			\st, 103/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2, 4,
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
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;

// setup: pos / 8 + 0.6 / Pkey(\st)
// kick 3, 9, 15,19,25, 29,31, 35,41,47
// hat, 2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50
// doublehat, 1, 5, 11,13,17,21,27,33,37,43,45,49
// snare 4, 12, 20, 28, 36,44
// cymkick: 16, 42, 
// snarekick, 10,26,32, 48,0
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part1).wav'),
			\legato, 1,
			\st, 167/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			],1),4).loop / Pkey(\st) + 0.9,
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
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 1,
			\st, 177/4/60,
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
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			//\st, 184/4/60,
			\st, 183/4/60, // sound better, at 185bpm at least

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
