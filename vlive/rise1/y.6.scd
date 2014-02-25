Pdef(~name +++ \pre, 

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, Veco(~namex).isrest(32),
	\fratio, 2,
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	\rq, Pseq([0.1,0.9,0.6,0.2],inf),
));

// END

Sdef(~name, \mypreset).edit

(
Ndef(\plop, {

	var sig;
	sig = In.ar(0);
	sig * SinOsc.kr(2).abs;
	ReplaceOut.ar(0, sig);

//}).play(group:Group.basicNew(s,1), addAction:\addToTail)
}).play(group:~get_mixer_group.(), addAction:\addToTail)
)

Group

(
Ndef(\bla, {

	var sig;
	sig = SinOsc.ar(102)!2 * 0.01;

//}).play(group:Group.basicNew(s,1), addAction:\addToTail)
}).play(Ndef(\rop))
)

(
Ndef(\bla, {

	var sig;
	sig = SinOsc.ar([402,300,200])!2 * 0.01;
	sig = sig.flatten;
	sig = Splay.ar(sig);

//}).play(group:Group.basicNew(s,1), addAction:\addToTail)
})
)

Tartini
Ndef(\rop, { Ndef(\bla).ar(2) }).play
Ndef(\rop, \filter -> { arg in; in * SinOsc.ar(400); })
(
Ndef(\rop, { 
	var freq = 400;
	var in = \in.ar([0,0]);
	var sig;
	freq = ZeroCrossing.ar(in);
	//freq.poll;
	//in * SinOsc.ar(SinOsc.ar(1)*0.1+1*freq); 
	//in * SinOsc.ar(freq); 
	freq = LPF.ar(freq, 100);
	sig = LFTri.ar(freq) * Amplitude.ar(in); 
	//sig = sig + in;
})
)
(
Ndef(\rop, { 
	var freq = 400;
	var in = \in.ar([0,0]);
	var sig;
	freq = ZeroCrossing.ar(in);
	//freq.poll;
	//in * SinOsc.ar(SinOsc.ar(1)*0.1+1*freq); 
	//in * SinOsc.ar(freq); 
	freq = LPF.ar(freq, 100);
	sig = LFTri.ar(freq) * Amplitude.ar(in); 
	in;
	//sig = sig + in;
})
)
(
Ndef(\frop, { 
	var freq = 400;
	var in = \in.ar([0,0]);
	freq = ZeroCrossing.ar(in);
	//freq.poll;
	//in * SinOsc.ar(SinOsc.ar(1)*0.1+1*freq); 
	//in * SinOsc.ar(freq); 
	LFSaw.ar(freq) * Amplitude.ar(in); 
})
)

(
~fxon = { arg inname;
	Ndef(\rop) <<> Ndef(inname); Ndef(inname).stop;
};
~fxoff = { arg inname;
	Ndef(\rop) <<> nil; 
	Ndef(inname).play;
};
);
~fxon.(~name+++\mixer);
~fxoff.(~name+++\mixer);
Ndef(\rop).map(\in, ~a.busArg);
Ndef(\rop).map(\in, BusPlug.for(BusDef(\hey)));
Ndef(\rop).map(\in, Ndef(\bus));

~a.busArg
~fxon.(\t+++\mixer);

Veco.main.nodes.keys.asArray.sort

(
Veco.main.nodes.keysValuesDo { arg key, val;
	if(val.has_mixer) {
		key.postln;
		Ndef(key+++\mixer).play(BusPlug.for(BusDef(\hey)).bus);
	};

}
)

Ndef(\rop).map(\in, BusPlug.for(BusDef(\hey)));
		Ndef(\t+++\mixer).play(BusDef(\hey));
		Ndef(\y+++\mixer).play(BusDef(\hey));
Ndef(\y+++\mixer).play(0)
Ndef(\t+++\mixer).play(0)
Ndef(\t+++\mixer).play
Ndef(\y+++\mixer).play
Ndef(\y+++\mixer).end
Ndef(\y+++\mixer).play(Ndef(\rop).bus)
Ndef(\y+++\mixer).play(~a.bus)
Ndef(\t+++\mixer).play(~a.bus)
Ndef(\t+++\mixer).play(Ndef(\bus).bus)
Ndef(\y+++\mixer).play(Ndef(\bus).bus)
Ndef(\rop).stop
Ndef(\rop).end
Ndef(\rop).play
Ndef(\rop).asBus
Ndef(\rop).bus
Ndef(\bus).stop
Ndef(\bus).play
Ndef(\bus).bus
Ndef(\bus).end
kBusPlug
Ndef(\yeah).bus
BusDef(\hey, \audio)
~a = BusPlug.audio(s,2)
~a.bus
~a.index
~a.play
~a.stop

~b = BusPlug.for(BusDef(\hey))
~b.bus
~b.index
~b.play
~b.stop

Ndef(\bla).play(Ndef(\rop).bus)
Ndef(\y+++\mixer).play(Ndef(\rop).bus)
Ndef(\y+++\mixer).stop(Ndef(\rop).bus)
Ndef(\y+++\mixer).play(0)
Ndef(\t+++\mixer).play(0)
Ndef(\t+++\mixer).stop
Ndef(\y+++\mixer).stop
Ndef(\rop).play
Ndef(\rop).stop
Ndef(\rop).bus
Ndef(\bla) <>>.in Ndef(\rop)
nil <>>.in 
Ndef(\rop) <<> nil; Ndef(\bla).play;
Ndef(\rop) <<> Ndef(\bla); Ndef(\bla).stop;
Ndef(\rop).play
Ndef(\rop).clear
Ndef(\bla).clear
Ndef(\bla).stop
Ndef(\bla).play
