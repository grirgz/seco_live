
// xTAGS: perc, echo, metallic, pdef, klank
~size = 8;
Pdef(~name +++ \pre, Pbind(
	\freq, 700,
	\isRest, false,
	\freqs, Pseq([
		Pfunc({
			[ { 520.rand + 50 } ! ~size ]
		}),
	],inf).trace,
	\amps, Pseq([
		Pfunc({
			[ { 0.1.rand + 0.1 } ! ~size ]
		}),
	],inf),
	\decays, Pseq([
		Pfunc({
			[ { 0.1.rand + 0.1 } ! ~size ]/100
		}),
	],inf),
	//Pseq([1/8,1/2,1/4],inf).stutter(16),
	\imprate, Pwhite(0.4,8),
	\adsr, Pseq([
		//Pfuncn({
		//	[ Env.adsr(0.0001,0.1,0.8,2.1.rand+9.5,1,-8) ]
		//},1),
		Pfuncn({
			[ Env.adsr(0.0001,0.1,0.8,0.2,1,-8) ]
		},1),
	],inf).stutter(16),
	\sustain, Pseq([
		Prand([
			Pseq([
				0,0,0,0, 1/2,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			
			Pseq([
				0,0,0,0, 0,0,1/4,0,
				0,0,0,0, 0,0,0,0,
			],1),
			
			Pseq([
				0,0,0,0, 0,0,0,1/8,
				0,0,0,0, 0,0,0,0,
			],1),

			Pseq([
				0,0,0,0, 1/8,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 0,0,0,0,
				1/8,0,0,0, 0,0,0,0,
			],1),
		],7),

		0,0,0,0, 0,0,0,0,
		1/8,0,1/8,0, 1/8,0,0,1/8,
	],inf).stutter(1),
	//\isRest, Pkey(\sustain) <= 0,
	\isRest, Pfunc({ arg ev; ev[\sustain] <= 0 }).trace,
	//\what, Pfunc({ arg ev; ev.postln; 1 }),
	\dur, 1/8,
).trace);
