
// create chaotic recursive function

(
~f = { arg x=0.5, b;
	var r = 1.0.rand;
	[x,b].debug("xb");
	if(r > 0.5) {
		x * ( 1+r );
	} {
		x + r - 0.25;
	};
};
(1..10).reduce(~f);
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\freq, 400 * Prout({ arg ev;
			var x = 0.5;
			var f = { arg x=0.5, b;
				var r = 1.0.rand;
				[x,b].debug("xb");
				if(r > 0.5) {
					x * ( 0.25+r );
				} {
					x + r - 0.25;
				};
			};
			loop {
				x = f.(x);
				x.yield;
			}
		}),
		\dur, 1/4,
		\amp, 0.1/4,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\note, Prout({ arg ev;
			var x = 0.5;
			var f = { arg x=0.5, b;
				var r = 1.0.rand;
				[x,b].debug("xb");
				if(r > 0.5) {
					x * ( 0.25+r );
				} {
					x + r - 0.25;
				};
			};
			loop {
				x = f.(x);
				( (x * 12).round(1) ).yield;
			}
		}).trace,
		\dur, 1/32,
		\amp, 0.1/4,
	)
).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \default,
			\octave, 6,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/4,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/2,
			\amp, 0.1/4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\octave, 3,
			\isRest, Pseq([
				1,0.1,0.5,0.1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \default,
			\octave, 6,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/4,
			\isRest, Pseq([
				1,0.1,0.5,0.1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/2,
			\isRest, Pseq([
				1,0.1,0.5,0.1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/4,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\octave, 3,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \default,
			\octave, 6,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/4,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\octave, 3,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \default,
			\octave, 6,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/4,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \default,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/4,
		),
	].collect({ arg pat;
		Pbind(
			\dur, Plazy({
				Pseq(16.partition([4,8,12].choose)/[2,4,8,16,32].choose,(1..4).choose)
			}).loop
		) <> pat
   
	}))
)).play;
);

(
	// with holis project
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\octave, 3,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\octave, 6,
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, 1/4,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/6,
		),
		Pbind(
			\note, Prout({ arg ev;
				var x = 0.5;
				var f = { arg x=0.5, b;
					var r = 1.0.rand;
					[x,b].debug("xb");
					if(r > 0.5) {
						x * ( 0.25+r );
					} {
						x + r - 0.25;
					};
				};
				loop {
					x = f.(x);
					( (x * 12).round(1) ).yield;
				}
			}).trace,
			\dur, Prand([1/8,1/4,1/2],inf),
			\amp, 0.1/4,
		),
	].collect({ arg pat;

		Pbind(
			\dur, Plazy({
				Pseq(16.partition([4,8,12].choose)/[2,4,8,16,32].choose,(1..4).choose)
			}).loop,
			\note, Pkey(\note).clip(-50,50),
			\isRest, false,
			\legato, 0.8,
			\out, BusDef(\sendbus1, \audio),
		) <> pat
		<> Plazy({
			Pfindur([4,6,8].choose,~ze_list_synth.choose)
		}).loop
   
	}))
)).play;
);

Pdef(\part).clear;

(
~ze_list_synth = [
				Pdef(\ze_kalimba),
				Pdef(\ze_brownbass),
				Pdef(\ze_fmbass),
				Pdef(\ze_fmbell),
				Pdef(\ze_vlip),
				Pdef(\ze_pluck),
				Pdef(\ze_chordar),
				Pdef(\ze_fmsaw_scratch),
				Pdef(\ze_rise),
				Pdef(\ze_sibass),
				Pdef(\ze_stringsx),
				Pdef(\ze_basicbass),
				Pdef(\ze_organ_tonewheel1),
				Pdef(\ze_hech),
				Pdef(\ze_fzion3),
				Pdef(\ze_fzion4),
				Pdef(\ze_fzion2),
				Pdef(\ze_fzion),
				Pdef(\ze_dronebleu),
				Pdef(\ze_dronebleuhi),
				Pdef(\ze_iron),
				Pdef(\ze_cracklemono),
				Pdef(\ze_crackledec),
				Pdef(\ze_bassgrise),
				Pdef(\ze_dubdrone4x),
				Pdef(\ze_dubdrone4),
				Pdef(\ze_chovar),
				Pdef(\ze_organ),
				Pdef(\ze_wavechord),
				Pdef(\ze_grancru),
				Pdef(\ze_simpleacid),
				Pdef(\ze_stepchord1),
				Pdef(\ze_stepchord2),
				Pdef(\ze_chordlock2),
				Pdef(\ze_chordlock3),
				Pdef(\ze_basslok),
			Pdef(\ze_tassbass),
			Pdef(\ze_chordo),
			Pdef(\ze_perctone),
			Pdef(\ze_aigu),
			Pdef(\ze_longf),
			Pdef(\ze_dubdrone),
			Pdef(\ze_dubdrone3),
			Pdef(\ze_chordo2),
			Pdef(\ze_plouc),
			Pdef(\ze_hipass),
			Pdef(\ze_hipasswide),
			Pdef(\ze_chordodo),
			Pdef(\ze_basicpadfm),
			Pdef(\ze_oneone),
			Pdef(\ze_oneone2),
]
)
