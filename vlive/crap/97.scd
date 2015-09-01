(
SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

///////// lfo communicating with main pattern

(
Ndef(\lfo1, {  EnvGen.kr(Env([1,4,1],[0.1,0.2]), \trig.tr(0)) * \lforange.kr(1000);  });

Pdef(\main, Pbind(
	\instrument, \rlpf,
	\midinote, Pseq([60, 62, 64], inf),
	\legato, 0.5,
	\move, Pseq([0,1,0, 1,0,0],inf),
	\lforange, Pseq([1000,2000,3000],inf).stutter(8),
	\ffreq, Pfunc({ arg ev;
		Ndef(\lfo1).set(\trig, ev[\move], \lforange, ev[\lforange]);
		Ndef(\lfo1);
	}),
	\dur, 0.5
)).play 
)

////// sub pattern way

(
	Pdef(\micro, { arg midinote, move;
		Pbind(
			\instrument, \rlpf,
			\midinote, midinote + 
				switch(move,
					\up, Pseq((0..7)),
					\down, Pseq((7..0)),
					Pseq(0!8),
				),
			\dur, 1/16,
		)
	});

	Pdef(\main,
		Pbind(
			\instrument, \micro,
			\move, Pseq([\n, \n, \up, \n, \n, \down],inf),
			\type, \phrase,
			\midinote, Pseq([60, 62, 64], inf),
			\dur, 1/2,
		)
	).play;
)

//////// same in mono

(
	Pdef(\micro, { arg midinote, move;
		Pmono(
			\rlpf,
			\midinote, midinote + 
				switch(move,
					\up, Pseq((0..7)),
					\down, Pseq((7..0)),
					Pseq(0!8),
				),
			\dur, 1/16,
		)
	});

	Pdef(\main,
		Pbind(
			\instrument, \micro,
			\move, Pseq([\n, \n, \up, \n, \n, \down],inf),
			\type, \phrase,
			\midinote, Pseq([60, 62, 64], inf),
			\dur, 1/2,
		)
	).play;
)
