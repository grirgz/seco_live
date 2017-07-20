

Pdef(\main, Pdef(\drums1)).play
(
	Pdef(\drums1, 
		PatKitDef(\algokit).asPattern(Ppar([
			Pbind(
				\kitIndex, Pseq([rrand(0,3)],inf),
				\isRest, Pseq({[
					1,0,1,0, 1,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, rrand(0.051,0.1),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\kitIndex, Pseq([4],inf),
				\isRest, Pseq({[
					0,0,1,0, 0,0,1,1,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, rrand(0.051,0.1),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\kitIndex, Pseq([8],inf),
				\isRest, Pseq({[
					0,0,1,1, 0,0,1,1,
					1,0,1,1, 0,0,1,1,
					1,0,1,1, 1,1,1,1,
					0,1,1,0, 0,1,1,1,
					0,1,1,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, rrand(0.051,0.051) * Pseq({[
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,2,1,0, 0,2,1,0,
					1,1,1,1, 0,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).linlin(0,2,1,2),
				\gain, Pseq({[
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,1,0,1, 0,1,0,1,
				].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1),
				\speed, 2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\kitIndex, Pseq([9],inf),
				\isRest, Pseq({[
					0,0,1,1, 0,0,1,1,
					1,0,1,1, 0,0,1,1,
					1,0,1,1, 1,1,1,1,
					0,1,1,0, 0,1,1,1,
					0,1,1,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, rrand(0.051,0.051) * Pseq({[
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,2,1,0, 0,2,1,0,
					1,1,1,1, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).linlin(0,2,1,2),
				\gain, Pseq({[
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,1,0,1, 0,1,0,1,
				].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1),
				\speed, 1,
				\dur, 1/8,
				\amp, 0.1,
			),
			//Pbind(
			//	\kitIndex, Pseq([rrand(0,3)],inf),
			//	\isRest, Pseq({[
			//		0,1,0,0, 0,0,0,0,
			//		0,0,0,0, 0,1,0,0,
			//		0,0,0,0, 0,0,0,1,
			//	].clump(8).choose}.dup(4).flat,inf).coin.not,
			//	\sustain, rrand(0.051,0.1),
			//	\speed, rrand(1/2,2),
			//	\dur, 1/8,
			//	\gain, 0.5,
			//	\amp, 0.1,
			//),
			//Pbind(
			//	\kitIndex, Pseq([4],inf),
			//	\isRest, Pseq({[
			//		0,0,0,0, 0,0,0,1,
			//		0,0,0,1, 0,0,0,0,
			//		0,1,0,0, 0,0,0,0,
			//	].clump(8).choose}.dup(4).flat,inf).coin.not,
			//	\sustain, rrand(0.051,0.1),
			//	\speed, rrand(1/2,2),
			//	\dur, 1/8,
			//	\gain, 0.5,
			//	\amp, 0.1,
			//),
		]))
	);
)

Pdef(\drums1).set(\out, BusDef(\sendbus0))
Pdef(\drums1).clear
Pdef(\drums1).play
Pdef(\drums1).unset(\out)
ProtoDef(\rdn).outBus = 0
ProtoDef(\rdn).play
ProtoDef(\rdn).edit


(
Pdef(\bass, Pbind(
	\instrument, \criz,
	\degree, Pseq([0,0,7,7],inf),
	\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
	\rq, 0.1,
	\octave, 3,
	\legato, 0.9,
	\dur, 1/8,
	\amp, 0.1
)).play;
Pdef(\treb, Pbind(
	\instrument, \criz,
	\note, Pseq([7,6,5,4]+5,inf).stutter(8),
	\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
	\fold, Pseg(Pseq([0.2,1],inf),8),
	\foldspread, Pseg(Pseq([0,4],inf),8),
	//\lpfr, Pseg(Pseq([1/2,2],inf),8),
	\lpfr, 1,
	\rq, 0.3,
	\octave, 5,
	\legato, 0.9,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
)

(
Pdef(\modrdn, Ppar([
	Pfindur(8,Pbind(
		\instrument, \modenv,
		\out, ~ndefmod.(\rdn, \delay),
		\env, [ Env([0,0,0.1],[0,8]/~t) ],
		\dur, Pseq([8],inf),
	)),
	Pfindur(8,Pbind(
		\instrument, \modenv,
		\out, ~ndefmod.(\rdn, \distamp),
		\env, [ Env([0,0,440.4],[0,8]/~t) ],
		\dur, Pseq([8],inf),
	)),
],inf)).play;
)


(
TrackDef(\gridbin, TrackDef(\playergrid));
TrackDef(\gridbin).source = [
	[
		ProtoDef(\rdnbin, ProtoTemplateDef(\rdn)),
	],
	[
		ProtoDef(\rdnbin2, ProtoTemplateDef(\rdn)),
	],
	[
		Pdef(\drums1),
	],
	[
		Pdef(\bass),
	],
	[
		Pdef(\treb),
	],
	[
		nil,
	],
];
5.do { arg x; TrackDef(\gridbin).childAt(x).mixer.play };
);


TrackDef(\gridbin).edit;
TrackDef(\gridbin).clear

	(
		~masterplay = {
			ProtoDef(\rdnbin).play;
			ProtoDef(\rdnbin2).play;
			5.do { arg x; TrackDef(\gridbin).childAt(x).mixer.play };
		};
		~masterplay.();
	Pdef(\main, 
		Pseq([
			Pfindur(16, Pdef(\binpart5)),
			Pdef(\binpart1),
			Pfindur(14, Pdef(\binpart2)),
			Pfindur(2, Pdef(\binpart_end1)),
			Pfindur(16, Pdef(\binpart4)),
			Pfindur(16, Pdef(\binpart3)),
		],2),
	).play;
	)

(
	Pdef(\main, Pdef(\binpart1)).play;
	~masterplay.();
	Pdef(\binpart1, 
		Pseq([
			Pfindur(7,Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([0],inf),
						\isRest, Pseq({[
							1,0,1,0, 1,0,1,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, 1,
						\dur, 1/8,
						\amp, 0.1,
					),
				])),

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					\lpfr, Pseg(Pseq([0,1, 1,4, 4,8],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),
				

			])),
			Pfindur(1*1,Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([0],inf),
						\isRest, Pseq({[
							1,0,1,0, 1,0,1,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, 1,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([5],inf),
						\isRest, Pseq({[
							1,1,1,1, 1,1,1,1,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, 3/4,
						\dur, 1/8,
						\amp, 0.1,
					),
				])),

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					\lpfr, Pseg(Pseq([1/2,8],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),
				

			])),
		]),
	);
)

(
	Pdef(\main, Pdef(\binpart2)).play;
	~masterplay.();
	Pdef(\binpart2, 
		Pseq([
			Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([rrand(0,3)],inf),
						\isRest, Pseq({[
							1,0,1,0, 1,0,1,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([4],inf),
						\isRest, Pseq({[
							0,0,1,0, 0,0,1,1,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([8],inf),
						\isRest, Pseq({[
							0,0,1,1, 0,0,1,1,
							1,0,1,1, 0,0,1,1,
							1,0,1,1, 1,1,1,1,
							0,1,1,0, 0,1,1,1,
							0,1,1,0, 0,0,1,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1),
						\speed, 2,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([9],inf),
						\isRest, Pseq({[
							0,0,1,1, 0,0,1,1,
							1,0,1,1, 0,0,1,1,
							1,0,1,1, 1,1,1,1,
							0,1,1,0, 0,1,1,1,
							0,1,1,0, 0,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1),
						\speed, 1,
						\dur, 1/8,
						\amp, 0.1,
					),
				])),

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),
				Pdef(\treb, Pbind(
					\instrument, \criz,
					\note, Pseq([7,6,5,4]+5,inf).stutter(8),
					\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
					\fold, Pseg(Pseq([0.2,1],inf),8),
					\foldspread, Pseg(Pseq([0,4],inf),8),
					//\lpfr, Pseg(Pseq([1/2,2],inf),8),
					\lpfr, 1,
					\rq, 0.3,
					\octave, 5,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),

			]),
		]),
	);
)

(
	Pdef(\main, Pdef(\binpart3)).play;
	~masterplay.();
	Pdef(\binpart3, 
		Pseq([
			Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([rrand(0,3)],inf),
						\isRest, Pseq({[
							1,0,1,0, 1,0,1,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([4],inf),
						\isRest, Pseq({[
							0,0,1,0, 0,0,1,1,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([8],inf),
						\isRest, Pseq({[
							0,0,1,1, 0,0,1,1,
							1,0,1,1, 0,0,1,1,
							1,0,1,1, 1,1,1,1,
							0,1,1,0, 0,1,1,1,
							0,1,1,0, 0,0,1,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1),
						\speed, 2,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([9],inf),
						\isRest, Pseq({[
							0,0,1,1, 0,0,1,1,
							1,0,1,1, 0,0,1,1,
							1,0,1,1, 1,1,1,1,
							0,1,1,0, 0,1,1,1,
							0,1,1,0, 0,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1),
						\speed, 1,
						\dur, 1/8,
						\amp, 0.1,
					),
				])),

				// tone

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					//\lpfr, Pseg(Pseq([2,1],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),
				Pdef(\treb, Pbind(
					\instrument, \criz,
					\note, Pseq([7,6,5,4]+5,inf).stutter(8),
					\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
					\fold, Pseg(Pseq([0.2,1],inf),8),
					\foldspread, Pseg(Pseq([0,4],inf),8),
					//\lpfr, Pseg(Pseq([1/2,2],inf),8),
					\lpfr, 1,
					\rq, 0.3,
					\octave, 5,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),

				// mod
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin, \delay),
					\env, [ Env([0,0,0.1],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),

				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay),
					\env, [ Env([0.1,0.1,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay2),
					\env, [ Env([0.01,0.01,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pseq([
					Pfindur(7,Pbind(
						\instrument, \modenv,
						\out, ~ndefmod.(\rdnbin2, \distamp),
						\env, [ Env([0,0,400.01],[0,7]/~t) ],
						\dur, Pseq([8],inf),
					)),
					Ppar([
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin, \distamp),
							\env, [ Env([400,400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin, \delay),
							\env, [ Env([0.400,0.400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin2, \distamp),
							\env, [ Env([400,400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin2, \delay2),
							\env, [ Env([0.01,0.01,0.1003],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
					]),
				],1),


			]),
		]),
	);
)

(
	Pdef(\main, Pdef(\binpart4)).play;
	~masterplay.();
	Pdef(\binpart4, 
		Pseq([
			Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([rrand(0,3)],inf),
						\isRest, Pseq({[
							1,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([9],inf),
						\isRest, Pseq({[
							1,0,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1) * 0.7,
						\speed, 1,
						\dur, 1/8,
						\amp, 0.1,
					),
				])),

				// tone

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					//\lpfr, Pseg(Pseq([2,1],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),
				Pdef(\treb, Pbind(
					\instrument, \criz,
					\note, Pseq([7,6,5,4]+5,inf).stutter(8),
					\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
					\fold, Pseg(Pseq([0.2,1],inf),8),
					\foldspread, Pseg(Pseq([0,4],inf),8),
					//\lpfr, Pseg(Pseq([1/2,2],inf),8),
					\lpfr, 1,
					\rq, 0.3,
					\octave, 5,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),

				// mod
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin, \delay),
					\env, [ Env([0,0,0.1],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),

				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay),
					\env, [ Env([0.1,0.1,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay2),
					\env, [ Env([0.01,0.01,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pseq([
					Pfindur(7,Pbind(
						\instrument, \modenv,
						\out, ~ndefmod.(\rdnbin2, \distamp),
						\env, [ Env([0,0,400.01],[0,7]/~t) ],
						\dur, Pseq([8],inf),
					)),
					Ppar([
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin, \distamp),
							\env, [ Env([400,400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin, \delay),
							\env, [ Env([0.400,0.400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin2, \distamp),
							\env, [ Env([400,400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin2, \delay2),
							\env, [ Env([0.01,0.01,0.1003],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
					]),
				],1),


			]),
		]),
	);
)

(
	Pdef(\binpart_intro, Pdef(\binpart5));
	Pdef(\main, Pdef(\binpart5)).play;
	~masterplay.();
	Pdef(\binpart5, 
		Pseq([
			Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([9],inf),
						\isRest, Pseq({[
							1,0,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1) * 0.7,
						\speed, 1,
						\dur, 1/4,
						\amp, 0.1,
					),
				])),

				// tone

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					//\lpfr, Pseg(Pseq([2,1],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.1,
					\dur, 1/8,
					\amp, 0.1
				)),
				Pdef(\treb, Pbind(
					\instrument, \criz,
					\note, Pseq([7,6,5,4]+5,inf).stutter(8),
					\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
					\fold, Pseg(Pseq([0.2,1],inf),8),
					\foldspread, Pseg(Pseq([0,4],inf),8),
					//\lpfr, Pseg(Pseq([1/2,2],inf),8),
					\lpfr, 1,
					\rq, 0.3,
					\octave, 5,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),

				// mod
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin, \delay),
					\env, [ Env([0,0,0.1],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),

				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay),
					\env, [ Env([0.1,0.1,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay2),
					\env, [ Env([0.01,0.01,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pseq([
					Pfindur(7,Pbind(
						\instrument, \modenv,
						\out, ~ndefmod.(\rdnbin2, \distamp),
						\env, [ Env([0,0,400.01],[0,7]/~t) ],
						\dur, Pseq([8],inf),
					)),
					Ppar([
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin, \distamp),
							\env, [ Env([400,400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin, \delay),
							\env, [ Env([0.400,0.400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin2, \distamp),
							\env, [ Env([400,400,0.01],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
						Pfindur(1,Pbind(
							\instrument, \modenv,
							\out, ~ndefmod.(\rdnbin2, \delay2),
							\env, [ Env([0.01,0.01,0.1003],[0,1]/~t) ],
							\dur, Pseq([8],inf),
						)),
					]),
				],1),


			]),
		]),
	);
)

(
	Pdef(\binpart_end1, Pdef(\binpart6));
	Pdef(\main, Pdef(\binpart6)).play;
	~masterplay.();
	Pdef(\binpart6, 
		Pseq([
			Ppar([
				PatKitDef(\algokit).asPattern(Ppar([
					Pbind(
						\kitIndex, Pseq([rrand(0,3)],inf),
						\isRest, Pseq([
							1,0,1,0, 1,0,1,0,
							1,1,1,0, 1,1,1,0,
						],1).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([4],inf),
						\isRest, Pseq({[
							0,0,1,0, 0,0,1,1,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\sustain, rrand(0.051,0.1),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([9],inf),
						\isRest, Pseq({[
							1,0,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, rrand(0.051,0.051) * Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,2,1,0, 0,2,1,0,
							1,1,1,1, 0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).linlin(0,2,1,2),
						\gain, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
						].clump(8).choose}.dup(4).flat,inf).linlin(0,1, 0.5,1) * 0.7,
						\speed, 1,
						\dur, 1/4,
						\amp, 0.1,
					),
				])),

				// tone

				Pdef(\bass, Pbind(
					\instrument, \criz,
					\degree, Pseq([0,0,7,7],inf),
					//\lpfr, Pseg(Pseq([2,1],inf),Pseq([8,0],inf)),
					\rq, 0.1,
					\octave, 3,
					\legato, 0.1,
					\dur, 1/8,
					\amp, 0.1
				)),
				Pdef(\treb, Pbind(
					\instrument, \criz,
					\note, Pseq([7,6,5,4]+5,inf).stutter(8),
					\lpfr, Pseg(Pseq([2,4],inf),Pseq([8,0],inf)),
					\fold, Pseg(Pseq([0.2,1],inf),8),
					\foldspread, Pseg(Pseq([0,4],inf),8),
					//\lpfr, Pseg(Pseq([1/2,2],inf),8),
					\lpfr, 1,
					\rq, 0.3,
					\octave, 5,
					\legato, 0.9,
					\dur, 1/8,
					\amp, 0.1
				)),

				// mod
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin, \delay),
					\env, [ Env([0.3,0.3,0.1],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay),
					\env, [ Env([0.0001,0.0001,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),
				Pfindur(8,Pbind(
					\instrument, \modenv,
					\out, ~ndefmod.(\rdnbin2, \delay2),
					\env, [ Env([0.01,0.01,0.0003],[0,8]/~t) ],
					\dur, Pseq([8],inf),
				)),

			]),
		]),
	);
)


RandDelayNetwork(\defaultdel).presetCompileString(\rdnbin).editorInsert
(
RandDelayNetwork('defaultdel').make('rdnbin', "4-OD3U-D826");
Ndef('rdnbin').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 1.3504679373003,
	'fb', 0.0001,
	'delay', 'c3',
	'delay2', 0.00090778539919376,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 'c4',
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.73529411764706,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

RandDelayNetwork(\defaultdel).presetCompileString(\rdnbin2).editorInsert
(
RandDelayNetwork('defaultdel').make('rdnbin2', "4-2EED-U67O");
Ndef('rdnbin2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0001,
	'delay', 'c0',
	'delay2', 'c1',
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 'c2',
	'pitchlag', 0.125,
	'pitchmix', 0.0,
	'prelpf', 20000.0,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 1.0,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.1,
	'wet20', 1.0,
	'mamp', 1,
	'indelay', 0.04,
	'gain', 0.82562104854279,
	'mix', 0.92436974789916,
).keep(1));

);

(
~rdnpresets = (
	p1: [
		'wet10', 1.0,
		'fb', 0.0001,
		'delay', 0.001,
		'delay2', 0.001,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 10,
		'pitchlag', 0.125,
		'pitchmix', 0.0,
		'prelpf', 20000.0,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 17,
		'fbdistamp', 0.47619047619048,
		'fbdistmix', 1.0,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.1,
		'wet20', 1.0,
		'mamp', 1,
		'indelay', 0.04,
		'gain', 0.82562104854279,
		'mix', 0.92436974789916,
	],
	p2: [
		'wet10', 1.0,
		'fb', 0.0001,
		'delay', 0.001,
		'delay2', 0.01,
		'shift', 0.0,
		'shift2', 0.01,
		'distamp', 100,
		'pitchlag', 0.125,
		'pitchmix', 0.0,
		'prelpf', 20000.0,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 17,
		'fbdistamp', 0.47619047619048,
		'fbdistmix', 1.0,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.1,
		'wet20', 1.0,
		'mamp', 1,
		'indelay', 0.04,
		'gain', 0.82562104854279,
		'mix', 0.92436974789916,
	],
	p3: [
		'wet10', 1.0,
		'fb', 0.0001,
		'delay', 0.801,
		'delay2', 0.81,
		'shift', 0.0,
		'shift2', 0.01,
		'distamp', 100,
		'pitchlag', 0.125,
		'pitchmix', 0.0,
		'prelpf', 20000.0,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 17,
		'fbdistamp', 0.47619047619048,
		'fbdistmix', 1.0,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.1,
		'wet20', 1.0,
		'mamp', 1,
		'indelay', 0.04,
		'gain', 0.82562104854279,
		'mix', 0.92436974789916,
	],
);
~setrdnpreset = { arg key, preset;
	Ndef(key).put(100, \pset -> Pbind(*preset).keep(1))
};
~morphrdnpreset = { arg key, preset1, preset2, time=8;
	var dictp1 = Dictionary.newFrom(preset1);
	var dictp2 = Dictionary.newFrom(preset2);
	Pfindur(time, Ppar(preset1.clump(2).collect { arg kv, idx;
		var prekey = kv[0];
		var val1 = dictp1[prekey];
		var val2 = dictp2[prekey] ? val1;
		if(val1 != val2) {
			Pbind(
				\instrument, \modenv,
				\env, [ Env([val1,val1,val2],[0,time]/~t) ],
				\out, ~ndefmod.(key, prekey),
				\legato, 1,
				\dur, time,
			).trace
		} {
			Rest(1)
			// TODO
			//Pbind(
			//	\type, \bus,
			//	\
			//)
		}
	},1))
};
//~setrdnpreset.(\rdnbin2, ~rdnpresets.p2);
~masterplay.();
Pdef(\main, Ppar([
	Pdef(\binpart2),
	Pseq([
		~morphrdnpreset.(\rdnbin2, ~rdnpresets.p1, ~rdnpresets.p1, 3),
		~morphrdnpreset.(\rdnbin2, ~rdnpresets.p1, ~rdnpresets.p3, 1),
	],inf),
])).play;
)
