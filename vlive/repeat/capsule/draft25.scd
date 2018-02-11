
(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				0,5,2,3,1,-12,-5,1,-2,0,1,
			],inf),
			\legato, Pseq([
					4,0,0,0, 0,0,1,1,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\out, BusDef(\mixer3, \audio),
			\amp, 0.1 * Pseq([1,1],inf),
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				80,70,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.4* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			\octave, 4,
			\sustain, 0.1,
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				//10,9,8,10,
				\r
			],inf),1),
			\isRest, Pseq([
				1,0,1,1, 0,0,0,0,
				1,0,0,1, 0,1,1,0,
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, 50,
			\delay, 0.0001,
			\gain, 0.3/3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx2, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.9/4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


(
SynthDef(\gameboy, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.7);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/2 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq((1..8)),
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx2, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx2, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		Pmono(\gameboy,
			\inbus, BusDef(\fx2, \audio),
			\samplerate, ~pmodenv.(Pseq([1,0.1,0.0004,0.03,0.05],inf), 1,1,1),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
SynthDef(\fxknife, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = CombL.ar(sig, 4/~t, 1/8/~t,1/~t) + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/2 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.7);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/2 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	sig = LocalIn.ar(2) * \fb.kr(0.2);
	sig = sig + in;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	//sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.kr(8*~t) * 1 + 1 ) * ( SinOsc.ar(208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.1*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	//sig = RLPF.ar(sig, SinOsc.kr(4*~t).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);

	// dist

	sig1 = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/4);
	sig = SelectX.ar(\distmix.kr(0.18), [sig, sig1]);

	// delay

	sig = DelayC.ar(sig, 2, 1/3/~t)+sig;

	// limiter

	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\gain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part_drum).reset;
);

(
SynthDef(\riseflang, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * EnvGen.kr(Env([1,1.02,1],[0.01,0.8]), 1);
	freq = freq * [1,4.000001,2.00001];
	sig = LFSaw.ar(freq);
	sig = LocalIn.ar(2) * \fb.kr(0.5) + sig;
	sig = DelayC.ar(sig, 1, XLine.kr(0.001,1,2/~t)) + sig;
	sig = DelayC.ar(sig, 1, XLine.kr(0.000123,1,2/~t)) + sig;
	sig = DelayC.ar(sig, 1, XLine.kr(0.0000123,1,2/~t)) + sig;
	sig = sig / 4;
	sig = ( sig*\distamp.kr(10) * XLine.kr(32,1/8,2) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, EnvGen.kr(Env([110,6200,12001],[0.1,0.8]), 1), \rq.kr(0.5));
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [-0.001,0,0.002], amp).mean;
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \riseflang,
			\note, Pseq([
				1,0,1,-5,
			],inf),
			\sustain, 1/8/~t,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \default,
			\freq, Pwhite(100.0,10000),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\fxknife,
			\inbus, BusDef(\fx2, \audio),
			//\samplerate, ~pmodenv.(Pseq([1,0.1,0.0004,0.03,0.05],inf), 1,1,1),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	~master.();
Pdef(\part_drum, Pdef(\drumsplop, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				70,60,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1/4,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.8* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
			Pseq([
				
				//Pmono(\gain,
					//\inbus, BusDef(\fx1, \audio),
					//\freq, 200,
					////\out, BusDef(\mixer6, \audio),
					//\distamp, 50,
					//\delay, 0.0001,
					//\gain, 0.2,
					//\dur, Pseq([1],3),
					//\amp, 0.1,
				//),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						Pser([
							0
						],1),
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
			],inf),
	])
)).play;
)

Pdef(\part).stop;


/////////////////////////////////////////////////////////

(
SynthDef(\infx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fxknife4fil, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(1341) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	sig = LPF.ar(sig, \lpf.kr(10000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part_drum).reset;
)

(
	~master.();
Pdef(\part_drum, Pdef(\drumsplop, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				70,60,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1/4,
				\isRest, true,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.8* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \riseflang,
			\note, Pseq([
				1,0,1,-5,
			],inf),
			\sustain, 1/~t,
			\dur, 2,
			\octave, 3,
			\amp, 0.4,
			\out, BusDef(\fx1, \audio),
		),
			Pseq([
				
				//Pmono(\gain,
					//\inbus, BusDef(\fx1, \audio),
					//\freq, 200,
					////\out, BusDef(\mixer6, \audio),
					//\distamp, 50,
					//\delay, 0.0001,
					//\gain, 0.2,
					//\dur, Pseq([1],3),
					//\amp, 0.1,
				//),
				Pmono(\fxknife4,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],7),
					\amp, 0.1,
				),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],1),
					\amp, 0.1,
				),
			],inf),
	])
)).play;
)

(
	~master.();
Pdef(\part_drum, Pdef(\drumsplop, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.8* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
				\isRest, true,
			)),
		Pbind(
			\instrument, \riseflang,
			\note, Pseq([
				1,0,1,-5,
			],inf),
			\sustain, 1/~t,
			\dur, 2,
			\octave, 3,
			\amp, 0.4,
			\out, BusDef(\fx1, \audio),
		),
			Pseq([
				
				//Pmono(\gain,
					//\inbus, BusDef(\fx1, \audio),
					//\freq, 200,
					////\out, BusDef(\mixer6, \audio),
					//\distamp, 50,
					//\delay, 0.0001,
					//\gain, 0.2,
					//\dur, Pseq([1],3),
					//\amp, 0.1,
				//),
				Pmono(\fxknife2,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.4,
					\dur, Pseq([1/2],7),
					\amp, 0.1,
				),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],1),
					\amp, 0.1,
				),
			],inf),
	])
)).play;
)

(
	~master.();
Pdef(\part_drum, Pdef(\drumsplop, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				70,60,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1/4,
				\isRest, true,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.8* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \riseflang,
			\note, Pseq([
				1,0,1,-5,
			],inf),
			\sustain, 1/~t,
			\dur, 2,
			\octave, 3,
			\amp, 0.4,
			\out, BusDef(\fx1, \audio),
		),
			Pseq([
				
				//Pmono(\gain,
					//\inbus, BusDef(\fx1, \audio),
					//\freq, 200,
					////\out, BusDef(\mixer6, \audio),
					//\distamp, 50,
					//\delay, 0.0001,
					//\gain, 0.2,
					//\dur, Pseq([1],3),
					//\amp, 0.1,
				//),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 5,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],7),
					\amp, 0.1,
				),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],1),
					\amp, 0.1,
				),
			],inf),
	])
)).play;
)

Pdef(\part_drum).clear
Pdef(\part).clear
(
	~master.();
Pdef(\part_drum, Pdef(\drumsplop, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				70,60,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1/4,
				\isRest, true,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.8* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \riseflang,
			\note, Pseq([
				1,0,1,-5,
			],inf),
			\sustain, 1/8/~t,
			\dur, 2,
			\octave, 3,
			\amp, 0.4,
			\out, BusDef(\fx2, \audio),
		),
		Pbind(
			\instrument, \default,
			//\freq, Plazy({ arg ev;
				//Pseq([
					//exprand(40.0!16,7424).sort,
				//].flat,inf);
			//}).loop,
			\note, Pseq([
				Pseq([
					rrand(0!8,44),
				].flat,inf),
			],inf),
			\octave, 3,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,1,1,
				1,1,0,1, 1,0,1,1,
				1,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
				Pmono(\fxknife4fil,
					\inbus, BusDef(\fx2, \audio),
					\freq, 200,
					\fb,0.1,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 40,
					\lpf, Pseg(Pseq([90,17000],inf),8),
					\delay, 0.1001,
					\gain, 0.3,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
			Pseq([
				
				//Pmono(\gain,
					//\inbus, BusDef(\fx1, \audio),
					//\freq, 200,
					////\out, BusDef(\mixer6, \audio),
					//\distamp, 50,
					//\delay, 0.0001,
					//\gain, 0.2,
					//\dur, Pseq([1],3),
					//\amp, 0.1,
				//),
				Pmono(\fxknife4,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],7),
					\amp, 0.1,
				),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],1),
					\amp, 0.1,
				),
			],inf),
	])
)).play;
)
