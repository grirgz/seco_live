
~t = 120/2/60; TempoClock.default.tempo = ~t;
////////////// pad_house_classic

(
SynthDef(\pad_house_classic, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,1+\det.kr(0.01)]).mean;
	sig = HPF.ar(sig, \hpf.kr(150));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_house_classic,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
			],inf),
			\octave, 5,
			\dur, 4,
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
			\bufnum, ~buflib.kick[1428].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \pad_house_classic,
			\note, Pseq([
				[0,3,7,10],
				[0,5,9,3],
			],inf),
			\det, PmodEnv(Pseq([0.001,0.01],3), 8).loop,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

/////////////// pad_house_cinema


(
SynthDef(\pad_house_cinema, { 
    arg out=0, gate=1, amp=0.1, pan=0, freq=440, hpf=150, cutoff=600, freqLFO=0.1, depthLFO=0.5;

    var sig1, sig2, sig3, sig4, sig, lfo;

    // fondamental
    sig1 = SinOsc.ar(freq * [0.99, 1.01]).mean;

    // octave au-dessus
    sig2 = SinOsc.ar(freq * 2 * [0.995, 1.005]).mean * 0.5;

    // octave encore au-dessus, très discrète
    sig3 = SinOsc.ar(freq * 4 * [0.999, 1.001]).mean * 0.3;

    // octave en dessous, chaleureuse
    sig4 = SinOsc.ar(freq * 0.5 * [0.98, 1.02]).mean * 0.7;

    // rassembler
    sig = sig1 + sig2 + sig3 + sig4;

    // filtrage + LFO une seule fois
    sig = HPF.ar(sig, hpf);
    lfo = SinOsc.kr(freqLFO, 0, depthLFO);
    sig = BPF.ar(sig, cutoff + (lfo * 200), 0.3);

    // enveloppe
    sig = sig * EnvGen.kr(Env.adsr(1, 0.1, 0.8, 2.1), gate, doneAction: 2);

    // panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_house_cinema,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_house_cinema,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
			],inf),
			\octave, 5,
			\cutoff, PmodEnv(Pseq([100,1000],1), 8, \exp).loop,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_house_cinema,
			\note, Pseq([
				[0,3,7],        // accord parfait
				[0,3,7,9],      // 7e
				[0,3,7,9,11],   // 9e
				[5,9,0],        // cycle d’autres accords dans la grille
			], inf),
			\octave, 5,
			\cutoff, PmodEnv(Pseq([100, 800], 1), 8, \exp).loop,  // cutoff qui monte lentement
			\dur, 4,
			\amp, 0.1,
			\hpf, 120,
			\freqLFO, 0.05,
			\depthLFO, 0.25,
		)	
	])
)).play;
);

///////////////////////// pad_acid_modulated

(
SynthDef(\pad_acid_modulated, { 
    arg out=0, gate=1, amp=0.1, pan=0, freq=440,
          hpf=100, bpfCutoff=600, bpfQ=0.3,
          freqLFO=0.5, depthLFO=0.5, freqLFOpitch=10, depthLFOpitch=0.01;

    var sig1, sig2, sig, lfo, lfo2;

    // couche 1 : fondamental, légèrement déphasé
    sig1 = SinOsc.ar(freq * [0.99, 1.01]).mean;

    // couche 2 : octave au-dessus, discrète
    sig2 = SinOsc.ar(freq * 2 * [0.995, 1.005]).mean * 0.5;

    // rassembler
    sig = sig1 + sig2;

    // filtrage
    sig = HPF.ar(sig, hpf);
    // BPF : cœur du son acid/vivant
    sig = BPF.ar(sig, bpfCutoff, bpfQ);

    // LFO très lent sur le cutoff (respiration)
    lfo = SinOsc.kr(freqLFO, 0, depthLFO);
    sig = BPF.ar(sig, bpfCutoff + (lfo * 200), bpfQ);

    // LFO rapide sur le pitch (effet “squirm” acid)
    lfo2 = SinOsc.kr(freqLFOpitch, 0, depthLFOpitch);
    sig = sig * (1 + lfo2);

    // enveloppe ADSR
    sig = sig * EnvGen.kr(Env.adsr(1, 0.1, 0.8, 2.1), gate, doneAction: 2);

    // panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_acid_modulated,
			\note, Pseq([
				[0,3,7],        // I
				[0,3,7,9],      // I7
				[5,9,0],        // V
				[0,3,7],        // retour à I
			], inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.12,
			\hpf, 120,
			// le cutoff grimpe lentement au fil du morceau
			\bpfCutoff, PmodEnv(Pseq([400, 900], 1), 16, \exp).loop,
			\bpfQ, 0.3,
			\freqLFO, 0.1*10,
			\depthLFO, 0.5,
			\freqLFOpitch, 10,
			\depthLFOpitch, 0.02,
		)
	])
)).play;
);

////////////////////// pad_noise_texture

(
SynthDef(\pad_noise_texture, { 
    arg out=0, gate=1, amp=0.15, pan=0,
          hpf=100, lpf=1000, panFreq=0.2, panDepth=0.5;

    var noise, sig, panner, env;

    // bruit de base
    noise = WhiteNoise.ar(0.5);

    // filtrage : laisser le mid, limiter les extrêmes
    sig = HPF.ar(noise, hpf);
    sig = LPF.ar(sig, lpf);

    // enveloppe très lente, pour un “drone” discret
    env = EnvGen.kr(Env.linen(3, 0, 5, -12), gate, doneAction: 2);
    sig = sig * env;

    // léger panning mouvant (LFO sur le pan)
    panner = SinOsc.kr(panFreq, 0, panDepth);
    sig = Pan2.ar(sig, panner, amp);
    // ou : sig = sig * 0.5;  // si tu veux juste un panning fixe, pas de LFO
    //     Pan2.ar(sig, pan, amp);

    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_noise_texture,
			\dur, 8,
			\amp, 0.12,
			\hpf, 120,
			\lpf, 900,
			\panFreq, 0.1,
			\panDepth, 0.3,
		)
	])
)).play;
);

/////////////////// pad_house_arpeggiated

(
SynthDef(\pad_house_arpeggiated, { 
    arg out=0, gate=1, amp=0.15, pan=0, freq=440,
          hpf=150, cutoff=600, decay=0.5, delayTime=0.25, feedback=0.3;

    var sig1, sig2, sig, env, delayed;

    // couche 1 : fondamental, légèrement déphasé
    sig1 = SinOsc.ar(freq * [0.99, 1.01]).mean;

    // couche 2 : octave au-dessus, discrète
    sig2 = SinOsc.ar(freq * 2 * [0.995, 1.005]).mean * 0.5;

    // rassembler
    sig = sig1 + sig2;

    // filtrage
    sig = HPF.ar(sig, hpf);
    sig = LPF.ar(sig, cutoff);

    // enveloppe courte, pour un effet “pulsing”
    env = EnvGen.kr(Env.perc(0.05, decay), gate, doneAction: 2);
    sig = sig * env;

    // petit delay discret pour faire boucler l’arpège
    delayed = CombL.ar(sig, 0.5, delayTime, 0.5, 1.0);
    sig = sig + (delayed * feedback);

    // panning + sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_house_arpeggiated,
			\note, Pseq([
				0, 4, 7, 0,  // I triade
				5, 9, 0, 5,  // V accord
			], inf), 
			\octave, 5,
			\dur, 1/4,     
			\amp, 0.1,
			\hpf, 180,
			\cutoff, 700,
			\decay, 0.8,            // un peu plus de tenue
			\delayTime, 0.5,        // délai plus long pour un effet “echo”
			\feedback, 0.4,
		)	
	])
)).play;
);

//////////////////// pad_ambient_lofi

(
SynthDef(\pad_ambient_lofi, { 
    arg out=0, gate=1, amp=0.15, pan=0, freq=440,
          hpf=100, lpf=1000, satAmount=0.1, lfoFreq=0.01, lfoDepth=0.3;

    var sig1, sig2, sig, lfo, env, sat;

    // couche 1 : fondamental, légèrement déphasé
    sig1 = SinOsc.ar(freq * [0.99, 1.01]).mean;

    // couche 2 : octave au-dessus, très discrète
    sig2 = SinOsc.ar(freq * 2 * [0.995, 1.005]).mean * 0.3;

    // rassembler
    sig = sig1 + sig2;

    // filtrage : pas de sub, pas de aigus agressifs
    sig = HPF.ar(sig, hpf);
    sig = LPF.ar(sig, lpf);

    // enveloppe très longue, presque pas de coupure
	env = EnvGen.kr(\adsr.kr(Env.adsr(5.1,0.1,0.8,5.1,1,2)), gate, doneAction:2);
    sig = sig * env;

    // saturation douce (très légère)
	sat = sig;
	sat = sat.clip2(0.8);  // on limite le crâne, un peu de distortion soft
	sig = sig + (sat * satAmount).tanh; 

    // LFO très lent sur le volume pour un effet de respiration
    lfo = SinOsc.kr(lfoFreq, 0, lfoDepth);
    sig = sig * (1 + lfo);

    // panning et sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \pad_ambient_lofi,
			\note, Pseq([
				[0,3,7],        // I triade
				[0,3,7,9],      // I7
				[5,9,0],        // V
			], inf),
			\octave, 5,
			\dur, 8,
			\amp, 0.12,
			\hpf, 120,
			\lpf, 900,
			\satAmount, 0.1,
			\lfoFreq, 0.01,
			\lfoDepth, 0.2,
		)
	])
)).play;
);

(
SynthDef(\pad_drone, { 
    arg out=0, gate=1, amp=0.15, pan=0, freq=440,
          hpf=150, lpf=1000, lfoFreq=0.01, lfoDepth=0.1;

    var sig, lfo, env;

    // couche 1 : très simple, une seule note
    sig = SinOsc.ar(freq);

    // filtrage : pas de sub, pas d’aigus agressifs
    sig = HPF.ar(sig, hpf);
    sig = LPF.ar(sig, lpf);

    // enveloppe très longue, presque pas de coupure
	env = EnvGen.kr(\adsr.kr(Env.adsr(10.1,0.1,0.8,10.1)), gate, doneAction:2);
    sig = sig * env;

    // LFO très lent sur le volume pour un effet de respiration
    lfo = SinOsc.kr(lfoFreq, 0, lfoDepth);
    sig = sig * (1 + lfo);

    // panning et sortie
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_drone,
			\note, 0,              // une seule note
			\octave, 4,
			\dur, 32,             // 32 beats, très long
			\amp, 0.12,
			\hpf, 100,
			\lpf, 900,
			\lfoFreq, 0.05,
			\lfoDepth, 0.15,
		)
	])
)).play;
);

///////////////////////

(
SynthDef(\pad_granular, { 
    arg out=0, gate=1, amp=0.15, pan=0, freq=440,
          density=100, grainsize=0.05, pos=0, sustain=10, hpf=100, lpf=1000;

    var src, grained, env;

    // source de bruit simple (simulée)
    src = WhiteNoise.ar(1.0);

    // grainage
    // grainSize = durée de chaque grain
    // pos = position dans le buffer (on peut laisser 0 pour un buffer statique)
    // density = nombre de grains par seconde
    // sustain = durée du grain
    grained = GrainBuf.ar(
        2,                // 2 channels
        Impulse.ar(1),    // 1 grain à la fois (pour density=1)
        density,         // 100 grains par seconde
        pos,              // 0
        1,                // 1 buffer
        1,                // 1 channel
        1,                // 1 duration
        1,                // 1 offset
        1,                // 1
    );

    // filtrage du grain
    grained = HPF.ar(grained, hpf);
    grained = LPF.ar(grained, lpf);

    // enveloppe très longue
    env = EnvGen.kr(Env.linen(5, 5, 5, 1, \lin), gate, doneAction: 2);
    grained = grained * env;

    // panning et sortie
    grained = Pan2.ar(grained, pan, amp);
    Out.ar(out, grained);
}).add;
)

(
SynthDef(\pad_granular, { 
    arg out=0, gate=1, amp=0.15, pan=0, freq=440,
            hpf=100, lpf=1000, density=100, grainDur=0.05, rate=1, maxGrains=100, mbufnum, normpos=0;

    var grained, env, trig;


    // trigger : densité de grains
    trig = Impulse.ar(density);  // 100 grains par seconde

    // grainage
    // numChannels: 2, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains, mul, add
    // sndbuf doit être un buffer (Buffer) déjà chargé, sinon il faut charger un buffer
    grained = GrainBuf.ar(
        2,                    // 2 channels
        trig,                // 100 grains par seconde
        grainDur,            // 0.05 secondes
        mbufnum,                 // 1 buffer (src est le buffer)
        rate,                // 1
        normpos,                   
        2,                   // 2
        0,                   // 0
        -1,                  // -1
        maxGrains,           // 100
        1,                   // 1
        0                    // 0
    );

    // filtrage
    grained = HPF.ar(grained, hpf);
    grained = LPF.ar(grained, lpf);

    // enveloppe très longue
	env = EnvGen.kr(\adsr.kr(Env.adsr(5.1,0.1,0.8,5.1)), gate, doneAction:2);
    grained = grained * env;

    // panning et sortie
    grained = Pan2.ar(grained, pan, amp);
    Out.ar(out, grained);
}).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_granular,
			\mbufnum, BufDef.mono('notes/trumpet.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, 0,              // une seule note
			\octave, 4,
			\dur, 1,             // 16 beats, très long
			\amp, 0.12,
			\hpf, 120,
			\lpf, 900,
			\normpos, PmodEnv(Pwhite(0.0,1,inf).stutter(10) + Pwhite(0.0,0.1,inf),Pwhite(0.2,2,inf)).loop,
			\density, 100,
			\grainsize, 0.05,
		)	
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_granular,
			\mbufnum, BufDef.mono('notes/trumpet.flac'),
			\mbufnum, BufDef(\padbuf),
			\note, 0,              // une seule note
			\octave, 4,
			\dur, 1,             // 16 beats, très long
			\amp, 0.72,
			\hpf, 120,
			\lpf, 900,
			\normpos, PmodEnv(Pwhite(0.0,1,inf).stutter(10) + Pwhite(0.0,0.1,inf),Pwhite(0.2,2,inf)).loop,
			\density, 100,
			\grainsize, 0.05,
		)	
	])
)).play;
);

BufDef(\padbuf, s.sampleRate * 10, 1)


		Pbind(
			\instrument, \pad_house_classic,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		).record


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pad_house_classic,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\recbus, \audio, 2),
		),
		Pmono(
			\recorderStereoToMono,
			\inbus, BusDef(\recbus, \audio, 2),
			\mbufnum, BufDef(\padbuf),
		),
	])
)).play;
);
