
(
SynthDef(\ebm_synth_bass, { 
    arg out=0, gate=1, amp=0.3, pan=0, freq=110,
          lpf=1000, decay=0.2;

    var sig1, sig2, sig, env;

    // 1 forme d'onde très "carrée / raide"
    sig1 = LFPulse.ar(freq, 0, 0.1);   // pulse très courte -> attaque nette
    sig2 = LFSaw.ar(freq * 0.99);      // légèrement déphasée pour du beat

    sig = Mix.ar([sig1, sig2]) * 0.5;

    // 2 filtre pour rogner les aigus et garder le punch du bas
    sig = LPF.ar(sig, lpf);

    // 3 enveloppe très courte, très articulée
    env = EnvGen.kr(Env.perc(0.01, decay), gate, doneAction: 2);
    sig = sig * env;

    // 4 panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

~t = 181/2/60; TempoClock.default.tempo = ~t;
(
	Pdef(\part, Pdef(\zedpart, 
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[38].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1857].value,
				//\bufnum, ~buflib.snare[1591].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \ebm_synth_bass,
				\note, Pseq([
					0
				], inf) + Pstep(Pseq([0,-5,-1,-6],inf),4),
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,1, 0,1,
				],inf).coin.not,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.3,
				\lpf, 1000 * Pseq([1,1,2,1.3],inf).stutter(2),
				\decay, 0.2,
			)
		])
	)).play;
);

(
SynthDef(\ebm_synth_bass2, { 
    arg out=0, gate=1, amp=0.3, pan=0, freq=110,
          lpf=1000, decay=0.2;

    var sig1, sig2, sig3, sig, env;
	var xsig;

    // 1 forme d'onde très "carrée / raide"
    sig1 = LFPulse.ar(freq, 0, \pwidth.kr(0.02));   // pulse très courte -> attaque nette
    sig2 = LFSaw.ar(freq * 0.99);      // légèrement déphasée pour du beat
	sig3 = SinOsc.ar(freq/2); 

    sig = Mix.ar([sig1, sig2, sig3]) * 0.5;

    // 2 filtre pour rogner les aigus et garder le punch du bas
    sig = LPF.ar(sig, lpf);

	xsig = AnalogVintageDistortion.ar(sig, drivegain: 0.2, bias: 0.5, lowgain: 0.7, highgain: 0.1);
	xsig = xsig * 0.5;
	sig = SelectX.ar(\distmix.kr(0.2), [sig, xsig]);
    // 3 enveloppe très courte, très articulée
    env = EnvGen.kr(Env.perc(0.01, decay), gate, doneAction: 2);
    sig = sig * env;

    // 4 panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)


(
	Pdef(\part, Pdef(\zedpart, 
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[38].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1857].value,
				//\bufnum, ~buflib.snare[1591].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \ebm_synth_bass2,
				\note, Pseq([
					0
				], inf) + Pstep(Pseq([0,-5,-1,-6],inf),4),
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,1, 0,1,
				],inf).coin.not,
				\pwidth, PmodEnv(Pseq([0.1,0.5,0.9],1), 8).loop,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.3,
				\lpf, 1000 * Pseq([1,1,2,1.3],inf).stutter(2),
				\decay, 0.2,
			)
		])
	)).play;
);
/////////////
~t = 130/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\house_arp_anthemic, { 
    arg out=0, gate=1, amp=0.2, pan=0, freq=440,
          lpf=4000, decay=0.1, lfoFreq=10, lfoDepth=0.1;

    var saw1, saw2, sig, lfo, env;

    // 2 saws légèrement déphasées
    saw1 = LFSaw.ar(freq);
    saw2 = LFSaw.ar(freq * 1.01);

    sig = Mix.ar([saw1, saw2]) * 0.5;

    // filtre passe‑bas pour le mid
    sig = LPF.ar(sig, lpf);

    // LFO très rapide sur le volume pour un effet “pulsing”
    lfo = SinOsc.kr(lfoFreq, 0, lfoDepth);
    sig = sig * (1 + lfo);

    // enveloppe très courte, pour que chaque note soit nette
    env = EnvGen.kr(Env.perc(0.01, decay), gate, doneAction: 2);
    sig = sig * env;

    // panning et sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \house_arp_anthemic,
			\note, Pseq([
				[0,4,7,9],           // I9
				[5,9,0,4],           // V
				[0,4,7,9,11],        // I11
				[7,0,4,9],           // VII
			], inf),
			\octave, 5,
			\dur, 0.25,             // 1/16 notes
			\amp, 0.2,
			\lpf, PmodEnv(Pseq([400,5000],1), 8).loop,
			\decay, PmodEnv(Pseq([0.1,1.2],1), 8).loop,
			\lfoFreq, 10,
			\lfoDepth, 0.2,
		)
	])
)).play;
);

//////////////////////////
~t = 125/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\lofi_synth_bass, { 
    arg out=0, gate=1, amp=0.4, pan=0, freq=110,
          hpf=80, lpf=300, saturation=0.3, decay=0.3;

    var sig, env, dist;

    var noise = WhiteNoise.ar(0.05);   // faible niveau de bruit
    // 1 fondamental + un peu d’harmonique
    sig = SinOsc.ar(freq * [1, 1.5, 2]).mean * 0.7;

    // 2 un peu de bruit pour le “warmth” analogique
    sig = sig + noise;

    // 3 filtrage très doux : tu veux garder le sub, mais pas de hi‑fi propre
    sig = HPF.ar(sig, hpf);   // enlève un peu de sub si besoin
    sig = LPF.ar(sig, lpf);   // garde le mid‑bas chaleureux

    // 4 envelope courte mais pas trop raide
    env = EnvGen.kr(Env.perc(0.01, decay), gate, doneAction: 2);
    sig = sig * env;

    // 5 distortion soft / saturation très douce
    dist = sig.clip2(0.6);
    sig = sig + (dist * saturation);   // mélange original + soft‑clipped
    sig = sig * 0.8;                   // un peu de volume compensé

    // 6 panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lofi_synth_bass,
			\note, Pseq([
				0,0,0,7,
			], inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 1.4,
			\hpf, 80,
			\lpf, 300,
			\saturation, 0.3,
			\decay, 0.3,
		)
		
	])
)).play;
);

(
SynthDef(\lofi_synth_bass, { 
    arg out=0, gate=1, amp=0.4, pan=0, freq=110,
          hpf=80, lpf=300, saturation=0.3, decay=0.3;

    var sig, env, dist;

    var noise = WhiteNoise.ar(0.05);   // faible niveau de bruit
    // 1 fondamental + un peu d’harmonique
    sig = SinOsc.ar(freq * [1, 1.5, 2]).mean * 0.7;

    // 2 un peu de bruit pour le “warmth” analogique
    sig = sig + noise;

    // 3 filtrage très doux : tu veux garder le sub, mais pas de hi‑fi propre
    sig = HPF.ar(sig, hpf);   // enlève un peu de sub si besoin
    sig = LPF.ar(sig, lpf);   // garde le mid‑bas chaleureux

    // 4 envelope courte mais pas trop raide
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.3,0.1)), gate, doneAction:2);
    sig = sig * env;

    // 5 distortion soft / saturation très douce
    dist = sig.clip2(0.6);
    sig = sig + (dist * saturation);   // mélange original + soft‑clipped
    sig = sig * 0.8;                   // un peu de volume compensé

    // 6 panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)
//Howling - Howling (Âme Remix)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \lofi_synth_bass,
			\note, Pstep(Pseq([
				-3,-1,-6,-6,
			], inf),2),
			\octave, 4,
			\dur, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1,2.3) ],
			],inf),
			\amp, 0.2,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\hpf, 40,
			\lpf, Pseg(Pseq([200,400],inf),8),
			\saturation, PmodEnv(Pseq([0.1,1],1), 8*2).loop,
			\decay, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[38].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);


///////////////////////

~t = 135/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\psy_arp, { 
    arg out=0, gate=1, amp=0.2, pan=0, freq=100,
          lpf=4000, decay=0.05, resonance=0.9;

    var sig, env;

    // 1 forme d’onde très “saw / carrée” pour le caractère
    sig = LFSaw.ar(freq * [1, 1.01]).mean * 0.5;

    // 2 filtre très résonant pour le “ronron” psy
    sig = LPF.ar(sig, lpf, resonance);

    // 3 enveloppe très courte, très percussive
    env = EnvGen.kr(Env.perc(0.005, decay), gate, doneAction: 2);
    sig = sig * env;

    // 4 panning et sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[38].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1633].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,1/2,1,1/2, 1,1,1,1/2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1633].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,1/2,1,1/2, 1,1/2,1,1/2,
			],inf),
		),
		Pbind(
			\instrument, \psy_arp,
			\note, Pseq([
				0,
			], inf) + Pstep(Pseq([0,-3],inf),32),
			\octave, 3,
			\dur, 1/8,
			\legato, 0.1,
			\amp, 1.2 * Pseq([
				0.1,0.4,1,1,
			],inf),
			\lpf, PmodEnv(Pseq([50,250,400,600,1000],1), 8,\exp).loop,
			\resonance, 0.3,
			\decay, Pseg(Pseq([0.10,0.4],inf),8*4,\exp),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[640].value,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,1, 0,0,1,1,
				],15),
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1532].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],16),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],15),
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[72].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,1,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
	])
)).play;
);

//////////////:
~t = 113/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\rickBass, { |out=0, freq=110, amp=0.15, gate=1, pan=0|
	var env, modEnv, car, mod, sig;

	env = EnvGen.kr(
		Env.adsr(0.005, 0.08, 0.65, 0.12),
		gate,
		doneAction: 2
	);

	modEnv = EnvGen.kr(
		Env([0, 3.5, 1.8], [0.01, 0.12], [-4, -3]),
		gate
	);

	mod = SinOsc.ar(freq * 2, 0, freq * 1 * ( modEnv +2 ));
	car = SinOsc.ar(freq + mod, 0);

	sig = car;
	sig = LPF.ar(sig, 1800);
	sig = sig + (sig.tanh * 0.2) * 0.8;
	sig = sig + (BPF.ar(sig, 900, 0.6) * 0.15);
	sig = LeakDC.ar(sig);

	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \rickBass,
			\note, Pseq([
				0,5
			],inf),
			\octave, 3,
			\sustain, 0.07,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[339].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1639].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \rickBass,
			\instrument, \dxBass80s,
			\instrument, \dx7Bass1,
			\octave, 3,
			\note, Pseq([
				3, 3,3, \r, 
				12, 10, 8,8,  
				\r, 5,8,      

				5, 5,5, \r, 
				12, 10, \r, 10,10,
				\r, 12,10,      

				3, 3,3, \r, 
				12, 10, 8,8,  
				\r, 8,8,      

				5, 5,5, \r, 
				12, 10, \r, 8,8,
				12,10,      
			], inf),
			\dur, Pseq([
				1/4,1/8,1/8,1/8,
				1/8,1/4,1/4,1/4,
				1/4,1/8,1/8,

				1/4,1/8,1/8,1/8,
				1/8,1/4,1/4, 1/8,1/8,
				1/8,1/4,1/8,

				1/4,1/8,1/8,1/8,
				1/8,1/4,1/4,1/4,
				1/4,1/8,1/8,

				1/4,1/8,1/8,1/8,
				1/8,1/4,1/4, 1/4,1/8,
				1/4,1/8,
			], inf),
			//\scale, Scale.major,  // ou Scale.dbmajor
			\amp, 0.2
		)
	])
)).play;
);


(
SynthDef(\dxBass80s, { |out=0, freq=110, amp=0.15, gate=1|
	var env, modEnv, sig;

	env = EnvGen.kr(Env.perc(0.02, 0.18, 1, -4), gate, doneAction: 2);
	modEnv = EnvGen.kr(Env.perc(0.001, 0.10, 2, -6), gate);

	sig = SinOsc.ar(
		freq + (SinOsc.ar(freq * 2, 0, freq * 2.5 * ( modEnv +0.3 ))),
		0,
		amp
	);

	sig = HPF.ar(sig, 30);
	sig = LPF.ar(sig, 2200);
	sig = sig * env;
	Out.ar(out, sig!2);
}).add;
)

0
(
SynthDef(\dx7Bass1, { |out=0, freq=110, amp=0.2, gate=1, vel=0.8|
    var env, sig = 0.0;
    var modEnv = EnvGen.kr(Env.adsr(0.01, 0.12, 0.3, 0.1, curve: -4), gate);
    var carEnv = EnvGen.kr(Env.adsr(0.01, 0.08, 0.7, 0.15, curve: -2), gate, doneAction: 2);

    // Op6 (modulateur faible pour Op4)
    var op6 = SinOsc.ar(freq * 1, 0, SinOsc.ar(freq * 1.0, 0, 0.4 * modEnv));
    // Op4 (modulé par Op6, mod pour Op2)
    var op4 = SinOsc.ar(freq / 2, op6 * 0.4, SinOsc.ar(freq * 1.0, 0, 0.7 * modEnv));
    // Op2 (modulé par Op4, mod pour Op1)
    var op2 = SinOsc.ar(freq * 2, op4 * 0.5, SinOsc.ar(freq / 2.0, 0, 0.6 * modEnv));
    // Op1 (modulé par Op2)
    var op1 = SinOsc.ar(freq / 2, op2 * 0.6);

    // Ops carriers simples (ratio 1:1)
    var op3 = SinOsc.ar(freq * 1.0, 0, 0.99 * ( modEnv ));
    var op5 = SinOsc.ar(freq * 1.0, 0, 0.99 * ( modEnv ));

    sig = (( op1 * 0.99 ) + ( op3 * 0.99 ) + ( op5 * 0.99 ) + ( op4 * 0.99 ) + ( op2 * 0.80 ) + ( op6 * 0.60 )) * vel;
	sig = sig * 0.5;

    sig = LPF.ar(sig, EnvGen.kr(Env([20000, 2800, 2200], [0.01, 0.2], -4), gate) * 1);
    sig = HPF.ar(sig, 40);
    //sig = tanh(sig * 1.3);  // Léger drive DX7-like
	sig = sig + ( sig.tanh * 0.2 ) * 0.8;
    sig = sig * carEnv * amp;

    Out.ar(out, Pan2.ar(sig, 0));
}).add;
)


//////////////
