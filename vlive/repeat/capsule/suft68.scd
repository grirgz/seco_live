
~t = 172/4/60; TempoClock.default.tempo = ~t;



(

SynthDef(\hech, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,12000,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,1000,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,7100,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = HPF.ar(sig, 1000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\fzion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,1.2]), 1);
	env2 = EnvGen.kr(Env([1,1.5,3/4],[0.1,1.2]), 1);
	freq = freq * [1,2,2.001];
	sig = LFPulse.ar(freq  * ( SinOsc.ar(freq * env2) * 0.9 + 1 ));
	sig = RHPF.ar(sig, 4000 ,0.3);
	sig = RLPF.ar(sig, 2400* env1,0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\fzion2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[0.1,1.4]), 1);
	env2 = EnvGen.kr(Env([1.2,1.1,3/4],[0.1,1.4]), 1);
	freq = freq * [1,1.01];
	sig1 = LFCub.ar(freq*2 * env2 * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(4.5) + 1 ));
	//sig = sig.fold2(env2 * 0.5)+( sig * 0.1 );
	sig1 = CombL.ar(sig1, 0.2,1/2100 / env2,0.1)+sig1;
	sig1 = sig1/4;
	sig1 = RHPF.ar(sig1, 800 * env1 ,0.7);
	sig1 = RLPF.ar(sig1, 1440,0.8);
	sig2 = LFCub.ar(freq * env2);
	sig2 = RHPF.ar(sig2, 300 ,0.9);
	sig2 = sig2.tanh;
	sig = [sig1, sig2].sum;
	//sig = sig1;
	sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\fzion3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[1.1,1.4]), 1);
	env2 = EnvGen.kr(Env([0.2,4.1,3/4],[0.1,1.4]), 1);
	freq = freq * [1,1.21,5/8];
	sig1 = LFCub.ar(freq * env2 * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(4.5) + 1 )) *  SinOsc.kr([1,2,3]).range(0.2,1);
	//sig = sig.fold2(env2 * 0.5)+( sig * 0.1 );
	//sig1 = CombL.ar(sig1, 0.2,1/2100 / env2,0.1)+sig1;
	sig1 = sig1/8;
	sig1 = RHPF.ar(sig1, 800 * env1 ,0.7);
	sig1 = RLPF.ar(sig1, 9440,0.8);
	sig2 = LFCub.ar(freq * env2);
	sig2 = RHPF.ar(sig2, 300 ,0.9);
	sig2 = sig2.tanh * 0.1;
	sig = [sig1, sig2].sum;
	sig = sig / 80;
	//sig = sig1;
	//sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = Limiter.ar(sig, 0.2);
	Out.ar(out, sig);
}).add;
SynthDef(\fzion4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[1.1,1.4]), 1);
	env2 = EnvGen.kr(Env([0.2,4.1,3/4],[0.1,1.4]), 1);
	sig1 = SinOsc.ar(freq * [1,1+( env2/8 )] * ( SinOsc.ar(72 * env2) * 0.1 + 1 )); 
	sig2 = LFSaw.ar(freq); 
	sig2 = RLPF.ar(sig2, \lpfr.kr(3.1) * freq, \rq.kr(0.5));
	sig = [sig1, sig2].sum;
	sig = sig / 5;
	//sig = sig1;
	//sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/2, 0.5, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	//sig = Limiter.ar(sig, 0.2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\trap1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],1), 1/2),
				Pseg( Pseq([ 2,1 ],1), 1),
				Pseg( Pseq([ 1/2,2 ],1), 1/2),

				Pseg( Pseq([ 0.71,0.71 ]*2,1), 1),
				Pseg( Pseq([ 1/2,1.2 ]*2,1), 1/2),
				Pseg( Pseq([ 1.11,1.21 ],1), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 1,0,0,
				1,1,0, 1,0,1,  1,0,0, 1,0,1,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
		)),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000,
			\hpmix, 1,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\bufnum, BufDef(\splah),
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \fzion3,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\trap2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],1), 1/2),
				Pseg( Pseq([ 2,1 ],1), 1),
				Pseg( Pseq([ 1/2,2 ],1), 1/2),

				Pseg( Pseq([ 0.71,0.71 ]*2,1), 1),
				Pseg( Pseq([ 1/2,1.2 ]*2,1), 1/2),
				Pseg( Pseq([ 1.11,1.21 ],1), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 1,0,0,
				1,1,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
		)),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				1,1.1,0.7,0.8,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 12,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				12,0,0, 0,0,0,  0,0,0, 1,0,12,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				2,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \fzion3,
			\freq, 1210,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fzion4,
			\note, Pseq([
				7,
			],inf).stutter(1)+[0,2],
			\freq, 1210,
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.45) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00010001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 4.604,
			'distamp2', 2.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
	// trap
Pdef(\part, Pdef(\trap3, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,

				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fzion4,
			\note, Pseq([
				17,0,19
			],inf).stutter(1)+[0,2],
			\octave, 6,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,1, 1,0,1,
				1,0,1, 1,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,1, 1,1,1,  1,0,1, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,1, 0,1,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,1, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.5,0.7],inf),
		),
		
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'mix', 0.002,
			'gain', 1.5,
			'fb', 0.000000031,
			'delay', 0.00010001,
			'delay2', 0.40001001,
			'delay3', 0.0000080,
			'distamp', 4.604,
			'distamp2', 4.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				1,1.1,0.7,0.8,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 12,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,12,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				2,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,1,  0,0,1, 1,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\trap4, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],1), 1/2),
				Pseg( Pseq([ 2,1 ],1), 1),
				Pseg( Pseq([ 1/2,2 ],1), 1/2),

				Pseg( Pseq([ 0.71,0.71 ]*2,1), 1),
				Pseg( Pseq([ 1/2,1.2 ]*2,1), 1/2),
				Pseg( Pseq([ 1.11,1.21 ],1), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 1,0,0,
				1,1,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
		)),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				1,1.1,0.7,0.8,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 12,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				12,0,0, 0,0,0,  0,0,0, 1,0,12,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				2,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \fzion3,
			\freq, 1210,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

//////////////////// main

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\trap5)),
		Pfindur(8, Pdef(\trap1)),
		Pfindur(8, Pdef(\trap2)),
		Pfindur(8, Pdef(\trap3)),
		Pfindur(8, Pdef(\trap4)),
	])
)).play;
)

/////////// drafting

(
	// trap
Pdef(\part, Pdef(\trap3, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,

				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fzion4,
			\note, Pseq([
				17,0,19
			],inf).stutter(1)+[0,2],
			\octave, 6,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,1, 1,0,1,
				1,0,1, 1,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,1, 1,1,1,  1,0,1, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,1, 0,1,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,1, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.5,0.7],inf),
		),
		
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'mix', 0.002,
			'gain', 1.5,
			'fb', 0.000000031,
			'delay', 0.00010001,
			'delay2', 0.40001001,
			'delay3', 0.0000080,
			'distamp', 4.604,
			'distamp2', 4.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				1,1.1,0.7,0.8,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 12,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,12,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				2,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,1,  0,0,1, 1,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\trap5, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\bufnum, BufDef(\ukraine, "bruit1/07_ukraine.flac"),
			\bufnum, BufDef('fix4/snare1.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\speed, 1.031 * Pseq([
				1,0.9,1.12
			],inf),
			\speed, ~pmodenv.(Pseq([
				1,1,1, 1,1,1,  1,1,1, 1,1,1,
				1,1,1, 1,1,1,  1,1,1, 1,1,1,
				1,2,1,1/2,1,1.2, 1,2,1,1/2,1,1.2,
				1,2,1,1/2,1,1.2, 1,2,1,1/2,1,1.2,
			],inf), 1/12),
			\pos, Pseq([
				4,2,5
			],inf),
			\dur, Pn(1/12,inf),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 2,0,0,
				0,0,0, 4,0,0,  0,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,1/2, 1,0,1,
				0,0,1/2, 0,0,1,  0,0,1, 1,0,0,
				//1,0,1, 3,0,0,  0,0,1, 2,0,0,
				//1,0,0, 0,0,0,  0,0,1, 0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1/4 * Pseq([
				1,2
			],inf).stutter(12*2),
			\out, BusDef(\smpbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus3),
			\time, 1/12/2/~t * Pseq([1,3],inf).stutter(2),
			\rate, 1 * Pseq([
				0.61,1.2,0.8,
			],inf),
			\mix, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,1,0,  1,1,0, 1,1,0,
				0,0,1, 1,0,0,  0,1,1, 0,0,0,
			],inf)*0.5,
			\dur, 1/12,
		),

		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('loop/loop2_185bpm.flac'),
			//\bufnum, BufDef('voices/feynman.flac'),
			//\speed, 2.031 * Pseq([
				//1,0.7,1.2,0.5,
			//],inf),
			//\pos, Pseq([
				//0,1,2,2,
				//0.1,1,2,2.4,
				//0,1,2,2,
				//0,1/2,5,3,
			//],inf),
			//\isRest, Pseq([
				//1,0,1,0,
				//1,1,1,1,
			//],inf).coin.not,
			//\dur, Pn(1/2,inf),
			//\gain, 1/2,
			//\out, BusDef(\smpbus2, \audio),
		//),
		//Pmono(\fx_stutter,
			//\inbus, BusDef(\smpbus2),
			//\time, 1/16/~t,
			//\mix, Pseq([
				//0,1,0,1,
				//0,1,1,1,
			//],inf),
			//\dur, 1/8,
		//),

		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			//\bufnum, BufDef('loop/loop2_185bpm.flac'),
			//\speed, 1.031,
			//\pos, Pseq([
				//0,1,2,2,
				//0.1,1,2,2.4,
			//],inf),
			//\dur, Pn(1/2,inf),
			//\gain, 1/2,
			//\out, BusDef(\smpbus, \audio),
		//),
		//Pmono(\fx_stutter,
			//\inbus, BusDef(\smpbus),
			//\time, 1/16/~t,
			//\mix, Pseq([
				//0,0,1,1,
				//0,1,0,1,
			//],inf),
			//\dur, 1/8,
		//),


		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,

				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \dronebleu,
			\freq, 80,
			\legato, Pseq([
				14,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				14,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				14,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \dronebleuhi,
			\note, Pseq([
				0,0,0, 0,0,0, 0,0,0,  0,0,0, 
			],inf),
			\detune, Pseq([
				0,0,0, 0,0,0, 0,0,0,  0,0,0, 
				0,0,0, 0,0,0, 0,0,0,  -100,0,0, 
				
			],inf),
			\detune, Pseq([
				Pseg(Pseq([0,00],1),3),
				Pseg(Pseq([0,-100],1),2),
				Pseg(Pseq([0,100],1),1),
			],inf),
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,2, 0,0,1,  0,0,1, 1/2,0,0,  
				0,0,1, 1,0,0,  1,0,0, 1,0,0,
				0,0,0, 2,0,1/2,  0,0,1, 0,0,0,  
				0,0,0, 0,0,1,  0,0,0, 1,0,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],12*3),
				Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.0) ],
				],12*1),
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
)



//////////// sdesign

(
SynthDef(\dronebleu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1,0.2,1],[1,0.01,0.8]), 1);
	env2 = Duty.kr(1/12/~t, 0, Dseq([
		1,1,1, 1,1,0,  1,1,1, 0,1,1,
		0,1,1, 0,1,1,  0,1,1, 0,1,1,
	],inf)).lag(0.1)+0.2;
	sig = SinOsc.ar(freq * env1 * [1,1.00001].mirror2.clump(2)).mean;
	sig = sig.fold2(0.9 * env2 * SinOsc.kr(1/(1..8)/~t).unipolar);
	sig.postln;
	sig = HPF.ar(sig, 100);
	sig = sig.mean;
	sig = sig * 2.0;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp);
	Out.ar(out, sig);
}).add;
SynthDef(\dronebleuhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.8,1,0.1],[0.01,0.8,1]), 1);
	env2 = EnvGen.kr(Env([1,1,0.2,1],[1,0.01,0.8]), 1);
	env2 = Duty.kr(1/12/~t, 0, Dseq([
		1,1,0, 1,0,1,
	],inf)).lag(0.1)+0.1;
	freq = freq * [1,1/2,1/4];
	sig = SinOsc.ar(freq * env1 * [1,1.00001].mirror2.clump(2)).mean;
	sig = sig.fold2(0.9 * env2 * SinOsc.kr(1/(1..8)/~t).unipolar);
	sig.postln;
	sig = HPF.ar(sig, 100);
	sig = RLPF.ar(sig, 8000);
	sig = FreqShift.ar(sig, env2*10) + sig / 2;
	sig = sig.mean;
	sig = sig * 1.5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				1,0.9,0.8,0.7,
			],inf)*2,
			\speed, Pseq([
				Pseg( Pseq([ 2,1 ],1), 1),
			],inf),
			\isRest, Pseq([
				1,0,1, 1,0,0, 1,0,0, 0,0,0,
				1,1,0, 1,1,0, 1,1,0, 0,1,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 0.3,
			\delayfac, 1/2,
			\mix, 1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\recorder, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\out, BusDef(\recorder, \audio),
		),
		Pbind(
			\instrument, \recorder,
			\inbus, BusDef(\recorder, \audio),
			\bufnum, BufDef(\splah, s.sampleRate * 2/~t, 2),
			\freq, 200,
			\dur, Pn(1,1),
			\amp, 0.1,
		),
		
	])
)).play;
)


BufDef(\splah).play
BufDef(\splah).plot
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000,
			\hpmix, 1,
			\bufnum, BufDef(\splah),
			\dur, 1,
			\gain, 1,
		)
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fzion3,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\demo, 
	Pbind(
		\instrument, \hech,
		\legato, 1/4,
		\dur, Pn(1,1),
		\amp, 0.1,
	),
).play;
)

////////// first draft
(
SynthDef(\fzion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,1.2]), 1);
	env2 = EnvGen.kr(Env([1,1.5,3/4],[0.1,1.2]), 1);
	freq = freq * [1,2,2.001];
	sig = LFPulse.ar(freq  * ( SinOsc.ar(freq * env2) * 0.9 + 1 ));
	sig = RHPF.ar(sig, 4000 ,0.3);
	sig = RLPF.ar(sig, 2400* env1,0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
	// straight 8
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		
	])
)).play;
)


(
	// straight 6
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/6,
			\isRest, Pseq([
				1,0,0, 0,0,0,
				0,1,1, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,1, 0,0,0,
				0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/6,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 1,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/6,
		)),
		
	])
)).play;
)

(
	// swing 8
	~swing = (1 + (0.16 * Pseq([0,1,0,-1],inf)));
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,k,0, 0,1,0,1, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, Pkey(\dur) * ~swing,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, Pkey(\dur) * ~swing,
			\dur, 1/16,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/16,
			\dur, Pkey(\dur) * ~swing,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\dur, Pkey(\dur) * ~swing,
			\sustain, 0.1,
			\dur, 1/16,
		)),
		
	])
)).play;
)


(
	// straight 12
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		
	])
)).play;
)

(
	// trap
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		
	])
)).play;
)


