
////
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(SinOsc.ar(freq + [0,0.07]) * freq * LFNoise1.kr(0.21).range(1,30) + LFNoise1.kr(0.2).exprange(0.01,2) );
	sig2 = SinOsc.ar(SinOsc.ar(freq*2 + [0,0.27] * ( sig1 * LFNoise1.kr(0.12).range(0,0.41) + 1 )) * freq*2  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig3 = SinOsc.ar(SinOsc.ar(freq*3 + [0,1.27] * ( sig2 * LFNoise1.kr(0.12).range(0,0.41) + 1 )) * freq*3  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig4 = SinOsc.ar(SinOsc.ar(freq*4 + [0,0.97] * ( sig3 * LFNoise1.kr(0.12).range(0,0.41) + 1 )) * freq*4  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig = sig1 + sig2 + sig3 + sig4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0,2,-1,3],inf),
		\octave, 2,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0],inf),
		\octave, 2,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


////////////

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 10.collect({ arg idx;
		SinOsc.ar(freq * idx * SinOsc.ar(0.051 * idx).range(2,10) * SinOsc.ar(freq/2*idx + [idx*0.02, idx*0.01]) + ( 0.1 * idx ) );
	}).mean;
	sig = RLPF.ar(sig, \lpf.kr(4030), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0],inf),
		\octave, 4,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([ [0,3,7] ],inf),
		\root, Pseq([0,3],inf),
		\lpf, ~pmodenv.(Pseq([1,2,1,4]*1000,inf), 3).loop,
		\octave, 5,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([ [0,3,7, -12, 12,7-12] ],inf),
		\root, Pseq([0,3],inf),
		\lpf, ~pmodenv.(Pseq([1,2,1,4]*1000,inf), 3).loop,
		\octave, 5,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

/////
// multiply harm by 1/n to get cleaner sound
// add another fm with 20 hertz to get vibrato

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 10.collect({ arg idx;
		var idxi = idx + 1;
		SinOsc.ar(freq * idxi * SinOsc.ar(20 * ( idxi/13+1 ) * ( SinOsc.kr(0.2) * 0.3 + 1 )).range(7,9) *  SinOsc.ar(freq*idxi + [idx*0.02, idx*0.01]) + ( 0.01 * idxi ) ) * 1/( idxi );
	}).mean;
	sig = RLPF.ar(sig, \lpf.kr(4030), \rq.kr(0.5));
	sig = AllpassL.ar(sig, 0.4,0.4, 1)+sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([ [3, -12, 12,7-12] ],inf),
		\root, Pseq([0,3,6,4],inf).stutter(2),
		\lpf, ~pmodenv.(Pseq([1,2,1,4]*1000,inf), 3).loop,
		\octave, 4,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

////

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 4.collect { arg idx;
		idx = idx + 1;
		//SinOsc.ar(freq * idx * SinOsc.ar(freq * idx) * LFNoise1.kr(0.14).range(2,12) + 0.2) * 1/idx;
		SinOsc.ar(freq * idx * ( SinOsc.ar(20 * Rand(0.5,2.0)) * LFNoise1.kr(0.12).exprange(0.0001,0.4) + 1 ) * SinOsc.ar(freq * idx) * LFNoise1.kr(0.14).range(0.2,12) + 0.2) * 1/idx;
	}.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);


(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([ 3, -12, 12,7-12 ],inf),
		\degree, Pseq([
			Pseq([
				[0,3,7] +.x [-12,0,12],
				[0,4,7] +.x [-12,0,12],
				[0,3,7] +.x [-12,0,12],
				[0,3,8] +.x [-12,0,12],
				[0,3,7] +.x [-12,0,12],
				[-1,3,7] +.x [-12,0,12],
			],inf),
		   	[3, -12, 12,7-12, 7],
		   	[3, -12, 12,8-12, 8],
		   	[4, -12, 12,7-12, 4+12],
		],inf).stutter(4),
		//\root, Pseq([0,3,6,4],inf).stutter(4),
		\lpf, ~pmodenv.(Pseq([1,2,1,4]*1000,inf), 3).loop,
		\octave, 4,
		\dur, 1,
		\amp, Ptuple(
			{
				~pmodenv.(Pwhite(0.01,0.1,inf), Pwhite(0.1,10,inf)).loop
			}!9
		),
	)
).play;
);

////


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var prev = SinOsc.ar(freq);
	sig = 15.collect { arg idx;
		idx = idx + 1;
		prev = SinOsc.ar(freq*8*2 + ( [ 0.1,0.12 ] * idx/10 ) * 1/idx * ( prev + LFNoise1.kr(0.1!2 + ( idx/10 )).range(0,0.2) * LFNoise1.kr(0.12).range(0,0.8) + (1) )) * ( SinOsc.ar(Rand(0.1,10)).unipolar * 1 + 1 );
		prev;
	}.mean;
	//sig = prev;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);


(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0, 2,3],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \zed,
		\note, Pseq([
			0,
		],inf),
		\dur, 1/6,
		\amp, Pseq([Pgeom(0.28,-3.dbamp,4)],inf) * 0.5,
	),
).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fm,
			\dur, 1/8,
			\midinote, Pseq([
				Pseq([[28,40]],32),
				Pseq([[24,36]],24), Pseq([[33,45]],8),
			],inf) + Pwrand([0,12],[0.9,0.1],inf),
			\mRatio, 1,
			\index, 2,
			\iScale, Pseq([3,2.5,2,1],inf),
			\atk, 0,
			\rel, Pexprand(0.2,0.4,inf),
			\amp, Pseq([
				Pseq([
					Pgeom(0.28,-3.dbamp,8),
				],8),
				Pseq([
					Pgeom(0.28,-3.dbamp,4),
				],7),
			],inf),
			\pan, Pseq([-0.25,0.25],inf),
			\out, 0,
			\fx, ~vbus,
			\fxsend, -inf,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.1,
			\gain, Pseq([Pgeom(0.1,-6.dbamp,4)],inf),
		),
	])
)).play;
);

///////////////////////////////////////////////

(
// by eli.fieldsteel
SynthDef(\elifm, {
	arg freq=500, mRatio=1, cRatio=1,
	index=1, iScale=5, cAtk=4, cRel=(-4),
	amp=0.2, atk=0.01, rel=3, pan=0,
	out=0;
	var car, mod, env, iEnv;
	
	//index of modulation
	iEnv = EnvGen.kr(
		Env(
			[index, index*iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	
	//amplitude envelope
	env = EnvGen.kr(Env.perc(atk,rel,curve:[cAtk,cRel]),doneAction:2);
	
	//modulator/carrier
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	
	car = Pan2.ar(car, pan);

	//direct out/reverb send
	Out.ar(out, car);
}).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \elifm,
			\note, Pseq([
				0,2,3,1,
			],inf),
			\cRatio, 1/2 * Pseq([1,2,3,4],inf),
			\index, ~pmodenv.(Pseq([0.1,2,1,4],1), 8).loop,
			\mRatio, Pseq([1,3,5],inf),
			\iScale, ~pmodenv.(Pseq([0.1,2,1,4],1), 3).loop,
			\rel, 0.4,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \elifm,
			\dur, 1/6,
			\midinote, Pseq([Pfin(64, Pseq([64,67,69,71,74,76],inf))],inf),
			\mRatio, Pwrand([0.5,1.5,2,3],[1,3,6,25].normalizeSum, inf),
			\index, Pexprand(2,2.5),
			\iScale, Pseq([Pgeom(1.2,1.2,6)],inf),
			\atk, Pwrand([0,Pexprand(0.02,0.1,1)],[0.99,0.01],inf),
			\rel, Pseq(Array.interpolation(64,0.03,0.25).mirror2,inf),
			\cAtk, 1,
			\cRel, Pseq(Array.interpolation(64,-4,3).mirror2,inf),
			\amp, Pseq([Pfin(64, Pseq([Pgeom(0.13,-3.dbamp,6)],inf))],inf),
			\pan, Pseq(Array.interpolation(64,0,1).lincurve(0,1,0,1,8),inf) * Pseq([1,-1],inf),
			\out, 0,
		),
	])
)).play;
);


///// analyse de elifm

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mratio=1, cratio=1, index=1, iscale=1;
	var sig;
	index = EnvGen.kr(Env([index,index*iscale,index],[0.01,0.4],[4,-4]), 1);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * mratio) * mratio * index + cratio ));
	sig = SinOsc.ar(freq * cratio + ( SinOsc.ar(freq * mratio) * freq * mratio * index ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \zed,
			\note, Pseq([
				0,2,3,1,
			],inf),
			\cratio, 1/2 * Pseq([1,2,3,4],inf),
			\index, ~pmodenv.(Pseq([0.1,2,1,4],1), 8).loop,
			\mratio, Pseq([1,3,5],inf),
			\iscale, ~pmodenv.(Pseq([0.1,2,1,4],1), 3).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4,1,[4,-4,-4]) ],
			],inf),
			\sustain, 0.01,
			\rel, 0.4,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \zed,
			\note, Pseq([
				0,2,3,1,
			],inf),
			\cratio, Pseq([1,2,3,4],inf),
			\index, Pseg(Pseq([0,1],inf),8),
			\mratio, Pseq([1,3,5],inf),
			\iscale, Pseq([1,1.2,1.4],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4,1,[4,-4,-4]) ],
			],inf),
			\sustain, 0.01,
			\rel, 0.4,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \zed,
			\dur, 1/6,
			\midinote, Pseq([Pfin(64, Pseq([64,67,69,71,74,76],inf))],inf),
			\mratio, Pwrand([0.5,1.5,2,3],[1,3,6,25].normalizeSum, inf),
			\index, Pexprand(2,2.5),
			\iscale, Pseq([Pgeom(1.2,1.2,6)],inf),
			\atk, Pwrand([0,Pexprand(0.02,0.1,1)],[0.99,0.01],inf),
			\rel, Pseq(Array.interpolation(64,0.03,0.25).mirror2,inf),
			\cAtk, 1,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.01,0.1,0.04,1,[1,-1,-4]) ],
			],inf),
			\sustain, 0.1,
			\cRel, Pseq(Array.interpolation(64,-4,3).mirror2,inf),
			\amp, Pseq([Pfin(64, Pseq([Pgeom(0.13,-3.dbamp,6)],inf))],inf),
			\pan, Pseq(Array.interpolation(64,0,1).lincurve(0,1,0,1,8),inf) * Pseq([1,-1],inf),
			\out, 0,
		),
	])
)).play;
);


///////////////////////////////////////////////

(
SynthDef(\elifm2, {
	arg freq=500, mRatio=1, cRatio=1,
	index=1, iScale=5, cAtk=4, cRel=(-4),
	amp=0.2, atk=0.01, rel=3, pan=0,
	out=0, fx=0, fxsend=(-25);
	var car, mod, env, iEnv;

	freq = freq + [0,0.2];
	
	//index of modulation
	iEnv = EnvGen.kr(
		Env(
			[index, index*iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	
	//amplitude envelope
	env = EnvGen.kr(Env.perc(atk,rel,curve:[cAtk,cRel]),doneAction:2);
	
	//modulator/carrier
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	
	car = Pan2.ar(car, pan);

	//direct out/reverb send
	Out.ar(out, car);
	Out.ar(fx, car * fxsend.dbamp);
}).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \elifm2,
			\note, Pseq([
				0,2,3,1,
			],inf),
			\cRatio, 2 * Pseq(1/[1,2,3,4],inf),
			\index, ~pmodenv.(Pseq([0.1,2,1,4],1), 8).loop,
			\mRatio, Pseq(1/[1,3,5],inf),
			\iScale, ~pmodenv.(Pseq([0.1,2,1,4],1), 3).loop,
			\rel, 0.4,
			\atk, 0.3,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////////////////////////////
/*
FM Rhodes Synthesizer

Native SuperCollider port of STK's Rhodey. This should be preferred over the StkInst version because:

- It uses much less CPU.
- It is easier to modify.
- It doesn't require sc3-plugins or a correct setting of StkGlobals.
- It's beginner-friendly because it uses only basic UGens: SinOsc, EnvGen, Mix, Pan2, Out.

*/

(
SynthDef(\rhodey_sc, {
    |
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
    // all of these range from 0 to 1
    vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
    |
    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    lfoSpeed = lfoSpeed * 12;

    freq = freq * 2;

    env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
    env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
    env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
    env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

    osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
    osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
    osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
    osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
    snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

    // using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
    snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;
)

(
Pbind(
    \instrument, \rhodey_sc,
    \scale, Scale.mixolydian,
    \octave, 4,
    \root, 2,
    \legato, Pseq([0.9, 0.5, 0.5, 0.9, 0.9, 0.9, 0.9, 0.5, 1, 0.5, 1, 0.6, 0.3], inf),
    \dur, Pseq([1 + (1/3), 1/3, 1/3, 1/7, 6/7, 5/6, 1/6, 1/2, 2/6, 1/6, 2 + ( 1/2 ), 1, 1/2], inf),
    \degree, Pseq([
        [0, 2, 4], 2, 4, 7, 8, 7, 0, [1, 3, 6], 5, [1, 3, 6], Rest(), [-1, 1, 3], [1, 3, 5],
        [0, 2, 4], 2, 4, 8, 9, 7, 0, [1, 3, 6], 5, [1, 3, 6], Rest(), [-1, 1, 3], [1, 3, 5],
    ], inf),
    \mix, 0.2,
    \modIndex, 0.2,
    \lfoSpeed, 0.5,
    \lfoDepth, 0.4,
    \vel, Pgauss(0.8, 0.1, inf),
    \amp, 0.3
).play(TempoClock(1.5));
)


/////////////////
(
// Pulse doesn't respond well to being frequency modulated - loads of weird low freq noise
{ Pulse.ar(SinOsc.ar(XLine.kr(1,8000,20)).range(1,2000))*0.2 !2}.play
)

(
// LFPulse doesn't sound like an analogue synth due to loads of aliasing
{ LFPulse.ar(SinOsc.ar(XLine.kr(1,8000,20)).range(1,2000))-0.5*0.4 !2}.play
)

(
// But you can also produce a good approximation of a pulse wave by clipping a 
// high-amplitude sine wave.  Clipper8 (from sc3-plugins) allows you to do this 
// in a band-limited way.  This sounds much more like a frequency modulated analogue
// oscillator.
{ Clipper8.ar(SinOsc.ar(SinOsc.ar(XLine.kr(1,8000,20)).range(0,2000), 0, 10), -0.2, 0.2) !2 * 0.5}.play
// note: there are two SinOscs - the inner one is the modulator and the outer one is
// clipped to make the pulse wave
)

(
// with PWM too
{ Clipper8.ar(SinOsc.ar(SinOsc.ar(XLine.kr(1,8000,20)).range(50,1000), 0, 10)+LFTri.ar(8,mul:9.9), -0.2, 0.2) !2}.play
)

////////////////////:

SynthDef(\fmsynth, {arg outbus = 0, freq=440, carPartial=1, modPartial=1, index=3, mul=0.2, ts=1;
    var mod, car, env;
    // modulator frequency
    mod = SinOsc.ar(freq * modPartial, 0, freq * index );
    // carrier frequency
    car = SinOsc.ar((freq * carPartial) + mod, 0, mul );
    // envelope
    env = EnvGen.ar( Env.perc(0.01, 1), doneAction: 2, timeScale: ts);
    Out.ar( outbus, car * env)
}).add;

Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \ts, 1]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 2.5, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 3.5, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 4.0, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 300.0, \carPartial, 1.5, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 0.5, \ts, 2]);

Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 300.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 400.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 800.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);

Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1.1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1.15, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1.2, \ts, 2]);

SynthDef(\fmsynthenv, {arg outbus = 0, freq=440, carPartial=1, modPartial=1, index=3, mul=0.2, ts=1;
    var mod, car, env;
    var modfreqenv, modindexenv;
    modfreqenv = EnvGen.kr(Env.perc(0.1, ts/10, 0.125))+1; // add 1 so we're not starting from zero
    modindexenv = EnvGen.kr(Env.sine(ts, 1))+1;
    mod = SinOsc.ar(freq * modPartial * modfreqenv, 0, freq * index * modindexenv);
    car = SinOsc.ar((freq * carPartial) + mod, 0, mul );
    env = EnvGen.ar( Env.perc(0.01, 1), doneAction: 2, timeScale: ts);
    Out.ar( outbus, Pan2.ar(car * env))
}).add;

Synth(\fmsynthenv, [ \freq, 440.0, \ts, 10]);
Synth(\fmsynthenv, [ \freq, 440.0, \ts, 1]);
Synth(\fmsynthenv, [ \freq, 110.0, \ts, 2]);

/////////////////////////

// MM - Symphonic Ensemble - 2020 Matias Monteagudo.

(
Server.local.options.device = "ASIO : ASIO PreSonus FireStudio";
Server.local.options.sampleRate=48000;
Server.local.options.hardwareBufferSize=128;
Server.local.options.memSize=32768;
)


//Reverb.
((
	SynthDef(\verb, {
		|in, predelay=1, revtime=2, lpf=4500,mix=0.5,amp=1,out=0|
		var dry,wet,temp,sig;
		dry = In.ar(in, 2);
		temp = In.ar(in, 2);
		wet=0;
		temp=DelayN.ar(temp, 0.2, predelay);
		32.do {temp=AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2,revtime);
			temp=LPF.ar(temp,lpf);
			wet=wet+temp;
		};
		sig=XFade2.ar(dry,wet,mix*2-1,amp);
		Out.ar(out,sig);
	}).add;
);
)

//After evaluating this. You can hit "CMD+." or even restart the server and the verb will be there. (You'll need to re evaluate only if you restart SC)
(
~revBus = Bus.audio(s,2);
~createReverb={~reverbSynth=Synth(\verb, [\mix,0.23, \in, ~revBus])};
ServerTree.add(~createReverb);
)

ServerTree.removeAll;//If you wanna empty the Tree.

//Instruments.
(
(
~bFl1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_flute/AKWF_flute_0006.wav");
~bOb1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_oboe/AKWF_oboe_0010.wav");
~bCla1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_clarinett/AKWF_clarinett_0021.wav");
~bVln1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_violin/AKWF_violin_0011.wav");
~bVla1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_violin/AKWF_violin_0011.wav");
~bCel1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_cello/AKWF_cello_0003.wav");
~bBas1=Buffer.read(s,"G:/SAMPLES/Waveforms/AKWF_dbass/AKWF_dbass_0012.wav");
~loop1=Buffer.read(s,"C:/Audio/SC/Mat SC/GamesLoop1.wav");
~loop2=Buffer.read(s,"C:/Audio/SC/Mat SC/GamesLoop2.wav");
);

//Flute.
(
SynthDef(\flutes, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,
	pl1,pl2,pl3,pl4;
	mod1=SinOsc.ar(Rand(3,6),0,0.03);
	mod2=SinOsc.ar(Rand(5,6),0,0.03);
	mod3=SinOsc.ar(Rand(3,6),0,0.03);
	mod4=SinOsc.ar(Rand(4,6),0,0.03);
	pl1=PlayBuf.ar(1,~bFl1,freq+mod1,loop:1);
	pl1=(pl1*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1*0.8,1,Rand(0.01,0.1));
	pl2=PlayBuf.ar(1,~bFl1,freq+mod2,loop:1);
	pl2=(pl2*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl2*0.8,1,Rand(0.01,0.1));
	pl3=PlayBuf.ar(1,~bFl1,freq+mod3,loop:1);
	pl3=(pl3*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl3*0.8,1,Rand(0.01,0.1));
	pl4=PlayBuf.ar(1,~bFl1,freq+mod4,loop:1);
	pl4=(pl4*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl4*0.8,1,Rand(0.01,0.1));
	sig=Splay.ar([pl1,pl2,pl3,pl4],spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);

//Oboe
(
SynthDef(\oboes, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,
	pl1,pl2,pl3,pl4;
	mod1=SinOsc.ar(Rand(5.2,6),0,0.008);
	mod2=SinOsc.ar(Rand(5.3,6),0,0.008);
	mod3=SinOsc.ar(Rand(5.4,6),0,0.008);
	mod4=SinOsc.ar(Rand(5.5,6),0,0.008);
	pl1=PlayBuf.ar(1,~bOb1,freq+mod1,loop:1);
	pl1=(pl1*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1,0.2,Rand(0.01,0.1));
	pl2=PlayBuf.ar(1,~bOb1,freq+mod2,loop:1);
	pl2=(pl2*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl2,0.2,Rand(0.01,0.1));
	pl3=PlayBuf.ar(1,~bOb1,freq+mod3,loop:1);
	pl3=(pl3*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl3,0.2,Rand(0.01,0.1));
	pl4=PlayBuf.ar(1,~bOb1,freq+mod4,loop:1);
	pl4=(pl4*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl4,0.2,Rand(0.01,0.1));
	sig=Splay.ar([pl1,pl2,pl3,pl4],spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);

//Clarinet
(
SynthDef(\clarinets, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,
	pl1,pl2,pl3,pl4;
	mod1=SinOsc.ar(Rand(5.2,6),0,0.008);
	mod2=SinOsc.ar(Rand(5.3,6),0,0.008);
	mod3=SinOsc.ar(Rand(5.4,6),0,0.008);
	mod4=SinOsc.ar(Rand(5.5,6),0,0.008);
	pl1=PlayBuf.ar(1,~bCla1,freq+mod1,loop:1);
	pl1=(pl1*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1,0.2,Rand(0.01,0.1));
	pl2=PlayBuf.ar(1,~bCla1,freq+mod2,loop:1);
	pl2=(pl2*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl2,0.2,Rand(0.01,0.1));
	pl3=PlayBuf.ar(1,~bCla1,freq+mod3,loop:1);
	pl3=(pl3*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl3,0.2,Rand(0.01,0.1));
	pl4=PlayBuf.ar(1,~bCla1,freq+mod4,loop:1);
	pl4=(pl4*0.6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl4,0.2,Rand(0.01,0.1));
	sig=Splay.ar([pl1,pl2,pl3,pl4],spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);

//Violins
(
SynthDef(\violins, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,mod5,mod6,mod7,mod8,
	pl1,pl2,pl3,pl4,pl5,pl6,pl7,pl8;
	mod1=SinOsc.ar(Rand(5,7),0,0.02);
	mod2=SinOsc.ar(Rand(5,6),0,0.02);
	mod3=SinOsc.ar(Rand(5,5),0,0.02);
	mod4=SinOsc.ar(Rand(5,7),0,0.02);
	mod5=SinOsc.ar(Rand(5,6),0,0.02);
	mod6=SinOsc.ar(Rand(5,5),0,0.02);
	mod7=SinOsc.ar(Rand(5,7),0,0.02);
	mod8=SinOsc.ar(Rand(5,6),0,0.02);
	pl1=PlayBuf.ar(1,~bVln1,freq+mod1,loop:1);
	pl1=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1,0.2,Rand(0.01,004));
	pl2=PlayBuf.ar(1,~bVln1,freq+mod2,loop:1);
	pl2=(pl2)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl2,0.2,Rand(0.01,0.04));
	pl3=PlayBuf.ar(1,~bVln1,freq+mod3,loop:1);
	pl3=(pl3)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl3,0.2,Rand(0.01,0.04));
	pl4=PlayBuf.ar(1,~bVln1,freq+mod4,loop:1);
	pl4=(pl4)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl4,0.2,Rand(0.01,0.04));
	pl5=PlayBuf.ar(1,~bVln1,freq+mod5,loop:1);
	pl5=(pl5)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl5=DelayN.ar(pl5,0.2,Rand(0.01,0.04));
	pl6=PlayBuf.ar(1,~bVln1,freq+mod6,loop:1);
	pl6=(pl6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl6=DelayN.ar(pl6,0.2,Rand(0.01,0.04));
	pl7=PlayBuf.ar(1,~bVln1,freq+mod7,loop:1);
	pl7=(pl7)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl7=DelayN.ar(pl7,0.2,Rand(0.01,0.04));
	pl8=PlayBuf.ar(1,~bVln1,freq+mod8,loop:1);
	pl8=(pl8)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl8=DelayN.ar(pl8,0.2,Rand(0.01,0.03));
	sig=BHiPass.ar([pl1,pl2,pl3,pl4,pl5,pl6,pl7,pl8],850);
	sig=Splay.ar(sig,spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);

//Violas
(
SynthDef(\violas, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,mod5,mod6,mod7,mod8,
	pl1,pl2,pl3,pl4,pl5,pl6,pl7,pl8;
	mod1=SinOsc.ar(Rand(5,7),0,0.02);
	mod2=SinOsc.ar(Rand(5,5),0,0.02);
	mod3=SinOsc.ar(Rand(5,6),0,0.02);
	mod4=SinOsc.ar(Rand(5,7),0,0.02);
	mod5=SinOsc.ar(Rand(5,6),0,0.02);
	mod6=SinOsc.ar(Rand(5,7),0,0.02);
	mod7=SinOsc.ar(Rand(5,6),0,0.02);
	mod8=SinOsc.ar(Rand(5,7),0,0.02);
	pl1=PlayBuf.ar(1,~bVla1,freq+mod1,loop:1);
	pl1=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1,0.2,Rand(0.01,004));
	pl2=PlayBuf.ar(1,~bVla1,freq+mod2,loop:1);
	pl2=(pl2)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl2,0.2,Rand(0.01,0.04));
	pl3=PlayBuf.ar(1,~bVla1,freq+mod3,loop:1);
	pl3=(pl3)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl3,0.2,Rand(0.01,0.04));
	pl4=PlayBuf.ar(1,~bVla1,freq+mod4,loop:1);
	pl4=(pl4)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl4,0.2,Rand(0.01,0.04));
	pl5=PlayBuf.ar(1,~bVla1,freq+mod5,loop:1);
	pl5=(pl5)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl5=DelayN.ar(pl5,0.2,Rand(0.01,0.04));
	pl6=PlayBuf.ar(1,~bVla1,freq+mod6,loop:1);
	pl6=(pl6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl6=DelayN.ar(pl6,0.2,Rand(0.01,0.04));
	pl7=PlayBuf.ar(1,~bVla1,freq+mod7,loop:1);
	pl7=(pl7)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl7=DelayN.ar(pl7,0.2,Rand(0.01,0.04));
	pl8=PlayBuf.ar(1,~bVla1,freq+mod8,loop:1);
	pl8=(pl8)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl8=DelayN.ar(pl8,0.2,Rand(0.01,0.03));
	sig=BHiPass.ar([pl1,pl2,pl3,pl4,pl5,pl6,pl7,pl8],750);
	sig=Splay.ar(sig,spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);

//Cellos
(
SynthDef(\cellos, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,mod5,mod6,
	pl1,pl2,pl3,pl4,pl5,pl6;
	mod1=SinOsc.ar(Rand(5,7),0,0.002);
	mod2=SinOsc.ar(Rand(5,6),0,0.002);
	mod3=SinOsc.ar(Rand(5,5),0,0.002);
	mod4=SinOsc.ar(Rand(5,7),0,0.002);
	mod5=SinOsc.ar(Rand(5,6),0,0.002);
	mod6=SinOsc.ar(Rand(5,5),0,0.002);
	pl1=PlayBuf.ar(1,~bCel1,freq+mod1,loop:1);
	pl1=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1,0.2,Rand(0.01,004));
	pl2=PlayBuf.ar(1,~bCel1,freq+mod2,loop:1);
	pl2=(pl2)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl2,0.2,Rand(0.01,0.04));
	pl3=PlayBuf.ar(1,~bCel1,freq+mod3,loop:1);
	pl3=(pl3)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl3,0.2,Rand(0.01,0.04));
	pl4=PlayBuf.ar(1,~bCel1,freq+mod4,loop:1);
	pl4=(pl4)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl4,0.2,Rand(0.01,0.04));
	pl5=PlayBuf.ar(1,~bCel1,freq+mod5,loop:1);
	pl5=(pl5)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl5=DelayN.ar(pl5,0.2,Rand(0.01,0.04));
	pl6=PlayBuf.ar(1,~bCel1,freq+mod6,loop:1);
	pl6=(pl6)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl6=DelayN.ar(pl6,0.2,Rand(0.01,0.04));
	sig=Splay.ar([pl1,pl2,pl3,pl4,pl5,pl6],spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);

//Basses
(
SynthDef(\basses, {
	|gate=1,amp=1,pan=0,freq=4,atk=0.1,rel=1,cur=1,spr=1|
	var sig,
	mod1,mod2,mod3,mod4,
	pl1,pl2,pl3,pl4;
	mod1=SinOsc.ar(Rand(5.2,7),0,0.002);
	mod2=SinOsc.ar(Rand(5.3,7),0,0.002);
	mod3=SinOsc.ar(Rand(5.4,7),0,0.002);
	mod4=SinOsc.ar(Rand(5.5,7),0,0.002);
	pl1=PlayBuf.ar(1,~bBas1,freq+mod1,loop:1);
	pl1=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl1=DelayN.ar(pl1*0.8,0.2,Rand(0.01,0.045));
	pl2=PlayBuf.ar(1,~bBas1,freq+mod1,loop:1);
	pl2=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl2=DelayN.ar(pl1*0.8,0.2,Rand(0.01,0.05));
	pl3=PlayBuf.ar(1,~bBas1,freq+mod1,loop:1);
	pl3=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl3=DelayN.ar(pl1*0.8,0.2,Rand(0.01,0.055));
	pl4=PlayBuf.ar(1,~bBas1,freq+mod1,loop:1);
	pl4=(pl1)*EnvGen.kr(Env.adsr(atk,0.3,1,rel,0.8),gate,doneAction:2);
	pl4=DelayN.ar(pl1*0.8,0.2,Rand(0.01,0.06));
	sig=Splay.ar([pl1,pl2,pl3,pl4],spr,center:pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig*amp);
}).add
);
//BassDrum
(
SynthDef(\bdrum, {
	|amp=1, pan=0, ext=1, freq=1, loss=1|
	var sig,exciter;
	exciter=PinkNoise.ar(EnvGen.ar(Env([0,ext,0],[0.001,1],-40),1, doneAction:2));
	sig=MembraneHexagon.ar(exciter,freq,loss,amp);
	sig=DelayN.ar(sig,0.2,Rand(0.06,0.09));
	sig=Balance2.ar(sig,sig,pan,1);
	Out.ar(~revBus, sig)
}).add
);

//Celesta
(
SynthDef(\celesta, {
	|amp=1, pan=0, freq=800,rel=10|
	var sig,mod;
	mod=SinOsc.ar(freq*2,0);
	sig=LFTri.ar(freq,mod)*EnvGen.kr(Env([0,amp,0],[0.001, rel],-3),1,doneAction:2);
	sig=DelayN.ar(sig,0.2,Rand(0.06,0.09));
	sig=Pan2.ar(sig, pan);
	sig=LeakDC.ar(sig, 0.995);
	Out.ar(~revBus, sig)
}).add
);

(
SynthDef(\loop1, {
	|gate=1,amp=1|
	var sig;
	sig=PlayBuf.ar(2,~loop1)*EnvGen.kr(Env.adsr(0.0001,0.1,amp,0.0001),gate,doneAction:2);
	sig=DelayN.ar(sig, 0.1,0.05);
	Out.ar(0, sig)
}).add
);

(
SynthDef(\loop2, {
	|gate=1,amp=1|
	var sig;
	sig=PlayBuf.ar(2,~loop2)*EnvGen.kr(Env.adsr(0.0001,0.1,amp,0.0001),gate,doneAction:2);
	sig=DelayN.ar(sig, 0.1,0.05);
	Out.ar(0, sig)
}).add
);

)

//Test song.

(
TempoClock.tempo=85/60;
//Flute
(
~pFlute=Pbindef(\pflute, \instrument, \flutes, \gate,1, \envdur,1.8, \amp,0.8, \pan, -0.5, \atk,0.2, \rel,0.5, \dur,1/4, \scale, Scale.chromatic, \octave,0, \legato, 1/3,
	\degree, Pseq([
		10,3,-1,-4, 8, 3,-1,-4, 7, 3,-1,-4, 8, 3,-1,-4, //Bar1
		8,1,-2,-6,6,1,-2,-6,5,1,-2,-6,6,1,-2,-6, //Bar2
		6,-1,-4,-7,5,-1,-4,-7,4,-1,-4,-7,5,-1,-4,-7, //Bar3
		5,-2,-6,-9,3,-2,-6,-9,2,-2,-6,-9,3,-2,-6,-9, //Bar4
		10,3,-1,-4, 8, 3,-1,-4, 7, 3,-1,-4, 8, 3,-1,-4, //Bar5
		11,4,1,-5,10,4,1,-5,9,4,1,-5,10,4,1,-5, //Bar6
		13,3,-1,-4,11,3,-1,-4,10,3,-1,-4,11,3,-1,-4, //Bar7
		10,3,-1,-7,8,3,-1,-7,6,3,-1,-7,5,3,-1,-7 //Bar8
		],inf),
));
//Oboe
(
~pOboe=Pbindef(\poboe, \instrument, \oboes, \gate,1, \envdur,1.8, \amp,0.15, \pan, -0.4, \dur,1, \scale, Scale.chromatic, \octave,-2,
	\degree, Pseq([
		10,8, 7, 8, //Bar1
		8,6,5,6, //Bar2
		6,5,4,5,
		5,3,2,3,
		10,8,7,8,
		11,10,9,10,
		13,11,10,11,
		10,8,6,5,
		],inf),
));

//Clarinet
(
~pClarinet=Pbindef(\pclarinet, \instrument, \clarinets, \gate,1, \envdur,1.8, \amp,0.1, \pan, -0.2, \dur,1, \scale, Scale.chromatic, \octave,-1,
	\degree, Pseq([
		-2,-1,3,-4, //Bar1
		-4,-2,1,-6, //Bar2
		-6,-4,-1,-7,
		-7,-6,-2,-9,
		-2,-1,3,-4,
		-2,1,4,-5,
		-4,-1,3,-4,
		-7,-4,-1,3
		],inf),
));
//Violins Pat1
(
~pViolin1=Pbindef(\pcviolin1, \instrument, \violins, \gate,1, \envdur,4, \amp,0.6, \pan, -0.2, \atk, 0.15, \rel, 0.8, \dur,1/4, \legato, 1/3, \scale, Scale.chromatic, \octave,-1,
	\degree, Pseq(#[
		rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,
		rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,
		rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,
		rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,rest,
		10,3,-1,-4, 8, 3,-1,-4, 7, 3,-1,-4, 8, 3,-1,-4, //Bar5
		11,4,1,-5,10,4,1,-5,9,4,1,-5,10,4,1,-5, //Bar6
		13,3,-1,-4,11,3,-1,-4,10,3,-1,-4,11,3,-1,-4, //Bar7
		10,3,-1,-7,8,3,-1,-7,6,5,10,8,15,11,17,15 //Bar8
		]),
));
//Violins Pat2
(
~pViolin2=Pbindef(\pcviolin2, \instrument, \violins, \gate,1, \envdur,4, \amp,0.4, \pan, -0.2, \atk, 0.15, \rel, 0.8, \dur,1/4, \legato, 1/3, \scale, Scale.chromatic, \octave,-1,
	\degree, Pseq([
		10,3,-1,-4, 8, 3,-1,-4, 7, 3,-1,-4, 8, 3,-1,-4, //Bar1
		8,1,-2,-6,6,1,-2,-6,5,1,-2,-6,6,1,-2,-6, //Bar2
		6,-1,-4,-7,5,-1,-4,-7,4,-1,-4,-7,5,-1,-4,-7, //Bar3
		5,-2,-6,-9,3,-2,-6,-9,2,-2,-6,-9,3,-2,-6,-9, //Bar4
		10,3,-1,-4, 8, 3,-1,-4, 7, 3,-1,-4, 8, 3,-1,-4, //Bar5
		11,4,1,-5,10,4,1,-5,9,4,1,-5,10,4,1,-5, //Bar6
		13,3,-1,-4,11,3,-1,-4,10,3,-1,-4,11,3,-1,-4, //Bar7
		10,3,-1,-7,8,3,-1,-7,6,5,10,8,15,11,17,15 //Bar8
		],inf),
));
//Viola
(
~pViola=Pbindef(\pviola, \instrument, \violas, \gate,1, \envdur,1.8, \amp,0.4, \pan, -0.5, \atk, 0.5, \dur,1/4, \scale, Scale.chromatic, \octave,-2,
	\degree, Pseq(#[
		-1,11,15,22,rest,rest,rest,rest,
		rest,11,22,20,25,22,20,15,
		-2,10,13,20,rest,rest,rest,rest,
		-2,rest,20,18,25,20,18,15,
		-4,8,11,18,rest,rest,rest,rest,
		-4,8,18,17,20,17,13,11,
		-9,-9,10,17,rest,rest,rest,rest,
		-6,6,17,15,20,18,25,23,
		-1,11,15,22,rest,rest,rest,rest,
		-1,11,22,20,27,22,20,15,
		-2,10,13,25,rest,rest,rest,rest,
		3,15,25,22,28,27,25,22,
		-4,8,15,23,rest,rest,rest,rest,
		-4,8,23,22,25,23,20,15,
		1,13,20,23,rest,rest,rest,rest,
		1,13,23,20,29,27,32,29,
		],inf),
));
//Cellos
(
~pCello=Pbindef(\pcello, \instrument, \cellos, \gate,1, \envdur,4, \amp,0.35, \pan, 0.4, \atk, 0.25, \dur,1/4, \scale, Scale.chromatic, \octave,-3,
	\degree, Pseq(#[
		-1,11,15,22,rest,rest,rest,rest,
		rest,11,22,20,25,22,20,15,
		-2,10,13,20,rest,rest,rest,rest,
		-2,rest,20,18,25,20,18,15,
		-4,8,11,18,rest,rest,rest,rest,
		-4,8,18,17,20,17,13,11,
		-9,-9,10,17,rest,rest,rest,rest,
		-6,6,17,15,20,18,25,23,
		-1,11,15,22,rest,rest,rest,rest,
		-1,11,22,20,27,22,20,15,
		-2,10,13,25,rest,rest,rest,rest,
		3,15,25,22,28,27,25,22,
		-4,8,15,23,rest,rest,rest,rest,
		-4,8,23,22,25,23,20,15,
		1,13,20,23,rest,rest,rest,rest,
		1,13,23,20,29,27,32,29,
		],inf),
));
//Basses
(
~pBass=Pbindef(\pbass, \instrument, \basses, \gate,1, \envdur,4, \amp,0.6, \pan, 0.5, \atk, 0.15, \dur,1/2, \scale, Scale.chromatic, \octave,-3,
	\degree, Pseq(#[
		-1,rest,rest,rest,
		-1,rest,rest,rest,
		-2,rest,rest,rest,
		-2,rest,rest,rest,
		-4,rest,rest,rest,
		-11,rest,rest,rest,
		-9,rest,rest,rest,
		-6,rest,rest,rest,
		-1,rest,rest,rest,
		-1,rest,rest,rest,
		-2,rest,rest,rest,
		-9,rest,rest,rest,
		-4,rest,rest,rest,
		-4,rest,rest,rest,
		1,rest,rest,rest,
		-11,rest,rest,rest,
		],inf),
));
//Drum
(
~pDrum=Pbindef(\pbdrum, \instrument, \bdrum, \gate,1, \amp,0.06, \pan, 0,  \loss,0.99995, \dur, 2,
	\freq, Pseq(#[
		0.0052,rest,
		rest,rest,
		0.0052,rest,
		rest,rest,
		],inf),
));
//Celesta
(
~pCelesta=Pbindef(\pcelesta, \instrument, \celesta, \gate,1, \amp,0.06, \pan, 0.8,  \rel, 2, \dur,1/2, \scale, Scale.chromatic, \octave,7,
	\degree, Pseq(#[
		14,3,7,3,
		11,3,7,3,
		12,2,5,2,
		9,2,5,2,
		10,0,3,0,
		8,0,3,0,
		9,-2,2,-2,
		6,-2,2,-2,
		14,3,7,3,
		11,3,7,3,
		15,5,8,5,
		13,5,8,5,
		17,3,7,3,
		14,3,7,3,
		14,3,7,3,
		10,3,7,3,
		],inf),
));

//Celesta2
(
~pCelesta2=Pbindef(\pcelesta2, \instrument, \celesta, \gate,1, \amp,0.1, \pan, -0.8,  \rel, 2, \dur,1, \scale, Scale.chromatic, \octave,7,
	\degree, Pseq(#[
		14,12,11,12,
		12,10,9,10,
		10,9,8,9,
		9,7,6,7,
		14,12,11,12,
		15,14,13,14,
		17,15,14,15,
		14,12,10,9
		],inf),
));

//Empty phrase.
(
~pEmpty=Pbindef(\pEmpty, \dur,0.25,
	\degree, Pseq(#[
		rest
		],128),
));
//Loop
(
~pLoop1=Pbind(\instrument, \loop1, \amp,1, \gate,1, \legato,10, \dur,2, \degree, Pseq(#[
	rest,rest,rest,rest,
	rest,rest,rest,rest,
	rest,rest,rest,rest,
	rest,rest,1,rest
],1));
);
//Loop2
(
~pLoop2=Pbind(\instrument, \loop2, \amp,1, \gate,1, \dur,32, \legato,1, \degree, Pseq([1],inf));
);

(
~laneFlute=Pseq([~pFlute],inf).play;
~laneOboe=Pseq([~pEmpty,~pOboe],inf).play;
~laneClarinet=Pseq([~pEmpty,~pClarinet],inf).play;
~laneViolin=Pseq([~pViolin1,~pViolin2],inf).play;
~laneViola=Pseq([~pEmpty,~pViola],inf).play;
~laneCello=Pseq([~pEmpty,~pCello],inf).play;
~laneBass=Pseq([~pEmpty,~pBass],inf).play;
~laneDrums=Pseq([~pEmpty,~pDrum],inf).play;
~laneCelesta=Pseq([~pCelesta],inf).play;
~laneCelesta2=Pseq([~pCelesta2],inf).play;
~laneLoop=Pseq([~pLoop1,~pLoop2]).play;
)

/*(
~laneFlute=Pseq([~pFlute],inf).play;
~laneOboe=Pseq([~pOboe],inf).play;
~laneClarinet=Pseq([~pClarinet],inf).play;
~laneViolin=Pseq([~pViolin],inf).play;
~laneViola=Pseq([~pViola],inf).play;
~laneCello=Pseq([~pCello],inf).play;
~laneBass=Pseq([~pBass],inf).play;
~laneDrums=Pseq([~pDrum],inf).play;
~laneCelesta=Pseq([~pCelesta],inf).play;
~laneCelesta2=Pseq([~pCelesta2],inf).play;
~laneLoop=Pseq([~pLoop2]).play;
)*/

)


Synth(\loop)

~loop.query

//Stop song.

(
~laneFlute.stop;
~laneOboe.stop;
~laneClarinet.stop;
~laneViolin.stop;
~laneViola.stop;
~laneCello.stop;
~laneBass.stop;
~laneDrums.stop;
~laneCelesta.stop;
~laneCelesta2.stop;
~laneLoop.stop;
)












//Koji Kondo, Sir you're a superb composer.

//////////////////////////

(
//init/cleanup
~vbus = Bus.audio(s, 2);
s.freeAll;
~players.do(_.stop);

s.waitForBoot({

	//fm synth
	SynthDef(\fm, {
		arg freq=500, mRatio=1, cRatio=1,
		index=1, iScale=5, cAtk=4, cRel=(-4),
		amp=0.2, atk=0.01, rel=3, pan=0,
		out=0, fx=0, fxsend=(-25);
		var car, mod, env, iEnv;
		
		//index of modulation
		iEnv = EnvGen.kr(
			Env(
				[index, index*iScale, index],
				[atk, rel],
				[cAtk, cRel]
			)
		);
		
		//amplitude envelope
		env = EnvGen.kr(Env.perc(atk,rel,curve:[cAtk,cRel]),doneAction:2);
		
		//modulator/carrier
		mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
		car = SinOsc.ar(freq * cRatio + mod) * env * amp;
		
		car = Pan2.ar(car, pan);

		//direct out/reverb send
		Out.ar(out, car);
		Out.ar(fx, car * fxsend.dbamp);
	}).add;

	//reverb
	SynthDef(\reverb, {
		arg in=0, out=0, dec=4, lpf=1500;
		var sig;
		sig = In.ar(in, 2).sum;
		sig = DelayN.ar(sig, 0.03, 0.03);
		sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
		sig = SplayAz.ar(2, sig);
		sig = LPF.ar(sig, lpf);
		5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
		sig = LPF.ar(sig, lpf);
		sig = LeakDC.ar(sig);
		Out.ar(out, sig);
	}).add;

	s.sync;

	Synth(\reverb, [\in, ~vbus]);

	s.sync;

	//array of sequencers
	~players = [

		//bass
		Pbind(
			\instrument, \fm,
			\dur, 1/6,
			\midinote, Pseq([
				Pseq([[28,40]],32),
				Pseq([[24,36]],24), Pseq([[33,45]],8),
			],inf) + Pwrand([0,12],[0.9,0.1],inf),
			\mRatio, 2,
			\index, 1.5,
			\iScale, Pseq([3,2.5,2,1],inf),
			\atk, 0,
			\rel, Pexprand(0.2,0.4,inf),
			\amp, Pseq([Pgeom(0.28,-3.dbamp,4)],inf),
			\pan, Pseq([-0.25,0.25],inf),
			\out, 0,
			\fx, ~vbus,
			\fxsend, -inf,
		).play,

		//lead
		Pbind(
			\instrument, \fm,
			\dur, 1/6,
			\midinote, Pseq([Pfin(64, Pseq([64,67,69,71,74,76],inf))],inf),
			\mRatio, Pwrand([0.5,1.5,2,3],[1,3,6,25].normalizeSum, inf),
			\index, Pexprand(2,2.5),
			\iScale, Pseq([Pgeom(1.2,1.2,6)],inf),
			\atk, Pwrand([0,Pexprand(0.02,0.1,1)],[0.99,0.01],inf),
			\rel, Pseq(Array.interpolation(64,0.03,0.25).mirror2,inf),
			\cAtk, 1,
			\cRel, Pseq(Array.interpolation(64,-4,3).mirror2,inf),
			\amp, Pseq([Pfin(64, Pseq([Pgeom(0.13,-3.dbamp,6)],inf))],inf),
			\pan, Pseq(Array.interpolation(64,0,1).lincurve(0,1,0,1,8),inf) * Pseq([1,-1],inf),
			\out, 0,
			\fx, ~vbus,
			\fxsend, -15,
		).play,

		//pad
		Pbind(
			\instrument, \fm,
			\dur, 1/6 * 32,
			\midinote, Pseq([
				[40,52,57,59,62],
				[40,55,57,59,64],
				[40,52,57,59,62],
				[33,45,57,59,64],
			],inf),
			\mRatio, 1,
			\index, 1.5,
			\iScale, Pseq([2,4],inf),
			\atk, 1/6 * 16,
			\rel, 1/6 * 24,
			\cAtk, 0,
			\cRel, 0,
			\amp, 0.027,
			\out, 0,
			\fx, ~vbus,
			\fxsend, -10,
		).play,

		//snare
		Pbind(
			\instrument, \fm,
			\dur, 1/6,
			\freq, Pseq([
				\,\,\,\,1,\,\,\,
				\,\,\,\,1,\,\,\,
				\,\,\,\,1,\,\,\,
				\,\,\,\,1,\,\,1,
				\,\,\,\,1,\,\,\,
				\,\,\,\,1,\,\,\,
				\,\,\,\,1,\,\,\,
				\,\,\,\,1,1,1,1,
			],inf) * 411,
			\cRatio, 45.9,
			\mRatio, 1.5,
			\index, 100,
			\iScale, 1,
			\atk, 0,
			\rel, 0.1,
			\cRel, -8,
			\amp, Pseq([0.18,0.04,0.18,0.1],inf),
			\pan, 0,
			\out, 0,
			\fx, ~vbus,
			\fxsend, -12,
		).play,

		//kick
		Pbind(
			\instrument, \fm,
			\dur, 1/6,
			\freq, 25,
			\mRatio, 0.4,
			\index, 2,
			\iScale, 8,
			\atk, 0,
			\rel, 0.08,
			\amp, Pseq([Pgeom(0.8,-2.dbamp,8)],inf),
			\pan, Pseq([0.3,-0.3],inf),
			\out, 0,
			\fx, ~vbus,
			\fxsend, -16,
		).play
	];
});
)

//stop

~players.do(_.stop);
~players[0].play;
~players[0].stop



/////////////////

(
	Pbind(
		\degree, Pseq([0], inf),
		\dur, Prout({ arg ev;
			var x=0;
			var xold=0;
			var xnew;
			loop {
				xnew = 1.0 - (1.4 * x * x) + (0.3 * xold);
				xold = x;
				x = xnew;
				ev[\root] = 3.rand+3;
				ev = x.yield;
			}
		}).abs.trace,
	).play();
)
