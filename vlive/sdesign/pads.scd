
(
SynthDef(\basicsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.7)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\sdesign, 
	Ppar([
		Pbind(
			\instrument, \basicsaw,
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,10-12]+5,
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\sdesign, 
	Ppar([
		Pbind(
			\instrument, \basicsaw,
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,10-12]+5,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
SynthDef(\sawunisson, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1), Rand(0,1));
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.7)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\sdesign, 
	Ppar([
		Pbind(
			\instrument, \sawunisson,
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,10-12]+5,
			],inf),
			\lpf, PmodEnv(Pseq([300,4000],1), 8).loop,
			\spread, 0,
			\fspread, 0.00041,
			\dur, 4,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
SynthDef(\sawunissonxp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1) *.x SinOsc.ar((1..8)/2*freq,mul:0.9,add:1), Rand(0,1) );
	sig = sig * 0.3;
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.7)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\sdesign, 
	Ppar([
		Pbind(
			\instrument, \sawunissonxp,
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,10-12]+5,
			],inf),
			\lpf, PmodEnv(Pseq([300,4000],1), 8).loop,
			\spread, 0,
			\fspread, 0.00041,
			\dur, 4,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

////////////// pluck


(
SynthDef(\fpluck, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv;
	sig = LFSaw.ar(freq);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.05,0.05,0.4)), gate, doneAction:2);
	sig = RLPF.ar(sig, \lpf.kr(270) * ( lpenv * \lpenvamt.kr(2.4) + 1 ), \rq.kr(0.5));
	//sig = RLPF.ar(sig, \lpf.kr * ( lpenv * \lpenvamt.kr + 1 ), \rq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\sdesign2, 
	Ppar([
		Pbind(
			\instrument, \fpluck,
			\note, Pseq([
				[2,9],
				[-5,9],
			],inf).stutter(8*2),
			\lpf, PmodEnv(Pseq([1,2,1,4]*300,1), 8).loop,
			\rq, 0.3,
			\octave, 5,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);


Pdef(\sdesign).edit
Pdef(\sdesign).presetCompileString.editorInsert
Pdef(\sdesign).asParamGroup.getPbindCompileString.editorInsert
(

Pbind(
	'legato', 1.4965935969844,
)

);
(
Pdef('sdesign').setVal('legato', 1.4965935969844);
Pdef('sdesign').setVal('lpadsr', Env([ 0.0, 1.0, 0.061728395521641, 0.0 ], [ 0.0, 0.30365386605263, 0.42451922480877 ], [ -4.0, -1.5, -4.0 ], 2.0));
Pdef('sdesign').setVal('adsr', Env([ 0.0, 1.0, 0.22222222387791, 0.0 ], [ 0.0, 0.44038462638855, 0.3105768928161 ], [ -4.0, 0.2, -1.2 ], 2.0));
Pdef('sdesign').setVal('lpenvamt', 5.7450498005048);
Pdef('sdesign').setVal('legato', 1.4965935969844);
Pdef('sdesign').setVal('lpf', 87.69026712551);

);
Pdef(\sdesign).addHalo(\instrument, \pluck)
