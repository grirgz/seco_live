~t = 150/4/60; TempoClock.default.tempo = ~t;
// soul love

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				//1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				//0,0,1,0, 
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				//1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,1, 0,0,1,1,
				1,1,1,1, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				//0,0,1,0, 
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,1,0,0, 0,1,0,1,
				0,1,0,0, 0,0,1,0,
				0,0,0,1, 0,1,0,1,
				0,1,0,0, 0,0,1,1,
			],inf).coin.not,
			\sustain, 0.041,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/8,
			\dur, 1/8,
		)),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					//1,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,1, 0,0,1,1,
					1,1,1,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					//0,0,1,0, 
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
			
					0,1,0,0, 0,1,0,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,1,0,1,
					0,1,0,0, 0,0,1,1,
				],inf).coin.not,
				\sustain, 0.041,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\velamp, 1/8,
				\dur, 1/8,
			)),
		]),
		
	])
)).play;
);

ClipTimeline(\suft91).edit
ClipTimeline(\suft91).clear
Param(ClipTimeline(\suft91).editor.clipEditor.model,\sustain).get
Param(ClipTimeline(\suft91).editor.clipEditor.model,\event_dropdur, ControlSpec(0,1,\lin)).get
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(100 * ( SinOsc.ar(0.1 * ( SinOsc.ar(1/4) * 1 + 1 )) * 1 + 1 )) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
ParamProto.init(true)
ClipTimeline(\suft91).clear

WindowDef(\bla, {
	HLayout(*[TextField().string_(""),BasicButton()])
}).front
[1].addAll([2,3])
