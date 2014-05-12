
Pdef(~name +++ \pre, Sdef(~name, \mypreset).busmorph([0,1,2,3]) <> Pbind(
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\freq, 100,
));

Sdef(~name, \mypreset_morph_default).edit
MIDIBoard.map(\k1, Sdef(~name, \mypreset_morph_default), \morph)

////

Sdef(~name, \mypreset).busmorph([0,1],0);
Sdef(~name, \mypreset).busmorph([2,3],1); 
Pdef(~name +++ \pre, Sdef(~name, \mypreset).superbusmorph([0,1]) <> Pbind(
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\freq, 100,
));

// END

Sdef(~name, \mypreset);
Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset_morph_0).edit
MIDIBoard.map(\k1, Sdef(~name, \mypreset_morph_default), \morph)
(
	MIDIBoard.map(\k3, [
		[Sdef(~name, \mypreset_morph_0), \morph],
		[Sdef(~name, \mypreset_morph_1), \morph],
	]);
	MIDIBoard.map(\k4, Sdef(~name, \mypreset_supermorph_default), \morph);
)


////////////////////////////////////////

~morph_to.(\mod2, { arg from;  {XLine.kr(from.value,500,10)}});
~morph_to.(\mod1, { arg from;  {XLine.kr(from.value,9,10)}});

(
~morph_to = { arg key, gen;
	Ndef(~name+++key, gen.value({Ndef(~name+++key).kr}));
}
)

////////////////////////////////////////

Sdef(~name, \morph, \preset, [\morph, \unipolar.asSpec]);

Pdef(~name +++ \pre, 
	~lmorphpat.(
		[
			Sdef(~name, \mypreset).getsub(0).pbind,
			Sdef(~name, \mypreset).getsub(1).pbind,
			Sdef(~name, \mypreset).getsub(2).pbind,
		],
		//Pseq([0,0.5,1],inf)
		Sdef(~name, \morph).get_active_score.vals[\morph].valpattern
	)
	<> Pbind(
		\name, ~name,
		\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
		\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	)
);



(
~name = "saw";
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

)

////////////////////////////////////////

blend([Env.adsr(0.1,0.1,0.8,0.2)],[Env.adsr(0.7,0.7,0.5,0.4)],0.5).asCompileString


Pdef(~name).play;


(
// preset 1

~a = Pdef(~name, ~morph.(\bla, 2.1, Pbind(
	\freq, 100,
	\ffreq, 1300,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));

);

(
// preset 2

~a = Pdef(~name, ~morph.(\bla, 1, Pbind(
	\freq, 1500,
	\ffreq, 200,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));

);
