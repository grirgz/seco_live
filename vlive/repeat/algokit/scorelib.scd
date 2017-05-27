
(
	~scorelib = ~scorelib ? ();
	~scorelib.hiphop = (
		kick: { arg self;
			Pbind(
				\isRest, Pseq({[
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0, 
					1,1,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,1,
					1,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\dur, 1/8,
			)
			
		},
		snare: { arg self;
			Pbind(
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
					0,0.2,0,0, 1,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\dur, 1/8,
			)
			
		},
		hat: { arg self;
			Pbind(
				\isRest, Pseq({[
					0,0,1,0, 1,0,1,0, 
					1,1,1,1, 0,0,0,0, 
					1,0,0,0, 1,0,0,0, 
					0,0,1,1, 0,0,1,1, 
					1,1,1,0, 0,0,1,0, 
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\dur, 1/8,
			)
			
		},

	);

	~kitgen = ~kitgen ? ();
	~kitgen.chooseFromKit = { arg self, index;
		PatKitDef(\algokit).targets[index]
	};
	~kitgen.simple = (
		kick: { arg self;
			StepEvent.newFrom((
				instrument: \playersec,
				bufnum: [
					BufDef('fix1/kick.flac'), 
					BufDef('fix3/kick1.flac'),
					BufDef('fix4/kick1.flac'),
					BufDef('fix4/kick2.flac'),
				].choose,
				pos:0.04,
				speed: rrand(1/2,2),
				sustain: rrand(0.051,0.2),
			))
		},
		snare: { arg self;
			StepEvent.newFrom((
				instrument: \playersec,
				bufnum: [
					BufDef('fix3/snare1.flac'),
					BufDef('my3/snare2.flac'),
					BufDef('fix4/snare1.flac'),
					BufDef('fix1/snare.flac'),
				].choose,
				pos:0.04,
				speed: rrand(1/2,2),
				sustain: rrand(0.051,0.2),
			))
		},
		hat: { arg self;
			StepEvent.newFrom((
				instrument: \playersec,
				bufnum: [
					BufDef('fix3/hat1.flac'),
					BufDef('fix1/hat.flac'),
					BufDef('fix4/hat2.flac'), 
					BufDef('fix4/hat1.flac'),
				].choose,
				pos:0.04,
				speed: rrand(1/2,2),
				sustain: rrand(0.051,0.2),
			))
		},
	);

	~kitgen.patkit = (
		kick: { arg self;
			StepEvent.newFrom(~kitgen.chooseFromKit([0,1,2,3,12][rrand(0,4)]).copy.putAll((
				pos:0.04,
				speed: rrand(1/2,2),
				sustain: rrand(0.051,0.2),
			)))
		},
		snare: { arg self;
			StepEvent.newFrom(~kitgen.chooseFromKit(rrand(0,3)+4).copy.putAll((
				pos:0.04,
				speed: rrand(1/2,2),
				sustain: rrand(0.051,0.2),
			)))
		},
		hat: { arg self;
			StepEvent.newFrom(~kitgen.chooseFromKit(rrand(0,3)+8).copy.putAll((
				pos:0.04,
				speed: rrand(1/2,2),
				sustain: rrand(0.051,0.2),
			)))
		},
	);
	
)

// END
PatKitDef(\algokit).edit

(
// predefined
Pdef(\zdrums, 
	Plazy({ arg ev;
		var kits = (
			kicks: 4.collect({ ~kitgen.patkit.kick.value }),
			snares: 4.collect({ ~kitgen.patkit.snare.value }),
			hats: 4.collect({ ~kitgen.patkit.hat.value }),
		);
		var scores = (
			kicks: 4.collect({ ~scorelib.hiphop.kick.value }),
			snares: 4.collect({ ~scorelib.hiphop.snare.value }),
			hats: 4.collect({ ~scorelib.hiphop.hat.value }),
		);
		var tracks = ();
		kits.keys.do { arg key;
			[ scores[key], kits[key] ].flop.pairsDo { arg pair, idx;
				var a, b;
				#a, b = pair;
				tracks[key] = tracks[key].add(a <> b)
			}
		};
		Pseq([
			Pfindur(6,
				Ppar([
					Pbind(\dur, Pkey(\dur) * 1) <> tracks[\kicks][0],
					tracks[\snares][0],
					tracks[\hats].keep(2),
					Pbind(
						\instrument, \blik2,
						\freq, 200,
						\dur, 1,
						\amp, 0.1
					);
				].flat)
			),
			Pfindur(2,
				Ppar([
					tracks[\kicks].keep(4).collect({ arg x; Pbind(\dur, Pkey(\dur) * 1) <> x }),
					//tracks[\snares][0],
					tracks[\hats].keep(4),
				].flat)
			),
		],1);
	}).loop(1),
).play;
)

(
// patkit
Pdef(\xdrums, Ppar([
	3.collect {
		~kitgen.patkit.kick.value.asPattern <> 
		Pseq([
			Pfindur(4,~scorelib.hiphop.kick.value),
			Pfindur(4,~scorelib.hiphop.kick.value),
		],inf)
	},
	1.collect {
		~kitgen.patkit.snare.value.asPattern <> ~scorelib.hiphop.snare.value
	},
	1.collect {
		~kitgen.patkit.hat.value.asPattern <> 
		Pseq([
			Pfindur(4,~scorelib.hiphop.hat.value),
			Pfindur(4,~scorelib.hiphop.hat.value),
		],inf)
	},
	Pseq([
		Rest(8),
		2.collect {
			~kitgen.patkit.hat.value.asPattern <> 
			Pfindur(8, Pseq([
				Pfindur(4,~scorelib.hiphop.hat.value),
				Pfindur(4,~scorelib.hiphop.hat.value),
			],inf))
		},
	].flat,inf)
].flat)).play;
)

(
// simple
Pdef(\xdrums, Ppar([
	3.collect {
		~kitgen.simple.kick.value.asPattern <> 
		Pseq([
			Pfindur(4,~scorelib.hiphop.kick.value),
			Pfindur(4,~scorelib.hiphop.kick.value),
		],inf)
	},
	1.collect {
		~kitgen.simple.snare.value.asPattern <> ~scorelib.hiphop.snare.value
	},
	1.collect {
		~kitgen.simple.hat.value.asPattern <> 
		Pseq([
			Pfindur(4,~scorelib.hiphop.hat.value),
			Pfindur(4,~scorelib.hiphop.hat.value),
		],inf)
	},
	Pseq([
		Rest(8),
		2.collect {
			~kitgen.simple.hat.value.asPattern <> 
			Pfindur(8, Pseq([
				Pfindur(4,~scorelib.hiphop.hat.value),
				Pfindur(4,~scorelib.hiphop.hat.value),
			],inf))
		},
	].flat,inf)
].flat)).play;
)



(
SynthDef(\bassgen, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = 4.collect({
		LFSaw.ar(freq + rrand(0.001,0.05))
	});
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

Pbind
);
