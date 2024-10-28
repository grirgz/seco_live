
~t = 166/2/60; TempoClock.default.tempo = ~t;
(
SynthDef(\Piano_rhodeySC, {
	//FM Rhodes Synthethizer
	|
	// standard meanings
	out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
	// all of these range from 0 to 1
	vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
	|
	var env1, env2, env3, env4;
	var osc1, osc2, osc3, osc4, snd;

	lfoSpeed = lfoSpeed * 12;

	freq = freq * 2;

	env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
	env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
	env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
	env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

	osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
	osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
	osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
	osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
	snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

	// using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
	//snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	snd = snd * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = Pan2.ar(snd, pan, amp);

	Out.ar(out, snd);
//By Nathan Ho aka Snappizz
//http://sccode.org/1-522
}).add;
SynthDef(\harpsichord_pluck, {
	|out=0, amp=0.1, freq=440, pan=0, atk=0, rel=0, trig= 1, maxdelaytime= 0.2, decaytime= 7, coef= 0.1|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(atk, decaytime, rel), doneAction: Done.freeSelf);
	sig = PinkNoise.ar(amp); //Can use white noise here, but Pink is more realistic
	delay = freq.reciprocal;
	sig = Pluck.ar(sig, trig, maxdelaytime , delay , decaytime , coef ) //fundamental
	+ Pluck.ar(sig, trig, maxdelaytime , delay/2 , decaytime , coef ); //octave higher
	Out.ar(out, Pan2.ar(sig , pan));
//Harpsichord based on Pluck Ugen
//By Zé Craum

}).add;
SynthDef(\violin, {
	| out=0, midinote=60, gate=1, amp=0.8 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(out, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
SynthDef(\kalimba, {
	//Kalimba based on bank of ressonators
	|out = 0, freq = 440, amp = 0.1, mix = 0.1, relMin = 2.5, relMax = 3.5|
	var snd;
	// Basic tone is a SinOsc
	snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(relMin, relMax), 1, -8), doneAction: 2);
	// The "clicking" sounds are modeled with a bank of resonators excited by enveloped pink noise
	snd = (snd * (1 - mix)) + (DynKlank.ar(`[
		// the resonant frequencies are randomized a little to add variation
		// there are two high resonant freqs and one quiet "bass" freq to give it some depth
		[240*ExpRand(0.9, 1.1), 2020*ExpRand(0.9, 1.1), 3151*ExpRand(0.9, 1.1)],
		[-7, 0, 3].dbamp,
		[0.8, 0.05, 0.07]
	], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);
	Out.ar(out, Pan2.ar(snd, 0, amp));
//By Nathan Ho aka Snappiz
//http://sccode.org/1-51l
}).add;
SynthDef(\glockenspiel, {
	|freq = 440, t60=6, pitchy=1, amp=0.25, gate=1, pan = 0|
	var sig, exciter;
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = DynKlank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60	 // ring times
		],
		exciter,
		freqscale: freq);
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pan, amp));
//This is the same used for glockenspiel, xylophone, marimba and regular bell, what changes is only the ring time t60
//By nicolaariutti and edited by Zé Craum
//	http://sccode.org/1-5ay#c835
}).add;
SynthDef(\xilophone, {
	|out = 0, freq = 440, t60=1, pitchy=1, amp=0.25, gate=1, pan = 0|
	var sig, exciter;
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = DynKlank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale: freq);
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, amp));
//This is the same used for glockenspiel, xylophone, marimba and regular bell, what changes is only the ring time t60
//By nicolaariutti and edited by Zé Craum
//	http://sccode.org/1-5ay#c835
}).add;
SynthDef(\strings, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
					var env, in, delay, f1, f2;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);
					delay = 0.25 / f2;
					env = Env.asr(0, 1, 0.3);
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay, 1);
					in = Resonz.ar(in, f1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp));

//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
}).add;
)
(
SynthDef("flute_waveguide", { arg out=0,scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, fdur = 1, amp = 0.4, relfac=1;

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;
	var dur = fdur;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 * relfac ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 * relfac ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, \lpf.kr(2000) );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	OffsetOut.ar( out, [ signalOut * kenv2, signalOut * kenv2 ] );

// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html
//by Wilson, Cottle and Collins
//also available at Bruno Ruviaro Collection https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/flute.scd
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \flute_waveguide,
			\scl, 0.20000000298023,
			\ipress, 0.89999997615814,
			\ibreath, 0.025000003576279,
			\ifeedbk1, 0.40000000596046,
			\ifeedbk2, 0.40000000596046,
			\lpf, 2000,
			\amp, 0.40000000596046,
			\note, Pseq([
				0,2,4,7,
			],inf),
			\ctranspose, Pseq([
				Pseq((0..7))
			],inf).stutter(4*4*2),
			\octave, Pseq([
				3,4,5,6,
			],inf).stutter(4*4),
			\relfac, 6,
			\legato, Pseq([
				3,0,0,1, 2,0,2,0,
			],inf),
			\fdur, Pkey(\sustain)/~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
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
			\instrument, \flute_waveguide,
			\scl, 0.20000000298023,
			\ipress, 0.89999997615814,
			\ibreath, 0.045000003576279,
			\ifeedbk1, 0.50000000596046,
			\ifeedbk2, 0.40000000596046,
			\lpf, 2000,
			\amp, 0.40000000596046,
			\note, Pseq([
				[0,4,7,12],
			],inf),
			\ctranspose, Pseq([
				0,0,1,0,
				//Pseq((0..7))
			],inf).stutter(4*4),
			\octave, Pseq([
				4,5,
			],inf).stutter(3),
			\relfac, 0.6,
			\legato, Pseq([
				3,0,0,1, 2,0,2,0,
			],inf),
			\fdur, Pkey(\sustain)/~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
SynthDef(\kalimba, {
	//Kalimba based on bank of ressonators
	|out = 0, freq = 440, amp = 0.1, mix = 0.1, relMin = 2.5, relMax = 3.5|
	var snd;
	// Basic tone is a SinOsc
	snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(relMin, relMax), 1, -8), doneAction: 2);
	// The "clicking" sounds are modeled with a bank of resonators excited by enveloped pink noise
	snd = (snd * (1 - mix)) + (DynKlank.ar(`[
		// the resonant frequencies are randomized a little to add variation
		// there are two high resonant freqs and one quiet "bass" freq to give it some depth
		[240*ExpRand(0.9, 1.1), 2020*ExpRand(0.9, 1.1), 3151*ExpRand(0.9, 1.1)],
		[-7, 0, 3].dbamp,
		[0.8, 0.05, 0.07]
	], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);
	Out.ar(out, Pan2.ar(snd, 0, amp));
//By Nathan Ho aka Snappiz
//http://sccode.org/1-51l
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kalimba,
			\mix, 0.30000000149012,
			\relMin, 0.5,
			\relMax, 4.5,
			\note, Pseq([
				[0,4,7,12],
			],inf),
			\ctranspose, Pseq([
				0,0,1,0,
			],inf).stutter(4*4),
			\octave, Ptuple(Prand([6,7],inf)!4),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \flute_waveguide,
			\scl, 0.20000000298023,
			\ipress, 0.89999997615814,
			\ibreath, 0.045000003576279,
			\ifeedbk1, 0.50000000596046,
			\ifeedbk2, 0.40000000596046,
			\lpf, 2000,
			\amp, 0.40000000596046,
			\note, Pseq([
				[0,4,7,12],
			],inf),
			\ctranspose, Pseq([
				0,0,1,0,
				//Pseq((0..7))
			],inf).stutter(4*4),
			\octave, Pseq([
				4,5,
			],inf).stutter(3),
			\relfac, 0.6,
			\legato, Pseq([
				3,0,0,1, 2,0,2,0,
			],inf),
			\fdur, Pkey(\sustain)/~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/2,
		),
	])
)).play;
);


(
~basepat = { arg ffac;
	Pbind(
		\freq, ~pmodenv.(Pseq([300,600,600],1)*ffac, Pseq([1.6,8-0.1])).loop,
		\dur, Pn(4,1),
		\fdur, Pkey(\sustain)/~t,
		\amp, 0.1,
		//\out, BusDef(\sendbus1, \audio),
	)
};
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar([
			~basepat.(2) <> Pbind(\instrument, \flute_waveguide),
			~basepat.(1) <> Pbind(\instrument, \strings),
			~basepat.(1/2) <> Pbind(\instrument, \harpsichord_pluck),
		]).repeat(4),

	])
)).play;
);


