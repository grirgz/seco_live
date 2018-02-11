
(
SynthDef(\melo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFPulse.ar(freq * [1,1/2,2] * [[1,1.01]]).sum;
	sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig = ( sig*3 ).tanh * 2 + sig;

	sig1 = LFPulse.ar(freq * [1,1/2,2] * [[1, SinOsc.kr(1).range(1,1.002)]]).sum;
	sig1 = RLPF.ar(sig1, \lpfr2.kr(8.1) * freq, \rq2.kr(0.5));
	sig1 = ( sig1*3 ).tanh * 2 + sig1;

	sig = ( sig1 * \osc2gain.kr(1) ) + ( sig * \osc1gain.kr(1) );

	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.4,0.01),gate,doneAction:2);
	sig= sig.debug("kjk");
	sig = sig / 3;
	sig = Pan2.ar(sig, pan, amp).sum;
	sig= sig.debug("kjk2");
	Out.ar(out, sig);
}).add;
SynthDef(\noiserise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,2],[2.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0.01,[3,2]/2,2],[2.1,0.8],4), 1) * LFNoise1.kr([1,1.2]*3).range(1,1.4);
	sig = WhiteNoise.ar(freq);
//	sig = BPF.ar(sig, env2*4100 * [1/2,1/3,1], 0.21).sum;
//	sig = LPF.ar(sig, env1*2000);
	sig = BPF.ar(sig, 4000*[1,2.123,3.34,4.12], env2).mean;
	sig = sig * EnvGen.kr(Env([0,1,0],[1/~t,0.01],4), 1, doneAction:2);
	sig = sig /28;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	~trans = 0;
	Pdef(\melobase,
		Pbind(
		)
	);
	Pdef(\melo, Pbind(
		\instrument, \melo,
		\note, Pseq([
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,6,5,3,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,\r,3,\r,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,\r,5,3,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,6,5,\r,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,6,\r,\r,6,
		],inf),
		\legato, Pseq([
			4.0,0.6,0.6,0.6,
			0.8,0.6,0.6,0.6,

		],inf),
		\ctranspose, ~trans,
		\osc2gain, 0,
		\octave, 3,
		\dur, 1/4,
		\amp, 0.1
	) <> Pdef(\melobase));


	Pdef(\melo2, Pbind(
		\instrument, \melo,
		\ctranspose, ~trans,
		\note, Pseq([
			0,\r,\r,\r,\r,\r,5,3,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,6,5,\r,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,6,\r,\r,6,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,6,5,3,
			0,\r,\r,\r,\r,\r,\r,\r,
			0,\r,\r,\r,\r,\r,3,\r,
			0,\r,\r,\r,\r,\r,\r,\r,
			//Pseq([
			//	1,\r,\r,\r, \r,\r,3,\r,
			//	1,1,\r,\r, \r,2,\r,1,
			//	1,\r,1,\r, \r,2,\r,\r,
			//	1,1,\r,1, \r,2,\r,1,
			//	1,\r,\r,\r, 1,\r,\r,\r,
			//	1,1,\r,\r, \r,2,\r,1,
			//	1,\r,1,\r, \r,2,\r,\r,
			//	1,1,\r,1, \r,2,\r,1,
			//],inf),
		],inf),
		\legato, Pseq([
			2.0,0.6,0.6,0.6,
			0.8,0.6,0.6,0.6,

		],inf),
		\osc2gain, 1,
		\osc1gain, 0,
		\octave, 3,
		\dur, 1/4,
		\amp, 0.1
	));

	Pdef(\ridrums1, 
		Ppar([

			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				//\speed, 1.4,
				\sustain, Pseq([
					0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
					1.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
				],inf)/7,
				\gain, 1 * Pseq([
					0.5,0.3,0.3,0.3,
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
		])
	);

	Pdef(\ridrums2, 
		Ppar([

			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\gain, 1/1.5,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1/1.5,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\gain, 1/1.5,
			)),
			Pbind(
				\instrument, \snarebpf,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.1/3,0.1,0.8,0.1,1,-6) ]
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/4,
				\pan, 0.1,
				\amp, 0.1/1.5,
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				//\speed, 1.4,
				\sustain, Pseq([
					0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
					1.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
				],inf)/7,
				\gain, 1 * Pseq([
					0.5,0.3,0.3,0.3,
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
		])
	);

	Pdef(\ridrums3,  // fast
		Ppar([

			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1/1.5,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\gain, 1/1.5,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1/1.5,
			)),
			Pbind(
				\instrument, \snarebpf,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.1/3,0.1,0.8,0.1,1,-6) ]
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\pan, 0.1,
				\amp, 0.1/1.5,
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\sustain, 0.1,
				//\speed, 1.4,
				\sustain, Pseq([
					0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
					1.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
				],inf)/7,
				\gain, 1 * Pseq([
					0.5,0.3,0.3,0.3,
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
		])
	);
Pdef(\hats, 
	Ppar([
		
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,0,1,0, 1,0,1,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\sustain, 0.1,
			//\speed, 1.4,
			\sustain, Pseq([
				0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
				1.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1,
			],inf)/7,
			\gain, 1 * Pseq([
				0.5,0.3,0.3,0.3,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
	])
);
Pdef(\morehats, 
	Ppar([
		
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\pos, 0.21,
			\isRest, Pseq({[
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\sustain, Pseq([0.01,0.03],inf),
			\gain, Pseq([
				Pwhite(0.01,0.7,1),0.5,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
	])
);
);



(
Pdef(\emain, 
	Pseq([
		Pfindur(12,Ptpar([
			0,Pdef(\melo),
			4,Pdef(\hats),
			8,Pdef(\melo2),
			11, Pbind(
				\instrument, \noiserise,
				\degree, Pseq([0],inf),
				\legato, 1,
				\isRest, Pseq([
					1,
				],1).coin.not,
				\dur, 1,
				\amp, 0.1
			),
			11, PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					1,0,1,1, 0,1,1,0,
				].clump(8).choose}.dup(1).flat,1).coin.not,
				\sustain, 0.1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
		])),
		Pfindur(32,Ptpar([
			0,Pdef(\melo),
			0,Pdef(\melo2),
			0,Pdef(\ridrums2),
			7, Pbind(
				\instrument, \noiserise,
				\degree, Pseq([0],inf),
				\legato, 1,
				\isRest, Pseq([
					1,
				],1).coin.not,
				\dur, 1,
				\amp, 0.1
			),
			8,Pdef(\morehats),
			15, PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,1,0,1, 0,0,1,1,
				].clump(8).choose}.dup(1).flat,1).coin.not,
				\sustain, 0.2,
				\gain, 0.7,
				\dur, 1/8,
				\amp, 0.1,
			))
		
		])).loop,
		
	])
).play;
)


///////////////////////////// DRAFT

(
Pdef(\noiserise, Pbind(
	\instrument, \noiserise,
	\degree, Pseq([0],inf),
	\legato, 1,
	\isRest, Pseq([
		0,0,
		0,1,
	],inf).coin.not,
	\dur, 1,
	\amp, 0.1
)).play;
);


(
Pdef(\mainmelo, 
	Ppar([
		Pdef(\melo),
		Pdef(\melo2),
		
	])
).play;
)

(
Pdef(\melo, Pbind(
	\instrument, \melo,
	\note, Pseq([
		\r,\r,\r,\r,\r,\r,2,1,
	],inf),
	\legato, 0.6,
	\octave, 3,
	\dur, 1/4,
	\amp, 0.1
)).play;
);
(
Pdef(\melo, Pbind(
	\instrument, \melo,
	\note, Pseq([
		\r,\r,\r,\r,5,3,\r,\r,
	],inf),
	\legato, 0.6,
	\octave, 3,
	\dur, 1/4,
	\amp, 0.1
)).play;
)
(
Pdef(\melo, Pbind(
	\instrument, \melo,
	\note, Pseq([
		\r,\r,\r,\r,\r,\r,
	],inf),
	\legato, 0.6,
	\octave, 3,
	\dur, 1/4,
	\amp, 0.1
)).play;
);



ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).startControl(Pdef(\melead))
Pdef(\melead,Pbind(\instrument, \melead))

(
SynthDef(\melead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,142,1],[0.01,0.1]), 1);
	sig = LFPulse.ar(freq * [1,1.001]).sum;
	//sig = sig + FreqShift.ar(sig, freq*2);
	sig = sig + FreqShift.ar(sig, 0.1 * env1);
	sig = BPF.ar(sig, freq, \rq.kr(0.1) * env1);
	sig = sig * 0.7;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melead1, Pbind(
	\instrument, \melead,
	\note, Pseq([
		Pseq(
			{ [0,[7,6,5,3].choose] }.dup(4)
		,1),
	],inf),
	\rq, 0.01,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,0,
	],inf).coin.not,
	\legato, Pseq([0.7,0.3],inf),
	\dur, 1/8,
	\amp, 0.1
)).play;
);

Pdef(\melead1).stop;

(
SynthDef(\sale, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, speed=1, pos=0, doneAction=2, loop=1, bufnum;
	var sig;
	var phase;
	//sig = LFPulse.ar(freq * [1,1/2,1/4] * ( (1..8)/8*0.03+1 )).sum;
	//sig = ( sig * 1/2 ).tanh;
	//sig = CuspL.ar(freq * ( 1 + ( SinOsc.ar(freq) * 1 )));
	//sig = sig + CuspL.ar(freq,1);
	//speed = SinOsc.ar(100 * [1,1.01,2] * ( 1 + ( SinOsc.kr(1) * 1 )));
	//speed = LFTri.ar(1/4).lag(0.2)+1*4;
	//sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = EnvGen.ar(Env([0,1/25,0],[1,1]/8), \trigger.tr(1), timeScale:1, levelBias:pos) * BufFrames.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase+[0,5000]);
	sig = CombL.ar(sig, 0.1,1/40*[1,1.1] * ( 1 + ( SinOsc.ar(5 * ( 1 + ( SinOsc.kr(1/2) * 1 ))) * 1 )),1)+sig;
	sig = ( sig*100 ).tanh/13;
	//sig = sig/4 + BPF.ar(sig, freq,0.1,mul:15);
	sig = sig  *4*1;
	sig = HPF.ar(sig, 800);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sale, PmonoArtic( \sale,
	\degree, Pseq([7,6,5,3],inf),
	\bufnum, BufDef('fix4/snare1.flac'),
	\bufnum, BufDef('voices/02_moeten.flac'),
	\trigger,1,
	\octave, 5,
	\pos, 0.2,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,1,1, 1,1,1,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\dur, 1/8,
	\amp, 0.2
)).play;
);

(
	// test
Pdef(\emain, Ppar([
		Pfindur(16,Ptpar([
			//0,Pdef(\melo),
			//0,Pdef(\melo2),
			0,Pdef(\ridrums3),
			0,Pdef(\morehats),
		])).loop,

])).play;
)

(
SynthDef(\sale, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, speed=1, pos=0, doneAction=2, loop=1, bufnum;
	var sig;
	var phase;
	//sig = LFPulse.ar(freq * [1,1/2,1/4] * ( (1..8)/8*0.03+1 )).sum;
	//sig = ( sig * 1/2 ).tanh;
	//sig = CuspL.ar(freq * ( 1 + ( SinOsc.ar(freq) * 1 )));
	//sig = sig + CuspL.ar(freq,1);
	//speed = SinOsc.ar(100 * [1,1.01,2] * ( 1 + ( SinOsc.kr(1) * 1 )));
	//speed = LFTri.ar(1/4).lag(0.2)+1*4;
	//sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	//phase = EnvGen.ar(Env([0,1/25,0],[1,1]/8), \trigger.tr(1), timeScale:1, levelBias:pos) * BufFrames.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase+[0,5000]);
	sig = CombL.ar(sig, 0.1,1/40*[1,1.1] * ( 1 + ( SinOsc.ar(480 * ( 1 + ( SinOsc.ar(80*~t, 1/4 * 2pi) * 0.1 ))) * 0 )),4)+sig;
	sig = ( sig*100 ).tanh/13;
	//sig = sig/4 + BPF.ar(sig, freq,0.1,mul:15);
	sig = sig  *2*1;
	//sig = HPF.ar(sig, 800);
	sig = LPF.ar(sig, 15000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sale, PmonoArtic( \sale,
	\degree, Pseq([7,6,5,3],inf),
	\bufnum, BufDef('fix4/snare1.flac'),
	\bufnum, BufDef('voices/02_moeten.flac'),
	\trigger,1,
	\octave, 5,
	\pos, 0.2,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,1,1, 1,1,1,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\dur, 1/8,
	\amp, 0.2
)).play;
);

(
SynthDef(\sale, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, speed=1, pos=0, doneAction=2, loop=1, bufnum;
	var sig;
	var phase;
	sig = SinOsc.ar(freq) ;
	sig = CombL.ar(sig, 0.1,1/40*[1,1.1] * ( 1 + ( SinOsc.ar(480 * ( 1 + ( SinOsc.ar(80*~t, 1/4 * 2pi) * 0.1 ))) * 0 )),4)+sig;
	sig = ( sig*100 ).tanh/13;
	sig = sig  *2*1;
	sig = HPF.ar(sig, 80);
	sig = LPF.ar(sig, 15000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sale, PmonoArtic( \sale,
	\degree, Pseq([7,6,5,3],inf),
	\bufnum, BufDef('fix4/snare1.flac'),
	\bufnum, BufDef('voices/02_moeten.flac'),
	\trigger,1,
	\octave, 5,
	\pos, 0.8,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,1,1, 1,1,1,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\dur, 1/8,
	\amp, 0.2
)).play;
);



Pdef(\emain).play
(
SynthDef(\sale, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, speed=1, pos=0, doneAction=2, loop=1, bufnum;
	var sig;
	var phase;


	freq = freq * XLine.kr(1,4,10);

	sig = LocalIn.ar(2) * 1.7;
	sig = sig + LFSaw.ar(freq + [ [0,0.001] ] * [1,2,4,1/2] * ( 1 + ( SinOsc.ar(freq) * 1 )));
	sig = CombL.ar(sig, 0.1, 1/freq * [1,2,1/2] * SinOsc.ar(410 * [1,2,1.2,1/2]).range(1.01,1*[1,1.1,1.01]),10.1) + sig;
	sig = sig.sum;
	sig = sig.debug("ig");
	//sig = ( sig*100 ).tanh/13;
	//sig = sig/4 + BPF.ar(sig, freq,0.1,mul:15);
	//sig = sig  *1*1/4/4;
	sig = HPF.ar(sig, 800);
	sig = LPF.ar(sig, 15000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//pan = LFNoise1.kr((1..4)) * 0.4 + pan;
	sig = Pan2.ar(sig, pan, amp).sum;
	sig = sig.clip2(0.41)/4;
	LocalOut.ar(sig);
	sig = sig * 0.2;
	//sig = LPF.ar(sig, 7000);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sale, PmonoArtic( \sale,
	\degree, Pseq([7,6,5,3],inf),
	\degree, Pseq([
		Pseq(
			(1..8)-24
		,1),
	],inf),
	\degree, Pseq([
		Pseq(
			(1..24+24)-24
		,1),
	],inf),
	\bufnum, BufDef('fix4/snare1.flac'),
	\bufnum, BufDef('voices/02_moeten.flac'),
	\trigger,1,
	\octave, 5,
	\pos, 0.0,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,1,1, 1,1,1,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\dur, 1/8,
	\amp, 0.2
)).play;
);


//////////////

(
Pdef(\test, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Ndef(\localmax, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var osig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	osig = sig;

	sig = sig + ( LocalIn.ar(2) * \fb.kr(0.1) );
	sig = HPF.ar(sig, \hpf.kr(200));
	sig = FFT({ LocalBuf(2**10) }.dup(2), sig);
	//sig = PV_MagSquared(sig);
	//sig = PV_LocalMax(sig, MouseY.kr(0.01,5000,\exponential));
	//sig = PV_MagAbove(sig, MouseX.kr(0.01,5000,\exponential));

	    sig = PV_RandComb(sig, 0.95, Impulse.kr(0.4));

	sig = IFFT(sig) * 2;
	sig = sig * (-28.dbamp);
	sig = SelectX.ar(1, [osig, sig]);
	sig = Limiter.ar(sig);
	sig = sig * \gain.kr(1);
	LocalOut.ar(sig);
	sig;
}).play;
);

Ndef(\localmax).edit
(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Pseq([0,0,0,2],inf)*( 137/60 ),
	\out, BusDef(\sendbus0, \audio),
	\legato, 1,
	\dur, 2,
	\gain, 1/2,
	\amp, 0.1
)).play;
)

Pdef(\sale).stop
Pdef(\test).stop
