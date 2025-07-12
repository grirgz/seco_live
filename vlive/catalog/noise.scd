
/////// standard noise
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = BrownNoise.ar;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = PinkNoise.ar;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Dust.ar(1500);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
// sound like WhiteNoise but is deterministic
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
    sig = Hasher.ar( SinOsc.ar(100));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

/////// LFNoise


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(150 * LFNoise1.ar(1000));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(15000 * LFNoise1.ar(400));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(1150 * LFNoise1.ar(1000));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(1150 * LFNoise1.ar(1000));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(1150 * LFNoise1.ar(1000));
	sig = ( sig*\distamp.kr(1000) ).tanh * \distpostamp.kr(1/2);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


/////// fm noise
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(100 * ( SinOsc.ar(100 * ( SinOsc.ar(100) * 1000 + 1 )) * 1000 + 1 )) * 1000 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=839, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(304 * ( SinOsc.ar(20 * ( SinOsc.ar(0.1) * 1000 + 1 )) * 1000 + 1 )) * 10 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=139, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(304 * ( SinOsc.ar(10 * ( SinOsc.ar(1) * 1000 + 1 )) * 1000 + 1 )) * 10 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=2139, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(44.3 * ( SinOsc.ar(10 * ( SinOsc.ar(0.3) * 1000 + 1 )) * 1000 + 1 )) * 1000 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(4 * ( SinOsc.ar(1 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * 100 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	freq = XLine.kr(10,1000,100);
	sig = SinOsc.ar(freq * ( SinOsc.ar(4 * ( SinOsc.ar(1 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * 100 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(10,2000,100);
	freq = XLine.kr(10,1000,100);
	sig = SinOsc.ar(freq * ( SinOsc.ar(4 * ( SinOsc.ar(1 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * env1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


//////// henon

// default initial params
{ HenonN.ar(MouseX.kr(20, SampleRate.ir)) * 0.1 ! 2 }.play(s);

// mouse-control of params
{ HenonN.ar(SampleRate.ir/4, MouseX.kr(1,1.4), MouseY.kr(0,0.3)) * 0.1 ! 2 }.play(s);

// randomly modulate params
(
{ HenonN.ar(
    SampleRate.ir/8/8,
    LFNoise2.kr(1, 0.2, 1.2),
    LFNoise2.kr(1, 0.15, 0.15)
) * 0.1 ! 2 }.play(s);
)

// as a frequency control
Ndef(\zed,{ SinOsc.ar(HenonN.ar(80, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*80+200)*0.1!2 }).play;


(
SynthDef(\henonosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fm;
	//sig = SinOsc.ar(HenonN.ar(3020, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*470+freq);
	fm = HenonN.ar(3020, MouseX.kr(1,1.4), MouseY.kr(0,0.3));
	sig = SinOsc.ar(freq * ( LeakDC.ar(fm) * 1.5 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\henonosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fm;
	var lpenv;
	//sig = SinOsc.ar(HenonN.ar(3020, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*470+freq);
	//fm = HenonN.ar(\henonfreq.kr(320), MouseX.kr(1,1.4), MouseY.kr(0,0.3));
	fm = HenonN.ar(\henonfreq.kr(320), \henona.kr(0).linlin(0,1,1,1.4), \henonb.kr(0).linlin(0,1,0,0.3));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.7,0.1,0.8,7.1)), gate, doneAction:0) * \lpadsramt.kr(1.4) + 1;
	sig = SinOsc.ar(freq * ( LeakDC.ar(fm) * \fma.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(0.8) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = RLPF.ar(sig, ( \lpfr.kr(0.8) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\henonosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fm;
	var lpenv;
	var hmod, fmaenv;
	//sig = SinOsc.ar(HenonN.ar(3020, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*470+freq);
	hmod = EnvGen.kr(Env([0,1,0],[0.01,0.2],-3), 1) * 0.99;
	fm = HenonN.ar(\henonfreq.kr(44), ( \henona.kr(0) + hmod ).linlin(0,1,1,1.4), ( \henonb.kr(0) + hmod ).linlin(0,1,0,0.3));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.7,0.1,0.8,7.1)), gate, doneAction:0) * \lpadsramt.kr(1.4) + 1;
	fmaenv = EnvGen.kr(Env([0,4,-0.01],[0.01,1.0],-3), 1) * 1 + 1;
	sig = SinOsc.ar(freq * ( LeakDC.ar(fm) * \fma.kr(1) * fmaenv + 1 ));
	sig = sig * LFPulse.ar(freq/32);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.8) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	//sig = RLPF.ar(sig, ( \lpfr.kr * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \henonosc,
			\note, Pseq([
				[0,4,7,12],
				[0,4,7,12]+5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \henonosc,
			\note, Pseq([
				0,4,3,2,
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
		Pmono(\henonosc,
			//\freq, 800,
			\note, Pseq([
				0,5,3,2,
			],inf).stutter(1),
			\dur, 1,
			\fma, PmodEnv(Pseq([0,8],1), 8).loop,
			\henonfreq, PmodEnv(Pseq([10,1000],1), 8).loop,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \henonosc,
			\note, Pseq([
				0,4,3,2,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,3,2,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);
