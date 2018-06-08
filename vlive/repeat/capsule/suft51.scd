
// sound design


(
SynthDef(\aigu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \aigu,
			\freq, 2000,
			\sustain, 0.1,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\pan, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \aigu,
			\freq, 6000,
			\sustain, 0.071,
			\dur, 0.78,
			\isRest, Pseq([
				0,1,0,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \aigu,
			\freq, Pseq([
				4700+Pwhite(-420,100.0).stutter(12)
			],inf),
			\sustain, 0.011,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 0.05,
			\pan, 0.3 * Pwhite(-1,1).stutter(9),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pwhite(0.5,1).stutter(13),
		),
		Pbind(
			\instrument, \noise1,
			\freq, 9200,
			\lpf, 17000,
			\hpf, 13000,
			\isRest, Pseq([
				0,0,1,
			],inf).coin.not,
			\dur, 1.3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmjet,
			\note, 0,
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1.2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmperc,
			\freq, Pwhite(800.0,8000).stutter(19),
			\sustain, 0.01,
			\dur, Pseq([
				7.3,Pn(0.051,5),0.3,Pn(0.04,8),
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \metperc,
			\freq, 3420,
			\dur, 1.4,
			\isRest, Pseq([
				0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \strangebass,
			\sustain, 0.3,
			\freq, 40,
			\dur, 1.432,
			\isRest, Pseq([
				0,0,0, 1,0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
	SynthDef(\whitenoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = WhiteNoise.ar(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
SynthDef(\noise1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFNoise1.ar(freq * ( LFNoise1.ar(17) * 0.21 + 1 ));
	sig = LPF.ar(sig, \lpf.ar(7000));
	sig = HPF.ar(sig, \hpf.ar(1200));
	sig = sig * Duty.kr(Dwhite(0.1,0.21,inf), 0, Drand([
		1,0,1,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fmjet, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([1,1,188],[0.1,4.8], [-2,-4]), 1);
	env2 = EnvGen.kr(Env([1,1,2],[1.1,1.2], [-2,-4]), 1);
	env3 = EnvGen.kr(Env([0,1/3,1/2],[1.1,1.2], [-2,-4]), 1);
	env4 = EnvGen.kr(Env([0,1/3,1/2],[1.1,1.2], [-2,-4]), 1);

	sig1 = SinOsc.ar(freq * [1, 2,3/4] * ( SinOsc.ar(freq) * 0.1 + 1 ));
	sig1 = sig1 * EnvGen.kr(Env([0,1,0],[0.1,1.8], -2), 1);
	sig2 = LFSaw.ar(freq * 2 * [4, 2,3/4] * ( LPF.ar(LFSaw.ar(freq*[2.1,5,3]), env1 * 10) * 1 + 1 ));
	sig2 = sig2 * ( LFPulse.ar(freq/8) * 0.51 *env3 + 1 );
	sig2 = sig2 * EnvGen.kr(Env([0,0,1,0],[0.1,1.1,0.1], [0,-2,2]), 1);
	sig2 = HPF.ar(sig2, 1000 * env2);
	sig2 = BRF.ar(sig2, env4*4000);

	sig3 = LFSaw.ar(freq * 3 * [4, 2,3/4] * ( LPF.ar(LFSaw.ar(freq*[2.1,5,3]), env1 * 10) * 1 + 1 ));
	sig3 = [
		BPF.ar(sig3, env4*4000,0.1),
		HPF.ar(sig3, 9000 * env2),
	].sum;
	sig3 = sig3 * EnvGen.kr(Env([0,0,1,0],[1.01,1.1,4.1], [0,-2,2]), 1);
	sig = sig1 + sig2 + sig3;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,1.4,1,[-2,0,-2])), gate, doneAction:2);
	pan = SinOsc.ar([0.021,0.01,0.001]) * 0.7  + pan;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

);



(
SynthDef(\fmperc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1,1/2],[0.01,0.1]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[2.1,0.8]), 1);
	env3 = EnvGen.kr(Env([0.7,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(env1* 880 * [1,2,5/3,3/4]) * env3 + 1 ));
	sig = HPF.ar(sig, 7000 * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.2)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmperc,
			\note, Pwalk((1..16), Pwhite(-10,10)),
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
)

////////

(
SynthDef(\metperc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1,1],[0.01,0.1]), 1);
	env2 = EnvGen.kr(Env([1,2,2],[0.01,1.8]), 1);
	env3 = EnvGen.kr(Env([0.1,2,1],[0.1,0.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.02,0.58], [1,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,0],[0.001,0.2]), 1);
	sig = LFPulse.ar(freq * [1,1.123,1.543] * env1);
	sig = ( sig*env5 ) + BPF.ar(WhiteNoise.ar, freq * 8 * env2, 0.1, mul:env4);
	sig = HPF.ar(sig, 2000 * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,1.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \metperc,
			\freq, 1000,
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)


///////////

(
SynthDef(\strangebass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,1/2,3,1],[0.1,0.05,0.08,0.2,0.2]), 1);
	env2 = EnvGen.kr(Env([10,200,100],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq);
	sig1 = CombL.ar(sig, 0.1, 1/freq);
	sig1 = sig1.tanh;
	sig1 = BPF.ar(sig1, 100 * env1);
	sig = sig1 + sig;
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	pan = EnvGen.kr(Env([0.1,-0.2,0],[0.1,0.8]), 1) + pan;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \strangebass,
			\sustain, 0.3,
			\freq, 40,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


(
SynthDef(\chordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \chordo,
			\freq, 1200,
			\sustain, 0.1,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)
