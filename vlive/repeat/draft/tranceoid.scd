

// INIT
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

SynthDef(\fmsaw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\brownbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(16) * freq ).clip(20,20000), \rq.kr(0.6)) + ( sig / 5 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, DelayC.ar(gate, 0.1, [0.01,0.032,0.0123] * \dstrum.kr(1)), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], 1, coef:coef).sum;
	sig = sig * 2;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\rise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, time=4;
	var sig;
	var fspread = XLine.kr(\spstart.kr(0.01),\spend.kr(10),time);
	freq= freq* XLine.kr(\start.kr(1),\end.kr(2),time);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * [ [1,1.01] ]);
	sig = sig.debug("sig").mean.debug("sig2");
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * (1+ fspread ) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Ndef(\verb, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	sig =in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig;
});

BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Pseq([0,0,0,2],inf)*( 137/60 ),
	\legato, 1,
	\dur, 2,
	\gain, 1/2,
	\amp, 0.1
));

Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\freq, Pseq([40,50,20,60],inf) * Pseg(Pseq([1,100],inf),8*8),
	\dstrum, Pseg(Pseq([0,10],inf),8*2),
	\decay, 0.04,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.61,
	\out, BusDef(\sendbus1, \audio),
	\dur, 1/8,
	\amp, 0.1
));
	Pdef(\drums1, 
		Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/4,
			\speed, Pseq([1,0.9,0.8,0.9],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-4) ],
			],inf),
			\speed, 0.9,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\pos, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		)),
			
		])
	);
);


