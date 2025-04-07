
// https://www.youtube.com/watch?v=vAkjcDNEaSY&t=7s

// from gogo

{GVerb.ar(in: Decay.ar(in: Dust.ar(density: 5),decayTime: 0.1) * LPF.ar(in: WhiteNoise.ar,freq: (LFNoise1.ar(freq: 50).range(100,1500))), roomsize: 10,revtime: 2,damping: 0.5,inputbw: 0.5,spread: 25,drylevel: 0.1,earlyreflevel: 0.8,taillevel: 0.2,maxroomsize: 300)}.play;


{LPF.ar(in: (GVerb.ar(in: ((f=Decay.ar(in: Dust.ar(density: 1.0),decayTime: LFNoise1.kr(freq: 1,mul: 1,add: 0).range(0.1,0.25)) * LPF.ar(in: WhiteNoise.ar,freq: (LFNoise1.ar(freq: 20).range(20,300)));[f,f+DelayN.ar(in: f,maxdelaytime: 0.2,delaytime: LFNoise1.kr(freq: 3,mul: 1,add: 0).range(0.0001,0.1),mul: 1,add: 0)]) * 5).tanh, roomsize: 800,revtime: 6,damping: 0.5,inputbw: 0.5,spread: 25,drylevel: 0.2,earlyreflevel: 0.2,taillevel: 0.8,maxroomsize: 1001)),freq: 2500,mul: 1,add: 0)}.play;

{ LFClipNoise.ar.range(0,1) * 0.1 ! 2 }.play

/////////////////////

SampleTimeline(\orig).edit

(
Ndef(\crackle, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = Crackle.ar(1.95);
	sig = sig * Decay.ar(Dust.ar(4), 0.1);
	sig = RHPF.ar(sig, ( [100,300,200,79] * ( LFNoise1.ar(1) * 0.1 + 1 ) ).clip(20,20000), 0.1).mean;
	sig1 = sig;

	sig = Crackle.ar(1.95);
	sig = sig * Decay.ar(Dust.ar(4), 0.1);
	sig = RHPF.ar(sig, ( 9200 * ( LFNoise1.ar(1) * 0.1 + 1 ) ).clip(20,20000), 0.1);
	sig2 = sig;

	sig = Crackle.ar(1.95);
	sig = sig * Decay.ar(Dust.ar(4), 0.1);
	sig = RHPF.ar(sig, ( 3200 * ( LFNoise1.ar(1) * 0.1 + 1 ) ).clip(20,20000), 0.1);
	sig3 = sig;

	sig = [sig1, sig2, sig3].mean;
	sig = sig * 8;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
{ Crackle.ar(1.95, 0.5)  }.play;
{ Crackle.ar(Line.kr(1.0, 2.0, 3), 0.5, 0.5)  }.play;

(
Ndef(\crackle, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig1 = 8.collect { arg idx;
		sig = Crackle.ar(1.95);
		//sig = sig * Decay.ar(Dust.ar(rrand(1.0,10)), 0.3);
		sig = ( sig*\distamp.kr(240) ).tanh * \distpostamp.kr(1/2);
		sig = sig * LFNoise1.kr(1).unipolar;
		sig = RHPF.ar(sig, ( rrand(60.0,20000) * ( LFNoise1.ar(1) * 0.1 + 1 ) ).clip(20,20000), 0.1);
		sig = sig * LFClipNoise.ar(8).range(0,1);
	};

	sig = sig1.sum;
	//sig = sig * 8;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\crackle, { arg freq=1200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0],[0.01,0.08]), 1);
	sig = Impulse.ar(freq * env1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\filter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = In.ar(0, 2); 
	sig = in;
	sig = BPF.ar(sig, MouseX.kr(30,14000));
	ReplaceOut.ar(0,sig);
}).play;
);


//////
// idea: create percusive sound, then arrange them


(
SynthDef(\crackleunit, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([17000,20,1],[0.01,0.08]), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env.perc(0.001,0.01), trig, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\crackleunit, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(\env.kr(Env([1700,20,1],[0.01,0.08])), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env.perc(0.001,0.01), trig, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \crackleunit,
			\freq, 1200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(

			Pbind(
				\instrument, \crackleunit,
				\env, Pfunc({[ Env([rrand(500,17000.0), 20,1], [0.01,0.08]) ] }),
				\dur, Pwhite(0.01,0.7,inf),
				\amp, 0.1,
			)!18
		)
	])
)).play;
);

/////////////////////


/////////////////
// clicks


(
// with fm
SynthDef(\click, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(\env.kr(Env([1700,20,1],[0.01,0.08])), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env.perc(0.001,0.01), trig, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \click,
			\freq, 1200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;


(
// only env on sinosc
SynthDef(\click, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.perc(0.001,0.001), trig, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
// nice but too wet
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(

			Pbind(
				\instrument, \click,
				//\env, Pfunc({[ Env([rrand(500,17000.0), 20,1], [0.01,0.08]) ] }),
				\freq, Pwhite(20,14000.0,inf),
				\dur, Pwhite(0.4,0.7,inf),
				\amp, 0.1,
			)!15
		)
	])
)).play;
);

(
SynthDef(\click, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	sig = SelectX.ar(\mix.kr(0.02), [SinOsc.ar(freq), WhiteNoise.ar(0.4)]);
	sig = sig * EnvGen.ar(Env.perc(0.001,\rel.kr(0.01)), trig, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \click,
		\freq, Pseq([2000],inf),
		\dur, 1/4,
		\amp, 0.4,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		//Ppar(

			//Pbind(
				//\instrument, \click,
				////\env, Pfunc({[ Env([rrand(500,17000.0), 20,1], [0.01,0.08]) ] }),
				//\freq, Pwhite(1400,7400.0,inf),
				//\mix, 0.9,
				//\dur, Pwhite(0.4,1.7,inf),
				//\rel, Pwhite(0.2, 0.001),
				//\amp, 0.1,
			//)!3
		//),
		//Ppar(

			//Pbind(
				//\instrument, \click,
				////\env, Pfunc({[ Env([rrand(500,17000.0), 20,1], [0.01,0.08]) ] }),
				//\freq, Pwhite(40,17400.0,inf),
				//\mix, 0.9,
				//\dur, Pwhite(0.4,0.7,inf),
				//\rel, Pwhite(0.1, 0.001),
				//\amp, 0.1,
			//)!3
		//),
		//Ppar(

			//Pbind(
				//\instrument, \click,
				////\env, Pfunc({[ Env([rrand(500,17000.0), 20,1], [0.01,0.08]) ] }),
				//\freq, Pwhite(50,100.0,inf),
				//\dur, Pwhite(0.4,1.7,inf),
				//\rel, Pwhite(0.02, 0.01),
				//\amp, 0.4,
			//)!3
		//),
		//Ppar(

			//Pbind(
				//\instrument, \clicklo,
				////\env, Pfunc({[ Env([rrand(500,17000.0), 20,1], [0.01,0.08]) ] }),
				//\freq, Pwhite(1770,400.0,inf),
				//\dur, Pwhite(0.4,1.7,inf),
				//\rel, Pwhite(0.02, 0.01),
				//\amp, 0.4,
			//)!3
		//),
	])
)).play;
);

(
SynthDef(\clicklo, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([freq,60,80],[0.01,0.08]), 1);
	sig = SelectX.ar(\mix.kr(0.2), [SinOsc.ar(env), WhiteNoise.ar(0.4)]);
	sig = sig * EnvGen.kr(Env.perc(0.001,0.03), trig, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \clicklo,
		\freq, 60,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


//////////

(
SynthDef(\clickrez, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([freq,60,80],[0.01,0.08]), 1);
	//sig = Impulse.ar(0);
	sig = SelectX.ar(\mix.kr(0), [SinOsc.ar(env), WhiteNoise.ar(0.4)]);
	sig = sig * EnvGen.kr(Env.perc(0.001,0.13), trig, doneAction:2);
	sig = Resonz.ar(sig, \rezfreq.kr(700));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \clickrez,
		\freq, 1200,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \clickrez,
		\freq, 1200,
		\rezfreq, Pwhite(60,500.0,inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


///////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(
			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(60,14500.0,inf),
				\dur, Pwhite(0.4,1.7,inf),
				\amp, 0.1,
			)!18
		),
	])
)).play;
);

(
SynthDef(\clickrezhi, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([freq,freq,freq],[0.01,0.08]), 1);
	//sig = Impulse.ar(0);
	sig = SelectX.ar(\mix.kr(1), [SinOsc.ar(env), WhiteNoise.ar(0.4)]);
	sig = sig * EnvGen.ar(Env.perc(0.001,\rel.kr(0.001)), trig, doneAction:2);
	sig = Resonz.ar(sig, \rezfreq.kr(700));
	sig = HPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(

			Pbind(
				\instrument, \clickrezhi,
				\freq, Pwhite(500,20000.0,inf),
				\rezfreq, Pwhite(3060,14500.0,inf),
				\hpf, Pwhite(100,15000.0),
				\dur, Pwhite(0.4,1.7,inf),
				\amp, 0.1,
			)!18
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(

			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(60,14500.0,inf),
				\dur, Pwhite(0.4,1.7,inf),
				\amp, 0.1,
			)!18
		),
		Ppar(
			Pbind(
				\instrument, \clickrezhi,
				\freq, Pwhite(500,20000.0,inf),
				\rezfreq, Pwhite(3060,14500.0,inf),
				\hpf, Pwhite(100,15000.0),
				\dur, Pwhite(0.4,1.7,inf),
				\mix, 0.5,
				\amp, 0.1,
			)!8
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(

			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(60,14500.0,inf),
				\dur, Pwhite(0.4,1.7,inf),
				\amp, 0.1,
			)!18
		),
		Ppar(

			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(1200,4500.0,inf),
				\rezfreq, Pwhite(60,19500.0,inf),
				\mix, 1,
				\rel, 0.01,
				\dur, Pwhite(0.4,1.7,inf),
				\amp, 0.1,
			)!18
		),
	])
)).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Dust.ar(14);
	//sig = Resonz.ar(sig, 1000);
	sig = Ringz.ar(sig, 15000,0.01);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\clickhi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Dust.ar(freq);
	sig = Decay.ar(Dust.ar(freq),0.01) * WhiteNoise.ar;

	sig = Resonz.ar(sig, \rezfreq.kr(1000));
	//sig = Ringz.ar(sig, \rezfreq.kr(1000) * rrand(1,4.1!4),0.02).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(

			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(120,14500.0,inf),
				\dur, Pwhite(0.4,1.7,inf),
				\amp, Pwhite(0.1,0.4,inf),
				\pan, Pwhite(-1.0,1,inf),
			)!28
		),
		Ppar(

			Pbind(
				\instrument, \clickhi,
				\freq, 1,
				\rezfreq, Pexprand(60,15500.0,inf),
				\mix, 1,
				\rel, 0.01,
				\dur, Pwhite(0.4,1.7,inf),
				\amp, Pwhite(0.1,0.4,inf)*2,
				\pan, Pwhite(-1.0,1,inf),
			)!38
		),
	])
)).play;
);

///////////// share

(
SynthDef(\clickrez, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([freq,60,80],[0.01,0.08]), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env.perc(0.001,\rel.kr(0.13)), trig, doneAction:2);
	sig = Resonz.ar(sig, \rezfreq.kr(700));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\crackle,
	Ppar(
		Pbind(
			\instrument, \clickrez,
			\freq, Pwhite(200,1500.0,inf),
			\rezfreq, Pexprand(60,14500.0,inf),
			\dur, Pwhite(0.4,1.7,inf),
			\amp, 0.1,
		)!18
	)
).play;
);

////


(
SynthDef(\clickrez, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([freq,60,80],[0.01,0.08]), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env.perc(0.001,\rel.kr(0.13)), trig, doneAction:2);
	sig = Resonz.ar(sig, \rezfreq.kr(700));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\clickhi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Dust.ar(freq);
	sig = Decay.ar(Dust.ar(freq),0.01) * WhiteNoise.ar;

	sig = Resonz.ar(sig, \rezfreq.kr(1000));
	//sig = Ringz.ar(sig, \rezfreq.kr(1000) * rrand(1,4.1!4),0.02).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\crackle,
	Ppar([
		Ppar(
			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(120,14500.0,inf),
				\dur, Pwhite(0.4,1.7,inf),
				\amp, Pwhite(0.1,0.4,inf),
				\pan, Pwhite(-1.0,1,inf),
			)!28
		),
		Ppar(
			Pbind(
				\instrument, \clickhi,
				\freq, 2,
				\rezfreq, Pexprand(60,15500.0,inf),
				\mix, 1,
				\rel, 0.01,
				\dur, Pwhite(0.4,1.7,inf),
				\amp, Pwhite(0.1,0.4,inf)*2,
				\pan, Pwhite(-1.0,1,inf),
			)!38
		),
	])
).play;
);

////////////////// variations

(
Pdef(\crackle,
	Ppar([
		Ppar(
			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(120,14500.0 * Pseg(Pseq([1,1,0.01],1),8),inf),
				\dur, Pwhite(0.4,1.7,inf) * Pseg(Pseq([1,1,4],1),8),
				\amp, Pwhite(0.1,0.4,inf),
				\pan, Pwhite(-1.0,1,inf),
				\out, BusDef(\pfx1,\audio),
			)!28
		),
		Ppar(
			Pbind(
				\instrument, \clickhi,
				\freq, 2 * Pseg(Pseq([1,1,2],inf),8),
				\rezfreq, Pexprand(60 * Pseg(Pseq([1,1,100],1),8),15500.0,inf),
				\mix, 1,
				\rel, 0.01,
				\dur, Pwhite(0.4,1.7,inf),
				\amp, Pwhite(0.1,0.4,inf)*2 * Pseg(Pseq([1,1,0.1],inf),8),
				\pan, Pwhite(-1.0,1,inf),
				\out, BusDef(\pfx1,\audio),
			)!38
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\room, 1,
			\mix, 0.1,
			\lag, 0.0009,
			\dur, 1,
		),
	])
).play;
);

