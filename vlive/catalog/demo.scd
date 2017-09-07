
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
// electro xylophone / telephone
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


////////////////////////////////////////////////////////////////////////////
// glisser son doigt sur une fenetre
// just fm


(
SynthDef(\window, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
	Pdef(\demo, 
		Pbind(
			// skank
			\instrument, \window,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([0,1],inf),
			\octave, 6,
			\isRest, Pseq([
				1,1,1,1,0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([0.9,0.9,0.9,0.4, 1.9,0.9,0.9,0.4,],inf).stutter(2) * 0.4,
			//\legato, 0.7,
			\dur, 1/8,
			\mixhpf, 0,
			\mixlpf, 1,
			\amp, 0.1/6,
		)
	).play
)

///////////// scratching !!
(
SynthDef(\chordar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([2.00,0.7,1,1.02],[0.01,0.08,3.4])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([0.10,1.4,0.1,0.01],[0.01,0.48,3.4])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1.10,1.4,0.9,0.01],[0.01,0.48,3.4])), 1);
	sig = LFSaw.ar(freq * (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum;
	sig = SinOsc.ar(freq* (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum + sig ;
	sig.debug("sig");
	sig1 = RHPF.ar(sig, \hpfr.kr(3.4) * freq * env1, \hrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixhpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = RLPF.ar(sig, \lpfr.kr(3.4) * freq * env1, \lrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixlpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = sig.tanh;
	sig = SelectX.ar(\mixdist.kr(0.5) * env3, [sig, sig1]);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.9)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * 0.5;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;

Pdef(\demo, 
	Ppar([
		Pbind(
			// skank
			\instrument, \fmsaw,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				[1,5,8],
				[1,6,10],
				[3,8,12, 0],
				[1,6,10, -2],
			],inf).stutter(8).collect({ arg x; x.choose }) + Pseq([0,1],inf),
			\isRest, Pseq([
				00.32,0,1,0.2, 0.51,0,0.51,0,
				0,1,0.2,1, 0.51,0,0.51,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,0.9,1,
				1,1,1,0.9,
			],inf).coin.not,
			\octave, Pseq([4,4,4,Prand([5,3],1)],inf).stutter(2) + Prand([0,1,0],inf).stutter(8),
			\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2) * 0.4,
			//\legato, 0.7,
			\dur, PdurStutter(Pseq([2,2,2,Prand([1,4],1)],inf),Pseq([1/4],inf)).trace,
			//\dur, 1/8,
			\mixhpf, 0,
			\mixlpf, 1,
			\amp, 0.1/6,
		),
	])
).play;
)

////////////////////////////////////////////////////
// pluck is good!
// chords

(
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
    sig = Pluck.ar(ex, Impulse.ar(0), freq.reciprocal, [1,1.001] * freq.reciprocal, decay, coef:coef);
	sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.05)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\octave, 3,
	\decay, 100,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.01,
	\dur, 4,
	\amp, 0.1
)).play;
);

/// hat

(
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, Impulse.ar(0), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], 1, coef:coef).sum;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,[0.2,0.1],0.8,1.4,1,4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\freq, 24,
	\decay, 4,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.01,
	\dur, 4,
	\amp, 0.1
)).play;
);

// metallic rhitm

(
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, Impulse.ar(10), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], 1, coef:coef).sum;
	sig = sig * 2;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\freq, Pseq([40,50,20,60],inf),
	\decay, 3.54,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.61,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

// elastic

(
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, DelayC.ar(gate, 0.1, [0.01,0.032,0.0123]), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], 1, coef:coef).sum;
	sig = sig * 2;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\freq, Pseq([40,50,20,60],inf)*10,
	\decay, 0.04,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.61,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

//////////////////// noisy instrument

(
SynthDef(\sale, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, speed=1, pos=0, doneAction=2, loop=1, bufnum;
	var sig;
	var phase;

	sig = LocalIn.ar(2) * 1.7;
	sig = sig + LFSaw.ar(freq + [ [0,0.001] ] * [1,2,4,1/2] * ( 1 + ( SinOsc.ar(freq) * 1 )));
	sig = CombL.ar(sig, 0.1, 1/freq * [1,2,1/2] * SinOsc.ar(410 * [1,2,1.2,1/2]).range(1.01,1*[1,1.1,1.01]),10.1) + sig;
	sig = sig.sum;
	sig = sig.debug("ig");
	//sig = ( sig*100 ).tanh/13;
	//sig = sig/4 + BPF.ar(sig, freq,0.1,mul:15);
	//sig = sig  *1*1/4/4;
	sig = HPF.ar(sig, 800);
	sig = LPF.ar(sig, 15000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//pan = LFNoise1.kr((1..4)) * 0.4 + pan;
	sig = Pan2.ar(sig, pan, amp).sum;
	sig = sig.clip2(0.41)/4;
	LocalOut.ar(sig);
	sig = sig * 0.2;
	//sig = LPF.ar(sig, 7000);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sale, PmonoArtic( \sale,
	\degree, Pseq([7,6,5,3],inf),
	\degree, Pseq([
		Pseq(
			(1..8)-24
		,1),
	],inf),
	\degree, Pseq([
		Pseq(
			(1..24+24)-24
		,1),
	],inf),
	\bufnum, BufDef('fix4/snare1.flac'),
	\bufnum, BufDef('voices/02_moeten.flac'),
	\trigger,1,
	\octave, 5,
	\pos, 0.0,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,1,1, 1,1,1,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\dur, 1/8,
	\amp, 0.2
)).play;
);

///////////////////////// self am. the mono+octave jump with pure sound is nice!

(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * (sig +1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);


////////////// glitchs
// subtil glitch due to ZeroCrossing error
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	sig = LFSaw.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	//sig = SinOsc.ar(freq * (  ZeroCrossing.ar(sig) * 3 + 1 ));
	sig = SinOsc.ar(freq) * SinOsc.ar(ZeroCrossing.ar(sig), add:1);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

// R2D2
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	sig = LFSaw.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	sig = SinOsc.ar(freq * (  ZeroCrossing.ar(sig) * 1 + 1 ));
	sig = SinOsc.ar(freq) * SinOsc.ar(ZeroCrossing.ar(sig), add:1);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// pure R2D2
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	sig = LFSaw.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	sig = SinOsc.ar(freq * (  ZeroCrossing.ar(sig) * 1 + 1 ));
	//sig = SinOsc.ar(freq) * SinOsc.ar(ZeroCrossing.ar(sig), add:1);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// pure R2D2
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqlag;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freqlag = freq.lag(0.0);
	freq = freq.lag(0.0);

	sig = Saw.ar(freq); 
	sig1 = sig;
	//sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	//sig = Pulse.ar(ZeroCrossing.ar(sig) * ( 1 + ( SinOsc.ar(freqlag) * 0.5 )));
	//sig = Pulse.ar(ZeroCrossing.ar(sig) * ( 1 + ( SinOsc.ar(freqlag) * 0.5 )));
	//sig = Pulse.ar(ZeroCrossing.ar(sig) * ( 1 + ( SinOsc.ar(freqlag) * 0.5 )));
	sig = SinOsc.ar(ZeroCrossing.ar(sig)*2 * ( 1 + ( SinOsc.ar(freq) * 0.1 )));
	sig = SinOsc.ar(ZeroCrossing.ar(sig) * ( 1 + ( SinOsc.ar(freq) * 0.1 )));
	sig = SinOsc.ar(ZeroCrossing.ar(sig)*4 * ( 1 + ( SinOsc.ar(freq) * 0.7 )));
	sig = SinOsc.ar(ZeroCrossing.ar(sig) * ( 1 + ( LFSaw.ar(freq) * 0.1 )));
	//sig = SinOsc.ar(ZeroCrossing.ar(sig) * ( 1 + ( SinOsc.ar(freqlag) * 0.4 )));
	//sig = sig * (1 + sig1);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\degree, Pseq([0,1,4,10],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\legato, Pseq([1,1,1,0.7],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);


// cool noisy bass!
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	sig = SinOsc.ar(freq); 
	8.do { arg x;
		var drysig = sig;
		var wetsig;
		wetsig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
		sig = SelectX.ar( SinOsc.ar(x+1*100).range(0,1), [drysig, wetsig]);
	};
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\legato, 0.9,
	\octave, 3,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\dur, 2,
	\amp, 0.1
)).play;
);


/// cool bass!!
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(0.4);

	sig = SinOsc.ar(freq); 
	5.do { arg x;
		var drysig = sig;
		var wetsig;
		wetsig = Select.ar(sig+1*2*[1,1], [ Saw.ar(freq/2), Pulse.ar(freq*2), SinOsc.ar(freq) ].rotate(x));
		//sig = SelectX.ar( LFNoise2.ar(x+1*1000/2*[1,1]).range(0,1), [drysig, wetsig]);
		sig = SelectX.ar( LFNoise1.ar([1,1]/2).range(0,1), [drysig, wetsig]);
	};
	sig = LeakDC.ar(sig);

	sig1 = sig;
	env1 = EnvGen.kr(Env([0,0,15000,500,10000],[0.01,0.1,0.1,5]), \trigx.tr(1));
	sig1 = BPF.ar(sig1, freq+[100,300,200],0.1).sum;
	sig1 = ( sig1 * 100 ).clip2(1)/4;
	env2 = Duty.kr(1/~t, 0, Dseq([
		1,1,1,1,
		4,4,4,4,
		2,4,4,16,
	],inf));
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1 * LFSaw.ar(env2*~t).lag(0.07).range(1.2,0.1));


	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,-2,4,6, -6,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\legato, 0.9,
	\legato, Pseq([1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\dur, 2,
	\amp, 0.1
)).play;
);
