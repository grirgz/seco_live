~name = 'q';

8.do { arg x;

	Veco(~name).get_clip_by_index(x).response_mode = \play; // retrigger clip play it again instead of stopping it
}

// END
Pdef(~name).clear

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, rq=0.32, fratio=2.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1,1.01,0.99]);
	sig = RLPF.ar(sig, freq*fratio, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.6)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


~swing = (1 + (0.06 * Pseq([-1,1],inf)));
Sdef(~name, \mynotes, \notes);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest(16),
	//\dur, 1/4 * ~swing,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
