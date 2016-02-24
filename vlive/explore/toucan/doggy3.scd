
(
Pdef(\perc_scar1, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			//\amp, Pkey(\amp) * 4/5,
			\timeScale, 3/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1)/13 * Pseq([
				1.0,0.7,0.9,0.5,
			],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));


Pdef(\perc_scar2, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 4/5,
			//\timeScale, 1/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0.2,0, 0.2,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0.9,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0.5,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.5,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				Pseq([
					0,0,0.1,0, 0.4,0,0,0,
					0.2,0,0.1,0, 1,0,0,0,
				],6),
				Prand([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						1,0,0,1, 0,0,1,0,
					],1),
					Pseq([
						1,0,0,1, 0,0,1,0,
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0,
					],1),
					Pseq([
						1,1,1,0, 1,0,1,0,
					],1),
				],2),
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1,
				Plazy({
					Prand([
						Pseq([1,1,1,1, 1,1,1,1/4].scramble),
						Pseq([1,1,1,1, 1,1,1,4].scramble)
					],1)
				}),
			],inf).stutter(1)/13 * Pseq([
				1.0,0.7,0.9,0.5,
			],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));

Pdef(\perc_scar3, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 4/5,
			//\timeScale, 1/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
		Pbind(
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1)/13 * Pseq([
				1.0,0.7,0.9,0.5,
			],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));

)

Pdef(\main, Pdef(\perc_scar1)).play
Pdef(\main, Pdef(\perc_scar2)).play
Ndef(\bypass).play

(
	Ndef(\myfx1).play;
	Tdef(\fx, {
		1.do  {
			//// intro
			"sec intro".postln;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
			8.wait;

			//////////////////////////////////////////// sec 1
			"sec 1".postln;
			//// part 1

			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;

			//// part 2
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D159", BusDef(\fx1)); // steady feedback
			(32+24).wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C9", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part 2b
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D058", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C8", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part reverb
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Pdef(\hat).set(\out, BusDef(\fx1));
			RandDelayNetwork(\default).make(\myfx1, "5-51E0-M5RH", BusDef(\fx1)); // good reverb
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			8.wait;
			Pdef(\hat).set(\out, 0);

			//////////////////////////////////////////// sec X
			"sec X".postln;
			//// part 3
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			( 32+24 ).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3b
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bt1", BusDef(\fx1)); // feedback
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//////////////////////////////////////////// sec fast
			"sec fast".postln;
			//// part fast /// change perc here !!!

			Ndef(\myfx1).put(100, \pset -> Pdef(\fx_fast1));
			RandDelayNetwork(\default).make(\myfx1, "5-2ils-1dl0", BusDef(\fx1));  // 
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			Ndef(\myfx1).put(100, \pset -> Pdef(\fx_fast1));
			RandDelayNetwork(\default).make(\myfx1, "5-NEI4-LT30", BusDef(\fx1));  //  yoha
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			////////////////////////////////////////////// sec rest
			"sec rest".postln;
			//// part 1

			Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
			RandDelayNetwork(\default).make(\myfx1, "5-a3lo-4358", BusDef(\fx1)); // steady feedback
			( 32+24 ).wait;
			Pdef(\hat).set(\out, BusDef(\fx1));
			Pdef(\hat).play;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;
			Pdef(\hat).set(\out, 0);
			Pdef(\hat).stop;

			//////////////////////////////////////////// sec 3
			"sec 3".postln;

			//// part 3
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			(32+24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3b
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bt1", BusDef(\fx1)); // feedback
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 1b

			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-u1kl", BusDef(\fx1)); // calm
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i113", BusDef(\fx1)); // bass
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-l1al", BusDef(\fx1)); // bass disto
			4.wait;

			//////////////////////////////////////////// outro
			"sec outro".postln;
			//// outro

			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
			8.wait;
		};
		Ndef(\myfx1).stop(5);

		nil;
	}).play;
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\main, 
		Pseq([
			Pfindur(32,
				Pdef(\perc_p2)
			),
			// sec 1
			Pfindur(5 * 32,
				Pdef(\perc_scar2)
			),
			// sec X
			Pfindur(3* 32,
				Pdef(\perc_scar2)
			),
			// sec fast
			Pfindur(2 * 32,
				Pdef(\perc_scar3)
			),
			// sec rest
			Rest(64),
			// sec 3
			Pfindur(4 * 32,
				Pdef(\perc_scar2)
			),
			// outro
			Pfindur(32,
				Pdef(\perc_p2)
			),
		]);
	).play;
)
Ndef(\myfx1).clear

(
	Ndef(\myfx1).play;
	RandDelayNetwork(\default).make(\myfx1, "5-5TKB-7QT0", BusDef(\fx1));  // disto max
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
	Pdef(\main, Pdef(\perc_scar3)).play;
)
(
	Ndef(\myfx1).play;
	Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
	RandDelayNetwork(\default).make(\myfx1, "5-a3lo-4358", BusDef(\fx1)); // steady feedback
	Pdef(\main).stop;
)
Ndef(\myfx1).clear
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D158", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C8", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;
5-SAOV-SC07 // bass disto
5-MPT6-RQHT // simple
5-5TKB-7QT0 // disto
5-EQ4B-SB1B // bass disto2
(
	Ndef(\myfx1).play;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fx_fast1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-2ils-1dl0", BusDef(\fx1));  // 
			RandDelayNetwork(\default).make(\myfx1, "5-2iys-1dl0", BusDef(\fx1));  // 
			RandDelayNetwork(\default).make(\myfx1, "5-OK8D-TS4M", BusDef(\fx1));  // 
			RandDelayNetwork(\default).make(\myfx1, "5-NEI4-LT30", BusDef(\fx1));  //  yoha
			"5-NEI4-LT30"
			RandDelayNetwork(\default).make(\myfx1, "5--", BusDef(\fx1));  // 
				Pdef(\main, Pdef(\perc_scar3)).play
)

gT
32*17/190

ParamGroupDef(\myfx1, Ndef(\myfx1).asParamGroup)
ParamGroupDef(\myfx1).save(\p1)
ParamGroupDef(\myfx1).load(\p1)
ParamGroupDef(\myfx1).group.getPbindCompileString

ParamGroupDef(\myfx1).getPbindCompileString(\p1)


(
	Pdef(\fx_fast1, 
		Pbind(  
			'inbus', Bus('audio', 20, 2, s),
			'wet10', 0.54444444444444,
			'pitchlag', 1.0,
			'delay', 0.00014307229891938,
			'delay2', 0.00056958108107377,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.3637122991511,
			'prelpf', 12144.04391382,
			'prehpf', 20.0,
			'fb', 0.050357680118343,
			'lpf', 14158.915687683,
			'hpf', 20.0,
			'pitchmix', 0.53333333333333,
			'plpf', 17000,
			'phpf', 17,
			'poamp', 0.057120705093586,
			'wet20', 1.0,
			'mamp', 1.8205642030261,
		)
	)
)
