
(
Pdef(\part, Pdef(\melo, 
		Pbind(
			\instrument, \fmbell,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
			],inf),
			//\dur, 1/1 * Pseq([4,1,3,4, 4,1,5,2].normalizeSum*4,inf),
			\amp, 0.1/5,
		),
).keep(1)).play;
ProtoDef(\piano).startControl(Pdef(\melo))
);
( 'instrument': \default, 'dur': 1, 'amp': 0.1, 'midinote': 55  ).play
