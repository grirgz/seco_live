
TempoClock.default.tempo = 95/60;
Pdef.defaultQuant = 4;
Veco.main.board_size = Point(16,64);
~swing = (1 + (0.06 * Pseq([-1,1],inf)));
~degcps = { arg deg, octave=5, root=(60.midicps); Scale.major.degreeToFreq(deg, 60.midicps, octave-5); };

(

~cdegcps = { arg tab, deg, octave=5, root=(60.midicps); 
	tab.collect { arg val;
		if(val >= 0) {
			~degcps.(val % 7, octave + (val/7).asInteger)
		} {
			~degcps.(val % 7, octave + (val-7/7).asInteger)
		}

	}
}
);

// END

(-7-7/7).asInteger
(-2) % 7
~degcps.(-1)

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	freq.poll;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pbind(
	\instrument, \plop,
	\degree, 2,
	\df, Pfunc { arg ev; ev[\octave].postln; },
	\dur, 1,
	\amp, 0.1
).trace.play;
)

(
	
~degcps = { arg deg, octave=0, root=(60.midicps); Scale.major.degreeToFreq(deg, 60.midicps, octave-5); };
~degcps.(2, 6);
)
