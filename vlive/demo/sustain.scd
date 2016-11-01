
//------------------------------------------------------------------------------------------------//
// How to generate random envelope but control it with pattern standard \dur and \legato mecanism //
//------------------------------------------------------------------------------------------------//



TempoClock.default.tempo = 1.5; 

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, sustain=1;
	var sig;
	var env = EnvGen.ar(\env.kr(Env([ 0,1,1,0 ],[1,1,1])),gate,doneAction:2);
	sig = SinOsc.ar(freq * ( env + 1 ));
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\dur, Pseq([8,2],inf),
	\legato, 0.8,
	\env, Pfunc({ arg ev; // Pfunc because rrand should be executed for each event
		var times = [ rrand(0.01,1), rrand(0.01,1), rrand(0.01,1) ];
		// sustain is already available in the default event and is computed from dur and legato
		var sustain = ev.use({ ~sustain.value }) / thisThread.clock.tempo; // ~sustain is in beats but env should be in seconds
		var env;
		sustain.debug("sustain");
		env = Env([0,1,1,0], times.normalizeSum * sustain);
		env.asCompileString.debug("env");
		[env]; // array arguments need to be enclosed to avoid multichannel expansion in pbind
	}),
	\amp, 0.1
)).play;
);


//////////////
//another way is to use timeScale of EnvGen

(
SynthDef(\plop2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, tsustain=1;
	var sig;
	var env = EnvGen.ar(\env.kr(Env([ 0,1,1,0 ],[1,1,1])),gate, timeScale:tsustain, doneAction:2);
	sig = SinOsc.ar(freq * ( env + 1 ));
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\plop, Pbind(
	\instrument, \plop2,
	\degree, Pseq([0],inf),
	\dur, Pseq([8,2],inf),
	\legato, 0.8,
	\tsustain, Pkey(\sustain) / Pfunc({ thisThread.clock.tempo }), // sustain is in beats, tsustain in seconds
	\env, Pfunc({ arg ev; 
		// this method is not really shorter, i just removed all explanations
		[ Env([0,1,1,0], [ rrand(0.01,1), rrand(0.01,1), rrand(0.01,1) ].normalizeSum) ];
	}),
	\amp, 0.1
)).play;
);
