
(
SynthDef(\basicfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * \modAmp.kr(1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			\modAmp, 40,
			\cratio, 2,
			\mratio, 1,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

/// comparaison avec mon systeme
// deja j'oublie souvent \cratio
// et en fait ca fait dependre modAmp de \freq alors qu'avec l'autre systeme c'est un parametre libre qui ne change pas avec les notes

(
SynthDef(\myfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * \modAmp.kr(1);
	sig = SinOsc.ar(freq * \cratio.kr(1) * ( mod + 1 ));
	(freq * \cratio.kr * \modAmp.kr).poll;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \myfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 4,
			\modAmp, 14.1,
			\cratio, 1,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

//////////////// exploration


(
SynthDef(\basicfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * \modAmp.kr(1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

//// bass

(
// augmenter modAmp rajoute du grain, puis fait comme un filtre qu'on augmente
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			\modAmp, Pseg(Pseq([10,400,8000],1), 8,\exp).loop.trace, // exp important 
			\cratio, 1,
			\mratio, 1,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
// augmenter cratio monte un peu le spectre mais on dirait aussi plus de resonance
// ca deplace la bande carrier (et donc ses sidebands) a droite
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			//\modAmp, Pseg(Pseq([10,400,8000],1), 8,\exp).loop.trace, // exp important 
			\modAmp, 400,
			\cratio, Pstep(Pseq([1,2,3,4,5,6,16,32,5/2,2/3,1.723,1/2],inf),2).trace,
			// non integers are inharmonic
			// simple ratio are inharmonic because modAmp is too high or note is too low
			\mratio, 1,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
// augmenter mratio change le contenu harmonic
// comme un petit son qu'on entend en fond
// ca ecarte les side band
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			//\modAmp, Pseg(Pseq([10,400,8000],1), 8,\exp).loop.trace, // exp important 
			\modAmp, 100,
			\cratio, 1,
			\mratio, Pstep(Pseq([1,2,3,4,5,6,16,32,5/2,2/3,1.723,1/2],inf),2).trace,
			// non integers are inharmonic
			// simple ratio are inharmonic because modAmp is too high or note is too low
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

///////////// moduler l'index plutot que modAmp
// index = modAmp/modFreq = modAmp/(freq * mratio)


(
SynthDef(\idxfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * freq * \mratio.kr * index;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// augmenter l'index augmente le nombre de sideband
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			\cratio, 1,
			\mratio, 1,
			\index, PmodEnv(Pseq([0.1,8,80],1), 8,\exp).loop,
			// all values are harmonic
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\idxadsrfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod;
	var idxenv = EnvGen.kr(
		\idxadsr.kr( Env.adsr(0.1, 0.1,0.4,0.2)) , gate, levelScale:iScale, levelBias:index
	).poll;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * freq * \mratio.kr * idxenv;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// augmenter l'index augmente le nombre de sideband
// beaucoup de sideband au debut et reduction dans la suite
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxadsrfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			\cratio, 1,
			\mratio, 1,
			\index, 1,
			\iScale, 8,
			//\index, PmodEnv(Pseq([0.1,8,80],1), 8,\exp).loop,
			// all values are harmonic
			\dur, 2/1,
			\idxadsr, Pseq([
				[ Env.adsr(0.01,1.5,0.3,0.4,1,2) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\idxenvfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod;
	var idxenv = EnvGen.kr(
		Env([index, index*iScale, index], [\atk.kr(1),\rel.kr(4)], [\atkC.kr(4), \relC.kr(-4)]), 1
	).poll;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * freq * \mratio.kr * idxenv;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
// peu de sideband au debut et augmentation dans la suite
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxenvfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			\cratio, 1,
			\mratio, 1,
			\index, 20,
			\iScale, 0.05,
			\atk, 0.01,
			\rel, 4,
			\dur, 2/1,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,1) ],
			],inf),
			\legato, 0.8,
			\amp, 0.1,
		),
	])
)).play;
);

 Env.adsr(5.01,0.1,1,0.4,-1,-4,-2).plot

////////// exploration

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxenvfm,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\octave, 3,
			\cratio, [1,1/2],
			\mratio, 1/2,
			\index, [4,20],
			\iScale, [0.5,0.005],
			\atk, 0.01,
			\rel, 4,
			\relC, -1,
			\dur, 2/1,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,1) ],
			],inf),
			\legato, 0.8,
			\amp, 0.1,
		),
	])
)).play;
);


///////////////////////////////// familles de son

// 1. Basses (Bass) - Ratios 1:1 ou 1:2
// Caractère : Punchy, fundamental clair, peu d'harmoniques.

// Bass FM simple (DX7 Bass 1 style)
(
SynthDef(\fmbass, { |freq=110, gate=1|
    var mod = SinOsc.ar(freq*1) * 13;  // Ratio 1:1
    var car = SinOsc.ar(freq + mod, 0);
    var env = EnvGen.kr(Env.perc(0.01,0.4), gate, doneAction:2);
    Out.ar(0, car * env * \amp.kr(0.1) ! 2);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 1/4,
			\octave, 3,
			\amp, 0.2,
		),
	])
)).play;
);

//// https://www.youtube.com/watch?v=1XbrTC0NndM
// 1- layers
//	 - pop: oscFb -> osc
//	 - resonance 1: oscFb -> osc
//	 - resonance 2 osc -> osc
//	 - decay: osc
// 2- algo
// 3- env
// 4- feedback
//	 - initial noise component
// 5- fine tuning



//////////////////////////////////
// 2. Cloches (Bells) - Ratios 1:4, 1:6, 1:9
// Caractère : Harmoniques inharmoniques, sustain long.

(
SynthDef(\fmbell, { |freq=220, gate=1|
	var car, env;
    var chain = SinOsc.ar(freq*9) * 20;  // Ratio 4x
    chain = SinOsc.ar(freq*6 + chain, 0) * 10.5;
    car = SinOsc.ar(freq + chain, 0);
    env = EnvGen.kr(Env.linen(0.1, 0.3, 4, 1,-4), gate, doneAction:2);
    Out.ar(0, car * env * 0.1 ! 2);
}).add;
)

(
SynthDef(\fmbell, { |freq=220, gate=1, amp=0.2|
    var env = EnvGen.kr(Env.linen(0.05, 0.4, 4, -8), gate, doneAction:2);
    var modEnv = EnvGen.kr(Env([0, 12, 4], [0.1, 2], -4), gate);
    
	// Ratios "magiques" pour chaque octave
	// [1.0, 2.0, 4.37, 6.02, 8.12, 9.76];
    var mod1 = SinOsc.ar(freq * 1.00) * (modEnv * 1.5);
    var mod2 = SinOsc.ar(freq * 2.00) * (modEnv * 1.2);
    var mod3 = SinOsc.ar(freq * 4.37) * (modEnv * 0.9);
    var mod4 = SinOsc.ar(freq * 6.02) * (modEnv * 0.6);
    
    var car = SinOsc.ar(freq * 1.00*[1,1.0001] + mod1 + mod2 + mod3 + mod4, 0, 0.4);
    
	var sig = Splay.ar(car, \spread.kr(0.8), amp, \pan.kr(0));
    
    Out.ar(0, sig * env);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				0,0,0,0,4,3,1,
			],inf),
			\dur, 4,
			\octave, 5,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				[9,24]
				//0,0,0,0,4,3,1,
			],inf),
			\dur, 4,
			\octave, 5,
			\amp, 0.1/2,
		),
	])
)).play;
);

// from https://youtu.be/vflzTCeYH58 - The Secret of Great DX7 Bells: For the DX11 also

(
SynthDef(\fmbell, { |freq=220, gate=1, amp=0.2|
    var env = EnvGen.kr(Env.linen(0.05, 0.4, 4, -8), gate, doneAction:2);
    var modEnv = EnvGen.kr(Env([0, 1, 0], [0.1, 2], -4), gate);
    
	// Ratios "magiques" pour chaque octave
	// [1.0, 2.0, 4.37, 6.02, 8.12, 9.76];
    var mod1 = SinOsc.ar(freq * 3.44) * (modEnv * 11.5);
    var mod2 = SinOsc.ar(freq * 1.00 + mod1) * (modEnv * 1.2);
    var mod3 = SinOsc.ar(freq * 3.88) * (modEnv * 10.9);
    var mod4 = SinOsc.ar(freq * 3.00 + mod3) * (modEnv * 0.6);
    var mod5 = SinOscFB.ar(177.8, 1) * (modEnv * 10.9);
    var mod6 = SinOsc.ar(freq * 0.995 + mod5) * (modEnv * 0.6);
    
    //var car = SinOsc.ar(freq * 1.00*[1,1.0001] + mod1 + mod2 + mod3 + mod4, 0, 0.4);
	var car = [mod2 * 0.5, mod4, mod6].mean;
    
	var sig = Splay.ar(car, \spread.kr(0.8), amp, \pan.kr(0));
    
    Out.ar(0, sig * env);
}).add;
)

(
// more test
SynthDef(\fmbell, { |freq=220, gate=1, amp=0.2|
    var env = EnvGen.kr(Env.linen(0.05, 0.4, 4, -8), gate, doneAction:2);
    var modEnv = EnvGen.kr(Env([0, 1, 0], [0.1, 2], -4), gate);
    
	// Ratios "magiques" pour chaque octave
	// [1.0, 2.0, 4.37, 6.02, 8.12, 9.76];
    var mod1 = SinOsc.ar(freq * 3.44) * (modEnv * 3.05) * freq;
    var mod2 = SinOsc.ar(freq * 1.00 + mod1) * (modEnv * 0.5);
    var mod3 = SinOsc.ar(freq * 3.88) * (modEnv * 4.9) * freq;
    var mod4 = SinOsc.ar(freq * 3.00 + mod3) * (modEnv * 0.6);
    var mod5 = SinOscFB.ar(177.8, 1) * (modEnv * 0.8) * freq;
    var mod6 = SinOsc.ar(freq * 0.995 + mod5) * (modEnv * 0.6);
    
    //var car = SinOsc.ar(freq * 1.00*[1,1.0001] + mod1 + mod2 + mod3 + mod4, 0, 0.4);
	var car = [mod2, mod4, mod6].mean;
    
	var sig = Splay.ar(car, \spread.kr(0.8), amp, \pan.kr(0));
    
    Out.ar(0, sig * env);
}).add;
)

(
// test with mul instead of add: better, but why ?
SynthDef(\fmbell, { |freq=220, gate=1, amp=0.2|
    var env = EnvGen.kr(Env.linen(0.05, 0.4, 4, -8), gate, doneAction:2);
    var modEnv = EnvGen.kr(Env([0, 1, 0], [0.1, 2], -4), gate);
    
	// Ratios "magiques" pour chaque octave
	// [1.0, 2.0, 4.37, 6.02, 8.12, 9.76];
    var mod1 = SinOsc.ar(freq * 3.44) * (modEnv * 1.5);
    var mod2 = SinOsc.ar(freq * 1.00 * ( mod1 + 1 )) * (modEnv * 1.2);
    var mod3 = SinOsc.ar(freq * 3.88) * (modEnv * 0.9);
    var mod4 = SinOsc.ar(freq * 3.00 * ( mod3 + 1 )) * (modEnv * 0.6);
    var mod5 = SinOscFB.ar(177.8, 1) * (modEnv * 0.9);
    var mod6 = SinOsc.ar(freq * 0.995 * ( mod5 + 1 )) * (modEnv * 0.6);
    
    //var car = SinOsc.ar(freq * 1.00*[1,1.0001] + mod1 + mod2 + mod3 + mod4, 0, 0.4);
	var car = [mod2 * 0.5, mod4, mod6].mean;
    
	var sig = Splay.ar(car, \spread.kr(0.8), amp, \pan.kr(0));
    
    Out.ar(0, sig * env);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				0,0,0,0,4,3,1,
			],inf),
			\dur, 4,
			\octave, 5,
			\amp, 0.1/2,
		),
	])
)).play;
);


(
// test mul with ia version
// bof, trop de dist
SynthDef(\fmbell, { |freq=220, gate=1, amp=0.2|
    var env = EnvGen.kr(Env.linen(0.05, 0.4, 4, -8), gate, doneAction:2);
    var modEnv = EnvGen.kr(Env([0, 0.5, 0], [0.1, 2], -4), gate);
    
	// Ratios "magiques" pour chaque octave
	// [1.0, 2.0, 4.37, 6.02, 8.12, 9.76];
    var mod1 = SinOsc.ar(freq * 1.00) * (modEnv * 1.5);
    var mod2 = SinOsc.ar(freq * 2.00) * (modEnv * 1.2);
    var mod3 = SinOsc.ar(freq * 4.37) * (modEnv * 0.9);
    var mod4 = SinOsc.ar(freq * 6.02) * (modEnv * 0.6);
    
    var car = SinOsc.ar(freq * 1.00*[1,1.0001] * ( mod1+1 ) * ( mod2+1 ) * ( mod3+1 ) * ( mod4+1 ), 0, 0.4);
    
	var sig = Splay.ar(car, \spread.kr(0.8), amp, \pan.kr(0));
    
    Out.ar(0, sig * env);
}).add;
)

(
// test mul freq in op with ia version
// better !
SynthDef(\fmbell, { |freq=220, gate=1, amp=0.2|
    var env = EnvGen.kr(Env.linen(0.05, 0.4, 4, -8), gate, doneAction:2);
    var modEnv = EnvGen.kr(Env([0, 1, 0.4], [0.1, 2], -4), gate);
    
	// Ratios "magiques" pour chaque octave
	// [1.0, 2.0, 4.37, 6.02, 8.12, 9.76];
    var mod1 = SinOsc.ar(freq * 1.00) * (modEnv * 0.15) * freq * 1.00;
    var mod2 = SinOsc.ar(freq * 2.00) * (modEnv * 0.17) *freq * 2.00;
    var mod3 = SinOsc.ar(freq * 4.37) * (modEnv * 0.14) *freq * 4.37;
    var mod4 = SinOsc.ar(freq * 6.02) * (modEnv * 0.16) *freq * 6.02;
    
    var car = SinOsc.ar(freq * 1.00*[1,1.0001] + mod1 + mod2 + mod3 + mod4, 0, 0.4);
    
	var sig = Splay.ar(car, \spread.kr(0.8), amp, \pan.kr(0));
    
    Out.ar(0, sig * env);
}).add;
)

//// https://www.youtube.com/watch?v=HAdWD24PPQk 


(
SynthDef(\bellabfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(8)) * \modAmp.kr(5) * EnvGen.kr(Env([0,1,0],[0.01,0.7],-4), 1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.4,0.0,1.4,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\idxfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * freq * \mratio.kr * index;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bellabfm,
			\note, Pseq([
				0,0,0,0,4,3,1,
			],inf),
			\modAmp, 1000,
			\mratio, 8,
			\dur, 4,
			\octave, 6,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				0,0,0,0,4,3,1,
			],inf),
			\index, 0.4,
			\mratio, 8,
			\dur, 4,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.01,1.4,0.0,1.4,1,-4) ]
			],inf),
			\amp, 0.1/2,
		),
	])
)).play;
);









////////////////////////////////////////////////////////////////
// 3. Cuivres (Brass) - Ratios 1:2 + enveloppe rapide
// Caractère : Attaque bright, decay lent.

(
SynthDef(\fmbrass, { |freq=220, gate=1|
    var modEnv = EnvGen.kr(Env([0,500,100],[0.05,0.3],-4), gate);
    var mod = SinOsc.ar(freq*2) * modEnv;
    var car = SinOsc.ar(freq + mod, 0);
    var env = EnvGen.kr(Env.adsr(0.05,0.3,0.6,0.5), gate, doneAction:2);
    Out.ar(0, car * env * 0.25 ! 2);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbrass,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 3,
			\octave, 5,
			\amp, 0.1,
		),
	])
)).play;
);

////////////////////////////////////////////////////////////////
// 4. Claviers/EP (Electric Piano) - Ratios 1:1 + 1:3 mélangés
// Caractère : Attack percussive, decay moyen.

(
SynthDef(\fmep, { |freq=220, gate=1|
    var mod1 = SinOsc.ar(freq*1) * 2;
    var mod2 = SinOsc.ar(freq*3) * 1.5;
    var car = SinOsc.ar(freq + mod1 + mod2, 0);
    var env = EnvGen.kr(Env.perc(0.005,0.8,-4), gate, doneAction:2);
    Out.ar(0, (car * env * 0.1 + PinkNoise.ar(0.003 * env)) ! 2);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmep,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 3,
			\octave, 5,
			\amp, 0.1,
		),
	])
)).play;
);


//////// https://www.youtube.com/watch?v=ZsAlC5lAHAE


(
// step 1: ok
SynthDef(\idxfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod;
	var modEnv = EnvGen.kr(\modadsr.kr(Env.adsr(0.01,0.1,0.6,6.1)), gate, doneAction:0);
	mod = LFCub.ar(freq * \mratio.kr(1)) * freq * \mratio.kr * index * modEnv;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				[0,4,7],
			],inf),
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			//\index, 4,
			\legato, 0.4,
			\octave, 5,
			\dur, 4,
			\dur, 1.5,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmtest,
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\dur, 1.5,
			\legato, 0.8,
			\amp, 0.15/5,
		)
	])
)).play;
);

(
// step 2 with index
SynthDef(\idxfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1.8, iScale=1;
	var sig;
	var mod, mod2;
	var modEnv2 = EnvGen.kr(\modadsr2.kr(Env.adsr(0.01,0.8,0.1,316.1)), gate, doneAction:0);
	var modEnv = EnvGen.kr(\modadsr.kr(Env.adsr(0.01,0.1,0.6,346.1)), gate, doneAction:0);
	// not sure if i should add \det2 in the mul part
	mod2 = Saw.ar(( freq * \mratio2.kr(4) * \det2.kr(0.1).midiratio ).poll)  * \mratio2.kr*  \index2.kr(2.8) * modEnv2;
	mod = LPF.ar(SinOsc.ar(freq * \mratio.kr(2), mod2).bipolar,4000) * freq * \mratio.kr * index * modEnv;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// step 2 with modAmp
SynthDef(\idxfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod, mod2;
	var modEnv2 = EnvGen.kr(\modadsr2.kr(Env.adsr(0.01,0.1,1.0,316.1)), gate, doneAction:0);
	var modEnv = EnvGen.kr(\modadsr.kr(Env.adsr(0.01,0.1,0.6,346.1)), gate, doneAction:0);
	mod2 = SinOsc.ar(freq * \mratio2.kr(1) + \det2.kr(0.02)) * \modAmp2.kr(32) * modEnv2;
	mod = SinOsc.ar(freq * \mratio.kr(1) + mod2) * freq * \mratio.kr * index * modEnv.poll;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				[0,4,7],
			],inf),
			\index, 4,
			\legato, 0.4,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \idxfm,
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))


(
SynthDef(\fmtest, { |out=0, freq, gate=1, amp=0.1|
    var o1, o2, o3, sig;
    o3 = SinOsc.ar(freq * 0.03.midiratio) * 0.003;
    o2 = LPF.ar(Saw.ar(freq + (freq * o3)), 4000) * EnvGen.ar(Env.asr(0.3, 1, 0.9, 1), gate) * 0.7;
    o1 = SinOsc.ar(freq, o2) * EnvGen.ar(Env.asr(0.1, 1, 0.5, 0), gate, doneAction: Done.freeSelf) * amp;
    sig = o1 ! 2;
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmtest,
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\dur, 1.5,
			\legato, 0.8,
			\amp, 0.15/5,
		)
	])
)).play;
);

// to pass from FM to PM, remove freq in op amp

// increasing cratio, mratio, index can stabilize the sound, tune it
// - you use index version
// - very small values are necessary
// - the env on op3 was messing thing up
// - the waveform of op2 is crucial to the result
// - FM and PM are mathematically equivalent but in practice they yield very different results and have their own pro and cons
// - Saw and LFSaw sound very different :o
// - setting mratio to 2 or 4 can sometime remove the unwanted detuning
//////////
// explore


(
SynthDef(\idxfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, index=1, iScale=1;
	var sig;
	var mod, mod2;
	var modEnv2 = EnvGen.kr(\modadsr2.kr(Env.adsr(0.0001,0.1,1.0,316.1)), gate, doneAction:0);
	var modEnv = EnvGen.kr(\modadsr.kr(Env.adsr(0.01,0.1,0.6,346.1)), gate, doneAction:0);
	// not sure if i should add \det2 in the mul part
	mod2 = SinOsc.ar(freq * \mratio2.kr(1) + \det2.kr(0.001)) * freq * \mratio2.kr + \det2.kr*  \index2.kr(0.01) * modEnv2;
	mod = LPF.ar(LFSaw.ar(freq * \mratio.kr(1) + mod2),\lpf.kr(4000)) * freq * \mratio.kr * index * modEnv;
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				[0,4,7],
			],inf),
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\index, 4,
			\legato, 0.4,
			\octave, 5,
			\dur, 4,
			\dur, 1.5,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\legato, 0.4,
			\octave, 5,
			\cratio, 2,
			\index, PmodEnv(Pseq([0.1,2],1), 16).loop,
			\dur, 4,
			\dur, 1.5,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\legato, 0.4,
			\octave, 5,
			\mratio, 8,
			\mratio2, 4,
			\index, 0.2,
			\index2, Pseg(Pseq([0.1,1],1), 16).loop.trace,
			\dur, 4,
			\dur, 1.5,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\legato, 0.4,
			\octave, 5,
			\mratio, 3,
			\mratio2, 2,
			\lpf, PmodEnv(Pseq([400,14000],1), 8,\exp).loop,
			\index, 1.2,
			\index2, 0.3,
			\dur, 4,
			\dur, 1.5,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([[0,12,15,19,24], [0,12,16,19,24]-2, [0,7,12,16]+3, [0,12,16,19]-4], inf) + 7 - 24,
			\legato, 0.4,
			\octave, 5,
			\mratio, 4,
			\mratio2, 1/2,
			\cratio, 1,
			\lpf, PmodEnv(Pseq([400,14000],1), 8,\exp).loop,
			\index, 0.2,
			\index2, 0.3,
			\dur, 4,
			\dur, 1.5,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				0,5,3,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\modadsr, Pseq([
				[ Env.adsr(0.2,0.1,0.1,0.1) ],
			],inf),
			\mratio, 1/2,
			\mratio2, 1/2,
			\index, 2,
			\cratio, 2,
			\index2, 0.8,
			\lpf, 13400,
			\octave, 5,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				0,5,3,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\modadsr, Pseq([
				[ Env.adsr(0.2,0.1,0,1.1) ],
			],inf),
			\modadsr2, Pseq([
				[ Env.adsr(0.2,0.1,0,1.1) ],
			],inf),
			\cratio, 1,
			\mratio, 8,
			\mratio2, 1,
			\index, 2,
			\index2, 1.8,
			\lpf, 1400,
			\octave, 5,
			\legato, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				0,5,3,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\modadsr, Pseq([
				[ Env.adsr(0.8,0.1,1,1.1) ],
			],inf),
			\modadsr2, Pseq([
				[ Env.adsr(0,0.1,1,1.1) ],
			],inf),
			\cratio, 1,
			\mratio, 2,
			\mratio2, 2,
			\index, 2,
			\index2, 4.8,
			\lpf, 1400,
			\octave, 5,
			\legato, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \idxfm,
			\note, Pseq([
				0,5,3,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\modadsr, Pseq([
				[ Env.adsr(0.01,0.1,0,1.1) ],
			],inf),
			\modadsr2, Pseq([
				[ Env.adsr(0.4,0.1,1,1.1) ],
			],inf),
			\cratio, 1,
			\mratio, 4,
			\mratio2, 1,
			\index2, PmodEnv(Pseq([0,4],1), 8).loop,
			\index, 0.8,
			\lpf, 1400,
			\octave, 5,
			\legato, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////////////////////// dietcv examples
// Here are some basic FM / PM example pairs with SinOsc and BufRd. Watch out
// for the scaling and the integration of the modulator:

// ordinary PM (index is naturally scaled by modFreq)
// normalize by 2pi and multiply by 2pi (redundant i know but watch for BufRd example)
// integrate SinOsc modulator to match FM

(
Ndef(\pm, {
    var modFreq, carFreq;
    var modPhase, carPhase;
    var pmod, sig;
    
    modFreq = 880;
    carFreq = 440;
    
    carPhase = Phasor.ar(DC.ar(0), carFreq * SampleDur.ir);
    modPhase = Phasor.ar(DC.ar(0), modFreq * SampleDur.ir);
    
    pmod = 1 - SinOsc.ar(DC.ar(0), modPhase * 2pi + 0.5pi) / 2pi;
    pmod = pmod * \index.kr(5);
    
    sig = SinOsc.ar(DC.ar(0), ( carPhase + pmod * 2pi ));
    
    sig!2 * 0.1;
}).play;
)

// same with FM (index scaled with modFreq)

(
Ndef(\fm, {
    var modFreq, carFreq;
    var modPhase, carPhase;
    var fmod, sig;
    
    modFreq = 880;
    carFreq = 440;
    
    fmod = SinOsc.ar(modFreq);        
    sig = SinOsc.ar(carFreq + (fmod * modFreq * \index.kr(5)));
    
    sig!2 * 0.1;
}).play;
)

// PM with "FM-scaling" (index scaled by ratio: normalized by modFreq, scaled by carFreq)
// normalize by 2pi and multiply by 2pi (redundant i know but watch for BufRd example)
// integrate SinOsc modulator to match FM

(
Ndef(\pm, {
    var modFreq, carFreq;
    var modPhase, carPhase;
    var pmod, sig;
    
    modFreq = 5;
    carFreq = 440;
    
    carPhase = Phasor.ar(DC.ar(0), carFreq * SampleDur.ir);
    modPhase = Phasor.ar(DC.ar(0), modFreq * SampleDur.ir);
    
    pmod = 1 - SinOsc.ar(DC.ar(0), modPhase * 2pi + 0.5pi) / 2pi; 
    pmod = (pmod * \index.kr(5) * (carFreq / modFreq)).wrap(0, 1);
    
    sig = SinOsc.ar(DC.ar(0), carPhase + pmod * 2pi);
    
    sig!2 * 0.1;
}).play;
)

// same with FM (scaled with carFreq)

(
Ndef(\fm, {
    var modFreq, carFreq;
    var fmod, sig;
    
    modFreq = 5;
    carFreq = 440;
    
    fmod = SinOsc.ar(modFreq);        
    sig = SinOsc.ar(carFreq + (fmod * carFreq * \index.kr(5)));
    
    sig!2 * 0.1;
}).play;
)

// PM with "FM-scaling" using BufRd (index scaled by ratio: normalized by modFreq, scaled by carFreq)
// normalize by 2pi and multiply by BufFrames
// integrate SinOsc to match FM

(
var sndBuf = Buffer.loadCollection(s, Signal.sineFill(4096, [1,0], 0!2));

Ndef(\pm, {
    var modFreq, carFreq;
    var modPhase, carPhase;
    var pmod, sig;
    
    modFreq = 5;
    carFreq = 440;
    
    carPhase = Phasor.ar(DC.ar(0), carFreq * SampleDur.ir);
    modPhase = Phasor.ar(DC.ar(0), modFreq * SampleDur.ir);
    
    pmod = 1 - SinOsc.ar(DC.ar(0), modPhase * 2pi + 0.5pi) / 2pi; 
    pmod = (pmod * \index.kr(5) * (carFreq / modFreq)).wrap(0, 1);
    
    sig = BufRd.ar(1, sndBuf, carPhase + pmod * BufFrames.kr(sndBuf));
    
    sig!2 * 0.1;
}).play;
)

// same with FM (scaled with carFreq)

(
var sndBuf = Buffer.loadCollection(s, Signal.sineFill(4096, [1,0], 0!2));

Ndef(\fm, {
    var modFreq, carFreq, carPhase;
    var fmod, sig;
    
    modFreq = 5;
    carFreq = 440;
    
    fmod = SinOsc.ar(modFreq);  
    
    carPhase = Phasor.ar(DC.ar(0), carFreq + (carFreq * fmod * \index.kr(5)) * SampleDur.ir);
    sig = BufRd.ar(1, sndBuf, carPhase * BufFrames.kr(sndBuf));
    
    sig!2 * 0.1;
}).play;
)
