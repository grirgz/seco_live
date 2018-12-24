
(
Ndef(\drone1, { arg freq=200, pan=0, amp=0.1, fac1=2, modamp=1, freq2=1/100, lpfr=1.1, rq=0.5, siglag=0.1;
	var sig;
	var lfo, lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var rosc, rosc1,rosc2,rosc3,rosc4,rosc5,rosc6;
	var randfreq, randfreq2, chrandfreq;
	var chosc;
	randfreq = {
		rrand(freq/fac1,freq*fac1)
	};
	randfreq2 = {
		rrand(freq2/fac1,freq2*fac1)
	};
	chrandfreq = {
		[randfreq, randfreq2].choose.()
	};
	rosc = { arg mod=0;
		SinOsc.ar(randfreq.() * ( mod * rrand(0.1,1) * modamp + 1 )) 
	};
	rosc1 = { arg mod=0;
		LFSaw.ar(randfreq.() * ( mod * rrand(0.1,1) * modamp + 1 )) 
	};
	rosc2 = { arg mod=0;
		LFSaw.ar(chrandfreq.() * ( mod * rrand(0.1,1) * modamp + 1 )) 
	};
	rosc3 = { arg mod=0;
		SinOsc.ar(chrandfreq.() * ( mod * rrand(0.1,1) * modamp + 1 )) 
	};
	rosc4 = { arg mod=0;
		var isig = LFSaw.ar(chrandfreq.() * ( mod * rrand(0.1,1) * modamp + 1 ));
		RLPF.ar(isig, lpfr * freq, rq);
		isig;
	};
	rosc5 = { arg mod=0;
		var isig = LFSaw.ar(chrandfreq.() * ( mod * rrand(0.1,1) * modamp + 1 ));
		RLPF.ar(isig, lpfr * freq * ( chosc.() * rrand(0.1,1) * mod * modamp + 1 ), rq);
		isig;
	};
	lfo1 = {
		rosc.(rosc.())
	};
	lfo2 = {
		rosc1.(rosc1.())
	};
	chosc = { arg mod=0;
		[rosc3,rosc, rosc4, rosc3, rosc5].choose.(mod)
	};
	lfo3 = {
		chosc.(chosc.())
	};
	lfo4 = {
		chosc.(chosc.())
	};
	lfo5 = {
		var cc = chosc.();
		var dd = chosc.(cc + chosc.(chosc.()))
		+ chosc.(cc - chosc.(chosc.()))
		/ 2;
		chosc.(dd) + dd.lag(siglag * rrand(1/fac1,1*fac1));
	};

	sig = SinOsc.ar(freq * ( { lfo4.() }.dup(16) * 1 + 1 ));
	sig = { lfo5.() }.dup(8);
	pan = pan + LFNoise1.ar({ randfreq2.() }!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\drone1).edit


(
Ndef(\drone1, { arg freq=200, pan=0, amp=0.1, lofreq=0.01, modamp=0.1;
	var sig;
	var size = 8;
	var randtab = {
		SinOsc.ar(lofreq * ( SinOsc.ar(rrand(lofreq,lofreq*2 ! size)) * 1 + 1 )) * modamp +1
	};
	sig = LFSaw.ar(freq * randtab.(), randtab.()-1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * randtab.() * freq, \rq.kr(0.5));
	pan = pan * randtab.();
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


(
SynthDef(\violinas, { arg out=0, gate=1,freq=200, pan=0, amp=0.1, lofreq=0.01, modamp=0.1, modamplo=0.01;
	var sig;
	var size = 8;
	var randtab = {
		SinOsc.ar(lofreq * ( SinOsc.ar(rrand(lofreq,lofreq*2 ! size), Rand(0,1.0)) * 1 + 1 ), Rand(0,1.0)) * modamp +1
	};
	var randtablo = {
		SinOsc.ar(lofreq * ( SinOsc.ar(rrand(lofreq,lofreq*2 ! size), Rand(0,1.0)) * 1 + 1 ), Rand(0,1.0)) * modamplo +1
	};
	sig = LFSaw.ar(freq * randtablo.(), randtab.()-1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * randtab.() * freq, \rq.kr(0.5));
	pan = pan + ( randtab.()-1 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\monoviolinas, { arg out=0, gate=1,freq=200, pan=0, amp=0.1, lofreq=0.01, modamp=0.1, modamplo=0.01;
	var sig;
	var size = 8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var randtab = {
		SinOsc.ar(lofreq * ( SinOsc.ar(rrand(lofreq,lofreq*2 ! size), Rand(0,1.0)) * 1 + 1 ), Rand(0,1.0)) * modamp +1
	};
	var randtablo = {
		SinOsc.ar(lofreq * ( SinOsc.ar(rrand(lofreq,lofreq*2 ! size), Rand(0,1.0)) * 1 + 1 ), Rand(0,1.0)) * modamplo +1
	};
	env1 = EnvGen.kr(Env([1/2,1,1/2],[0.01,1.8]), 1);
	sig = LFSaw.ar(freq * randtablo.(), randtab.()-1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * randtab.() * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \violinas,
			\note, Pseq([
				//-2,-3,-3,
				0,5-12,6,
			],inf),
			\octave, 3,
			\lpfr, ~pmodenv.(Pseq([2,1/8,1,2,4],inf), 8.1),
			\rq, 0.1,
			\modamp, 4.3,
			\dur, 1/1,
			\amp, 0.1 * Pseg(Pseq([0,1,0],inf),5.1),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
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
		),
		Pbind(
			\instrument, \violinas,
			\note, Pseq([
				0,4,3,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/8,1,2,4],inf), 8),
			\rq, 0.1,
			\modamp, 4.3,
			\dur, 1/8,
			\amp, 0.1 * Pseg(Pseq([1,0],inf),7.1),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \violinas,
			\note, Pseq([
				7,9,11,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/8,1,2,4],inf), 8),
			\rq, 0.1,
			\modamp, 4.3,
			\dur, 1/4,
			\amp, 0.071 * Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 1,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.4000080,
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1,
			\gain, 1/2,
			\dur, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp),
			\dur, 1,
			\cpt, 0.1,
			\cpabove, 0.01,
		),

		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		
	])
)).play;
);
Pdef(\part).clear;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \monoviolinas,
			\note, Pseq([
				0,4-12,6,
				0,5-12,6,
				0,5-12,7,
			],inf).stutter(4),
			\octave, 3,
			\lpfr, 1.4,
			\rq, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.4,0.2,0.1) ],
			],inf),
			\modamp, 4.3,
			\dur, 1/8,
			\legato, Pseq([
				1,0,2,0, 0,0,1,0,
				0,0,2,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,2,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
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
		),
		Pbind(
			\instrument, \violinas,
			\note, Pseq([
				0,4,3,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/8,1,2,4],inf), 8),
			\rq, 0.1,
			\modamp, 4.3,
			\dur, 1/8,
			\amp, 0.1 * Pseg(Pseq([1,0],inf),7.1),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \violinas,
			\note, Pseq([
				7,9,11,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/8,1,2,4],inf), 8),
			\rq, 0.1,
			\modamp, 4.3,
			\dur, 1/4,
			\amp, 0.071 * Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \violinas,
			\note, Pseq([
				7,9,11,
			],inf),
			\octave, 6,
			\lpfr, ~pmodenv.(Pseq([1/8,1,2,4],inf), 8),
			\rq, 0.1,
			\modamp, 4.3,
			\legato, 0.1,
			\lag, Prand([1/4,1/8,1/3,3/4]/2,inf),
			\dur, 1/4,
			\amp, 0.071 * Pseg(Pseq([0,1,0,0,1],inf),3.8),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 1,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.4000080,
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1,
			\gain, 1/2,
			\dur, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp),
			\dur, 1,
			\cpt, 0.1,
			\cpabove, 0.01,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus3, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 2,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			//\lag, 0.04,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1 * Pseq([
				1,1,1,1,
				1,1,1,5,
				1,5,1,1,
				1,1,1,5,
			],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			//\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
			'gain', 0.8344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 4.361836201538,
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
		),
		
	])
)).play;
);


(
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = ( freq * [1,1/2,2] * [[0,4,7].midiratio] ).flat;
	sig = LFSaw.ar(freq * ( LFPulse.ar(freq+1) * 1 + 1 ));
	sig = sig.fold( SinOsc.ar(freq+ SinOsc.kr( (1..8)/8).range(0,1))  );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * SinOsc.kr( (1..8)/8).range(2,1) * freq, \rq.kr(0.5));
	pan = pan + LFNoise1.kr(1/2!8);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



(
SynthDef(\padette, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	freq = ( freq * [1,1/2,2]  ).flat;
	sig = LFSaw.ar(freq * ( LFPulse.ar(freq+1) * 1 + 1 ));
	sig = sig.fold( SinOsc.ar(freq+ SinOsc.kr( (1..8)/8).range(0,1))  );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * SinOsc.kr( (1..8)/8).range(2,1) * freq, \rq.kr(0.5));
	pan = pan + LFNoise1.kr(1/2!8);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \padette,
			\note, Pseq([
				[0,3-12,7,11],
				[0+12,3,6,11]+4,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var freqs = ( exprand(100.0!8,1000) * [ [0,3,7] ].midiratio );
	sig = LFSaw.ar(freqs * LFNoise1.kr((1..8)/8).range(1.1,1));
	sig = sig.flop.mean;
	sig.debug("sig");
	sig = sig * LFNoise1.ar((1..8)/8).range(0,1);
	sig = sig * RLPF.ar(sig, freqs * LFNoise1.kr((1..8)/8).range(1.1,1) * \lpfr.kr(1), \rq.kr(0.5));
	pan = pan + LFNoise1.kr(1/2!8, mul:1);
	sig = Pan2.ar(sig, pan, amp).mean.sum;
	sig.debug("sig2");
}).play;
);

(
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sigin;
	sigin = LocalIn.ar(2) * \fb.kr(5.8);
	//freq = freq * [0,3,7].midiratio;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
	[0,3,7],
	[0,4,7],
	[0,1,7],
	[0,3,7]-12,
	],inf)).midiratio;

	sig = LFSaw.ar(freq, sigin * 1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( sigin + 1 ), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	sig = AllpassL.ar(sig, 0.7,0.7,0.1) + sig;
	sig.debug("siga");
	LocalOut.ar(sig);
	sig;
}).play;
);

(
SynthDef(\drone2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Dust.ar(1);
	sig = Ringz.ar(sig, LFNoise1.ar(1!10).exprange(100,1000))/1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Dust.ar(0.5!10);
	sig = Ringz.ar(sig, LFNoise1.ar(1!10).exprange(200,2000),0.2)*18;
	sig = AllpassL.ar(sig, 0.2,[0.123,0.2,0.02423],3)+sig;
	sig = AllpassL.ar(sig, 0.2,[0.123,0.2,0.02423]*rrand(1.0,2),3)+sig;
	sig = Pan2.ar(sig, pan, amp).mean*2;
}).play;
);

(
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bang = Dust.ar(1!8);
	freq = Demand.ar( bang, 0,Dwhite(100.0,2000) ).poll;
	bang = Decay.ar(bang);
	sig = Ringz.ar(bang, freq,0.1)/8;
	[0.123,0.2,0.32423].do { arg xx;
		sig = AllpassC.ar(sig, 0.4,xx,1.3)+sig;
	};
	sig = Pan2.ar(sig, pan, amp).mean*2;
}).play;
);


(
Ndef(\drone2, { arg freq=1000, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var bang = Impulse.kr(1/4);
	lfo1 = {Duty.ar(1/16/8/~t, 0, Dseq([
		Dseq(rrand(0,8!8))
	],inf))} ! 8;
	lfo2 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	lfo2 = lfo2 + EnvGen.kr(Env([0,1,0],[4.1,0.8]), DelayL.kr(Trig1.kr(1), 8,8));
	lfo3 = EnvGen.kr(Env([1,1/2,1/8],[1.1,4.8]), Impulse.kr(1/12));
	freq = freq * lfo2;
	sig = LFPulse.ar(freq * lfo1);
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * lfo3* freq, \rq.kr(0.5));
	//pan = pan + ( lfo1.lag(0.1)-4/8 );
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, 1, amp, pan);
}).play;
);


(
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var size = 8;
	lfo1 = Duty.kr((1..size)/11/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	freq = Duty.kr(Dseq([2,1,1/2,0.05123],inf)/~t, 0, Dseq([
		[123,432,1234,432,323,732,184,402,623] * Dwhite(0.5,1.5,1),
		Dwhite(100,500.0!size,1),
	],inf));
	sig1 = SinOsc.ar(freq);
	sig2 = LFPulse.ar(freq+lfo1);
	sig = SelectX.ar( SinOsc.ar(freq+1).range(0,1), [sig1, sig2]);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, 1, amp, pan)/2;
}).play;
);



(
	// diagonale squares

	~make_square = { arg startpos, sizex, sizey;
		Ppar([
			Pbind(
				\instrument, \default,
				\freq, ~pmodenv.(Pseq([0,sizey,0]+startpos,1), sizex/2),
				\dur, Pn(sizex,1),
				\legato, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\freq, ~pmodenv.(Pseq([0,0-sizey,0]+startpos,1), sizex/2),
				\dur, Pn(sizex,1),
				\legato, 1,
				\amp, 0.1,
			),
		])


	};

	//~make_super_square = { arg self, startpos, sizex, sizey, subdiv=2;
		//Ppar(
			//( sizex*(0..(subdiv*2 - 2))/( subdiv*2 ) ).collect({ arg sx;
				//Pseq([
					//Event.silent(sx),
					//~make_square.(startpos * (1+sx), sizex/subdiv, sizey/subdiv)
				//],1),
				
			//})
		//)
		//sizex
		
	//};
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(
			Pspawner({arg sp;
				1000.do {
					sp.par(
						Pbind(
							\instrument, \pourfend,
							\degree, [
								Pseq((1..8),1)+rrand(0,20),
								Pseq((1..8).reverse,1)+rrand(0,20),
							].choose,
							\scale, Scale.new([1,2,4,5,7,8]),
							\octave, 4,
							\dur, Pn(1/rrand(4.0,18)),
							\amp, 0.1,
						).trace

					);
					sp.wait(rrand(1.0,2.0));
				}

			})!2
		)<>
		Pbind(
			\fac1, Pseg(Pseq([0,1,7],inf),8),
		)
		
	])
)).play;
);


(
SynthDef(\pourfend, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,100,100],[0.1,0.8,10]), 1);
	sig = LFSaw.ar(freq * [1,1.01]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = sig.collect({ arg isig;
		isig = FreqShift.ar(isig, LFNoise1.ar(1!8,mul:env2));
		isig = isig.mean + isig;

		
	});
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-1,1], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pourfend, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0.1,2,100,100],[\fac1.kr(0.1),0.8,10]), 1);
	env3 = EnvGen.kr(Env([1/2,2,1],[0.01,0.8]), 1);
	sig = LFSaw.ar(freq * [1,1.01]);
	sig = sig.collect({ arg isig;
		//isig = RLPF.ar(isig, \lpfr.kr(1.1) * freq * env1 * LFNoise1.ar(1!8,mul:0.1,add:1), \rq.kr(0.5));
		isig = RLPF.ar(isig, \lpfr.kr(1.1) * freq * env1 * LFNoise1.ar(0.01!8,mul:0.10,add:1), \rq.kr(0.1) * env3);
		//isig = Limiter.ar(isig);
		isig = FreqShift.ar(isig, LFNoise1.ar(1!8,mul:0.0200)) + isig;
		isig = isig.tanh/1;
		isig = isig.mean;
	});
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-1,1], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(
			Pspawner({arg sp;
				1000.do {
					sp.par(
						Pbind(
							\instrument, \pourfend,
							\degree, [
								Pseq((1..8),1)+rrand(0,20),
								Pseq((1..8).reverse,1)+rrand(0,20),
							].choose,
							\scale, Scale.new([0,3,4,9,10,11]),
							\octave, 3,
							\dur, Pn(1/rrand(4.0,18)),
							\amp, 0.1,
						).trace

					);
					sp.wait(rrand(1.0,2.0));
				}

			})!2
		)<>
		Pbind(
			\fac1, Pseg(Pseq([0,1,7],inf),8),
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),

		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pourfend,
			\freq, 200,
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\fac1, Pseq([
				1,2,0.1,3,
			],inf).stutter(4),
			\dur, 1,
			\amp, 0.1/1.62,
			\fac1, Pseg(Pseq([0,1,7],inf),8),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\lag, 0.04,
			//\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 2,
			\lag, 0.04,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\lag, 0.04,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pourfend,
			\freq, 200 * Pseq([

				1,1,1,0.98,
				1,1,1,1,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\fac1, Pseq([
				1,2,0.1,3,
			],inf).stutter(4),
			\dur, 1,
			\amp, 0.1/1.62,
			\fac1, Pseg(Pseq([0,1,7],inf),8),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \pourfend,
			\freq, 1500,
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\fac1, Pseq([
				1,2,0.1,3,
			],inf).stutter(4),
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1/1.62 * Pseg(Pseq([0,1],inf),7),
			\fac1, Pseg(Pseq([0,1,7],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\lag, 0.04,
			//\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 2,
			\lag, 0.04,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\lag, 0.04,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		
	])
)).play;
)
