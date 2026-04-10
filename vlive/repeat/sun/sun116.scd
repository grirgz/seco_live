
(
~t = 139/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/fxsimple.scd");
FileSystemProject.load("sndlib/synthbasic.scd");
)

(
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\rq, 0.5,
			\envamt, 124,
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, 0.91,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\rq, 0.5,
			\envamt, 124,
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, 0.91,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf),
			\rq, 0.5,
			\envamt, 124,
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, 0.91,
			\dur, 1/8/2,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,

			//\vcomod, 0.1,
			//\vcomod, ~pmodsynth.({ SinOsc.kr(8) }),
			\pwidth, 0.5,
			\pwidth, Pseg(Pseq([0,1],inf),8),
			\pulse, 0.5,
			\saw, 0.5,
			\vcfmod, 0,
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf),
			\rq, 0.5,
			\envamt, Pseg(Pseq([50,200,400],inf),8,\exp),
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.8,0.1],1),4).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \reese,
			\fspread, 0.034000000208616,
			\fspread, Pseg(Pseq([0.004,0.02,0.051],inf),16,\exp),
			\distamp, 10.0,
			\distpostamp, 0.5,
			\note, Pseq([
				Pser([
					0
				],8*16),
				Pser([
					12,0,
				],8*16),
			],inf),
			\octave, 3,

			//\vcomod, 0.1,
			//\vcomod, ~pmodsynth.({ SinOsc.kr(8) }),
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf),
			\rq, 0.5,
			\lpadsramt, Pseg(Pseq([90,200,400],inf),8,\exp),
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.8,0.1],1),Pseq([15,1],inf)).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \reese,
			\fspread, 0.034000000208616,
			\fspread, Pseg(Pseq([0.004,0.02,0.051],inf),16,\exp).trace(prefix:"fspread:"),
			\distamp, 10.0,
			\distpostamp, 0.5,
			\note, Pseq([
				0,0,0,0, -4,-4,0,0,
			],inf)-3,
			\octave, 3,

			//\vcomod, 0.1,
			//\vcomod, ~pmodsynth.({ SinOsc.kr(8) }),
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf),
			\rq, 0.5,
			\lpadsramt, Pseg(Pseq([90,200,400],inf),8,\exp).trace(prefix:"lpadsramt:"),
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.8,0.1],1),Pseq([15,1],inf)).loop.trace(prefix:"legato:"),
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \reese,
			\fspread, 0.034000000208616,
			\fspread, Pseg(Pseq([0.004,0.02,0.051],inf),16,\exp).trace(prefix:"fspread:"),
			\distamp, 10.0,
			\distpostamp, 0.5,
			\note, Pseq([
				//0,0,0,0, -5,-5,0,0,
				//0,-5,-5+12,-5, -5,-5,0,0,
				//0,0,0,0, -5,-5,0,0,
				//0,-5,-5+12,-5, -5,-5,0,0,
				Pswitch1(
					[
						Ppatlace(
							8.collect { arg idx;
								Prand([
									0,0,0,-5,0,12,-5,-5+12,
								],inf).stutter(8+idx*8)
							}
						,inf),
						Pser([
							//0,-5,-5+12,-5, -5,-5,0,0,
							1,
							-3,
							3,
						],inf).stutter(8),
					],
					Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],3),
						1,1,1,1, 1,1,1,1,
					],inf),
				)
			],inf),
			\octave, 3,

			//\vcomod, 0.1,
			//\vcomod, ~pmodsynth.({ SinOsc.kr(8) }),
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf),
			\rq, 0.5,
			\lpadsramt, Pseg(Pseq([90,200,400],inf),8,\exp).trace(prefix:"lpadsramt:"),
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.8,0.1],1),Pseq([15,1],inf)).loop.trace(prefix:"legato:"),
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,0,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \rolandreese,
			\fspread, 0.034000000208616,
			\fspread, Pseg(Pseq([0.004,0.02,0.051],inf),16,\exp).trace(prefix:"fspread:"),
			\distamp, 10.0,
			\distpostamp, 0.5,
			\note, Pseq([
				//0,0,0,0, -5,-5,0,0,
				//0,-5,-5+12,-5, -5,-5,0,0,
				//0,0,0,0, -5,-5,0,0,
				//0,-5,-5+12,-5, -5,-5,0,0,
				Pswitch1(
					[
						Ppatlace(
							16.collect { arg idx;
								Prand([
									0,0,0,-5,0,12,-5,-5+12,
								],inf).stutter(8+idx*8)
							}
						,inf),
						Pser([
							//0,-5,-5+12,-5, -5,-5,0,0,
							1,
							-3,
							3,
						],inf).stutter(8),
					],
					Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],6),
						Pseq([
							1,1,1,1, 1,1,1,1,
						],2),
					],inf),
				)
			],inf),
			\octave, 3,

			//\vcomod, 0.1,
			//\vcomod, ~pmodsynth.({ SinOsc.kr(8) }),
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf)*2,
			\rq, Pseg(Pseq([0.5,0.05,1],inf),8,\exp),
			\kbamt, 0,
			\lpadsramt, Pseg(Pseq([90,200,400],inf),8,\exp).trace(prefix:"lpadsramt:"),
			\lpadsr, Pseq([
				[ Env.adsr(0.04,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.8,0.1],1),Pseq([15,1],inf)).loop.trace(prefix:"legato:"),
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,0,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \rolandreese,
			\fspread, 0.034000000208616,
			\fspread, Pseg(Pseq([0.004,0.02,0.051],inf),16,\exp),
			\distamp, 10.0,
			\distpostamp, 0.5,
			\note, Pseq([
				//0,0,0,0, -5,-5,0,0,
				//0,-5,-5+12,-5, -5,-5,0,0,
				//0,0,0,0, -5,-5,0,0,
				//0,-5,-5+12,-5, -5,-5,0,0,
				Pswitch1(
					[
						Ppatlace(
							16.collect { arg idx;
								Prand([
									0,0,0,-5,0,12,-5,-5+12,
								],inf).stutter(8+idx*8)
							}
						,inf),
						Pser([
							//0,-5,-5+12,-5, -5,-5,0,0,
							1,
							-3,
							3,
						],inf).stutter(8),
					],
					Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],6),
						Pseq([
							1,1,1,1, 1,1,1,1,
						],2),
					],inf),
				)
			],inf),
			\octave, 3,

			//\vcomod, 0.1,
			//\vcomod, ~pmodsynth.({ SinOsc.kr(8) }),
			\lpf, Pexprand(4,20.0,inf).stutter(4),
			\lpf, Pseq([
				3,20,10,10,
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				Pseq([
					3,Prand([5,10,20,15],3),
					5,5,5,5,
					5,5,5,5,
					Prand([5,5,5,10],4),
				],7),
			],inf)*2,
			\rq, Pseg(Pseq([0.5,0.05,1],inf),8,\exp),
			\kbamt, 0,
			\lpadsramt, Pseg(Pseq([90,200,400],inf),8,\exp),
			\lpadsr, Pseq([
				[ Env.adsr(0.04,0.3,0.7,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.8,0.1],1),Pseq([15,1],inf)).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,0,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,0,1,1,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);


/// drums
(
Pdef(\part2, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],14),
				0,0,1,1,
				0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,0,
			],inf).coin.not,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[30].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,1,
				],inf),
				1,1,1,0,
				1,1,0,0,
				1,1,1,1,
			],inf).coin.not,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[249].value,
			\bufnum, ~buflib.foley1[270].value,
			//\bufnum, ~buflib.foley1[334].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				//1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\speed, 0.7,
			\legato, 1.52,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[249].value,
			\bufnum, ~buflib.foley1[270].value,
			\bufnum, ~buflib.foley1[334].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,1,0,0,
				0,1,0,0,
				0,0,0,1,
				0,1,0,0,
			],inf).coin.not,
			\legato, 0.81,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 0.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[365].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 0.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[171].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\basstrack2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,0.3]+0,inf),8),
			\pos, 0.9,
			\speed, 0.81,
			\legato, 0.81,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.01) ],
			],inf),
			\dur, 1/8/2,
			\gain, 1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fxmultishift,
			\inbus, BusDef(\basstrack2),
			\mix, 0.71,
			\fspread, 0.1,
			\shift, PmodEnv(Pseq([1,0.25*~t],1), 8,\exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
		//Pmono(\fx_freqshift,
			//\inbus, BusDef(\basstrack2),
			//\mix, 0.51,
			//\shift, -80,
			//\dur, 1,
			//\amp, 0.1,
		//),

	])
)).play;
);


(
SynthDef(\fxmultishift, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	20.do { arg idx;
		sig = FreqShift.ar(sig, \shift.kr(100)) + sig / 2;
	};
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fxmultishift, { arg out=0, gate=1;
	var sig;
	var num = 20;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + num.collect { arg idx;
		FreqShift.ar(sig, \shift.kr(100) * (idx/num*\fspread.kr(1)+1));
	}.mean;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
