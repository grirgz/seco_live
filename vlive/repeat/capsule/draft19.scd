


/////////////////////////////////

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFsaw.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq);
	env1 = EnvGen.kr(Env([10000,2,800],[0.1,0.8]), 1);
	sig = RLPF.ar(sig, env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\sustain, 0.1,
	\dur, 1,
	\amp, 0.1,
)).play;
);


(
SynthDef(\bubblebub, {	|out=0, t_trig=0, attack=0.01, decay=0.08, pitchcurvelen=0.1, freq=300, doneAction=0, amp=0.1|
	var pitch, son;
	amp   = amp * EnvGen.ar(Env.perc(attack, decay).delay(0.003), t_trig, doneAction: doneAction);
	pitch = freq * EnvGen.ar(Env.new([0,0,1],[0,1]).exprange(1, 2.718), t_trig, timeScale: pitchcurvelen);
	son = SinOsc.ar(pitch);
	// high-pass to remove any lowpitched artifacts, scale amplitude
	son = HPF.ar(son, 500) * amp * 10;
	Out.ar(out, son);
}).store
)

x = Synth(\bubblebub);
x.set(\t_trig, 1); // run this line multiple times, to get multiple (very similar) bubbles!
x.free;
{ SinOsc.ar( EnvGen.kr(Env([900,80,700],[0.01,0.08]), 1) ) * EnvGen.kr(Env([0,1,0],[0.01,0.08]), 1, doneAction:2);  }.play




///////////////////////////////
// FM Bell

(
SynthDef(\fmbell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * \fmamp.kr(2) + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * 2.6629 * sig1 + 2.04);
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0], amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\chorus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.kr(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;

SynthDef(\chorusdist, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.kr(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\chorusdistlim, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.kr(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fmbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq / 4;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1; 
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 2.5 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	~master.();
Pdef(\part, Pdef(\plop, 
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
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		),
		Pmono(\chorus,
			\inbus, BusDef(\fx1, \audio),
			\delay, Pseq([
				0.003,
				0.00007,
			],inf).stutter(8),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


{ SinOsc.ar(300) * EnvGen.kr(Env([0,1,0],[0.01,0.01], [4,-4]), Impulse.kr(1)) * 0.1 !2  }.play


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				-12,0,
			],inf),
			\legato, 0.6,
			\dur, 1/1,
			\amp, 0.1 * Pseq([1,1],inf),
		);
	])
)).play;
)


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
			\gain, 0.3,
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
			\gain, 0.9,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)



(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				-5,0,0,0, 0,0,2,3,
				-3,0,0,0, 0,0,2,3,
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
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 4,
			\sustain, 0.1,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,8.01) ],
				//[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
			//],inf),
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				10,9,10,9,
			],inf),1),
			\isRest, Pseq([
				1,0,1,1, 0,0,0,0,
				1,0,0,1, 0,1,1,0,
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\sustain, 0.071 * Pseq([
				1,2,3,1,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\mixer4, \audio),
			\freq, 200,
			\distamp, 50,
			\delay, 0.0001,
			\gain, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx2, \audio),
			\out, BusDef(\mixer5, \audio),
			\freq, 200,
			\distamp, 40,
			\distpostamp, 1/1,
			\fb, 0.004,
			\distmix, 1,
			\delay, Pseq([
				0.01,
				0.01,
				0.00001,
			],inf),
			\modfreq, 4*~t,
			\modamp, 0.0101,
			\lpf, 9200,
			\hpf, ~pmodenv.(Pseq([18000,100,100,100],inf),8,1,1),
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

Pdef(\part).clear

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pstep(Pseq([
				-5,-5,-5,0, 2,2,2,3,
				-3,0,-3,-3, 3,0,2,3,
			],inf),1/4),
			\legato, Pseq([

					//7,0,0,0, 0,0,1,0,
					//4,0,0,0, 3,0,0,1,
					//7,0,0,0, 0,0,1,0,
					//1,0,4,0, 0,0,1,0,

					//7,0,0,0, 0,0,1,1,
					//3,0,0,1, 4,0,0,0,
					//7,0,0,0, 0,0,1,0,
					//1,0,1,1, 4,0,0,0,
					4,0,0,0, 0,0,0,0,
					1,1,6,0, 0,0,0,0,

					4,0,0,1, 0,0,1,0,
					2,0,0,0, 4,0,0,0,

					4,0,0,0, 3,0,0,0,
					0,0,6,0, 0,0,0,0,

					7,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,1,0,

					2,0,2,0, 3,0,0,0,
					4,0,0,0, 0,0,1,0,


			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\mixer3, \audio),
			\amp, 0.1 * Pseq([1,1],inf),
		),
			Pseq([
				Pfindur(24,Ppar([
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
				])),
				Ptpar([
					4, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							1,0,0,1, 0,0,0,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					6, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,0,1,0, 1,1,1,0,
							1,1,1,1, 1,1,1,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.2,
						],inf),
						\sustain, 0.05,
						\dur, 1/8,
						\amp, 0.1,
					)),
				]),
			],inf),
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 4,
			\sustain, 0.1,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,8.01) ],
				//[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
			//],inf),
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 5,
			\sustain, 0.1,
			\fmamp, ~pmodenv.(Pseq([1,2,1,4,1,5,2,10],inf), 2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.41) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				10,9,10,9,
			],inf),1),
			\out, BusDef(\fx2, \audio),
			\legato, Pseq([
				3,0,0,0,
				0.1,0.1,0.1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, 50,
			\delay, 0.0001,
			\gain, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx2, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.504,
			\distmix, 1,
			\delay, Pseq([
				0.01,
				0.01,
				0.00001,
			],inf),
			\modfreq, 4*~t,
			\modamp, 0.0101,
			\lpf, 9200,
			\hpf, ~pmodenv.(Pseq([100,100,100,100,18000],inf),8,1,1),
			\gain, 0.3,
			\gain, 0.13,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pfindur(32+8,
				Pbind(
					\instrument, \fmbass,
					\note, Pstep(Pseq([
						-5,-5,-5,0, 2,2,2,3,
						-3,0,-3,-3, 3,0,2,3,
					],inf),1/4),
					\note, Pstep(Pseq([
						-5,-5,-10,-5, -5,-5,-5,-5,
						-5,-5, -5,-5, -5,-5, -10,-5,
						-5,-5,-5,-5, -5,-5,-5,-5,
						-5,-5, -5,-5, -5,-5, -10,-5,
						-5,-5,-10,-5, -5,-5,-5,-5,
						-5,-5, -5,-5, -5,-5, -10,-5,
						-5,-5,-5,-10, -5,-5,-5,-10,
						-5,-5, -5,-5, -5,-5, -10,-5,
					],inf),1/8),
					\legato, Pseq([
						Plazy({ arg ev;
							var seqs = {
			
								var seq = [];
								seq = seq ++ { [
									[2,0],
									[1,1],
								].choose }.dup(3).flat;
								seq = seq ++ { [
									[2,0],
									[1,0],
									[1,1],
								].choose }.dup(1).flat;
								seq = seq ++ { [
									[2,0],
									[1,1],
								].choose }.dup(3).flat;
								seq = seq ++ { [
									[2,0],
									[1,0],
									[1,0],
								].choose }.dup(1).flat;
							}.dup(8).collect({ arg x; Pseq(x,1) });
							Pseq([
								seqs[0],
								seqs[1],
								seqs[0],
								seqs[2],
							],1);
						}).loop,
						2,0,1,1, 2,0,1,1,
						1,1,2,0, 2,0,1,0,
						2,0,1,1, 2,0,1,1,
						2,0,2,0, 2,0,1,0,
						1,1,1,1, 2,0,1,1,
						2,0,2,0, 2,0,1,0,
					],inf)*0.9,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					//\out, BusDef(\mixer3, \audio),
					\amp, 0.15,
				),
				
			),
			Event.silent(8)
		],inf),
			Pseq([
				Pfindur(24,Ppar([
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,1,0,0, 0,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
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
							0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
							0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,

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
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 1,1,0,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,

							0,0,1,0, 1,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,1, 1,0,1,0, 0,0,1,0, 1,1,0,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 1,1,1,0, 0,0,1,0, 1,1,0,1,

							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,1,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,

							0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,1,0,
							1,1,0,1, 1,1,0,1, 0,0,1,0, 1,0,1,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,1, 1,0,1,0, 0,0,1,0, 1,1,0,1,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.6,
						],inf),
						\sustain, 0.05,
						\dur, 1/16,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 9,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,

							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.6,
						],inf),
						\sustain, 0.10,
						\dur, 1/16,
						\amp, 0.1,
					)),
				])),
				Ptpar([
					4, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							1,0,0,1, 0,0,0,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					6, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,0,1,0, 1,1,1,0,
							1,1,1,1, 1,1,1,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.2,
						],inf),
						\sustain, 0.05,
						\dur, 1/8,
						\amp, 0.1,
					)),
				]),
			],inf),
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 4,
			\sustain, 0.1,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,8.01) ],
				//[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
			//],inf),
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
			\isRest, Pseq([
				0,0,1,0, 
				0,0,1,1, 
				0,1,1,0, 
			],inf).coin.not,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 5,
			\sustain, 0.1,
			\fmamp, ~pmodenv.(Pseq([1,2,1,4,1,5,2,10],inf), 2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.11) ],
				[ Env.adsr(0.1,0.1,0.8,0.41) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,1, 
				0,0,1,0, 
				0,1,1,0, 
				0,1,0,1, 
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				10,9,10,9,
			],inf),1),
			\out, BusDef(\fx2, \audio),
			\legato, Pseq([
				3,0,0,0,
				0.1,0.1,0.1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, 50,
			\delay, 0.0001,
			\gain, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx2, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.504,
			\distmix, 1,
			\delay, Pseq([
				0.01,
				0.01,
				0.00001,
			],inf),
			\modfreq, 4*~t,
			\modamp, 0.0101,
			\lpf, 9200,
			\hpf, ~pmodenv.(Pseq([100,100,100,100,18000],inf),8,1,1),
			\gain, 0.3,
			\gain, 0.13,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pfindur(32+8,
				Pbind(
					\instrument, \fmbass,
					\note, Pstep(Pseq([
						-5,-5,-5,0, 2,2,2,3,
						-3,0,-3,-3, 3,0,2,3,
					],inf),1/4),
					\note, Pstep(Pseq([
						-5,-5,-10,-5, -5,-5,-5,-5,
						-5,-5, -5,-5, -5,-5, -10,-5,
						-5,-5,-5,-5, -5,-5,-5,-5,
						-5,-5, -5,-5, -5,-5, -10,-5,
						-5,-5,-10,-5, -5,-5,-5,-5,
						-5,-5, -5,-5, -5,-5, -10,-5,
						-5,-5,-5,-10, -5,-5,-5,-10,
						-5,-5, -5,-5, -5,-5, -10,-5,
					],inf),1/8),
					\legato, Pseq([
						Plazy({ arg ev;
							var seqs = {
			
								var seq = [];
								seq = seq ++ { [
									[2,0],
									[1,1],
								].choose }.dup(3).flat;
								seq = seq ++ { [
									[2,0],
									[1,0],
									[1,1],
								].choose }.dup(1).flat;
								seq = seq ++ { [
									[2,0],
									[1,1],
								].choose }.dup(3).flat;
								seq = seq ++ { [
									[2,0],
									[1,0],
									[1,0],
								].choose }.dup(1).flat;
							}.dup(8).collect({ arg x; Pseq(x,1) });
							Pseq([
								seqs[0],
								seqs[1],
								seqs[0],
								seqs[2],
							],1);
						}).loop,
						2,0,1,1, 2,0,1,1,
						1,1,2,0, 2,0,1,0,
						2,0,1,1, 2,0,1,1,
						2,0,2,0, 2,0,1,0,
						1,1,1,1, 2,0,1,1,
						2,0,2,0, 2,0,1,0,
					],inf)*0.9,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					//\out, BusDef(\mixer3, \audio),
					\amp, 0.15,
				),
				
			),
			Event.silent(8)
		],inf),
			Pseq([
				Pfindur(24,Ppar([
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,1,0,0, 0,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
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
							0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
							0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,

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
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 1,1,0,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,

							0,0,1,0, 1,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,1, 1,0,1,0, 0,0,1,0, 1,1,0,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 1,1,1,0, 0,0,1,0, 1,1,0,1,

							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,1,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,

							0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,1,0,
							1,1,0,1, 1,1,0,1, 0,0,1,0, 1,0,1,1,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,1, 1,0,1,0, 0,0,1,0, 1,1,0,1,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.6,
						],inf),
						\sustain, 0.05,
						\dur, 1/16,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 9,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,

							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.6,
						],inf),
						\sustain, 0.10,
						\dur, 1/16,
						\amp, 0.1,
					)),
				])),
				Ptpar([
					4, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							1,0,0,1, 0,0,0,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					6, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,0,1,0, 1,1,1,0,
							1,1,1,1, 1,1,1,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.2,
						],inf),
						\sustain, 0.05,
						\dur, 1/8,
						\amp, 0.1,
					)),
				]),
			],inf),
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 4,
			\sustain, 0.1,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,8.01) ],
				//[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
			//],inf),
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
			\isRest, Pseq([
				0,0,1,0, 
				0,0,1,1, 
				0,1,1,0, 
			],inf).coin.not,
			\isRest, true,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 5,
			\fmamp, ~pmodenv.(Pseq([1,2,1,4,1,5,2,10],inf), 2),
			\fmamp, 10,
			\legato, 8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.41) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				10,9,10,9,
			],inf),1),
			\out, BusDef(\fx2, \audio),
			\legato, Pseq([
				3,0,0,0,
				0.1,0.1,0.1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, 50,
			\delay, 0.0001,
			\gain, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx2, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.504,
			\distmix, 1,
			\delay, Pseq([
				0.01, 0.01, 0.41, 0.41,   0.00001, 0.01, 0.01, 0.01,
				0.1, 0.1, 0.4, 0.1,   0.00001, 0.01, 0.00001, 0.01,
				0.01, 0.01, 0.00001, 0.01,   0.001, 0.01, 0.00001, 0.01,
				0.01, 0.01, 0.01, 0.41,   0.00001, 0.01, 0.01, 0.00001,
			],inf),
			\modfreq, 4*~t,
			\modamp, 0.0101,
			\lpf, 9200,
			\hpf, ~pmodenv.(Pseq([100,100,100,100,18000],inf),8,1,1),
			\gain, 0.3,
			\gain, 0.13,
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
)

////////////////////////////

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = EnvGen.kr(Env([200,4001,302,700,201],[0.1,0.8,0.4,0.4], loopNode:0, releaseNode:3), 1);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
~algofmenv = { arg freq=3200, pan=0, amp=0.1, gate=1;
	var sig;
	var op;
	var randfreq;
	var freqfac1 = \freqfac1.kr(1);
	var freqfac2 = \freqfac2.kr(1);
	var freqfacstr = Pseq([
		freqfac1, freqfac2
	],inf).asStream;

	op = { arg freq;
		[
			LFSaw.ar(freq),
			LFPulse.ar(freq),
			LFCub.ar(freq),
			SinOsc.ar(freq),
			WhiteNoise.ar,
		].choose * EnvGen.kr(
			Env([0, 1.0.rand, 2.0.rand, 1.0.rand, 0],[0.1.rand, 4.0.rand, 4.0.rand, 0.1.rand], {rrand(-5,5)}.dup(4), loopNode:0, releaseNode:3)
			, gate);
	};

	randfreq = {
		exprand(1/20,14000)* freqfacstr.next;
	};

	sig = op.(exprand(200, 14000) );

	rrand(5,20).do { arg idx;
		var algos = [
			{ op.(sig * exprand(0.01,2) + 1 * randfreq.value); }, // fm
			{ op.(sig * exprand(0.01,2) + 1 * randfreq.value) + sig; }, // fm + sig
			{ sig * exprand(0.01,2) + 1 * op.(randfreq.value); }, // am
			{ sig * op.(randfreq.value); }, // ring
			{ sig + op.(randfreq.value); }, // sum
		];
		sig = algos.choose.value;
	};

	sig = LPF.ar(sig, \lpf.kr(14000));
	sig = HPF.ar(sig, \hpf.kr(140));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
};
SynthDef(\algofmenv_t1, { arg out=0; 
	var sig;
	thisThread.randSeed = 26142.rand.postln;
	sig = SynthDef.wrap(~algofmenv);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
SynthDef(\algofmenv_t2, { arg out=0; 
	var sig;
	thisThread.randSeed = 12825;
	sig = SynthDef.wrap(~algofmenv);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\algofmenv_t1,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
)

//////////////////////////////////////

[2,3] * [20,30] // ->  [ 10, 40 ]
[2,3] *.t [20,30] // -> [ [ 40, 60  ], [ 60, 90  ]  ]
[2,3] *.x [20,30] // -> [ 40, 60, 60, 90  ]
