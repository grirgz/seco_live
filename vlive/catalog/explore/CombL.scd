(
SynthDef(\dmd, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=10;
	lfo1 = XLine.kr(1,1/2,16/~t);
	sig = LFPulse.ar(freq * lfo1).bipolar;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.4) * LFNoise1.ar(0.1!num,mul:0.7,add:1)) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig / 5;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\dmd, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=7;
	lfo1 = XLine.kr(1,1/2,6/~t);
	sig = LFPulse.ar(freq * lfo1).bipolar;
	//sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		//1,0,0,0,
	//],inf));
	sig = CombL.ar(sig, \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),2/~t) + ( sig/num/2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\dmd,
			\octave, 6,
			\note, Pseq([
				0,-2,3,7
			],inf),
			\dur, 4,
			\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\dmds, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=7;
	lfo1 = 1;
	lfo2 = XLine.kr(1,1/12,6/~t);
	sig = LFPulse.ar(freq * lfo1).bipolar;
	//sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		//1,0,0,0,
	//],inf));
	sig = AllpassL.ar(sig, \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),1.07/~t * lfo2) + ( sig/num/2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\dmds, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=7;
	//lfo1 = XLine.kr(1,1/2,6/~t);
	lfo1 = 1;
	sig = LFSaw.ar(freq * lfo1).bipolar;
	//sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		//1,0,0,0,
	//],inf));
	sig = AllpassL.ar(sig, \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),2/~t) + ( sig/num/2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\dmds,
			\octave, [3,4,6],
			\note, Pseq([
				0,-2,3,7
			],inf),
			\dur, 4,
			\delay, 0.1,
			\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\dmds,
			\octave, 3,
			\note, Pseq([
				0,-2,3,7
			],inf),
			\dur, 4,
			\delay, 0.1,
			\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			\amp, 0.1,
		),
		Pmono(\dmds,
			\octave, 4,
			\note, Pseq([
				7,5,7,5
			],inf),
			\dur, 4,
			\delay, 0.1,
			\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			\amp, 0.1,
		),
		Pmono(\dmds,
			\octave, 6,
			\note, Pseq([
				3,2,0,3
			],inf),
			\dur, 4,
			\delay, 0.1,
			\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////////
(
SynthDef(\ddd, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=7;
	lfo1 = 1;
	lfo2 = XLine.kr(1,1/12,6/~t);
	lfo2 = EnvGen.kr(Env([0,1,0],[0.1,1.8], -2), \ttrig.tr(1));
	sig = LFPulse.ar(freq * [1/2,1,4] * lfo1).bipolar;
	//sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		//1,0,0,0,
	//],inf));
	sig = AllpassL.ar(sig, \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),1.07/~t * lfo2) + ( sig/num/2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\ddd, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=7;
	lfo1 = 1;
	lfo2 = XLine.kr(1,1/12,6/~t);
	lfo2 = EnvGen.kr(Env([0,1,0],[0.1,1.8], -2), \ttrig.tr(1)) * \envamt.kr(4) + 1;
	sig = LFPulse.ar(freq * [1/2,1,4] * lfo1).bipolar;
	//sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		//1,0,0,0,
	//],inf));
	sig = CombL.ar(sig, \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),0.47/~t * lfo2) + ( sig/num/2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\ddd,
			\octave, 4,
			\note, Pseq([
				0,-2,3,7
			],inf),
			\ttrig, 1,
			\dur, 4,
			\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			\amp, 0.1,
		),
		
	])
)).play;
);


//////////////
(
SynthDef(\fxcombcluster, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num=7;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = in;
	lfo1 = 1;
	lfo2 = XLine.kr(1,1/12,6/~t);
	sig = sig * SinOsc.ar(300);
	sig = AllpassL.ar([ sig ], \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),1.07/~t * lfo2) + ( sig/num/2 );
	sig = sig.mean;
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,-2,3,7
			],inf),
			\octave, [3,4,5],
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\combc, \audio),
		),
		Pmono(\fxcombcluster,
			\inbus, BusDef(\combc, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);
