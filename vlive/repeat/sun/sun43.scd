
/// mashup
~t = 145/2/60; TempoClock.default.tempo = ~t;



// from sun22.scd


(
	// nice guy
Pdef(\part, Pdef(\noise1, 
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

(
SynthDef(\humpulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq *  ( LFNoise1.ar(1/2 * [1,1]) * 0.01 + 1 )).mean;
	//freq = 30;
	sig = Blip.ar(freq , \numharm.kr(310));
	sig = sig * LFPulse.kr(\pulsefreq.kr(17), width:\pulsewidth.kr(0.9)).lag(\pulselag.kr(0.01));
	sig = sig * LFPulse.kr(\pulsefreq2.kr(30), width:\pulsewidth2.kr(0.9)).lag(\pulselag.kr);
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
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \humpulse,
			\freq, Pwhite(40,60.0),
			\pulsefreq, Pwhite(1.0,50),
			\pulsefreq, ~pmodenv.(Pseq([1,20,10,40],1), 8).loop,
			\pulsefreq2, Pwhite(1.0,50),
			\pulsewidth, Pwhite(0.1,0.99),
			\pulsewidth, ~pmodenv.(Pseq([0.1,0.2,1,0.4],1), 8).loop,
			\octave, 3,
			\dur, Pwhite(1.0,4),
			\legato, 0.4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);
(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \humpulse,
			\freq, Pwhite(40,60.0),
			\pulsefreq, Pwhite(1.0,50),
			\pulsefreq, ~pmodenv.(Pseq([1,20,10,40],1), 1).loop,
			\pulsefreq2, Pexprand(1.0,50),
			\pulsewidth, Pwhite(0.1,0.99),
			\pulsewidth, ~pmodenv.(Pseq([0.1,0.2,1,0.4],1), 1).loop,
			\octave, 3,
			\dur, Pwhite(1.0/4,4),
			\legato, Pwhite(0.1,1),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(
			 \angelchord,
			\degree, Pseq([
				[  -3, 0, 2, 4, 7, 9 ]
			],inf),
			\ctranspose, 2,
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
				//~pmodenv.(Pseq([0,0,1],1), Pseq([1,8]), 1, 2),
				Pn(1,inf)
			],inf),
			\dur, 1,
			//\isRest, true,
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
				//~pmodenv.(Pseq([0,0,1],1), Pseq([1,8]), 1, 2),
				Pn(1,inf)
			],inf),
			\amp, 0.1,
		),
		
		Pmono(
			 \playersec,
			\bufnum, BufDef('field/Street-Ambience-2.flac'),
			\speed, 2,
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



(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \hum,
			\degree, Pseq([
				0,0,3,\r,2b,\r,1,1,
				\r,0,3,\r,2b,\r,\r,1,
				//0,\r,4,3,2b,2,1,0,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\legato, 0.4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[403].value,
			//\speed, 1.09,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\lag, 0.04,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1636].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[264].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
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
