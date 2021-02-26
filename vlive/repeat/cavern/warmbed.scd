
~swing = 0.3;
~t = 205/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[101].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8 + 0.1,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[242].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[868].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1705].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8 + 0.06,
			\gain, 0.11,
			\lag, 0.04,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[296].value,
			\isRest, Pseq([
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1,0, 0,1,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0, 0,0,1, 
				0,0,0, 1,0,1, 
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[661].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0.5,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0.5,1,0,
				0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\speed, Pseq([1,0.7],inf),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[740].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([1,0.7],inf),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);



(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\isRest, Pseq([
				0.8,
			],inf).coin.not,
			\sustain, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\lag, 0.4,
			\gain, 0.11 * Pseq([1,Pwhite(0.4,0.8,1)],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1268].value,
			\isRest, Pseq([
				0.8,
			],inf).coin.not,
			\sustain, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\lag, 0.4,
			\gain, 0.21 * Pseq([1,Pwhite(0.4,0.8,1)],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2325].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);






(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);



(
	// hurlement de chevres mort vivantes
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/4/8/~t, 0, Dseq([
		1,0, 1,0,
		1,0, 1,0,
		1,1, 1,1,
		1,1, 1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,0.7), gate, doneAction:0);
	env2 = EnvGen.kr(Env.adsr(0.2,0.7,1.8,0.04), gate, doneAction:0) + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		1,0,3,0,
	],inf)).midiratio * 10 * env2;
	sig = LinCongL.ar(freq * (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 ));

	sig = sig.tanh;
	sig = sig * 4;
	sig = sig * env1;
	//sig = sig * Line.kr(0.001,1,16);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play(BusDef(\sendbus2).index,2);
);
Ndef(\plop).quant=2

Ndef(\plop).stop;

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/~t, 0, Dseq([
		1,0,0,0,
		1,1,0,1,
		1,0,1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,4.7), gate, doneAction:0) * 0.41 + 0.01;
	env2 = EnvGen.kr(Env.adsr(0.1,0.7,0.1,0.04), gate, doneAction:0) * [0.1,0.4,0.9]  + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 70 * env2;
	sig = LinCongL.ar(freq *.t (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig.debug("ssig");
	sig.shape.debug("sshape");
	//sig = 1;
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig.shape.debug("sawshape");
	//sig = 1;
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	//sig = RLPF.ar([ sig ], 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 )).mean;
	//sig = BPF.ar([sig], 400 * ( (1..8)/8 ) * [ env2 ], 0.1) / 4 + ([ sig ]/34);
	//sig = LPF.ar(sig, 99);
	sig.shape.debug("filshape");

	sig = sig.tanh;
	sig = sig * 4;
	sig = sig * env1;

	sig = sig.collect({ arg x; x.sum });
	sig.shape.debug("ishape");
	//sig = PanAz.ar(sig.size, sig, {LFNoise1.kr(( 1/2 ).rand).range(0,2.0)} ! sig.size).flop.sum;
	sig.shape.debug("shape");
	sig = Pan2.ar(sig, {LFNoise1.kr(( 1/2 ).rand).range(-1.0,1.0)} ! sig.size, amp).sum;
	sig.shape.debug("eshape");
	//sig = sig.mean;
	//sig = sig* 2;
	sig = sig/ 2;
	sig.shape.debug("e2shape");
	sig.debug("esig");
}).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([

		Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 0,  3, 7  ]+1,
				[ 0,  3, 7  ]+4,
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2)*4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 0,  3, 7,12  ]+1,
				[ 0,  3, 7,12 ]+4,
				//[ 1,  5, 11, 2  ],
				//[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf)*4,
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([

		Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2)*4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 0.2,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf)*4,
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus3, \audio),
		),
		PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					Pseq([
						1,0.3,0.51,
					],1),
					Pseq([
						1,0.7,
					],1),
					Pseq([
						1,0.7,0.21,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
			\octave, 2,
			\dur, 1/4,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([
		
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.07,
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[740].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0.5,0,
				0,0,0.5,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([1,0.7],inf),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[293].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0.5,1,0.5,
				1,0,1,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[868].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1705].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8 + 0.06,
			\gain, 0.11,
			\lag, 0.04,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[740].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,

				1,0,0,0, 0,0,0.5,0,
				0,0,0.5,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([1,0.7],inf),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[293].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0.5,1,0.5,
				1,0,1,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[868].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1705].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8 + 0.06,
			\gain, 0.11,
			\lag, 0.04,
		),
		
	])
)).play;
);
