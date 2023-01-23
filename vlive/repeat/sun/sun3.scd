
Pdefp

NoteTimeline(\sun3, Pbindef(\sun3melo)).edit
NoteTimeline(\sun3).play
Pbindef(\sun3melo).play
Pbindef(\sun3melo, \pitch_stretch, Pfunc({ arg ev; ev.use { ( ~freq.value.cpsmidi - (12*3) ).midiratio } }))

49.midiratio


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\sun3melo) 
		<>
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,4,7],
			],inf),
			\octave, 3,
			\dur, 8,
			\amp, 0.1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\sun3melo) 
		<>
		Pmono(
			 \zegrainer,
			\note, Pseq([
				[0,3,7] +.x [-12,0,12],
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		)
		
	])
)).play;
);

(
SynthDef(\gregrainrand_pan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var randpos;
	randpos = LFNoise1.kr(\randfreq.kr(1)).range(0.0,1.0) * \randfac.kr(0.05);
	clk = Impulse.ar(freq * \trigfreqfac.kr(1));
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos + randpos % BufDur.kr(mbufnum), gdur, pan, 1, 4);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\pos, ~pmodenv.(6 + Pseq([0,5,10]/18,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\randfac, 0,
			\gdur, 0.1*3,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\note, Pseq([
				[0,3,7] +.x [-12,0,12],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\pos, 
			Ptuple(
				(1..9).collect { arg x;
					~pmodenv.(2 + (x/1400) + Pseq([0,5,10]/( 28-x ),1) + Pwhite(0,0.02,inf).stutter(8), 8+x).loop
				}
			),
			\randfac, 0.001,
			\randfreq, (1..9)*8,
			\gdur, 0.1*3,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\note, Pseq([
				[0,3,7] +.x [-12,0,12],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\pos, 
			Ptuple(
				(1..9).collect { arg x;
					~pmodenv.(2 + (x/1400) + Pseq([0,5,10]/( 28-x ),1) + Pwhite(0,0.02,inf).stutter(8), 8+x).loop
				}
			),
			\randfac, 0.001,
			\randfreq, (1..9)*8,
			\gdur, 0.1*3,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\note, Pseq([
				[0,3,7] +.x [-12,0,12],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, 1/2,
			\amp, 0.05,
		),

		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			//\pos, 4.0983836717573,
			\pos, ~pmodenv.(2 + Pseq([0,5,10]/198,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\note, Pseq([
				Prand([0,3,7,0,Prand((0..12),1)]),
			],inf),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1*2,
			\octave, 5,
			\legato, 1,
			\dur, 1,
			\amp, 0.8,
		)
		
	])
)).play;
)

