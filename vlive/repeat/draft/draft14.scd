(
SynthDef(\playersec_fx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * SinOsc.ar(\amplfo.kr(8*~t)).range(env1,1);
	sig = sig + FreqShift.ar(sig, SinOsc.kr(\shiftlfo.kr(4*~t)).range(env2,1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
MenuSpecDef(\patkitdef_synthdefs).addUnique(\playersec_fx);

SynthDef(\noiser, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, tsustain=1;
	var sig;
	var hpfenv = EnvGen.kr(\hpfenv.kr(Env([1,2,1,2],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	var lpfenv = EnvGen.kr(\lpfenv.kr(Env([1,2,1,2],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	var bpfenv = EnvGen.kr(\bpfenv.kr(Env([2,1/2,1,2],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	sig = WhiteNoise.ar;
	sig = HPF.ar(sig, \hpf.kr(200) * hpfenv);
	sig = LPF.ar(sig, \lpf.kr(10000) * lpfenv);
	sig = sig + BPF.ar(sig, \bpf.kr(200) * bpfenv, \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\trabass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([204,62,61],[0.05,0.2]), 1);
	env2 = EnvGen.kr(Env([1,2,3],[0.01,0.8]), 1);
	sig = LFSaw.ar(env1);
	//sig = ( sig*2 ).fold2(0.8);
	sig1 = sig.clip2(1);
	sig2 = sig.distort(1);
	sig3 = sig.tanh(1);
	sig = SelectX.ar(\distmix.kr(0.5)*2, [sig1, sig2, sig3]) + sig /2;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) *env2* freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\drums).clear

~t = 185/4/60; TempoClock.default.tempo = ~t; // don't know original tempo :(

(
Pdef(\drums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.31,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fx,
			\kitIndex, 4,
			//\pos, 0,
			\amplfo, Pseq([11],inf)*~t,
			\shiftlfo, Pseq([7],inf)*~t,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.2,
			\dur, 1/4,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				Pser([
					1,0,0,0,
				],16*4),
				Pser([
					1,0,1,0,
				],16*4),
				Pser([
					1,0.5,1,0.5,
				],16*4),
				Pser([
					1,0.8,1,0.9,
				],16*4),
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.15,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/4,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,0,1,0, 1,0,1,0,
			].rotate(1).clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,0,0, 1,1,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		//Pbind(
		//	\instrument, \bizar,
		//	\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),8),
		//	\fold, 1 * Pseg(Prand([3,1,2,1]/1.814,inf),8),
		//	\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//Ppar(
		//	{Pbind(
		//		\instrument, \bizar2,
		//		\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\diff, 0.001 * Pseg(Prand([100,3,1,2,1]/0.814,inf),16),
		//		\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
		//		\lpfr, 4 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\rq, 1 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\amdetune, 0.01 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\isRest, Pseq([
		//			Pseq({[
		//			1,1,1,1, 1,1,1,1,
		//			1,0,1,0, 1,0,1,0,
		//			1,0,0,0, 1,0,0,0,
		//			0,0,1,0, 0,0,1,0,
		//			].clump(4).choose}.dup(8).flat,inf)
		//		],inf).coin.not,
		//		\dur, 1/[8,4,16,1,2].choose,
		//		\amp, 0.1/4,
		//	)} ! 4,
		//),
		//Pbind(
		//	\isRest, Pstep(Pseq([
		//		Prand([
		//			Pseq([ 1,0,1,0, ],1),
		//			Pseq([ 1,1,0,0, ],1),
		//			Pseq([ 0,0,1,1, ],1),
		//		],inf),
		//	],inf),1).coin.not,
		//) <>
		Pbind(
			\instrument, \bizar3,
			\tsustain, 4,
			//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
			\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
			\detune, Pseg(Pseq([0,1000],inf),8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 2),
			\amp, 0.1/8,
			\amp, Pkey(\amp) * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		) ! 4,
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	\degree, Pwhite(-12,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 1,0,1,0, ],1),
		//	],inf),1).coin.not,
		//	\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	//\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 0,1,0,1, ],1),
		//	],inf),1).coin.not,
		//	//\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		Pbind(
			\instrument, \noiser,
			\lpfenv, Pfunc({ arg ev;
				[ Env([1,1.0.rand,1.0.rand,1],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([1/2,74,42,81],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.07,
		),
	].flat)
).play;
)

(
SynthDef(\bizar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig.fold(\fold.kr(0.8));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bizar2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, tsustain=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env.kr(Env([2,1,1/2,2],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	sig = LFSaw.ar(freq * [1,1+\diff.kr(0.001)]).sum;
	sig = sig * ( LFSaw.ar(freq * \amdetune.kr(1.001) * [1,1+\diff.kr]) + 1 );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp / 3;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bizar3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, tsustain=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env.kr(Env([2,1,1/2,2],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	sig = LFSaw.ar(freq * [1,1+\diff.kr(0.001)]).sum;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar([12,12.010]*100) * 1 )));
	sig = sig * ( LFSaw.ar(freq * \amdetune.kr(1.001) * [1,1+\diff.kr]) + 1 );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp / 3;
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\widx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,1],[0.2,0.8]), 1);
	env2 = EnvGen.kr(Env([0.2,0.81,1],[0.1,0.8]), 1);

	sig = SinOsc.ar(freq * env1 );
	sig = Select.ar(sig+1*\fac1.kr(1) * [1/2,1.2], [
		LPF.ar(SinOsc.ar(freq* [1,2,1/2]).mean, freq*\fac2.kr(1)),
		LPF.ar(Pulse.ar(freq), freq*\fac3.kr(1)),
	]).mean;
	sig = sig * 3;
	sig = HPF.ar(sig, 80);
	sig = LPF.ar(sig, 6000 * env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\widx, Pbind(
	\instrument, \widx,
	//\fac1, ~pmodenv.(Pseq([1/2,2],inf),4),
	\fac1, Ndef(\lfo1, { LFNoise1.kr(1/4).range(1/4,4) }),
	\fac2, Ndef(\lfo2, { SinOsc.kr(4).range(1,4) }),
	\fac3, Ndef(\lfo3, { LFNoise1.kr(1/4).range(1,4) }),
	\degree, Pseq([-1,0],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.2
)).stop;
);


(
SynthDef(\wob, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lfofreq = \lfofreq.kr(8*~t);
	lfo1 = SelectX.ar(\lfomix.kr(0)*3, [
		SinOsc.ar(lfofreq),
		LFPulse.ar(lfofreq),
		Pulse.ar(lfofreq),
		LFSaw.ar(lfofreq),
	]);
	freq = freq * ( 1 + ( lfo1 * 0.81 * \fmamp.kr(1) )) * [1/2,1,2];
	sig = SinOsc.ar(freq );
	sig = Select.ar(sig+1*\fac1.kr(1) * [1/2,1.2], [
		LPF.ar(SinOsc.ar(freq* [1,2,1/2]).mean, freq*\fac2.kr(1)),
		LPF.ar(Pulse.ar(freq), freq*\fac3.kr(1)),
	]);
	sig = sig * EnvGen.ar(Env.adsr(0.41,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\wob, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lfofreq = \lfofreq.kr(8*~t);
	lfo1 = SelectX.ar(\lfomix.kr(0)*3, [
		SinOsc.ar(lfofreq),
		LFPulse.ar(lfofreq),
		Pulse.ar(lfofreq),
		LFSaw.ar(lfofreq),
	]);
	freq = freq * ( 1 + ( lfo1 * 0.81 * \fmamp.kr(1) )) * [1/2,1,2];
	sig = SinOsc.ar(freq );
	sig = Select.ar(sig+1*\fac1.kr(1) * [1/2,1.2], [
		LPF.ar(SinOsc.ar(freq* [1,2,1/2]).mean, freq*\fac2.kr(1)),
		LPF.ar(Pulse.ar(freq), freq*\fac3.kr(1)),
	]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.41,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\wob, Pbind(
	\instrument, \wob,
	\degree, Pseq([0,2,4],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\lfofreq, ~pmodenv.(Prand([2,4,8,2],inf),2),
	\lfomix, ~pmodenv.(Prand([2,4,8,0]/8,inf),8),
	\fmamp, ~pmodenv.(Prand((0..8)/15,inf),8),
	\fac1, Ndef(\lfo1, { LFNoise1.kr(1/18).range(1/4,4) }),
	\fac2, Ndef(\lfo2, { SinOsc.kr(1/18).range(1,4) }),
	\fac3, Ndef(\lfo3, { LFNoise1.kr(1/18).range(1,4) }),
	\legato, 8,
	\dur, 1/4,
	\amp, 0.2
)).play;
);

(
var max = 300;
t = Array.series(max, 0, 1).curdle(0.06).scramble.flat;
b = Buffer(s, t.size, 1);

// alloc and set the values
s.listSendMsg( b.allocMsg( b.setnMsg(0, t) ) );


{
    var index, in, out, f0, fdiff;
    var bufnum = b;
    var input;
    input = MouseX.kr(0, max).round(1); // round to precision
    index = DetectIndex.kr(bufnum, input);
    index.poll;
    SinOsc.ar(index.linexp(0, max, 200, 700)) * 0.1
}.play;
)

b.free;


/////////// ambiance (drone qui bouge pas)

(
Ndef(\ambi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(100.0,10000) }!20 * ( 1 + ( SinOsc.kr((1..4).rand(0.0)/18) * 1/41 )));
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = BRF.ar(sig, { ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,1);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



(
SynthDef(\fall, { arg freq=200, pan=0, amp=0.1, gate=1, out=0;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,180,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(1,121200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\fall, Pbind(
	\instrument, \fall,
	\degree, Pseq([0],inf),
	\legato, 1,
	\dur, 4,
	\amp, 0.1
)).play;
);

	// stereo
(
SynthDef(\drone, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ ExpRand(20.0,10100!48!2), 0.001!8 ]), sig);
	sig = sig  / 1;
	sig = sig.debug("sig");
	sig = sig * amp;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\drone, Pbind(
	\instrument, \drone,
	\degree, Pseq([0],inf),
	\legato, 1,
	\dur, Pseq([7,1],inf),
	\amp, 0.1
)).play;
);

(
SynthDef(\drone_balance, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = 2.collect({
		DynKlank.ar(Ref([ Rand(0,1.0!48).round(SinOsc.kr(1/10).range(0.0001,1/80) ).linexp(0,1,20.0,15000) * [ [1,1.0 + SinOsc.kr(1/11).range(0,0.0051)] ], 0.001!8 ]), sig);
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.kr(Rand(0.1,1)).range(0,1)
	});

	sig = sig  / 1;
	sig = sig.debug("sig");
	sig = sig * amp;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\drone_balance, Pmono(\drone_balance,
	\degree, Pseq([0],inf),
	\legato, 1,
	\dur, Pseq([1,1],inf),
	\amp, 0.1
)).play;
);

(
	Pdef(\droneseq,
		Pseq([
			Pfindur(8,Pdef(\drone)),
			Pfindur(8,Pdef(\drone_balance)),
			Pfindur(8,Ppar([
				Pdef(\drone),
				Pdef(\drone_balance),
			])),
		],inf)
	).play;
)


///////////////////////////////:


ProtoDef(\rdn).edit
ProtoDef(\rdn).loadDefaultPreset

(
Ndef(\sound, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	Out.ar(BusDef(\sendbus0), sig);
	Silent.ar;
}).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert

(
	// cool disto like guitar !!!
RandDelayNetwork('deldefault').make('rdn', "4-8H4R-TRQV");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.40892487530566,
	'fb', 0.0021338168782668,
	'delay', 0.0015013107289082,
	'delay2', 0.00033190087959147,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 91.693867655233,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 20.0,
	'lpf', 17000,
	'hpf', 139.81952126401,
	'fbdistamp', 0.014670282844902,
	'fbdistmix', 0.51260504201681,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

