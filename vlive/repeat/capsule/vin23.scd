
(
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	ProtoDef(\rdn4).play;
};
~master.();
)
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\pwbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fadsr.kr(Env.adsr(1.1,1.1,0.4,1.1, 1, -2)), gate, doneAction:0);
	env2 = SinOsc.ar(freq/2); 
	env3 = EnvGen.kr(\triadsr.kr(Env.adsr(3.1,2.1,1,1.1)), gate, doneAction:0);
	env4 = SinOsc.ar(freq * SinOsc.ar(freq*3/2, Rand(0,1.0),0.2,1), Rand(0,1.0)).range(1/2,2);
	env5 = EnvGen.ar(Env.triangle(0.1,1.1),gate,doneAction:0);
	env6 = SinOsc.ar(1/113, Rand(0,1.0))* env3;
	sig1 = Pulse.ar(freq * [0.003, -0.003].midiratio, SinOsc.ar(0.01)+[0.4,0.8* env6]  );
	sig2 = LFTri.ar(freq * ( env4 * env5 * 0.11 *Rand(0.9,1.1) + 1 )) * env3;
	sig2 = BPF.ar(sig2, freq, 0.7);
	sig2 = FreqShift.ar(sig2, 0.2) * 0.4 + sig2;
	sig3 = SinOsc.ar(freq);
	sig1 = RLPF.ar(sig1, \lpfr.kr(1.1/2) * freq * (env1 * 5 + 1) * (env2 * env1 * 0.4 + 1), \rq.kr(0.5));
	sig = [sig1*1,sig2 * 0.7, sig3 * 0.71].sum;
	sig = Latch.ar(sig, Impulse.ar(1440)) * 0.4 + sig;
	//sig = [sig2];
	//sig = Pulse.ar(freq, SinOsc.ar(0.01)+0.4 );
	//pan = pan + ( [-1,1]*0.3 );
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

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
);

(
SynthDef(\upy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.1])), Impulse.kr ( \trigfreq.kr(1)));
	lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		1,64
	],inf));
	env2 = LFSaw.ar(1/2*~t * lfo1); 
	sig = LFSaw.ar(freq *(env2*\flfoamt.kr(0.3)+1) * ( SinOsc.ar(freq * [0,3].midiratio,mul:[1,0.1]).sum * \fmamt.kr(0.2) + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset;
);

/////////////////
// many grain

(
// simple grain
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[752].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/16,
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1577].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\lag, 1/16/~t,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[748].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 0.1,
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 4.4 + Pseq([
					0,0,0,0,
					0,1,1,3,
				]/3,inf),
				\dur, 1/4,
				\legato, 0.1,
				\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 3.9 + Pseq([
					0,0,0,0,
					0,0,0,2,
					0,0,0,0,
					0,0,0,1,
				]/3,inf).stutter(2) + Pseg(Pseq([0,0.11],inf),8),
				\dur, 1/8,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					1,1,0,1, 1,1,0,1,
				],inf).coin.not,
				\legato, 0.1,
				\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 7.4 + Pseq([
					0,0,0,0,
					0,0,0,1,
					0,0,1,0,
					0,1,1,3,
				]/3,inf),
				\dur, 1/4,
				\legato, Pseg(Pseq([0.1,0.03],inf),8),
				//\lag, 1/8/~t,
				\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 1/4,
			),
		
	])
)).play;
);

(
// grains
~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[752].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\legato, 0.1,
			\dur, Pseg(Pwhite(1/16,1),Pwhite(1/2,8)),
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1577].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\dur, Pseg(Pwhite(1/16,1),Pwhite(1/2,8)),
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\lag, 1/16/~t,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[748].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\dur, Pseg(Pwhite(1/16,1),Pwhite(1/2,8)),
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 4.4 + Pseq([
				0,0,0,0,
				0,1,1,3,
			]/3,inf),
			\dur, 1/4,
			\dur, Pseg(Pwhite(1/16,1),Pwhite(1/2,8)),
			\legato, 0.1,
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 3.9 + Pseq([
				0,0,0,0,
				0,0,0,2,
				0,0,0,0,
				0,0,0,1,
			]/3,inf).stutter(2) + Pseg(Pseq([0,0.11],inf),8),
			\dur, 1/8,
			\dur, Pseg(Pwhite(1/16,1),Pwhite(1/2,8)),
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				1,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 7.4 + Pseq([
				0,0,0,0,
				0,0,0,1,
				0,0,1,0,
				0,1,1,3,
			]/3,inf),
			\dur, 1/4,
			\dur, Pseg(Pwhite(1/16,1),Pwhite(1/2,8)),
			\legato, Pseg(Pseq([0.1,0.03],inf),8),
			//\lag, 1/8/~t,
			\speed, ~pmodenv.(Pseq([1,Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
			\gain, 1/4,
		),

	].collect({ arg pat, idx;
		Pbind(
			\dur, Pseg(Pwhite(1/20,1/8),Pwhite(1/2,8)),
			\dur, Pseq((0..7)/8,inf),
			\dur, Pseq(Array.geom(16,1/16,1.12 + (idx*0.01)),inf),
			\out, BusDef(\sendbus1, \audio),
		) <> pat;

	}))
)).play;
);

(
// grains + drums
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Ppar (
			{Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[752 + rrand(0,10)].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.021,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07,
			)}!6
		),
		Ppar (
			{Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[742 + rrand(0,10)].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.071,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3].choose}.dup(2),inf),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
			)}!6
		),
		Ppar (
			{Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[1014 + rrand(0,20)].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.111 * rrand(0.1,1),
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
			)}!6
		),
		
	])
)).play;
);
2**(1/4)
Pdef(\part).clear;
2**5

(
// soft grains + drums
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Ppar (
			{Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[752 + rrand(0,10)].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.021,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/(2**[0,1,2,3,4,5].choose),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07,
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!6
		),
		Ppar (
			{Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[742 + rrand(0,10)].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.071,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/(2**[0,1,2,3].choose),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!6
		),
		Ppar (
			{Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[1014 + rrand(0,20)].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.111 * rrand(0.1,1),
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/(2**[0,1,2,3,4,5].choose),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!6
		),
		
	])
)).play;
);

~durfun.(4)
(
// progressive grains + drums
	~durfun = { arg size=8;
		1/((1..8).keep(size).wchoose([1,1,0.14,1,0.07,0.15,0.07,1].keep(size).normalizeSum).debug("dur")*2)
	};
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Ppar([
			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[752 + rrand(0,10)].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.021,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1])*2),
				\dur, ~durfun.(),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07,
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16 ,

			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[742 + rrand(0,10)].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq({[
					0,0,1,0,
					1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,0,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.071,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/(2**[0,1,2,3].choose),
				\dur, 1/((1..8).choose*2),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1].normalizeSum)*2),
				\dur, ~durfun.(4),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16 ,

			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.111 * rrand(0.1,1),
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/(2**[0,1,2,3,4,5].choose),
				\dur, 1/((1..8).choose*2),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1].normalizeSum)*2),
				\dur, ~durfun.(6),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16
		].collect({ arg group;
			Ppar(group.collect({ arg pat;
				Pseq([
					Pbind(
						\isRest, Pswitch1([
							Pkey(\isRest),
							true,
						],Pstep( 
							Pseq([
								Pseq(8.collect { arg idx;
									Pseq([
										Pwrand([0,1],[idx+1*0.1,0.3].normalizeSum,1).stutter(6),
										Pn(0,2),
									],1);
								}),
								Pseq([
									Pwrand([0,1],[1,0.1].normalizeSum,1).stutter(6),
									Pn(0,2),
								],8),
							],inf),
							1/2
						)),
					) <>
					Pbind(
						//\lag,0.04,
						//\legato, 1,
						\isRest, Pswitch1([
							Pkey(\isRest),
							true,
						],Pstep(
							Pseq([
								Pseq([
									Pseq([
										Pn(0,7), 
										Pwrand([
											Pn(0,1),
											Pn(1,1),
										],[0.4,1].normalizeSum,1),
									],3),
									Pn(0,6), 
									Pwrand([
										Pn(0,1),
										Pn(1,1),
									],[0.1,1].normalizeSum,2),
								],3),
								Pseq([
									Pn(0,7), 
									Pwrand([
										Pn(0,1),
										Pn(1,1),
									],[0.4,1].normalizeSum,1),
								],3),
								Pn(0,4), 
								Pwrand([
									Pn(0,1),
									Pn(1,1),
								],[0.1,1].normalizeSum,4),
							],inf),
							1/2
						)),
					),
				],inf) <> pat;

			}))
		})),
		
	])
)).play;
);

(
// progressive grains + drums
	~durfun = { arg size=8;
		1/((1..8).keep(size).wchoose([1,1,0.14,1,0.07,0.15,0.07,1].keep(size).normalizeSum).debug("dur")*2)
	};
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar([
			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[752 + rrand(0,10)].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.021,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1])*2),
				\dur, ~durfun.(),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07,
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16 ,

			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[742 + rrand(0,10)].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq({[
					0,0,1,0,
					1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,0,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.071,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/(2**[0,1,2,3].choose),
				\dur, 1/((1..8).choose*2),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1].normalizeSum)*2),
				\dur, ~durfun.(4),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16 ,

			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.111 * rrand(0.1,1),
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/(2**[0,1,2,3,4,5].choose),
				\dur, 1/((1..8).choose*2),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1].normalizeSum)*2),
				\dur, ~durfun.(6),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16
		].collect({ arg group;
			Ppar(group.collect({ arg pat;
				Pseq([
					Pbind(
						\isRest, Pswitch1([
							Pkey(\isRest),
							true,
						],Pstep( 
							Pseq([
								Pseq(8.collect { arg idx;
									Pseq([
										Pwrand([0,1],[idx+1*0.1,0.3].normalizeSum,1).stutter(6),
										Pn(0,2),
									],1);
								}),
								Pseq([
									Pwrand([0,1],[1,0.1].normalizeSum,1).stutter(6),
									Pn(0,2),
								],8),
							],inf),
							1/2
						)),
					) <>
					Pbind(
						//\lag,0.04,
						\out, BusDef(\sendbus3, \audio),
						//\legato, 1,
						\isRest, Pswitch1([
							Pkey(\isRest),
							true,
						],Pstep(
							Pseq([
								Pseq([
									Pseq([
										Pn(0,7), 
										Pwrand([
											Pn(0,1),
											Pn(1,1),
										],[0.4,1].normalizeSum,1),
									],3),
									Pn(0,6), 
									Pwrand([
										Pn(0,1),
										Pn(1,1),
									],[0.1,1].normalizeSum,2),
								],3),
								Pseq([
									Pn(0,7), 
									Pwrand([
										Pn(0,1),
										Pn(1,1),
									],[0.4,1].normalizeSum,1),
								],3),
								Pn(0,4), 
								Pwrand([
									Pn(0,1),
									Pn(1,1),
								],[0.1,1].normalizeSum,4),
							],inf),
							1/2
						)),
					),
				],inf) <> pat;

			}))
		})),
		
	])
)).play;
);


(
// trance doydoy
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 4.1 + ~pmodenv.(Pseq([0,0.1,0.02],inf), 8),
			\legato, 0.9,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,1.2,0.81],inf), 8),
			\gain, 1 * Pseq([
				Pwhite(0.01,0.71,1),1,
			],inf),
		),
		Pbind(
			\instrument, \rhodey_sc,
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
			\lfoDepth, 1.4,
			\vel, Pgauss(0.8, 0.1, inf),
			\note, Pseq([
				-1,0,0,1,
				-1,0,0,1,
				-1,0,0,1,
				-1,-1,0,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-6,-7,-8,-7, -6,-5,-4,-5,
			],inf).stutter(16),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pwbass,
			\note, Pseq([
				\r,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		
	])
)).play;
);

(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Prand([0,2],inf)*( 137/60 ),
	\legato, 1,
	\dur, 2,
	\amp, 0.1
)).play;
);
Pdef(\amen).stop

(
// trance doydoy
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 4.1 + ~pmodenv.(Pseq([0,0.1,0.02],inf), 8),
			\legato, 0.9,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,1.2,0.81],inf), 8),
			\gain, 1 * Pseq([
				Pwhite(0.01,0.71,1),1,
			],inf),
		),
		Pbind(
			\instrument, \rhodey_sc,
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
			\lfoDepth, 1.4,
			\vel, Pgauss(0.8, 0.1, inf),
			\note, Pseq([
				-1,0,0,1,
				-1,0,0,1,
				-1,0,0,1,
				-1,-1,0,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-6,-7,-8,-7, -6,-5,-4,-5,
			],inf).stutter(16),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pwbass,
			\note, Pseq([
				\r,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,0,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.41,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 4*~t/(137/60),
			\pos, Prand([0,0],inf)*( 137/60 ),
			\legato, 1,
			\dur, 4,
			\gain, 1/2,
			\isRest, true,
		),	
	])
)).play;
);

(
// trance wamwam
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[299].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1533].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,0,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 4*~t/(137/60),
			\pos, Prand([0,0],inf)*( 137/60 ),
			\legato, 1,
			\dur, 4,
			\gain, 1/2,
			\isRest, true,
		),	
		Pbind(
			\instrument, \upy,
			\note, Pstep(Pseq([
				0,1,
			],inf),1),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,1,
			],inf),1),
			\octave, 5,
			\env1, Pseq([
				//[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				//[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,18 * Pseq([
				1,
				Pwhite(0.001,0.7,1),
				1,
				Pwhite(0.001,0.7,1),
				1,
				Pwhite(0.001,0.7,1),
				1,
				1,
			],inf),
			\fmr, Pseq([
				3.midiratio,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\adsr, Pseq([
				~pEnvadsr.(0.01,0.1,0.8, Pseg(Pseq([0.01,0.1,0.05,0.2],inf),8)),
			],inf),
			\legato, Pseq([
				0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\out, BusDef(\fxbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[203].value,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
			   	1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			   	1,0,1,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
			   	1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0.81,1,0.61,1, 1,0.61,1,0.71,
			],inf).coin.not,
			\isRest, Pseq([

			   	1,0,1,0, 1,0,1,0,
			   	1,0,1,0, 1,0,1,1,

			   	1,0,1,0, 1,0,1,0,
				0.81,1,0.61,1, 1,0.61,1,0.71,
			],inf).coin.not,
			\speed, 0.41 * Pseg(Pseq([2,1],inf),8),
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\fxrev, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[203].value,
			\isRest, Pseq([
				0,0.4,0, 0,0.13,0.41,0.14,0,
//				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, 0.41 * Pseg(Pseq([0.7,2,1],inf),8),
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\fxrev, \audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxrev, \audio),
			\verbmix, 0.4,
			\room, 0.7,
			\damp, 0.7,
			\mix, 0.861,
			\gain, 0.71,
			\dur, 2,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fxbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.05714285714286,
			'gain', 0.9344889782792,
			'fb', 0.00041099467303085,
			'delay', 0.0000011231 * Pseq([
				1,1/4,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono(\upy,
			\note, Pseq([
				0,1,
			],inf),
			\trigfreq, Pseq([4],inf)*~t,
			\lpenvamt, 3,
			\lpenv, Pseq([
				~pEnv.([0,1,0],[0.1, Pseg(Pseq([0,0.5],inf),32) ]),
			],inf),
			\octave, 5,
			\flfoamt,0.1,
			\fmamt, 0.01,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\upy,
			\note, Pseq([
				0,1,
			],inf),
			\trigfreq, Pseq([1,16*1],inf).stutter(1)*~t,
			//\trigfreq, Pseg(Pseq([1,30],inf),12),
			//\trigfreq, 1,
			\lpenvamt, Pseg(Pseq([1,3],inf),18),
			//\lpenvamt, 2,
			\flfoamt, Pseg(Pseq([0.01,0.11],inf),28),
			\flfoamt, 0.01,
			\fmamt, Pseg(Pseq([0.01,0.11],inf),14.23),
			\fmamt, 0.01,
			\dur, 1,
			\rq, Pseg(Pseq([0.54,0.1],inf),13.38),
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);



(
// trance doydoy on mixer0
	~master.();
	~durfun = { arg size=8;
		1/((1..8).keep(size).wchoose([1,1,0.14,1,0.07,0.15,0.07,1].keep(size).normalizeSum).debug("dur")*2)
	};
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\lag, 0.04,
			\out, BusDef(\mixer0, \audio),
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 4.1 + ~pmodenv.(Pseq([0,0.1,0.02],inf), 8),
				\legato, 0.9,
				\dur, 1/8,
				\speed, ~pmodenv.(Pseq([1,1.2,0.81],inf), 8),
				\gain, 1 * Pseq([
					Pwhite(0.01,0.71,1),1,
				],inf),
				\gain, 0.5,
			),
			Pbind(
				\instrument, \rhodey_sc,
				\mix, 0.2,
				\modIndex, 0.2,
				\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
				\lfoDepth, 1.4,
				\vel, Pgauss(0.8, 0.1, inf),
				\note, Pseq([
					-1,0,0,1,
					-1,0,0,1,
					-1,0,0,1,
					-1,-1,0,1,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					-6,-7,-8,-7, -6,-5,-4,-5,
				],inf).stutter(16),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \default,
				\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
				\dur, 1,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1533].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,

					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,1,1,0, 1,0,0,1,

					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,

					0,0,1,0, 0,0,1,0,
					0,0,1,0, 1,0,0,1,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,

					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,

					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.21,
			),
		]),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar([
			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[752 + rrand(0,10)].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.021,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1])*2),
				\dur, ~durfun.(),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07,
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16 ,

			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[742 + rrand(0,10)].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq({[
					0,0,1,0,
					1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,0,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.071,
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/(2**[0,1,2,3].choose),
				\dur, 1/((1..8).choose*2),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1].normalizeSum)*2),
				\dur, ~durfun.(4),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16 ,

			{Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq({[
					1,1,1,1, 1,0,0,1,
					1,1,0,1, 0,1,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 1,0,1,0,
				].clump(4)}.dup(8).flat,inf).coin.not,
				\sustain, 0.111 * rrand(0.1,1),
				\dur, Pwhite(1/16,1/4,inf),
				\dur, 1/Prand({2**[0,1,2,3,4,5].choose}.dup(2),inf),
				\dur, 1/(2**[0,1,2,3,4,5].choose),
				\dur, 1/((1..8).choose*2),
				\dur, 1/((1..8).wchoose([1,1,0.4,1,0.4,0.5,0.3,1].normalizeSum)*2),
				\dur, ~durfun.(6),
				\speed, ~pmodenv.(Pseq([Pwhite(0.8,1.2,1)],inf), Pwhite(1.0,8)),
				\gain, 0.07 * rrand(0.7,1),
				\gain, Pkey(\gain) * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
			)}!16
		].collect({ arg group;
			Ppar(group.collect({ arg pat;
				Pseq([
					Pbind(
						\isRest, Pswitch1([
							Pkey(\isRest),
							true,
						],Pstep( 
							Pseq([
								Pseq(8.collect { arg idx;
									Pseq([
										Pwrand([0,1],[idx+1*0.1,0.3].normalizeSum,1).stutter(6),
										Pn(0,2),
									],1);
								}),
								Pseq([
									Pwrand([0,1],[1,0.1].normalizeSum,1).stutter(6),
									Pn(0,2),
								],8),
							],inf),
							1/2
						)),
					) <>
					Pbind(
						//\lag,0.04,
						\out, BusDef(\sendbus3, \audio),
						//\legato, 1,
						\isRest, Pswitch1([
							Pkey(\isRest),
							true,
						],Pstep(
							Pseq([
								Pseq([
									Pseq([
										Pn(0,7), 
										Pwrand([
											Pn(0,1),
											Pn(1,1),
										],[0.4,1].normalizeSum,1),
									],3),
									Pn(0,6), 
									Pwrand([
										Pn(0,1),
										Pn(1,1),
									],[0.1,1].normalizeSum,2),
								],3),
								Pseq([
									Pn(0,7), 
									Pwrand([
										Pn(0,1),
										Pn(1,1),
									],[0.4,1].normalizeSum,1),
								],3),
								Pn(0,4), 
								Pwrand([
									Pn(0,1),
									Pn(1,1),
								],[0.1,1].normalizeSum,4),
							],inf),
							1/2
						)),
					),
				],inf) <> pat;

			}))
		})),
		
	])
)).play;
);

///////////////////////////

(
Pdef(\part, Pdef(\intro1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 4.1 + ~pmodenv.(Pseq([0,0.1,0.02],inf), 8),
			\legato, 0.9,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,1.2,0.81],inf), 8),
			\gain, 1 * Pseq([
				Pwhite(0.01,0.71,1),1,
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \rhodey_sc,
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
			\lfoDepth, 1.4,
			\vel, Pgauss(0.8, 0.1, inf),
			\note, Pseq([
				-1,0,0,1,
				-1,0,0,1,
				-1,0,0,1,
				-1,-1,0,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-6,-7,-8,-7, -6,-5,-4,-5,
			],inf).stutter(16),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \rhodey_sc,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, 10.2,
			\lfoDepth, 4.4,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \pwbass,
			\note, Pseq([
				\r,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[843].value,
			\isRest, Pseq([
				1,1,1,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[742].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pbind(
			\instrument, \rhodey_sc,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\mix, 0.2,
			\modIndex, ~pmodenv.(Pseq([0.1,2,1,4],inf), 13.8),
			\lfoSpeed, ~pmodenv.(Pseq([1/2,10],inf), 12.7),
			\lfoDepth, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 4.1 + ~pmodenv.(Pseq([0,0.1,0.02],inf), 8),
			\legato, 0.9,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,1.2,0.81],inf), 8),
			\gain, 1 * Pseq([
				Pwhite(0.01,0.71,1),1,
			],inf),
		),
		Pbind(
			\instrument, \rhodey_sc,
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
			\lfoDepth, 1.4,
			\vel, Pgauss(0.8, 0.1, inf),
			\note, Pseq([
				-1,0,0,1,
				-1,0,0,1,
				-1,0,0,1,
				-1,-1,0,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-6,-7,-8,-7, -6,-5,-4,-5,
			],inf).stutter(16),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pwbass,
			\note, Pseq([
				\r,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[843].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[742].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			//\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\fxstut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\fxstut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				1,1,0,0,
				0,0,1,1,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\rate, 1,
			//\rate, ~pmodenv.(Pseq([1,1/2],inf), 8),
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, ~pmodenv.(1/1/~t /Pseq([2,4],inf), 1/4),
			\time, ~pmodenv.(1/16/~t /Pseq([2,4,1/16,1],inf), 1/4),
			\time, 1/16/~t / Pseq([1,2,3,4],inf),
			\dur, Pser([1/16],inf),
			\amp, 0.1,
		),
		Pbind(
			\out, BusDef(\fxstut, \audio),
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 4.1 + ~pmodenv.(Pseq([0,0.1,0.02],inf), 8),
			\legato, 0.9,
			\dur, 1/8,
			\speed, ~pmodenv.(Pseq([1,1.2,0.81],inf), 8),
			\gain, 1 * Pseq([
				Pwhite(0.01,0.71,1),1,
			],inf),
		),
		Pbind(
			\instrument, \rhodey_sc,
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
			\lfoDepth, 1.4,
			\vel, Pgauss(0.8, 0.1, inf),
			\note, Pseq([
				-1,0,0,1,
				-1,0,0,1,
				-1,0,0,1,
				-1,-1,0,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-6,-7,-8,-7, -6,-5,-4,-5,
			],inf).stutter(16),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pwbass,
			\note, Pseq([
				\r,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\out, BusDef(\fxstut, \audio),
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\out, BusDef(\fxstut, \audio),
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		
	])
)).play;
);


(
// drum stutter test
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1424].value,
			\trigfreq, Pseq([
				1,1,1,1,
				//1,30,40,21,
			],inf).stutter(2),
			\out, BusDef(\fxstut, \audio),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\fxstut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t / Pseq([1,2,3,4],inf),
			\time, ~pmodenv.(1/16/~t /Pseq([2,4],inf), 1/4),
			\time, ~pmodenv.(1/4/~t /Pseq([2,4],inf), 1/4),
			\dur, Pser([1/8],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

	~master.();
(
// sidechain kick into rdn4 with max distort to create bouncing texture
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(\out, BusDef(\sendbus4, \audio)) <>
		Ppar([
			Pbind(
				\isRest, Pswitch1(
					[
						true,
						Pkeyd(\isRest,false),
					], 
					Pstep(Pseq([Pn(1,6),Pn(0,2)],inf),1)
				),
				\isRest, Pkey(\isRest),
			) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('smp/buffyvoice.flac'),
					\pos, 1.4 + Pseg(Pseq([0,1],inf),4*8),
					\dur, 1/2,
					\legato, 1,
					\speed, 0.71,
					\gain, 1.8,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[524].value,
					\isRest, Pseq([
						0,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.21,
				),
				Pbind(
					\instrument, \default,
					\note, Pseq([
						10,2,10,3,
					],inf),
					\legato, 0.1,
					\octave, 5,
					\dur, Pwhite(1/8,1,inf),
					\dur, 1/8,
					\amp, 0.1/4,
					\isRest, true,
				),
			]),
			Psched ([7,8],
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('smp/buffyvoice.flac'),
					\pos, 7.4,
					\dur, 2,
					\legato, 1,
					\speed, 1.11,
					\gain, 1.8,
				),
			).loop,
		]),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[843].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[742].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
			\out, BusDef(\mixer3, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\equi, \audio),
		),
		ProtoDef(\equi).asPattern,
	])
)).play;
);


(
// doydoy hiphop
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1406].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1890].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31 * Pseq([
				Pwhite(0.01,0.7,1), 1,
				Pexprand(0.01,0.7,1), 1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1580].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \rhodey_sc,
			\mix, 0.2,
			\modIndex, 0.2,
			\lfoSpeed, ~pmodenv.(Pseq([2,0.1],inf), 8),
			\lfoDepth, 1.4,
			\vel, Pgauss(0.8, 0.1, inf),
			\note, Pseq([
				-1,0,0,1,
				-1,0,0,1,
				-1,0,0,1,
				-1,-1,0,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-6,-7,-8,-7, -6,-5,-4,-5,
			],inf).stutter(16),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,1,2,1]*1000,inf), 1),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pwbass,
			\note, Pseq([
				\r,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[843].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		
	])
)).play;
);


ProtoDef(\equi, ProtoTemplateDef(\Equi));
ProtoDef(\equi).edit
ProtoDef(\equi).inbus = BusDef(\equi, \audio, 2)


(
SynthDef(\nitpik, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
