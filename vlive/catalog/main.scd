

- oscsampler
- zegrainer
- kick
- hihat


////////////////////////////////////////////////////////////////////////////////////////////////////

Ndef(\candy).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var slope;
	var fspread = \fspread.kr(0.01);
	var igate;
	var ifreq;
	ifreq = \ifreq.kr(1)*~t;
	freq = \freq.kr(100);
	sig = SinOsc.ar(freq); 
	slope = (Slope.kr(freq).abs.linexp(0,10,0.01,1) * Slope.kr(freq).sign ).lag(1.3);
	slope = 0;
	freq = freq * (1+slope);
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq *.x [0,7,3].midiratio;
	freq = freq * Duty.kr(1/ifreq, 0, Dseq([
		1,0,0,0,
		4,4,3,2,
	],inf)).midiratio;
	freq = freq.clip(20,19000);
	sig = sig * (1+LFSaw.ar(( freq *(1+ \amdetune.kr(1)) * (1+( slope*1 )) ).clip(20,19000),mul:\amamp.kr(1) * (1+slope )));
	
	sig = DelayL.ar(sig, 0.1, SinOsc.kr(1/4 * (1..8)/8 * \delfreq.kr(1)).range(0,0.1) * \del.kr(1)) + sig;
	sig = DelayL.ar(sig, 0.1, LFNoise1.kr(1/4 * (1..8)/8 * \delfreq.kr).range(0,0.1) * \del.kr) + sig;
	sig = RLPF.ar(sig, ( freq * \lpfac.kr(1) ).clip(10,19000), \rq.kr(0.5));

	igate = Impulse.kr(ifreq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.7)), igate);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
Ndef(\candy).addSpec(\fspread, ControlSpec(0.0001,1,\exp));
Ndef(\candy).addSpec(\amdetune, ControlSpec(0.001,100,\exp));
Ndef(\candy).play
Ndef(\candy).edit



- flanger
- rlpf follow freq
- Impulse to trigger notes
- adsr
- slope of freq modulate some parameters
- sequencing on freq;
- AM with a LFSaw with detune

////////////////////////////////////////////////////////////////////////////////////////////////////


SynthDef(\trig, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13, 2pi.rand).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14, 2pi.rand).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),Trig.kr(\igate.tr(1), \isustain.kr(0.3)),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

(
Pdef(\trig, Pmono(\trig,
	\fmfreq, 2,
	\fmrange, 34,
	\igate, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

- osc1: fm with low noise lfo
- osc2: two stage of distortion (fold and wrap) with a low sin lfo
- low and high filter
- inner env with sustain

////////////////////////////////////////////////////////////////////////////////////////////////////

(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;

	freq = 100*4;
	freq = Duty.kr(1/~t, 0, Dseq([
		//1,0,4,0,
		Dseq([1,0,4,0,],1) + Dstutter(Drand([1,2,3],inf),
			Drand([0,-12,-24,12],4)
		),
		
	],inf)).midiratio * freq;
	freq2 = (-20!8).rand;
	sig = SinOsc.ar(freq + ( freq2 / 8));
	sig = sig * ( 1 + ( FreqShift.ar(sig, freq2 * SinOsc.kr(41/4).range(0,1)) * SinOsc.kr(1/4).range(0,1) ) );
	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = (sig*23* LFNoise1.kr(1/8 * (1..8)).range(0,1)).tanh;
	sig = LPF.ar(sig, 1000 * LFNoise1.kr(1/4* (1..8)/8).range(0.1,2.0));

	sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	sig = BPF.ar(sig, 1000 * LFNoise1.kr(1/2 * (1..8)/16).range(0.0,4.0),0.11);
	sig = sig * 16 * 6;
	//sig = sig * 6;

	pan = 0;
	//pan = Duty.kr(1/~t, 0, Dseq([
	//	Drand([
	//		Dseq([
	//			1,0,-1,0,
	//		],1) * Drand([1,0.3,0.5],inf),
	//		Dseq([
	//			1,0.3,
	//		],1),
	//		Dseq([
	//			-1,-0.3,
	//		],1),
	//	],1),
	//],inf));
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 0.01,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
			[ Env.adsr(0.01,0.1,0.8,0.23) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 1/4,
));
Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([0.01,0.08,0.04],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		1,0,0,0, 1,0,1,0,
		0,0,1,0, 1,1,1,0,
		1,0,0,1, 0,0,1,0,
		0,1,1,0, 1,0,0,1,
	],inf),
	\dur, 1/4,
));
)


- two env
- two comb
- two do...

//////////////////////////////////////

(
// xTAGS: ndef, middle, nappe, fm
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	//var sig1, sig2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var oldsig;

	freq = 100*4;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,-1,0,
	],inf)).midiratio.lag(0.1) * freq;

	//freq = freq * [1,1.001];
	freq = freq * [19,3,7].midiratio;
	sig = SinOsc.ar(freq) ;
	oldsig = 1;
	8.do { arg x;
		sig = LFSaw.ar(freq+( x * SinOsc.kr(4+x).range(0,3) )) * (1+ sig ) * 0.8;
		sig = sig + DelayL.ar(sig, 0.1, [0,1/freq / 2* LFSaw.ar(freq * [1/4,1/8,1/2]).range(0.8,1)])/2;
	};

	//sig = sig ! 2;
	sig = sig * 1/4;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * 0.3, amp).mean;
	//sig = Pan2.ar(sig, 0, amp);
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 0.01,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1);
	}).loop,
	\dur, 1/4,
));
)

//////////////////////////////////////////////////////////////

(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;

	freq = 400*1;
	freq = Duty.kr(4/~t, 0, Dseq([
		1,0,4,0,
	],inf)).midiratio * freq;
	freq2 = (-20!8).rand;
	sig = SinOsc.ar(freq + ( freq2 / 8));
	sig = sig * ( 1 + ( FreqShift.ar(sig, freq2 * SinOsc.kr(41/4).range(0,1)) * SinOsc.kr(1/4).range(0,1) ) );
	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	//sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = (sig*23* LFNoise1.kr(1/8 * (1..8)).range(0,1)).tanh;
	sig = LPF.ar(sig, 1000 * LFNoise1.kr(1/4* (1..8)/8).range(0.1,2.0));

	sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	sig = BPF.ar(sig, 1000 * LFNoise1.kr(1/2 * (1..8)/16).range(0.0,4.0),0.11);
	sig = sig * 16 * 6;
	//sig = sig * 6;

	pan = 0;
	pan = Duty.kr(1/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,-1,0,
			],1) * Drand([1,0.3,0.5],inf),
			Dseq([
				1,0.3,
			],1),
			Dseq([
				1,0.9,
			],1),
			Dseq([
				0.1,0.2,
			],1),
			Dseq([
				-1,-0.3,
			],1),
		],1),
	],inf)).lag( Duty.kr(3/2/~t, 0, Dseq([
		0.1,0,0.4,0,
	],inf)));
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 4.01,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,1.03) ],
			//[ Env.adsr(0.01,0.1,0.8,0.23) ],
			//[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 2/1,
));
Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([0.01,0.08,0.04],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		1,1
	],inf),
	\dur, 1/4,
));
)

///////////////////////////////////////////////////////////////////

(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;

	freq = 100*2 * [1,1/2,1/4];
	freq = Duty.kr(4/~t, 0, Dseq([
		1,0,-1,-2,
	],inf)).midiratio * freq;
	freq = LFSaw.kr(1/2/~t).range(100,50);
	freq = 120 * Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0,
		Drand([12,-12,1],1),0,0,0,
		Drand([12,-12,1,6],1)*2,0,0,0,
		1,0,0,6,
		0,0,0,0,
		-5,1,1,1,
		0,0,0,-12,
		1,0,12,6,

		0,0,0,0,
		Drand([12,-12,1],1),0,0,0,
		Drand([12,-12,1,6],1)*2,0,0,0,
		1,0,0,6,
		0,0,0,0,
		-5,1,1,1,
		0,0,0,-12,
		12,0,6,6,
	],inf)).midiratio.lag(
		Duty.kr(1/4/~t, 0, Dseq([
			1,0,15,0,
			0,0,
			2,2,2,0,
			0,0,
			0,10,0,0,
		],inf))/20

	);
	freq2 = (-20!8).rand;
	sig = SinOsc.ar(freq + ( freq2 / 8));
	sig = sig + LFSaw.ar(freq * [1/2,1,2]) * [ 
		SinOsc.kr(1).range(0.5,1),
		SinOsc.kr(2).range(0.5,1),
		SinOsc.kr(1).range(0.5,1),
	] * 2;
	sig = sig * sig.fold2(0.5) * 4 + sig;
	sig.debug("sig");
	//sig = sig * ( 1 + ( FreqShift.ar(sig, freq2 * SinOsc.kr(4*~t).range(0,1)) * SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
	//	4,8,2,16,
	//	1/8,1/8,1/8,1/8,
	//],inf))*~t).range(0,1) ) );
	//sig = sig / 2;
	//sig = RLPF.ar(sig, XLine.kr(18000,120,16/~t), SinOsc.kr(1/4).range(0.1,1));
	sig = RLPF.ar(sig, Duty.kr(1/8/~t, 0, Dseq([
		0.01,0.5,1,1,
		0.1,0.5,1,0.5,
	],inf)).linexp(0,1,100,18000).lag(
		Duty.kr(1/4/~t, 0, Dseq([
			1,0,0.2,0.2,
			1,1,1,1,
		],inf))
	), Duty.kr(1/4/~t, 0, Dseq([
		4,1,5,4,
		8,4,4,4,
		8,8,8,8,
		1,1,1,1,
	],inf))/10);
	
	amp = amp * \gain.kr(1);
	//sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	//sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	//sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	//sig = (sig*23* LFNoise1.kr(1/8 * (1..8)).range(0,1)).tanh;
	//sig = LPF.ar(sig, 1000 * LFNoise1.kr(1/4* (1..8)/8).range(0.1,2.0));

	sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	//sig = BPF.ar(sig, 1000 * LFNoise1.kr(1/2 * (1..8)/16).range(0.0,4.0),0.11);
	//sig = sig * 16 * 6;
	//sig = sig * 6;

	pan = 0;
	pan = Duty.kr(1/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,-1,0,
			],1) * Drand([1,0.3,0.5],inf),
			Dseq([
				1,0.3,
			],1),
			Dseq([
				1,0.9,
			],1),
			Dseq([
				0.1,0.2,
			],1),
			Dseq([
				-1,-0.3,
			],1),
		],1),
	],inf)).lag( Duty.kr(3/2/~t, 0, Dseq([
		0.1,0,0.4,0,
	],inf)));
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 0.01,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.43) ],
			[ Env.adsr(0.01,0.1,0.8,1.43) ],
			//[ Env.adsr(0.01,0.1,0.8,0.23) ],
			//[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 1/4,
));
Ndef(~name+++\fx).play;
Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([0.01,0.08,0.04],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,0.13) ],
			[ Env.adsr(0.01,0.1,0.8,0.73) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		1,1,
	],inf),
	\dur, 1/8,
));
)


~set_project_tempo.(1);
