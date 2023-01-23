~t = 118/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\klankbell, {
	|out=0, freq=1, t60=1, pitchy=1, amp=0.1, gate=1, pan=0|
	var sig, exciter;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.1,0.3,0.8,0.1,0.2)), gate, doneAction:0);
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.903, 3.971, 5.074, 7.91, 10.948, 14.021],   // freqs
			[1, 0.444, 0.491, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:freq*pitchy);
	sig4 = Klank.ar(
		`[
			[1, 2, 2.903, 3.971, 5.074, 6.91, 10.948, 14.021],   // freqs
			[1, 0.444, 0.491, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:freq*pitchy/4 * 7.midiratio);
	sig3 = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:freq*pitchy);
	//sig = SelectX.ar( EnvGen.kr(Env([0,0.81,1],[0.051,0.8]), 1), [sig, sig4]);
	sig = sig + sig4 /2;
	sig = SelectX.ar( EnvGen.kr(Env([0,0.81,1],[0.051,0.8]), 1), [sig, sig3]);
	//sig = FreeVerb.ar(sig) * amp;
	//DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	//sig = BPF.ar(sig, freq*2, 0.1);
	sig1 = SinOsc.ar(freq*pitchy) * EnvGen.kr(\sinadsr.kr(Env.adsr(0.01,0.3,0.1,0.1)), gate, doneAction:0) * 2; 
	sig = SelectX.ar(\sinmix.kr(1), [sig, sig1]);
	sig1 = RLPF.ar(sig, \lpfr.kr(4.1) * freq * (env1 * \lpenvamt.kr(1) + 1), \rq.kr(0.4));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\klankbellbass, {
	|out=0, freq=1, t60=1, pitchy=1, amp=0.1, gate=1, pan=0|
	var sig, exciter;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.844, 0.091, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:freq*pitchy);
	//sig = FreeVerb.ar(sig) * amp;
	//DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	//sig = BPF.ar(sig, freq*2, 0.1);
	sig1 = SinOsc.ar(freq*pitchy) * EnvGen.kr(\sinadsr.kr(Env.adsr(0.01,0.3,0.1,0.1)), gate, doneAction:0) * 2; 
	sig = SelectX.ar(\sinmix.kr(1), [sig, sig1]);
	//sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
r = \r;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
				\instrument, \klankbellbass,
	\t60, 1,
	\pitchy, 2,
			\lpf, 1000,
			\sinmix, ~pmodenv.(Pwhite(0.0,0.4,inf), Pwhite(1.1,4,inf)),
			\note, Pseq([
				0,7,4,7, -1,7,2,7,
				-3,7,4,7, -1,7,2,7,
				0,7,4,7, -1,7,2,7,
				-3,7,4,7, -5,7,2,7,
				-7,5,0,5, -8,4,-1,4,

				-10,2,-3,2, -5,5,-1,5,
				0,7,4,7, -1,7,2,7,
				-2,5,2,5, -3,5,0,5,
				-5,4,0,4, -5,2,-1,2,
				0,7,4,7, 0,7,4,7,



				-4,3,0,4, -4,3,0,4,
				-5,4,0,4, -5,4,0,4,
				-4,3,0,4, -4,3,0,4,
				-5,4,0,4, -5,4,0,4,

				-4,3,0,4, -4,3,0,4,
				-5,4,0,4, -5,4,0,4,
				-6,2,0,2, -6,2,0,2,
				-5,2,-1,2, -5,5,2,11,

				0,7,4,7, -1,7,2,7,
				-3,7,4,7, -5,7,2,7,
				-7,5,0,5, -8,4,-1,4,
				-10,2,-3,2, -5,5,-1,5,

				0,7,4,7, -1,7,2,7,
				-2,5,2,5, -3,5,0,5,
				-5,4,0,4, -5,2,-1,2,
				0,7,2,7, 0,7,2,7,


			],inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fxbus3, \audio),
		),
		Ppar([
			Pbind(),
			//Pbind(\instrument, \acidbass, \amp,0.051, \octave,6),
		].collect{ arg x;

			x <>
			Pbind(
				\instrument, \klankbell,
				\t60, 1,
				\pitchy, 4,
				\sinmix, ~pmodenv.(Pwhite(0.0,0.4,inf), Pwhite(1.1,4,inf)),
				\note, Pseq([
					r,r,r,r, r,r,r,r,
					r,r,r,r, r,r,r,r,
					4,5,7,2, r,2,r,2,
					0,2,4,-1, r,-1,r,-5,
					-3,-1,0,-5, r,-5,-6,-5,

					-3,-1,0,-1, r,0,2,r,
					4,5,7,2, r,2,7,11,
					12,14,12,11, r,9,7,5,
					4,5,7,2, r,2,0,-1,
					0,r,r,r, r,r,r,r,


					0,2,0,2, r,3,5,7,
					7,r,r,r, r,r,r,r,
					0,2,0,2, r,3,r,5,
					7,r,r,r, r,r,r,r,

					0,2,0,2, r,3,5,7,
					7,4,0,-5, r,r,r,r,
					0,2,0,2, r,-3,-1,0,
					2,r,r,r, r,r,r,r,

					4,5,7,2, r,2,r,2,
					0,2,4,-1, r,-1,r,-5,
					-3,-1,0,-5, r,-5,-6,-5,
					-3,-1,0,-1, r,0,2,r,

					4,5,7,2, r,2,7,11,
					12,14,12,11, r,9,7,5,
					4,5,7,2, r,2,0,-1,
					0,r,r,r, r,r,r,r,
				],inf),
				\octave,5,
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fxbus3, \audio),
				//\out, BusDef(\sendbus1, \audio),
			)
		}),
		//Pmono(\fx_chorus,
			//\inbus, BusDef(\fxbus1, \audio),
			//\out, BusDef(\fxbus2, \audio),
			//\addAction, \addToTail,
			//\lag, 0.0006,
			//\mix, 1/2,
			//\fb, 0.9,
			//\delay, 0.1,
			//\diff, 0.001,
			//\modfreq, 0.1,
			//\modamp, 0.1,
			//\gain,2,
			//\dur, 1,
			//\amp, 0.1,
		//),
		//Pmono(\fx_echo,
			//\inbus, BusDef(\fxbus2, \audio),
			//\out, BusDef(\fxbus3, \audio),
			//\addAction, \addToTail,
			//\delay, 1/8/~t,
			//\lag, 0.0007,
			//\dur, 1,
		//),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fxbus3, \audio),
			\addAction, \addToTail,
			\lag, 0.0008,
			\verbmix, 0.41,
			\room, 0.5,
			\damp, 0.1,
			\mix, 0.5,
			\gain, 1,
			\dur, 2,
			//\out, BusDef(\fxbus4, \audio),
		),
	])
)).play;
);

(
r = \r;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
				\instrument, \klankbellbass,
	\t60, 1,
	\pitchy, 2,
			\lpf, 1000,
			\sinmix, ~pmodenv.(Pwhite(0.0,0.4,inf), Pwhite(1.1,4,inf)),
			\note, Pseq([
				0,7,4,7, -1,7,2,7, // C, G
				-3,7,4,7, -1,7,2,7, // C6, G
				0,7,4,7, -1,7,2,7, // C, G
				-3,7,4,7, -5,7,2,7, // C6, Gsus
				-7,5,0,5, -8,4,-1,4, // Fsus, Esus

				-10,2,-3,2, -5,5,-1,5, // Bsus, Bsus6
				0,7,4,7, -1,7,2,7, // C, G
				-2,5,2,5, -3,5,0,5, // Bb, F
				-5,4,0,4, -5,2,-1,2, // C, G
				0,7,4,7, 0,7,4,7, // C, C,



				//-4,3,0,4, -4,3,0,4,
				//-5,4,0,4, -5,4,0,4,
				//-4,3,0,4, -4,3,0,4,
				//-5,4,0,4, -5,4,0,4,

				//-4,3,0,4, -4,3,0,4,
				//-5,4,0,4, -5,4,0,4,
				//-6,2,0,2, -6,2,0,2,
				//-5,2,-1,2, -5,5,2,11,

				//0,7,4,7, -1,7,2,7,
				//-3,7,4,7, -5,7,2,7,
				//-7,5,0,5, -8,4,-1,4,
				//-10,2,-3,2, -5,5,-1,5,

				//0,7,4,7, -1,7,2,7,
				//-2,5,2,5, -3,5,0,5,
				//-5,4,0,4, -5,2,-1,2,
				//0,7,2,7, 0,7,2,7,


			],inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fxbus3, \audio),
		),
		Ppar([
			Pbind(),
			//Pbind(\instrument, \acidbass, \amp,0.051, \octave,6),
		].collect{ arg x;

			x <>
			Pbind(
				\instrument, \klankbell,
				\t60, 1,
				\pitchy, 4,
				\sinmix, ~pmodenv.(Pwhite(0.0,0.4,inf), Pwhite(1.1,4,inf)),
				\note, Pseq([
					r,r,r,r, r,r,r,r,
					r,r,r,r, r,r,r,r,
					4,5,7,2, r,2,r,2,
					0,2,4,-1, r,-1,r,-5,
					-3,-1,0,-5, r,-5,-6,-5,

					-3,-1,0,-1, r,0,2,r,
					4,5,7,2, r,2,7,11,
					12,14,12,11, r,9,7,5,
					4,5,7,2, r,2,0,-1,
					0,r,r,r, r,r,r,r,


					0,2,0,2, r,3,5,7,
					7,r,r,r, r,r,r,r,
					0,2,0,2, r,3,r,5,
					7,r,r,r, r,r,r,r,

					0,2,0,2, r,3,5,7,
					7,4,0,-5, r,r,r,r,
					0,2,0,2, r,-3,-1,0,
					2,r,r,r, r,r,r,r,

					4,5,7,2, r,2,r,2,
					0,2,4,-1, r,-1,r,-5,
					-3,-1,0,-5, r,-5,-6,-5,
					-3,-1,0,-1, r,0,2,r,

					4,5,7,2, r,2,7,11,
					12,14,12,11, r,9,7,5,
					4,5,7,2, r,2,0,-1,
					0,r,r,r, r,r,r,r,
				],inf),
				\octave,5,
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fxbus3, \audio),
				//\out, BusDef(\sendbus1, \audio),
				\isRest, true,
			)
		}),
		//Pmono(\fx_chorus,
			//\inbus, BusDef(\fxbus1, \audio),
			//\out, BusDef(\fxbus2, \audio),
			//\addAction, \addToTail,
			//\lag, 0.0006,
			//\mix, 1/2,
			//\fb, 0.9,
			//\delay, 0.1,
			//\diff, 0.001,
			//\modfreq, 0.1,
			//\modamp, 0.1,
			//\gain,2,
			//\dur, 1,
			//\amp, 0.1,
		//),
		//Pmono(\fx_echo,
			//\inbus, BusDef(\fxbus2, \audio),
			//\out, BusDef(\fxbus3, \audio),
			//\addAction, \addToTail,
			//\delay, 1/8/~t,
			//\lag, 0.0007,
			//\dur, 1,
		//),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fxbus3, \audio),
			\addAction, \addToTail,
			\lag, 0.0008,
			\verbmix, 0.41,
			\room, 0.5,
			\damp, 0.1,
			\mix, 0.5,
			\gain, 1,
			\dur, 2,
			//\out, BusDef(\fxbus4, \audio),
			//\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);
