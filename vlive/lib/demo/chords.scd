~name = \1;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, rq=0.32, fratio=2.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, freq*fratio, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);



(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pdef(\chords) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/4 * ~swing,
	\amp, 0.1
))
);
////////////////////////////////////////////////

Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([50,40,55,50, 60,65,45,50],inf),
	\degree, Pseq([0,1,2,4],inf),
	\octave, 3,
	\fbase, 50,
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
));

//////////////////////////////////////////////////////////////////////////////////////////////

~name = \3;

(
~current_chord = 0;
Pdef(\chords, Pbind(\mtranspose, Pfunc({ ~current_chord })));
Pdef(~name, Pbind(

	\chord, Pdefn(\chord),
	//\chord, Pseq([0,3,1,4],inf),
	\isRest, true,
	\dur, 2,
	\do, Pfunc{ arg ev;
		~current_chord =  ev[\chord];
		~current_chord.debug("curchord");
		1;
	}
))
);

////////////////////////////////////////////////

Pdefn(\chord, 0)
// some text to make it exists
