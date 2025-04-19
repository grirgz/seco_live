
// no rytm

(
SynthDef(\pulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(2.001)) * \fmamp.kr(0.2) + 1 ));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));

	sig1 = Ringz.ar(sig, freq * \ringffac.kr(1), \ringdecay.kr(0.001)) * \ringgain.kr(0.1);
	sig = SelectX.ar(\ringmix.kr(0.5), [sig, sig1]);

	sig = sig * EnvGen.kr(\pulseenv.kr(Env([0,0,1,0],[0.01,0.1,0.3])), Impulse.kr(\pulsefreq.kr(1)));

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	pulseenv: ParamEnvSpec(),
	ringmix: \unipolar
))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \pulsebass,
			//\freq, exprand(50,2000.0!8).postln,
			\freq, [ 110.49093655361, 105.89208632548, 110.81963031045, 99.505354591893, 453.81550841768, 70.585326907823, 147.14418479673, 267.02264592114  ] * Pseq([
				0,0,0,0, 5,2,3,1
			],inf).midiratio,

			\pulsefreq, 8*~t,
			\fmamp, ~pmodenv.(Pseq([0,2,1,4],1), 8).loop,
			\ringmix, 0.03,
			\lpfr, ~pmodenv.(Prand([1/2,4,1.4,8],1), Pwhite(0.1,8,inf)).loop,
			\distamp, 1000,
			\pulseenv, [ Env([0.5,0.5,1,0.5],[0.1,0.8]) ],
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf)).midiratio;
	mod2 = Duty.kr(1/2/~t, 0, Dseq([
		100,30,
	],inf));
	mod3 = Duty.kr(Dwhite(0.1,3), 0, Dseq([
		1,3,0,
	],inf)).lag(1);
	sig = SinOsc.ar(freq * mod1 * ( SinOsc.kr(mod2 * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * mod3 + 1 ));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = Duty.kr(4/~t, 0, Dseq([
		0,7,5,-12,
	],inf)).midiratio;
	freq = [-12,0,7,9,12,19].midiratio * freq * mod1;
	sig = SinOsc.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig.debug("sig");
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

WindowDef(\NdefEditor).front(Ndef(\zed))

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = 211;
	mod1 = Duty.kr(4/~t, 0, Dseq([
		0,7,5,-12,
	],inf)).midiratio;
	freq = [-12,0,7,9,12,19].midiratio * freq * mod1;
	sig = LFSaw.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig = HPF.ar(sig, 3000);
	sig1 = sig;

	sig = SinOsc.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig = sig.collect { arg isig, idx;
		isig * LFNoise1.kr(1/2).range(0.0,1.0);
	};
	sig2 = sig;

	sig = [sig1,sig2].sum;

	sig.debug("sig");
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = 211;
	mod1 = Duty.kr(4/~t, 0, Dseq([
		0,7,5,-12,
	],inf)).midiratio;
	freq = [-12,0,7,12,15,14].midiratio * freq * mod1;
	sig = LFSaw.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig = BPF.ar(sig, ( [ [16000,3333,7555, 12324] ] * LFNoise1.kr(1/2!4).range(0.4,2.0) ).clip(20,20000)).flop.mean;
	sig.debug("sigbpf");
	sig1 = sig;

	sig = SinOsc.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig = sig.collect { arg isig, idx;
		isig * LFNoise1.kr(1/2).range(0.0,1.0);
	};
	sig = BPF.ar(sig, ( [ [1600,333,755, 74]  * LFNoise1.kr(1/2!4).range(0.4,2.0)] ).clip(20,20000)).flop.mean;
	sig2 = sig;

	sig = [sig1,sig2].sum;

	sig.debug("sig");
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = 211;
	mod1 = Duty.kr(4/~t, 0, Dseq([
		0,7,5,-12,
	],inf)).midiratio;
	freq = [-12,0,7,12,15,14].midiratio * freq * mod1;
	sig = LFSaw.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig = BPF.ar(sig, ( [ [16000,3333,7555, 12324] ] * LFNoise1.kr(1/2!4).range(0.4,2.0) ).clip(20,20000)).flop.mean;
	sig.debug("sigbpf");
	sig1 = sig;

	sig = SinOsc.ar(freq * ( HenonC.ar(\henonfreq.kr(100), 2.2,0.4, ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \henonamp.kr(0.3) + 1));
	sig = sig.collect { arg isig, idx;
		isig * LFNoise1.kr(1/2).range(0.0,1.0);
	};
	sig = BPF.ar(sig, ( [ [1600,333,755, 74]  * LFNoise1.kr(1/2!4).range(0.4,2.0)] ).clip(20,20000)).flop.mean;
	sig2 = sig;

	sig = [sig1,sig2].sum;

	sig8 = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.001001) + 1) * ( SinOsc.ar(\modfreq.kr(0.1)) * \modamp.kr(0.48) + 1 )).mean;
	sig = SelectX.ar(\chorusmix.kr(0.5), [sig, sig8]);
	
	sig.debug("sig");

	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);


/////////////////



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 18;
	var noisefreq = 1;
	sig = SinOsc.ar( ExpRand(50.0,4300!num) );
	sig = sig.collect { arg isig, idx;
		isig * LFNoise1.kr(noisefreq).range(0.0,1.0);
		( isig*\distamp.kr(1)* LFNoise1.kr(noisefreq).exprange(0.01,20.0) ).tanh * \distpostamp.kr(1/2)
	};
	sig = Pan2.ar(sig, LFNoise1.kr(1/2!num).range(-1.0,1.0), amp).mean;
	sig = CombL.ar(sig, 4/~t, 2.1*1/8/~t,1/~t) + sig;
	sig.debug("sig");
}).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = 
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

////////

(
SynthDef(\fx_decimator, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Decimator.ar(sig, rate: \rate.kr(44100/2), bits:\bits.kr(4));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[508].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2287].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_decimator,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\rate, Pseg(Pseq([10,44100],inf),8, \exp),
			\bits, 24,
			\lag, 0.0009,
			\dur, 1,
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


////////// filterfm study

(
SynthDef(\filterfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\simplesin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sawrlpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sawfmrlpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				0,4,7,4
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 1.3234,
			\octave, 4,
			\fmr, 2,
			\fmamp, 0.9,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplesin,
			\note, Pseq([
				0,4,7,4
			],inf),
			\lpfr, 1,
			\octave, 3,
			\fmr, 1/2,
			\fmamp, 0.9,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawrlpf,
			\note, Pseq([
				0,4,7,4
			],inf),
			\lpfr, 3,
			\octave, 3,
			\fmr, 1/2,
			\fmamp, 0.9,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


////////////////////

(
SynthDef(\fx_chorust1, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.ar(\modfreq.kr(0.1)) * \modamp.kr(0.48) + 1 )).mean;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fx_chorust2, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.101) * ( SinOsc.ar(\modfreq.kr(0.1) * ((0..7)/7 - 0.5 * \diff.kr(0.1) + 1) ) * \modamp.kr(0.48) + 1 )).mean;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fx_chorust3, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + ( LocalIn.ar(2) * \fb.kr(0.1) );
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.101) * ( SinOsc.ar(\modfreq.kr(0.1) * ((0..7)/7 - 0.5 * \diff.kr(0.1) + 1) ) * \modamp.kr(0.48) + 1 )).mean;
	LocalOut.ar(sig + in);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				0,4,7,4
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 2,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.2,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, 0.01,
			\delay, 0.02,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				0,4,7,4
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 2,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.2,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, 0.01,
			\delay, 0.2,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				[ 0,4,7,4+12 ]
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 2,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.2,
			\dur, 1/2,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, 0.01,
			\delay, 1/4/~t,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				[ 0,4,7,4+12 ]
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 2,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.2,
			\dur, 1/2,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust3,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.01,
			\diff, 0.8,
			\delay, 0.1,
			\fb, 0.99,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				[ 0,4,7,4+12 ]
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 2,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.2,
			\dur, 1/2,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \simplesin,
			\note, Pseq([
				0,\r,\r,\r,
				\r,\r,\r,\r,
				0,\r,\r,\r,
				\r,\r,\r,5,
			],inf),
			\ctranspose, Pstep(Pseq([
				-5,
			],inf),4),
			\legato, Pseq([
				2,1/2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\lpfr, 4,
			\octave, 7,
			\fmr, 1/4,
			\fmamp, 0.3,
			\dur, 1/4,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust3,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, ~pmodenv.(Pseq([0.01,1],1), 8).loop,
			\delay, ~pmodenv.(Pseq([0.1,0.01,0.2],1), 14).loop,
			\fb, 0.99,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \filterfm,
			\note, Pseq([
				[ 0,4,7,4+12 ]
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 2,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.2,
			\dur, 1/2,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \simplesin,
			\note, Pseq([
				0,\r,\r,\r,
				\r,\r,\r,\r,
				0,\r,\r,\r,
				\r,\r,\r,5,
			],inf),
			\ctranspose, Pstep(Pseq([
				-5,
			],inf),4),
			\legato, Pseq([
				2,1/2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\lpfr, 4,
			\octave, 7,
			\fmr, 1/4,
			\fmamp, 0.3,
			\dur, 1/4,
			\amp, 0.1/2,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_chorust3,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, ~pmodenv.(Pseq([0.01,1],1), 8).loop,
			\delay, ~pmodenv.(Pseq([0.1,0.01,0.2],1), 14).loop,
			\fb, 0.99,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\fx_chorust3,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\modfreq, 0.4,
			\diff, 0.03,
			\delay, 0.2,
			\fb, 0.99,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

///////////////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawfmrlpf,
			\note, Pstep(Pseq([
				[0,4,7,12+4],
				[0+12,4,7,12+4],
			],inf),4),
			\ctranspose, Pstep(Pseq([
				0,-4,
			],inf),4),
			\lpfr, 3,
			\octave, 5,
			\fmr, 1/2,
			\fmamp, 0.1,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, 0.01,
			\delay, 0.15,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawfmrlpf,
			\note, Pseq([
				[0,4,7-12,12+4]
				[0,7,7+12,12+4]
			],inf),
			\ctranspose, Pstep(Pseq([
				0,-4
			],inf),4),
			\lpfr, 3,
			\octave, 6,
			\fmr, 1/4,
			\fmamp, 0.1,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_chorust2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\modfreq, 0.1,
			\diff, 0.1,
			\delay, 0.1,
			\mix, 0.5,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);


/////////////////////////:


// Rhythm-Experiment for sambalike patterns. The goal are cyclic patterns that accelerate in asymetrical way inside one cycle.

// Masterclock is a LFSaw that's bent via lincurve with the "swing"-argument.
// Speed is in Hz.

// Behaves asymetrial.
// swing = 0 is linear. Negative values shift things towards start, positive values towards end of cycle.

// The masterclock is chopped with the "div"-argument in shorter parts for each instrument.
// Negative values and zero for "div" should be avoided.

// The raw clock-signals control the instruments. More organic than classic triggers and envelopes, but strange sometimes.

// Default volumes of intruments are high for saturation and distortion.

y=Synth(\polyswingasym)
y.free

y.set(\swing,0.5);


y.set(\speed,1);

y.set(\kickv,86);
y.set(\snrv,72);
y.set(\hhv,111);
y.set(\tmv,64);
y.set(\clvv,30);
y.set(\wdv,20);

y.set(\deckick,6);
y.set(\decsnr,4);


y.set(\div1,2);
y.set(\div2,3);
y.set(\div3,5);
y.set(\div4,6);
y.set(\div5,7);
y.set(\div6,4);

y.set(\frqkick,65);
y.set(\frqtm,195);


(
SynthDef(\polyswingasym,{

	arg frqkick=45, frqtm=135, reskick=0.05, deckick=4, decsnr=4, speed=1, swing=0.5, div1=2, div2=3, div3=4, div4=6, div5=8, div6=3, out=0, kickv=86, snrv=74, hhv=110, tmv=70, clvv=30, wdv=100;

	var sig, master, master2, trig1, trig2, trig21, trig3, trig4, trig5, trig6,
	kick,envkick,snr,envsnr,hh,tm,clv,wd;

	master = LFSaw.ar(speed,pi,0.5,0.5).lincurve(0,1,0,1,swing);

	trig1 = (master%(1/div1))*div1;
	trig2 = (master%(1/div2))*div2;
	trig3 = (master%(1/div3))*div3;
	trig4 = (master%(1/div4))*div4;
	trig5 = (master%(1/div5))*div5;
	trig6 = (master%(1/div6))*div6;

	envkick = (((trig1.neg+1).lincurve(0,1,0,1,deckick).cubed*2)+1).lag(0.001);

	envsnr = ((trig2.neg+1).lincurve(0,1,0,1,decsnr).cubed).lag(0.001);

	kick= Resonz.ar(trig1,frqkick*envkick,0.005,kickv);
	snr=  (Resonz.ar(trig2,222,0.02,4)+WhiteNoise.ar(0.01)+Dust2.ar(123,0.01))*envsnr.tanh*snrv;
	hh= RHPF.ar(Mix.new(Resonz.ar(trig3,Array.linrand(11,4000,6500),0.0005)),2400,0.4,hhv);
	tm= Resonz.ar(trig4,frqtm,0.03,tmv);
	clv= HPF.ar(Mix.new(Resonz.ar(trig5,Array.linrand(9,500,3500),0.01,clvv)),700);
	wd= Resonz.ar(trig6,850,0.04,wdv);

	sig = kick+snr+hh+tm+clv+wd;

	Out.ar(out,LeakDC.ar(sig!2).tanh);
}).add;
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

	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
	// does not work
SynthDef(\rezkick, { |out=0, amp=0.1, pan=0, fratio=3.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;
	var driver = LFSaw.ar(2);

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0,0, 1, 0.5, 0], [0,0.005, 0.16, 1.1], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210,210, 62, 59], [0,0.045, 1.49], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, driver, doneAction:0, timeScale:timeScale);
	env1 = EnvGen.ar(env1, driver, timeScale:timeScale);
	
	sig = Ringz.ar(driver, env1 * freqpan, 0.001);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(4000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
Ndef(\kick, \rezkick).play
)





///////////////////////////////////////////

(
SynthDef(\chardgrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * AmpCompA.kr(freq, 80);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\chardgrainpulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * AmpCompA.kr(freq, 80);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\chard, 
	Pbind(
		\instrument, \chardgrain,
		\degree, Pseq([0,1,2],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pspawner({ arg sp;
			100.do {

				sp.par(
					Pfindur(rrand(1.0,10), 
						Pbind(
							\dur, rrand(1/16, 1),
							\ctranspose, rrand(-12, 12),
							\mtranspose, rrand(-7, 7),
							\pan, rrand(-1,1),
							\lpfr, rrand(0.4,4),
							\rq, rrand(0.2,1),
							\fmr, [1,1/2,2,3/2,2/3].choose,
							\fmamp, rrand(0.0,2),
							\octave, [3,4,5,6].choose,
						) <>
						Pdef(\chard)
					)
				);
				sp.wait(exprand(0.2,10));
			}
		}),
	])
)).play;
);

(
Pdef(\chard, 
	Pbind(
		\instrument, \chardgrain,
		\degree, Pseq([0,3,7],inf),
		\dur, 1,
		\amp, 0.1/4,
	)
);
);
(
Pdef(\chard, 
	Pbind(
		\instrument, \chardgrain,
		\degree, Pwrand([0,2,4,6],[2,1,2,1].normalizeSum,inf),
		\mtranspose, 0,
		\dur, 1,
		\amp, 0.1/4,
	)
);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pspawner({ arg sp;
			100.do {

				sp.par(
					Pfindur(rrand(1.0,10), 
						Pbind(
							\dur, rrand(1/16, 1),
							//\ctranspose, rrand(-12, 12),
							//\mtranspose, rrand(-7, 7),
							\legato, rrand(0.1,1),
							\adsr, [ Env.adsr(rrand(0.01,2),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)) ],
							\pan, rrand(-1,1),
							\lpfr, rrand(0.4,4),
							\rq, rrand(0.2,1),
							\fmr, [1,1/2,2,3/2,2/3].choose,
							\fmamp, rrand(0.0,2),
							\octave, [3,4,5,6].choose,
						) <>
						Pdef(\chard)
					)
				);
				sp.wait(exprand(0.2,2));
			}
		}),
	])
)).play;
);

(
Pdef(\chard, 
	Pbind(
		\instrument, \chardgrain,
		//\degree, Pwrand([0,2,4,6],[2,1,2,1].normalizeSum,inf),
		\cchord, [0,2,4,6b] +.x [-12,0,12],
		\cpond, [1,1,1,30.1].normalizeSum,
		\cpond, [1,1,1,0.1].normalizeSum,
		\mtranspose, 4,
		\dur, 1,
		\amp, 0.1/4,
	)
);
);
Pdef(\chard).play

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar({ 
			Plazy({ 
				Pbind(
					\dur, Pn(exprand(1/16,1),rrand(16*4,16*8)),
					\amp, 0.1,
					//\ctranspose, rrand(-12, 12),
					//\mtranspose, rrand(-7, 7),
					\legato, rrand(0.1,1),
					\adsr, [ Env.adsr(rrand(0.01,2),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)) ],
					\pan, rrand(-1,1),
					\lpfr, rrand(0.4,4),
					\rq, rrand(0.2,1),
					//\fmr, [1,1/2,2,3/2,2/3].choose,
					\fmr, [1,1/2,2].choose,
					\fmamp, rrand(0.0,2),
					\octave, [3,4,5,6].choose,
					\amp, Pkey(\amp) / 8,
					\degree, Prout({ arg ev;
						var len = ev[\cchord].size;
						var idxlist = (0 .. ev[\cchord].size - 1);
						//idxlist.scramble;
						idxlist = 100.collect({ idxlist.wchoose(ev[\cpond]) });
						10000.do { arg idx;
							ev = ev[\cchord][ idxlist[idx % ev[\cchord].size] ].yield;
						};
						ev;
					}).loop,
					\isRest, Pseq([
						0,0,0,0,
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
					].scramble,inf).coin.not,
				)
			}).loop <> Pdef(\chard);
		}!16),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\orchestra, 
	Ppar([
		Ppar({ 
			Plazy({ 
				Pbind(
					\dur, Pn([1/4,1/3,1/2,1/8,1/12,1/9,1/16].choose,rrand(16*4,16*8)),
					\amp, 0.1,
					//\ctranspose, rrand(-12, 12),
					//\mtranspose, rrand(-7, 7),
					\legato, rrand(0.1,1),
					\adsr, [ Env.adsr(rrand(0.01,2),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)) ],
					\pan, rrand(-1,1),
					\lpfr, rrand(0.4,4),
					\rq, rrand(0.2,1),
					//\fmr, [1,1/2,2,3/2,2/3].choose,
					\fmr, [1,1/2,2].choose,
					\fmamp, rrand(0.0,2),
					\octave, [3,4,5,6].choose,
					\amp, Pkey(\amp) / 8,
					\degree, Prout({ arg ev;
						var len = ev[\cchord].size;
						var idxlist = (0 .. ev[\cchord].size - 1);
						//idxlist.scramble;
						idxlist = 100.collect({ idxlist.wchoose(ev[\cpond]) });
						10000.do { arg idx;
							ev = ev[\cchord][ idxlist[idx % ev[\cchord].size] ].yield;
						};
						ev;
					}).loop,
					\isRest, Pseq([
						0,0,0,0,
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
					].scramble,inf).coin.not,
				)
			}).loop <> Pdef(\chard);
		}!16),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,1,4, 2,5,3,6],inf),4),
		) <>
		Pdef(\orchestra)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,1,4, 2,5,3,6],inf),4),
		) <>
		Pfindur(4,Pdef(\orchestra)).loop,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,1,4, 2,5,3,6],inf),4),
		) <>
		Pseed(11002,Pfindur(4,Pdef(\orchestra))).loop,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,1,4, 2,5,3,6],inf),4),
			\out, BusDef(\sendbus1, \audio),
		) <>
		Prout({ arg ev;
			Pseq([12001,12002],10).stutter(2).do { arg seed, idx;
				Pfindur(4,Pseed(seed.postln,Pdef(\orchestra))).embedInStream
			};
		}),
		
	])
)).play;
);

///
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,1,4, 2,5,3,6],inf),4),
			\out, BusDef(\sendbus1, \audio),
		) <>
		Prout({ arg ev;
			Pseq([12001,12002] + 203,10).stutter(2).do { arg seed, idx;
				Pfindur(4,Pseed(seed.postln,Pdef(\orchestra))).embedInStream
			};
		}),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-KG89-73BQ", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.27731092436975,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.41062499172443,
	'delay2', 0.42682721311638,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.1794746792312,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,1,4, 2,5,3,6],inf),4),
			\out, BusDef(\sendbus1, \audio),
		) <>
		Prout({ arg ev;
			Pseq([12001,12002] + ( 211 * 2 ),10).stutter(2).do { arg seed, idx;
				Pfindur(4,Pseed(seed.postln,Pdef(\orchestra))).embedInStream
			};
		}),
		
	])
)).play;
);

///

(
Pdef(\chard, 
	Pbind(
		\instrument, \chardgrain,
		//\degree, Pwrand([0,2,4,6],[2,1,2,1].normalizeSum,inf),
		\cchord, [0,2,4,6b] +.x [-12,0,12],
		\cpond, [1,1,1,30.1].normalizeSum,
		\cpond, [1,1,1,0.4].normalizeSum,
		\mtranspose, 4,
		\dur, 1,
		\amp, 0.1/4,
	)
);
);

(

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pser([
					1,0,0,0, 1,0,0,0,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1113].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pser([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,0,1,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[282].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
				Pser([
					0,0,0,0, 1,0,0,0,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\mtranspose, Pstep(Pseq([2,5],inf),4),
			//\out, BusDef(\sendbus1, \audio),
		) <>
		Prout({ arg ev;
			if(~orchestragen.isNil) {
				"orchestragen is nil".error;
				nil.yield;
			};
			Pseq([12001,12001] + ( 212 * 2 ),10).stutter(2).do { arg seed, idx;
				Pfindur(4,Pseed(seed.postln,
					~orchestragen.(idx+12)
				)).embedInStream
			};
		}),
		
	])
)).play;
);

(
	~orchestragen = { arg numpart=16;
		Ppar({ 
			Plazy({ 
				Pbind(
					\dur, Pn([1/4,1/3,1/2,1/8,1/12,1/9,1/16].choose,rrand(16*4,16*8)),
					\amp, 0.1,
					//\ctranspose, rrand(-12, 12),
					//\mtranspose, rrand(-7, 7),
					\legato, rrand(0.1,1),
					\adsr, [ Env.adsr(rrand(0.01,2),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)) ],
					\pan, rrand(-1,1),
					\lpfr, rrand(0.4,4),
					\rq, rrand(0.2,1),
					//\fmr, [1,1/2,2,3/2,2/3].choose,
					\fmr, [1,1/2,2].choose,
					\fmamp, rrand(0.0,2),
					\octave, [3,4,5,6].choose,
					\amp, Pkey(\amp) / 8,
					\degree, Prout({ arg ev;
						var len = ev[\cchord].size;
						var idxlist = (0 .. ev[\cchord].size - 1);
						//idxlist.scramble;
						idxlist = 100.collect({ idxlist.wchoose(ev[\cpond]) });
						10000.do { arg idx;
							ev = ev[\cchord][ idxlist[idx % ev[\cchord].size] ].yield;
						};
						ev;
					}).loop,
					\isRest, Pseq([
						0,0,0,0,
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
					].scramble,inf).coin.not,
				)
			}).loop <> Pdef(\chard);
		}!numpart);

	};
);

//////////

(

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pser([
					1,0,0,0, 1,0,0,0,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1113].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pser([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,0,1,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[282].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
				Pser([
					0,0,0,0, 1,0,0,0,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			\instrument, \chardgrain,
			\lpfr, ~pmodenv.(Pseq([1,2,0.9,4,0.7].scramble,1), 2).loop,
			\rq, 0.3,
			\fmr, Pseq([1,1/2,1,2],inf),
			\fma, ~pmodenv.(Pseq([1,2,1,4]/4,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 4,
			\degree, Pswitch1(
				[
					0,2,4,6b,
				] +.x [-12,0,12], 
				Plazy({ arg ev;
					Pseq([
						Pser({ 
							( 0 .. 4*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 4,32),
						Pser({ 
							( 0 .. 4*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 8,32),
						Pser({ 
							( 0 .. 4*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 32,32*2),
					],inf)
				}) % Pseq([2,3,4,8,16],inf).stutter(16),
			),
			\lpfrenv, Pseq([
				[ Env([0,1,0],[rrand(0.01,0.2),rrand(0.01,0.8)]) ],
			],inf),
			\lpfrenvamt, rrand(0.0,1),
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
				],64*9),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			\instrument, \chardgrainpulse,
			\lpfr, ~pmodenv.(Pseq([1,2,0.9,4,0.7].scramble,1), 2).loop,
			\rq, 0.3,
			\fmr, Pseq([1,1/2,1,2],inf),
			\fma, ~pmodenv.(Pseq([1,2,1,4]/4,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 4,
			\degree, Pswitch1(
				[
					0,1,2,3,
					4,5,6,7,
				] +.x [-12,0,12], 
				Plazy({ arg ev;
					Pseq([
						Pser({ 
							( 0 .. 8*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 4,24),
						Pser({ 
							( 0 .. 8*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 8,32),
						Pser({ 
							( 0 .. 8*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 32,32*2),
					],inf)
				}) % Pseq([2,3,4,8,16],inf).stutter(24),
			),
			\lpfrenv, Pseq([
				[ Env([0,1,0],[rrand(0.01,0.2),rrand(0.01,0.8)]) ],
			],inf),
			\lpfrenvamt, rrand(0.0,1),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
				Pser([
					1,1,1,1, 1,1,1,1,
				],64*11),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pseq([
			Event.silent(16),
			Pfindur(32,Pbind(
				\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			) <> ~orchestragen.(4)),
			Pfindur(32,Pbind(
				\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			) <> ~orchestragen.(16)),
		],inf),
		
	])
)).play;
);

(
SynthDef(\chardgrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpfrenv.kr(Env([0,1,0],[0.1,0.8])), 1);

	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( ( \lpfr.kr(1.1) * freq ) * (env1 * \lpfrenvamt.kr(0.3) + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * AmpCompA.kr(freq, 80, minAmp:0.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chardgrainpulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpfrenv.kr(Env([0,1,0],[0.1,0.8])), 1);

	sig = LFPulse.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( ( \lpfr.kr(1.1) * freq ) * (env1 * \lpfrenvamt.kr(0.3) + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * AmpCompA.kr(freq, 80, minAmp:0.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pser([
					1,0,0,0, 1,0,0,0,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1113].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pser([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,0,1,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[282].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
				Pser([
					0,0,0,0, 1,0,0,0,
				],64*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			\instrument, \chardgrain,
			\lpfr, ~pmodenv.(Pseq([1,2,0.9,4,0.7].scramble,1), 2).loop,
			\rq, 0.3,
			\fmr, Pseq([1,1/2,1,2],inf),
			\fma, ~pmodenv.(Pseq([1,2,1,4]/4,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 4,
			\degree, Pswitch1(
				[
					0,2,4,6b,
				] +.x [-12,0,12], 
				Plazy({ arg ev;
					Pseq([
						Pser({ 
							( 0 .. 4*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 4,32),
						Pser({ 
							( 0 .. 4*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 8,32),
						Pser({ 
							( 0 .. 4*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 32,32*2),
					],inf)
				}) % Pseq([2,3,4,8,16],inf).stutter(16),
			),
			\lpfrenv, Pseq([
				[ Env([0,1,0],[rrand(0.01,0.2),rrand(0.01,0.8)]) ],
			],inf),
			\lpfrenvamt, rrand(0.0,1),
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
				],64*9),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			//\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			\instrument, \chardgrainpulse,
			\lpfr, ~pmodenv.(Pseq([1,2,0.9,4,0.7].scramble,1), 2).loop,
			\rq, 0.3,
			\fmr, Pseq([1,1/2,1,2],inf),
			\fma, ~pmodenv.(Pseq([1,2,1,4]/4,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\octave, 4,
			\degree, Pswitch1(
				[
					0,1,2,3,
					4,5,6,7,
				] +.x [-12,0,12], 
				Plazy({ arg ev;
					Pseq([
						Pser({ 
							( 0 .. 8*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 4,24),
						Pser({ 
							( 0 .. 8*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 8,32),
						Pser({ 
							( 0 .. 8*3-1 ).wchoose([1,1,1,0.2].normalizeSum) 
						} ! 32,32*2),
					],inf)
				}).wrap(Pseq([8,0,16],inf).stutter(30), Pseq([2,3,4,8,16]*4,inf).stutter(24)),
			),
			\lpfrenv, Pseq([
				[ Env([0,1,0],[rrand(0.01,0.2),rrand(0.01,0.8)]) ],
			],inf),
			\lpfrenvamt, rrand(0.0,1),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
				Pser([
					1,1,1,1, 1,1,1,1,
				],64*11),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pseq([
			Event.silent(16),
			Pfindur(32,Pbind(
				\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			) <> ~orchestragen.(4)),
			Pfindur(32,Pbind(
				\mtranspose, Pstep(Pseq([0,2,1,3],inf),4),
			) <> ~orchestragen.(16)),
		],inf),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1849].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/20,
		),
		Pbind(
			\instrument, \chardgrain,
			\note, Pseq([
				//Pseq((0..12))
				Pseq([0,3,7,3] +.x [0,12])
			],inf).wrap(Pseq((0..1),inf).round, Pseq((4..12),inf) ),
			\octave, 5,
			\fmr, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/8,
			\legato, 0.4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chardgrain,
			\note, Pseq([
				//Pseq((0..12))
				Pseq([0,3,7,3] +.x [0,12])
			],inf).wrap(Pseq((0..1),inf).round, Pseq((4..12),inf) ),
			\octave, 4,
			\dur, 1/16,
			\legato, 0.4,
			\amp, 0.1,
		),
		
	])
)).play;
);
