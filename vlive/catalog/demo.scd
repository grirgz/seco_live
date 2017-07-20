
/////////////////////// freq spreading give feel of blurring
(
(
SynthDef(\blur, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((0..17)/17 -0.5 * XLine.kr(0.001,0.01,2) + 1) ).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
Pdef(\blur, Pbind(
	\instrument, \blur,
	\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);


////// variation: rising fx
(
(
SynthDef(\blur, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((0..17)/17 -0.5 * XLine.kr(0.001,100.01,2) + 1) ).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
Pdef(\blur, Pbind(
	\instrument, \blur,
	\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);

////// variation: strange echo
(
(
SynthDef(\blur, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(((0..17)/17 -0.5 * XLine.kr(0.001,100.01,2) + 1)) * 1 ))  ).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
Pdef(\blur, Pbind(
	\instrument, \blur,
	\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);


///////////////////////////////////// chord scape

(
(
SynthDef(\chordscape, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*[1,1.01,1.001]) * 1 ))) * 1 )) ) * ( Line.kr(0.0001,0.51,2) ) ))  ).mean;
	sig.postln;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);

	Out.ar(out, sig);
}).add;
);
Pdef(\chordscape, Pbind(
	\instrument, \chordscape,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf),
	\legato, Ptuple(Pwhite(0.3,1.3)!3),
	\dur, 2,
	\amp, 0.2
)).play;

Pdef(\lead, PmonoArtic(  \default,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 1/8,
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf).stutter(1/Pkey(\dur) * 2).collect({ arg x; x.choose  }) + [-7,0,7].choose,
	//\legato, Ptuple(Pwhite(0.7,1.8)!3),
	//\legato, 1,
	\legato, 
	Pseq([
		{
			Pseq({[
				1,0,0,0,
				1,0,1,0,
				1,1,1,1,
				0,0,1,0,
				0,1,1,0,
				1,0,0,1,
				0,0,0,0,
			].clump(4).choose.stutter([1,2,4,4,4,8].choose)}.dup(4).flat,2);
		} ! 4,
		Pseq([
			0
		],16),
	].flat,inf),
	\isRest, Pkey(\legato).collect(_==0),
	\amp, 0.2
)).play;
);


///////////////////////////////////////////


(
SynthDef(\lead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, linetime=4;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig.fold2(\fold.kr(0.7) * ( (1..8)/8 + 1 ));
	sig.postln;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	pan = pan + LFNoise1.kr(1/23, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;

	Out.ar(out, sig);
}).add;
Pdef(\chordscape).play;
Pdef(\lead, 
	
	PmonoArtic(  \lead,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 1/8,
	//\legato, Ptuple(Pwhite(0.7,1.8)!3),
	//\legato, 1,
	\amp, 0.2,
)
<>
	Pbind(
	\degree, Pkey(\degree).collect({ arg x; x.choose + [-7,0,7].choose }),
	\legato, Pseq([
		{
			Pseq({[
				1,0,0,0,
				1,0,1,0,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				0,0,1,0,
				0,1,1,0,
				1,0,0,1,
				//0,0,0,0,
				//1,1,1,1,
			].clump(4).choose}.dup(4).flat,4);
		} ! 4,
		Pser([
			1,1,1,0.71, 1,1,1,0.1
		],16),
	].flat,inf),
	\isRest, Pkey(\legato).collect(_==0),

	).stutter(Prand([1,1,1,2,4,8],inf)) 

	<>
	Pbind(
		
	\fold, Pseg(Pseq([1.1,0.1],inf),4),
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf).stutter(8*2),
	\octave, 5,
	)

).play;
)

(
SynthDef(\criz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, linetime=4;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig.fold2(\fold.kr(0.7) * ( (1..8)/8 + 1 ));
	sig.postln;
	sig = RLPF.ar(sig, \lpfr.kr(2.4) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	pan = pan + LFNoise1.kr(1/23, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;

	Out.ar(out, sig);
}).add;
Pdef(\chordscape).play;
Pdef(\lead).play;
Pdef(\criz, 
	
	PmonoArtic(  \criz,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 1/8,
	//\legato, Ptuple(Pwhite(0.7,1.8)!3),
	//\legato, 1,
	\amp, 0.2,
)
<>
	Pbind(
	\degree, Pkey(\degree).collect({ arg x; x.choose + [-7,0,7].choose }),
	\legato, Pseq([
		{
			Pseq({[
				1,0,0,0,
				1,0,1,0,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				0,0,1,0,
				0,1,1,0,
				1,0,0,1,
				//0,0,0,0,
				//1,1,1,1,
			].clump(4).choose}.dup(4).flat,4);
		} ! 4,
		Pser([
			1,1,1,0.71, 1,1,1,0.1
		],16),
	].flat,inf),
	\isRest, Pkey(\legato).collect(_==0),

	).stutter(Prand([4],inf)) 

	<>
	Pbind(
		
	\fold, Pseg(Pseq([1.1,0.1],inf),4),
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf).stutter(8*2),
	\octave, 5,
	)

).play;
)

Kit
