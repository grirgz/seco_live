
///// copy video sound design
~t = 1; TempoClock.default.tempo = ~t;

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);





(
SynthDef(\whitenoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = LPF.ar(sig, (\lpf.kr(7000) ).clip(20,20000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \whitenoise,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\whitenoisebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = Ringz.ar(sig, \ringzfreq.kr(10),\ringzdecay.kr(0.01)) * \ringzgain.kr(1/10);
	sig = LPF.ar(sig, (\lpf.kr(7000) ).clip(20,20000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(
			\whitenoisebass,
			\ringzfreq, Pseq([
				~pmodenv.(Pseq([10,80],1), 8),
				Pn(80,inf),
			],inf),
			\ringzdecay, 0.1,
			\ringzgain, 1/50,
			\lpf, Pseq([
				~pmodenv.(Pseq([20,200],1), 4),
				Pn(200,inf)
			],inf),
			\amp, 1.4,
		),
	])
)).play;
);


(
SynthDef(\angelchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.00001) + 1) * ( LFNoise1.kr(1/9) * 0.01 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * ( LFNoise1.kr(1/4!4) * 0.8 + 1 ) ).clip(20,20000), \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(4.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fx_washit, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	//sig = DelayL.ar(sig, 0.3, 0.01 * ( LFNoise1.ar(3) * 0.01 + 1 )) + sig;
	//sig = CombL.ar(sig, 4/~t, 1/8/~t * ( LFNoise1.ar(3) * 0.01 + 1 ),4/~t) + sig;
	//sig = CombL.ar(sig, 4/~t, 1/2/~t * ( LFNoise1.ar(3) * 0.01 + 1 ),4/~t) + sig;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.9) ) + sig;

		isig = DelayL.ar(isig, 1.3, 0.01 * ( LFNoise1.ar(1474.03) * 0.01 + 1 )) + ( isig*0.1 );
		isig = DelayL.ar(isig, 0.3, 0.1 * ( LFNoise1.ar(0.03) * 0.1 + 1 )) + ( isig*0.1 );
		isig = DelayL.ar(isig, 0.3, 0.01 * ( LFNoise1.ar(0.03) * 0.1 + 1 )) + ( isig*0.1 );
		isig = DelayL.ar(isig, 0.3, 0.001 * ( LFNoise1.ar(0.03) * 0.1 + 1 )) + ( isig*0.1 );
		isig = DelayL.ar(isig, 0.3, 0.1 * ( LFNoise1.ar(4.03) * 0.01 + 1 )) + isig;
		isig = BRF.ar(isig, LFNoise1.kr(1/12).exprange(40.0,10000.0));
		isig = BRF.ar(isig, LFNoise1.kr(1/12).exprange(40.0,10000.0));
	
		isig = Limiter.ar(isig);
		isig;
	});
	sig = RHPF.ar(sig, 200);
	sig = RLPF.ar(sig, 8000);

	sig = SelectX.ar(\mix.kr(1.0), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \angelchord,
			\degree, Pseq([
				[  -14,-7, -5, -3, 0, 2, 4, 7, 9 ]
			],inf),
			\scale, Scale.minor,
			\dur, 4,
			\lpfr, 2.1,
			\octave, 6,
			\amp, 0.1/6/2,
			\out, BusDef(\fxreverb, \audio),
		),
		Pmono(\fx_washit,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			//\mix, 0.51,
			\lag, 0.0009,
			\dur, 1,
			\isRest, true,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\room, 12,
			\damp, 1,
			\mix, 0.51,
			\lag, 0.0009,
			\dur, 1,
			\isRest, true,
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\size, 5,
			\diff, 1,
			\delay, 1.01,
			\modDepth, 1,
			\modDepth, 4,
			\mix, 1,
			\dur, 1,
			\amp, 0.1,
		),
		//Pmono(\fx_freeverb2,
			//\inbus, BusDef(\fxreverb, \audio),
			//\addAction, \addToTail,
			//\room, 2,
			//\damp, 1,
			//\mix, 1,
			//\lag, 0.0009,
			//\gain, Pseq([
				//~pmodenv.(Pseq([0,0,1],1), Pseq([1,8]), 1, 2),
				//Pn(1,inf)
			//],inf),
			//\dur, 1,
		//),
		
	])
)).play;
);

(
	// nice guy
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \whitenoise,
			\dur, Pseq([
				Rest(4),
				0.4,
				Rest(4),
				0.051,
				Rest(0.051),
				0.5,
			],1),
			\amp, 0.1,
		),
		Pmono(
			\whitenoisebass,
			\ringzfreq, Pseq([
				~pmodenv.(Pseq([10,80],1), 8),
				Pn(80,inf),
			],inf),
			\ringzdecay, 0.1,
			\ringzgain, 1/50,
			\lpf, Pseq([
				~pmodenv.(Pseq([20,200],1), 4),
				Pn(200,inf)
			],inf),
			\amp, 1.4,
		),
		Pmono(
			 \angelchord,
			\degree, Pseq([
				[  -3, 0, 2, 4, 7, 9 ]
			],inf),
			\scale, Scale.minor,
			\dur, 4,
			\octave, 6,
			\amp, 0.1/6,
			\out, BusDef(\fxreverb, \audio),
		),
		Pmono(\fx_washit,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			//\mix, 0.51,
			\lag, 0.0009,
			\gain, Pseq([
				~pmodenv.(Pseq([0,0,1],1), Pseq([1,8]), 1, 2),
				Pn(1,inf)
			],inf),
			\dur, 1,
			\isRest, true,
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\size, 5,
			\diff, 1,
			\delay, 1.01,
			\modDepth, 1,
			\modDepth, 4,
			\mix, 1,
			\dur, 1,
			\gain, Pseq([
				~pmodenv.(Pseq([0,0,1],1), Pseq([1,8]), 1, 2),
				Pn(1,inf)
			],inf),
			\amp, 0.1,
		),
		
		Pmono(
			 \playersec,
			\bufnum, BufDef('field/Street-Ambience-2.flac'),
			\dur, 1,
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\hpf, Pseq([
				~pmodenv.(Pseq([2000,1000,20],1), 2, 1, -4),
				Pn(20,inf)
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


NoteTimeline(\bla).edit


////////////////


(
SynthDef(\bpnoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFNoise1.ar(freq);
	sig = sig + PinkNoise.ar;
	//sig = BPF.ar(sig, freq, 0.4);
	sig = LPF.ar(sig, freq/2);
	sig = HPF.ar(sig, freq*2);
	sig = sig * \gain.kr(40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	//sig = SinOsc.ar(freq * ( SinOsc.ar(freq*3/4 * ( LFNoise1.ar(1) * 0.1 + 1 ) ) * 14 + 1 ));
	sig = LFPulse.ar([70,1000,2000]).mean;
	//sig = sig + SinOsc.ar(freq * ( SinOsc.ar(110.13 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	//sig = HPF.ar(sig, 12799);
	//sig = LPF.ar(sig, 11000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	//sig = SinOsc.ar(freq * ( SinOsc.ar(freq*3/4 * ( LFNoise1.ar(1) * 0.1 + 1 ) ) * 14 + 1 ));
	sig = LFPulse.ar((Array.series(10,10.01,40))).mean;
	//sig = sig + SinOsc.ar(freq * ( SinOsc.ar(110.13 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	sig = HPF.ar(sig, 799);
	sig = LPF.ar(sig, 11000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	//sig = SinOsc.ar(freq * ( SinOsc.ar(freq*3/4 * ( LFNoise1.ar(1) * 0.1 + 1 ) ) * 14 + 1 ));
	sig = LFPulse.ar((Array.series(10,1.01,40))).mean;
	//sig = sig + SinOsc.ar(freq * ( SinOsc.ar(110.13 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	sig = HPF.ar(sig, 799);
	sig = LPF.ar(sig, 11000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	//sig = SinOsc.ar(freq * ( SinOsc.ar(freq*3/4 * ( LFNoise1.ar(1) * 0.1 + 1 ) ) * 14 + 1 ));
	sig = LFPulse.ar((Array.series(10,90.01,100))).mean;
	//sig = sig + SinOsc.ar(freq * ( SinOsc.ar(110.13 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	sig = HPF.ar(sig, 799);
	sig = LPF.ar(sig, 11000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	sig = SinOsc.ar(freq * ( SinOsc.ar(110.12 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	sig = sig + SinOsc.ar(freq * ( SinOsc.ar(110.13 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	sig = HPF.ar(sig, 1799);
	sig = LPF.ar(sig, 11000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = ( SinOsc.ar( EnvGen.kr(Env([0.1,100,0.01,1000,10,0.1],[10.1,0.1,3.1,3.8,10]), 1) ) * 1 + 1 );
	mod1 = Duty.kr(Dseq([1,1/2,1/4,1/4]*4/~t,inf), 0, Dseq([
		1,100,0.1,10,
	],inf));
	mod2 = Env([0.1,1,20],[30.1,30.8]).kr;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	sig = SinOsc.ar(freq  * ( SinOsc.ar(110.12* mod1 * ( LFNoise1.ar(100) * 0.1 * mod2 + 1 ) ) * 14 + 1 ));
	sig = sig + SinOsc.ar(freq * mod1 * ( SinOsc.ar(110.13 * ( LFNoise1.ar(100) * 0.01 + 1 ) ) * 14 + 1 ));
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	sig = HPF.ar(sig, 39);
	sig = LPF.ar(sig, Env([1000,1,10100,1000],[1.1,5.8,5]).circle.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\hum,
			\freq, 100,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	///// obscuria
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(
			 \bpnoise,
			\freq, 2200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);





////////////////////////////////
// sound design draft

(
SynthDef(\fmdouble, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq*\f1r.kr(1)+\f1offset.kr(0) * ( SinOsc.ar(freq*\f2r.kr(1/2)+\f2offset.kr(0.0002) * ( SinOsc.ar(freq*\f3r.kr(1)+\f3offset.kr(0.001)) * \f3amp.kr(6) + 1 )) * \f2amp.kr(1.80) + 1 )) * \f1amp.kr(1).poll;
	sig1 = Pan2.ar(sig1, \pan1.kr(-1), 1);
	sig2 = SinOsc.ar(freq*\f6r.kr(1)+\f6offset.kr(0) * ( SinOsc.ar(freq*\f7r.kr(1)+\f7offset.kr(0.0002) * ( SinOsc.ar(freq*\f8r.kr(1)+\f8offset.kr(0.001)) * \f8amp.kr(6.01) + 1 )) * \f7amp.kr(1.80) + 1 )) * \f6amp.kr(1);
	sig2 = Pan2.ar(sig2, \pan2.kr(0), 1);

	//sig = SelectX.ar(\wavemix.kr(0.5), [sig1, sig2]);
	sig = sig1 + sig2;

	sig3 = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.0), [sig, sig3]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,7,0,
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \fmdouble,
			\note, Pseq([
				0,4,7,0,
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,7,0,
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pbindef(\fmdouble,
			\instrument, \fmdouble,
			\note, Pseq([
				0,4,7,0,
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
);

Pbindef(\fmdouble).edit




///// scary
(
SynthDef(\angelchorddetune, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.00001) + 1) * ( LFNoise1.kr(1/2) * 0.2 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * ( LFNoise1.kr(1/4!4) * 0.8 + 1 ) ).clip(20,20000), \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(4.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \angelchorddetune,
			\degree, Pseq([
				[  -3, 0, 2, 4, 7, 9 ]
			],inf),
			\scale, Scale.minor,
			\dur, 4,
			\octave, 6,
			\amp, 0.1/6/2,
			\out, BusDef(\fxreverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

///////////////////
//// dirty bass


(
SynthDef(\hum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	//freq = 30;
	sig = Blip.ar(freq , 100);
	//sig = sig * ( WhiteNoise.ar * 0.1 + 1 );
	//sig = HPF.ar(sig, 199);
	//sig = LPF.ar(sig, 11000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \hum,
			\note, Pseq([
				0,4,2,-1,
				-4,-5,9,8,
			],inf),
			\legato, Pseq([
				1,1,1,1,
				0.4,0.1,0.5,0.4,
			],inf) * 0.8,
			\octave, 2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				0,3,2b,1,
			],inf),
			\octave, 3,
			\dur, 1,
			\legato, 0.4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-RASG-3P1L", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.83193277310924,
	'gain', 0.49159663865546,
	'fb', 0.0001,
	'delay', 0.62852032692401,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 66.608462908092,
	'pitchlag', 1.0,
	'pitchmix', 0.45378151260504,
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


/////////////////////////////



FileSystemProject.load("./sun22_FxManager_dirtybass.scd")
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1755].value,
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
			\bufnum, ~buflib.hat[1563].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,1,0,
				//0,0,1,0, 0,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,1, 1,1,0,1,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \hum,
			\note, Pseq([
				0, 7-12,
				0, 7-12,
				0, 7-12,
				4-12,-12,
				//0,4,2,-1,
				//-4,-5,9,8,
			],inf).stutter(2) + Pseq([
				0,0,0,-1,0,0,0,-7
				
			],inf).stutter(16) -5 + Pseq([
				0,7
				
			],inf).stutter(8*16),
			\legato, Pseq([
				1,1,1,1,
				0.4,0.1,0.5,0.4,
			],inf) * 0.8,
			\octave, 2,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,
				2,0,0,2, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Prout({ arg ev;
			loop  {
				// 5-8O8U-8I0S
				ProtoDef(\rdn).proxy.set(\delay, 0.0001);
				3.wait;
				ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
				1.wait;

				ProtoDef(\rdn).proxy.set(\delay, 0.0001);
				3.wait;
				ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
				1.wait;

				ProtoDef(\rdn).proxy.set(\delay, 0.0001);
				1.wait;
				ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
				1.wait;
				ProtoDef(\rdn).proxy.set(\delay, 0.0001);
				1.wait;
				ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
				1.wait;

				ProtoDef(\rdn).proxy.set(\delay, 0.0001);
				3.wait;
				ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
				1.wait;
			}
		}),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				(0..15),
				8,9,8,9,
				0,1,0,1,
				8,9,8,9,
				0,1,0,1,
				(0..15),
				0,0,0,0, (0..3),
				4,0,0,4, (0..3)+8+4,
				(0..7),
				(0..7)+8,
				8,9,9,10, 10,11,11,12,
				(0..7)+8,
			].flat,inf)/8/ Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \playersec,
			   	\bufnum, ~buflib.kick[1266].value,
			   	//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			   	\isRest, Pseq([

					Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
					],3),
					Pseq([
						1,0,0,0, 1,1,1,1,
						1,0,0,0, 0,0,0,1,
						1,0,0,1, 1,0,1,1,
						1,0,0,1, 0,0,1,0,
					],1),
			   	],inf).coin.not,
			   	\dur, 1/8,
			   	\gain, 0.1,
			   	\out, BusDef(\sendbus2, \audio),
			   ),
			   4,Pbind(
			   	\instrument, \playersec,
			   	//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			   	\bufnum, ~buflib.snare[1755].value,
			   	\isRest, Pseq([
			   		0,0,0,0, 0,0,0,0,
			   		1,0,0,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\dur, 1/8,
			   	\gain, 0.11,
			   	\lag, 0.04,
			   ),
			   8,Pbind(
			   	\instrument, \playersec,
			   	\bufnum, ~buflib.hat[1563].value,
			   	//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			   	\isRest, Pseq([
			   		//0,0,1,0, 0,0,1,0,
			   		//0,0,1,0, 0,0,1,0,
			   		1,0,0,0, 1,0,0,0,
			   		1,0,0,0, 0,0,1,0,
			   		1,1,1,1, 1,1,1,1,
			   		1,0,0,0, 0,0,1,0,
			   		1,0,1,0, 0,1,0,0,
			   		1,1,1,1, 0,0,0,0,
			   		1,0,1,1, 1,1,0,1,
			   		1,0,0,0, 0,0,1,0,
			   	],inf).coin.not,
			   	\dur, 1/8,
			   	\gain, 0.11/2,
			   	//\lag, 0.04,
			   	\out, BusDef(\sendbus3, \audio),
			   ),
			   16,Pbind(
			   	\instrument, \hum,
			   	\note, Pseq([
			   		0, 7-12,
			   		0, 7-12,
			   		0, 7-12,
			   		4-12,-12,
			   		//0,4,2,-1,
			   		//-4,-5,9,8,
			   	],inf).stutter(2) + Pseq([
			   		0,0,0,-1,0,0,0,-7
			   
			   	],inf).stutter(16) -5 + Pseq([
			   		0,7
			   
			   	],inf).stutter(8*16),
			   	\legato, Pseq([
			   		1,1,1,1,
			   		0.4,0.1,0.5,0.4,
			   	],inf) * 0.8,
			   	\octave, 2,
			   	\legato, Pseq([
					Pseq([
						8,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,0,1,
						8,0,0,0, 0,0,0,0,
						2,0,0,2, 0,0,2,0,
					],3),
						8,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,0,1,
						8,0,0,0, 0,0,0,0,
						Pser([Rest()],8),
			   	],inf),
			   	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			   	\dur, 1/8,
			   	\amp, 0.1,
			   	\out, BusDef(\sendbus1, \audio),
			   ),
			   16,Prout({ arg ev;
			   	loop  {
					// lenght: 32 beats
			   		// 5-8O8U-8I0S
						
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		3.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		3.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		3.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;

					////

			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		3.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		3.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   
			   		ProtoDef(\rdn).proxy.set(\delay, 0.0001);
			   		ProtoDef(\rdn).proxy.set(\delay2, 1.0001);
			   		3.wait;
			   		ProtoDef(\rdn).proxy.set(\delay, exprand(0.001,1.0));
			   		1.wait;
			   		ProtoDef(\rdn).proxy.set(\delay2, 0.0001);
			   	}
			   }),
			   32,Pbind(
			   	\instrument, \playersec,
			   	\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			   	\legato, 1,
			   	\st, 110/2/60,
			   	\speed, 1 * ~t / Pkey(\st),
			   	\pos, Pseg(Pseq([
			   		0, 4,
			   	]+0,1),4).loop / Pkey(\st),
			   	\pos, Pseq([
			   		(0..15),
			   		8,9,8,9,
			   		0,1,0,1,
			   		8,9,8,9,
			   		0,1,0,1,
			   		(0..15),
			   		0,0,0,0, (0..3),
			   		4,0,0,4, (0..3)+8+4,
			   		(0..7),
			   		(0..7)+8,
			   		8,9,9,10, 10,11,11,12,
			   		(0..7)+8,
			   	].flat,inf)/8/ Pkey(\st),
			   	\dur, 1/8,
			   	\gain, 1/8,
			   	\out, BusDef(\sendbus4, \audio),
			   ),
		])
		
	])
)).play;
);



///////////////


a = Ndef(\flex).mold(2, 'audio', 'elastic', 100);
a = Ndef(\flex2).mold(2, 'audio', 'elastic', 100);
a = Ndef(\flex3).mold(2, 'audio', 'elastic', 100);
Ndef(\flex4).mold(2, 'audio', 'elastic', 3);


Ndef(\flex4).play
Ndef(\flex4)[0] = {SinOsc.ar(166) * 0.1}
a.play;
a.fadeTime = 100;
a.fadeTime

(
a[0] = {SinOsc.ar(366) * 0.1}
)

Main.version


{Impulse.ar(freq: 0.0,phase: 0.0,mul: 1.0,add: 0.0)}.play
{Impulse.ar(freq: 10.5,phase: 0.0,mul: 1.0,add: 0.0)}.plot(4)



////////////////////////////

(
p = Pbind(
    \degree, Prand([-9, 1, 2, 4, 5,-2,-5, 3, 2, 5, 3,-9], inf),
	\octave, 3,
    \dur, 0.26
).play;
) 

(
Pdef(\mypat,
	Ppar([
		Pbind(
			\degree, Prand([-9, 1, 2, 4, 5,-2,-5, 3, 2, 5, 3,-9], inf),
			\octave, Prand([4,5,6],inf),
			\dur, 0.26
		),
		Pbind(
			\degree, Prand([-9, 1, 2, 4, 5,-2,-5, 3, 2, 5, 3,-9], inf),
			\octave, 3,
			\dur, 0.26
		),
	])
).play;
);

(
SynthDef(\basickick, { arg out=0, amp=0.1, pan=0, freq=200;
	var sig;
	var env = EnvGen.kr(Env([400,70,50],[0.02,0.08]), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\mypat,
	Ppar([
		Pbind(
			\degree, Prand([-9, 1, 2, 4, 5,-2,-5, 3, 2, 5, 3,-9], inf),
			\octave, Prand([4,5,6],inf),
			\dur, 0.26
		),
		Pbind(
			\degree, Prand([-9, 1, 2, 4, 5,-2,-5, 3, 2, 5, 3,-9], inf),
			\octave, 3,
			\dur, 0.26
		),
		Pbind(
			\instrument, \basickick,
			\dur, 0.26/2,
			\amp, 0.2 * Pseq([1,0,1,0, 0,0,0,0],inf),
		),
	])
).play;
);


