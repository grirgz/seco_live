
// see libdef/macros.scd

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1).poll * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\dur, 2,
			\lpfr, ~pnoteEnv_adsr.(Pseq([0.1,2.1],1),0.1,0.2,Pseq([0.3,1],inf),3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv_adsr.(Pseq([0.1,2.1],1),0.1,0.8,0.1),
				~pnoteEnv_adsr.(Pseq([0.1,2.1],1),0.1,0.8,0.1),
			],1),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////

(
// test local bus with overlapping events
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([Pseq([1,3,0.3],4),0.1,1,8],[1,0.1,2]/2),
			],1),
			\dur, 1,
			\legato, 1.6,
			\amp, 0.1,
		),
		
	])
)).play;
);
////////// test free bus

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([Pseq([1],1),0.1,1,8],[1,0.1,1]/4),
			],1),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\testunroll,
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				//~pnoteEnv.([Pseq([1],1),0.1,1,8],[1,0.1,1]/4, 0,1,0,1,\lpfr),
				~pnoteEnv.([Pseq([1],1),0.1,1,8],[1,0.1,1], 0,1,0,1),
			],1),
			\dur, 4/1,
			\amp, 0.1,
		),
).play;
);


/////////// tests
// tests for freeing resources
// - test when pattern stop by itself
// - test when pattern is stopped by Pfindur
// - test when pattern is stopped by .stop
// - test when pattern is stopped by cmd-dot
// - test when stopped in middle of note


//////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\dur, 2,
			\lpfr, PnoteEnv.adsr(Pseq([0.1,2.1],1),0.1,0.2,Pseq([0.3,1],inf),3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);


PnoteEnv.adsr(Pseq([0.1,2.1],1),0.1,0.2,Pseq([0.3,1],inf),3).asStream


//////////

Pbind(\dur, 1/3, \note, Pstep(Pseq([0,1,2],inf),1/4)).play
