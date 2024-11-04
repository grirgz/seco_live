
(
	// Nick Collins tutorial on server side sequencing
	{
		var mouse_y, mouse_x;
		mouse_y = MouseY.kr (0, 4) * [ 0, 128, 256, 128  ] / SampleRate.ir;
		mouse_x = MouseX.kr (10, 300, 'exponential');
		EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], mouse_y.poll), Impulse.ar (mouse_x) );

	}.play

)

(
Ndef(\impulsebass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mouse_y, mouse_x;
	mouse_y = MouseY.kr (0, 4) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	mouse_x = MouseX.kr (10, 300, 'exponential');
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], mouse_y.poll), Impulse.ar (mouse_x) );
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

/////// base synthdef

(
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebass,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			\timefac, ~pmodenv.(Pseq([0.1,1,4],4).trace, 8, 1, \exp).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////// changing wavetime

(
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	// this make it more aggressive, more harmonics
	wavetime = \timefac.kr(0.5) * [ 0, 428, 56, 128  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebass,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			\timefac, ~pmodenv.(Pseq([0.1,1],4), 8, 1, \exp).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

// changing wavetime
// pulse wave

(
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	wavetime = \timefac.kr(0.5) * [ 0, 0, 256, 0, 256, 0  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, 1,-1,-1, 0  ], wavetime), Impulse.ar (freq) );
	//sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebass,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			//\timefac, ~pmodenv.(Pseq([0.1,1],4), 8, 1, \exp).loop,
			\timefac, 1,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////// waveshaping using phase of sinosc give interesting results

(
SynthDef(\impulsebassosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig = SinOsc.ar(0, sig*pi*\phasefac.kr(1));
	//sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebassosc,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			\timefac, ~pmodenv.(Pseq([0.1,1],4), 8, 1, \exp).loop,
			\phasefac, ~pmodenv.(Pseq([0.1,2,1,4],1), 5).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

////// adding RLPF

(
// env on RLPF and phasefac is nice
SynthDef(\impulsebassosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,4,1],[0.2,0.2]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[0.2,0.2]), 1);
	sig = SinOsc.ar(freq);
	// changing time do not change a lot
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	// waveshaping using phase of sinosc give interesting results
	sig = SinOsc.ar(0, sig*pi*\phasefac.kr(1) * env1);
	sig = LeakDC.ar(sig);
	sig = RLPF.ar(sig, ( \lpfr.kr(2.1) * freq * env2 ).clip(20,20000), \rq.kr(0.2));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebassosc,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			\timefac, ~pmodenv.(Pseq([0.1,1],4), 8, 1, \exp).loop,
			\phasefac, ~pmodenv.(Pseq([0.1,2,1,4],1), 5).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]+1,1), 7).loop,
			\octave, Pseq([
				2,3,4
			],inf).stutter(4),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


//////////// effects

(
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig = DelayL.ar(sig, 0.2, ( 1/(\delfac.kr(1) * freq) ).poll)+sig / 2;
	sig = DelayL.ar(sig, 0.2, ( 1/(\delfac.kr(1) * freq+20) ).poll)+sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\impulsebass,
			\note, Pseq([
				0,-1,
			],inf),
			\delfac, ~pmodenv.(Pseq([8,2,1,4],10), 8).loop,
			\timefac, ~pmodenv.(Pseq([0,2],10), 7).loop,
			\octave, Pseq([
				3,2,
			],inf).stutter(2),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////////// multichannel

(
// normal
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// diff in wavetime factor
// kind of autopan, very nice
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	wavetime = \timefac.kr(1.1) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig1 = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig2 = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime*1.91), Impulse.ar (freq) );
	sig = [sig1, sig2];
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// diff in impulse freq
// subtle deepness
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	sig1 = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig2 = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq+0.1) );
	sig = [sig1, sig2];
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// diff in impulse freq
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime, wavetime2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
	wavetime2 = \timefac.kr * [ 0, \wat.kr(1) * 128, 256, 128  ] / SampleRate.ir;
	sig1 = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime), Impulse.ar (freq) );
	sig2 = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime2), Impulse.ar (freq) );
	sig = [sig1, sig2];
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebass,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			// moving timefac move the pan
			\timefac, ~pmodenv.(Pseq([0.1,1,4],4).trace, 8, 1, \exp).loop,
			\wat, ~pmodenv.(Pseq([1/2,2,1,4],1), 9).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
// multichan
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	sig = 10.collect { arg item, idx;

		wavetime = \timefac.kr(0.5) * [ 0, 128, 256, 128  ] / SampleRate.ir;
		sig = EnvGen.ar( Env([ 0, 0, 1, -1, 0  ], wavetime * LFNoise1.kr(1/2).range(0.5,1.5)), Impulse.ar (freq* LFNoise1.kr(1/2).range(0.995,1.005)) );
		sig;
	};
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impulsebass,
			\note, Pseq([
				0,4,2,-3,
			],inf),
			// moving timefac move the pan
			\timefac, ~pmodenv.(Pseq([0.1,1,4],4).trace, 8, 1, \exp).loop,
			\wat, ~pmodenv.(Pseq([1/2,2,1,4],1), 9).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// multichan
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	sig = 10.collect { arg item, idx;

		wavetime = \timefac.kr(0.5) * [ 0, LFNoise1.kr(1/32).range(0.0,428), 128, 256, 128  ] / SampleRate.ir;
		sig = EnvGen.ar( Env([ 0, 0,0, 1, -1, 0  ], wavetime ), Impulse.ar(freq) );
		sig;
	};
	//sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.2));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


~t = 145/2/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1077].value,
			\bufnum, ~buflib.kick[114].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[883].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1921].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4,
		),
		Pmono(\impulsebass,
			\note, Pseq([
				0,4,2,-3,
				0,14,12,13,
			].rotate(1),inf),
			// moving timefac move the pan
			\timefac, ~pmodenv.(Pseq([0.1,1,4],4).trace, 8, 1, \exp).loop,
			//\timefac, 2,
			//\wat, ~pmodenv.(Pseq([1/2,2,1,4],1), 9).loop,
			\lpf, ~pmodenv.(Pseq([1/2,2,1,4]*2100,1), 9).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////
(
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	sig = 10.collect { arg item, idx;

		wavetime = \timefac.kr(0.5) * [ 0, LFNoise1.kr(1/32).range(0.0,428), 128, 256, 128  ] / SampleRate.ir;
		sig = EnvGen.ar( Env([ 0, 0,0, 1, -1, 0  ], wavetime ), Impulse.ar(freq) );
		sig;
	};
	//sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = SinOsc.ar(0, sig*pi*\phasefac.kr(1) * EnvGen.kr(Env([1,4,1],[0.7,0.3]), Impulse.kr(1/2*~t)));
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.2));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\impulsebass,
			\note, Pseq([
				0,4,2,-3,
				0,14,12,13,
			].rotate(1),inf),
			// moving timefac move the pan
			\timefac, ~pmodenv.(Pseq([0.1,1,4],4).trace, 8, 1, \exp).loop,
			//\timefac, 2,
			//\wat, ~pmodenv.(Pseq([1/2,2,1,4],1), 9).loop,
			\lpf, ~pmodenv.(Pseq([1/2,2,1,4]*1100,1), 9).loop,
			\octave, Pseq([
				2,3,
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\impulsebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var wavetime;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,3,
		4,2,1,3,
	],inf));
	sig = 10.collect { arg item, idx;

		wavetime = \timefac.kr(0.5) * [ 0, LFNoise1.kr(1/32).range(0.0,428), 128, 256, 128  ] / SampleRate.ir;
		sig = EnvGen.ar( Env([ 0, 0,0, 1, -1, 0  ], wavetime ), Impulse.ar(freq) );
		sig;
	};
	//sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = SinOsc.ar(0, sig*pi*\phasefac.kr(1) * lfo1);
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
