

Pdef(\drums).play;
Pdef(\slow_ksh).play;
Pdef(\slow_ksh).stop;
Pdef(\slow_ksh).set(\out, BusDef(\sendbus0));
Pdef(\algoloop).play;
Pdef(\guitar).play;
Pdef(\algoloop).stop;
Ndef(\siren).stop;

Pdef(\drums).set(\out, 0)
Pdef(\drums).set(\out, BusDef(\sendbus0))
Pdef(\guitar).set(\out, BusDef(\sendbus0))


(
//////////// INIT
8.do { arg xx; BusDef(\sendbus++xx,\audio) };
ProtoDef(\rdn).loadDefaultPreset;
ProtoDef(\rdn).inbus = BusDef(\sendbus0);
BusDef(\sendbus0,\audio);
Ndef(\normal, { arg freq=200, pan=0, amp=0.1;
	var sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = DelayC.ar(sig, 0.04, 0.04);
}).play;
Ndef(\normal).set(\inbus, BusDef(\normal, \audio));
~master_init = {
	ProtoDef(\rdn).play;
	Ndef(\normal).play;
};
FileSystemProject.load("algokit/flow/kitlib.scd");
)

	ProtoDef(\rdn).edit;


(
~master_init.();
Pdef(\part1, 
	Plazy({
		var pat;
		var partlist = ~kitlib.lcd;
		var distkit1 = partlist.distkit.collect({ arg val; val.value });
		var distkit2 = partlist.distkit.collect({ arg val; val.value });
		var distkit3 = partlist.distkit.collect({ arg val; val.value });
		var guitarkit1 = partlist.guitarkit.collect({ arg val; val.value });
		var guitarkit2 = partlist.guitarkit.collect({ arg val; val.value });
		var guitarkit3 = partlist.guitarkit.collect({ arg val; val.value });
		var slow_ksh1 = partlist.slow_ksh.collect(_.value);
		var scorelist = (

			part1: Pseq([

				// intro
				Pfindur(8,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				])),
				//

				Pfindur(8,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					2,distkit1.kick.value,
					4,distkit2.values.choose.value,
					4,distkit3.values.choose.value,
				])),
				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar(distkit2.values),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,distkit1.hat,
					0,distkit3.hat,
					0,distkit1.hat2,
					0,distkit1.snare,
					2,Ppar(distkit2.values),
					4,distkit3.values.choose.value,
					4,distkit3.values.choose.value,
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						partlist.part4
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit2.values),
					0,Ppar(distkit1.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar(distkit3.values),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
					0,Ppar(distkit3.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar([
							distkit1.hat,
							distkit1.hat2,
							distkit2.hat,
							distkit3.snare,
							distkit3.snare2,
							distkit2.hat2,
						]),
					),
				],1),

				//

				Pfindur(8+6,Ptpar([
					0, Pbind(\out, BusDef(\sendbus0)) <> slow_ksh1,
					8, Ppar(distkit1.values),
				])),

				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar([
							distkit2.hat,
							distkit2.hat2,
							distkit3.hat,
							distkit1.snare,
							distkit1.snare2,
							distkit3.hat2,
						]),
					),
				],1),

				//

				Pfindur(4+8,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
					0,Ppar(distkit2.values),
					0,Ppar(distkit3.values),
				])),
				Pfindur(2,Ptpar([
					0,Ppar(distkit3.values.collect({ arg pp; 
						Pbind(\dur, Pkey(\dur)* 2) <> pp;
					})),
				])),

				Pseq([
					Pfindur(2,
						//Rest(2)
						partlist.part4
					),
				],1),
			],1),

			// guitar part
			part2: Pseq([

				// intro
				Pfindur(8,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				])),
				//

				Pfindur(8,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Pfindur(7,guitarkit1.trankil),
					2,distkit1.kick.value,
					4,distkit2.values.choose.value,
					4,distkit3.values.choose.value,
				])),

				//

				Pfindur(6,Ptpar([
					0,guitarkit1.trankil,
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
				])),
				Pseq([
					Pfindur(2,
						Ppar([
							Pfindur(1,guitarkit1.solo),
							Ppar(distkit2.values),
						]),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,guitarkit1.trankil,
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					4,distkit1.hat,
					4,distkit3.hat,
					0,distkit1.hat2,
					0,distkit1.snare,
					2,Ppar(distkit2.values),
					4,distkit3.values.choose.value,
					4,distkit3.values.choose.value,
				])),
				Pseq([
					Pfindur(2,
						Ptpar([
							0,guitarkit2.solo,
							//Rest(2)
							1,partlist.part4,
						]),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,guitarkit1.slow,
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit2.values),
					//0,Ppar(distkit1.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar(distkit3.values),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,guitarkit1.trankil,
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					//0,Ppar(distkit1.values),
					0,Ppar(distkit3.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar([
							guitarkit1.solo,
							distkit1.hat,
							distkit1.hat2,
							distkit2.hat,
							distkit3.snare,
							distkit3.snare2,
							distkit2.hat2,
						]),
					),
				],1),

				//

				Pfindur(8+6,Ptpar([
					0,guitarkit1.slow,
					0, Pbind(\out, BusDef(\sendbus0)) <> slow_ksh1,
					8, Ppar(distkit1.values),
				])),

				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar([
							distkit2.hat,
							distkit2.hat2,
							distkit3.hat,
							distkit1.snare,
							distkit1.snare2,
							distkit3.hat2,
						]),
					),
				],1),

				//

				Pfindur(4+8,Ptpar([
					2,guitarkit2.solo,
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
					0,Ppar(distkit2.values),
					0,Ppar(distkit3.values),
				])),
				Pfindur(2,Ptpar([
					0,guitarkit1.slow,
					0,Ppar(distkit3.values.collect({ arg pp; 
						Pbind(\dur, Pkey(\dur)* 2) <> pp;
					})),
				])),

				Pseq([
					Pfindur(2,
						//Rest(2)
						partlist.part4
					),
				],1),
			],1),
		);




		Pseq([
			//Pfindur(76,Ptpar([ // explore
			//	0,partlist.part1,
			//	0,Ppar(distkit3.values),
			//	0,guitarkit1.trankil,
			//])),

			scorelist.part1,
			scorelist.part2,

			// outro
			Pfindur(6,Ptpar([
				0,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
				0,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				2,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
				2,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
			])),

		],1);
	})
).play;
)

Pdef(\part1).set(\out, BusDef(\sendbus0))
Pdef(\part1).set(\out, BusDef(\normal, \audio))
Pdef(\part1).set(\out, 0)
Pdef(\guitar).set(\out, BusDef(\sendbus0))
ProtoDef(\rdn).edit

(
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
RandDelayNetwork('deldefault').make('rdn', "5-O476-H6CC");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.81015160133764,
	'fb', 0.00038151028583369,
	'delay', 0.00013628679593558,
	'delay2', 0.013111339374216,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.9581576155567,
	'pitchlag', 0.45673455020088,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 8619.5338032601,
	'hpf', 17,
	'fbdistamp', 0.43315678728535,
	'fbdistmix', 0.94117647058824,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
RandDelayNetwork('deldefault').make('rdn', "5-4O3C-CDMU");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.98126325966079,
	'fb', 0.0094868329805051,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 96.519158522978,
	'pitchlag', 1.0,
	'pitchmix', 0.76470588235294,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.43315678728535,
	'fbdistmix', 0.94117647058824,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



////////////////////////////////////////////////////////
// junk


		Pseq([
			Pfindur(32,Ptpar([
				0,partlist.part1,
				0,Pfindur(15,
					Pbind(\isRest, false, \gain, ~pmodenv.(Pseq([0,1,1,1],1), 8)) <>
					partlist.part2_hat
				),
				16,partlist.part2,
			])),
		],1);

		Pseq([
			Pfindur(32,Ptpar([
				0, Pseq([
					Pfindur(6,
						partlist.part1
					),
					Pfindur(2,
						Pbind(\speed, ~pmodenv.(Pseq([1,1/2,1/2,2],1), Pseq([1,1,1,1]))) <>
						partlist.part1end
					),
				],4),
				8, Pfindur(8,partlist.part2),
				16, Pseq([
					Pfindur(8, partlist.part3),
					Pfindur(8, 
						Pbind(\isRest, false, \dur, 1, \sustain, 1/~t) <>
						partlist.part3
					),
				],1),

			])),
		],1);
