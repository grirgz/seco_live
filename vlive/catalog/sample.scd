//// techniques
// - basic sampling: start + sustain, speed (constant duration)
// - slice sampling: start + end, speed (always reach end and can start from end in reverse)
// - oscsampling + posenv
// - granulation

// options:
// - specify position (and Phaser): BufRd
// - specify rate: BufPlay
// - keep sample panning or sum + custom pan
// - hpf + lpf
// - fixed sustain: use another key for sustain to allow timeline no caring about sustain
// - startpos in seconds or normalized

// fx:
// - freqshift
// - am
// - ring






//////////////////////////////

SynthDef(\recorder, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum;
	var sig;
	var sig1;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig.poll;
	sig1 = EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:0);
	RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:\prelevel.kr(0), run:1, loop:0, trigger:1, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\player, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1;
	var sig;
	var sig1;
	// pos from 0 to 1
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.01),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig * \gain.kr(1));
}).add;
SynthDef(\playerbeat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig * \gain.kr(1));
}).add;
SynthDef(\playerpansec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;

SynthDef(\playersec_hlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = LPF.ar(sig, \lpf.kr(19000));
	sig = HPF.ar(sig, \hpf.kr(40));
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\playersec_hlpf);

// fm + shift with lfo
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

/////////////////////

SynthDef(\playersec_looper, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.kr(\trigfreq.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;

(
	~t = 185/1/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef(\amen),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(185/60),
			\speed, 1,
			\legato, 1,
			\gain, 1/4,
			\amp, 0.1
	) <>
	Pseq([
		Pbind(
			\pos, Pseq([0],2)/( 137/60 ),
			\dur, 2,
		),
		Pfindur(4,Pbind(
			\pos, Pseq([2],inf)*( 137/60 )+0.04,
			\trigfreq, Prand([
				1,2,4,8,16,32,64,
				1/16, 1/16, 1/16, 1/16, 1/16,
			],inf)/8*~t,
			\dur, PdurStutter(Prand([1,2,4],inf), 1),
		)),
	],inf),
).play;
);

/////////////////////////////////////////

(
Pdef(\sample, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
			],inf),
			\gain, 0.5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_fx,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf) +0.3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,1,1,1, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\speed, 4.0,
			\gain, 0.2,
			\dur, 1/16,
			\amp, 0.1,
		),
	])
).play;
)
//////////////////////////////////////////////
// use the sampler as an oscillator with pmodenv to modulate position

SynthDef(\playersec_osc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec_osczig, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	var speedtrigger = Impulse.ar(\trigfreq.kr*2);
	speed = speed * Demand.ar(speedtrigger, 0, Dseq([
		1,-1,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)


(
Pdef(\glitch, 
	Ppar([
		Pbind(
			\instrument, \playersec_osczig,
			\trigfreq, 400 * 1/8 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, ~pmodenv.(Pseq([0.1,1,0.1,2]/4,inf), 8)+0.3,
			\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\lpfr, 8,
			\legato, 1,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('voices/feynman.flac'),
			\freq, 200,
			\dur, 1/2,
			\gain, 30,
			\gain, 1/2,
			\amp, 0.1,
		);
		
	])
).play;
)

////////////
// hear the sampled voice pitched

(
SynthDef(\playersec_osczig_stereo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	var speedtrigger = Impulse.ar(\trigfreq.kr*2);
	speed = speed * Demand.ar(speedtrigger, 0, Dseq([
		1,-1,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos+[0,0.01]*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig.debug("sig");
	sig = sig.flop.sum.debug("sig");
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)


(
Pdef(\glitch, 
	Ppar([
		Pbind(
			\instrument, \playersec_osczig_stereo,
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 1),
			\pos, ~pmodenv.(Pseq([0.1,4,0.1,2]/4,inf), 1)+2.0,
			\lpfr, 8,
			\legato, 1,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\freq, 200,
			\dur, 1/2,
			\gain, 30,
			\gain, 1/2,
			\amp, 0.1,
		);
		
	])
).play;
)

///////////////////////////////////////////

SynthDef(\oscsampler3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;

(
~buf = BufDef(\moeten, "voices/02_moeten.flac");
~t = ~t ?? {  165/2/60 }; TempoClock.default.tempo = ~t;
Ndef(\lfo1).quant = Pdef.defaultQuant;
Ndef(\lfo3).quant = Pdef.defaultQuant;

Ndef(\lfo1, { arg freq=1; SinOsc.kr(freq * ~t).range(50,7500).lag(0.051)});
Ndef(\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\dur, 1/1,
));
Ndef(\lfo3, { arg freq=20; freq.lag(0.401).round(0.1) * SinOsc.kr(1/16*~t).range(0.5,1.5).round(0.1)});
Ndef(\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		2,2,2,2,
		2,4,4,6,
		2,2,2,2,
		2,4,4,6,
	]*250,inf),
	\dur, 1,
));

Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3,
		\freq, 700,
		\pos, 0.012,
		\fshift, -148,
		\lpmix, 0.01,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\levelScale, 8,
		\timeScale, 1,
		\range, 0.0001,
		\ffreq, Ndef(\lfo1),
		\freq, Ndef(\lfo3).bus.asMap,
		\bufnum, ~buf,
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.21) ],
		],inf),
		\legato, 4.0,
		\dur, 1/4,
		\isRest, Pseq([
			1,0,0,0,
			0,0,0,0,
		],inf).coin.not,
		\amp, 1 * Pkey(\amp),
	)
).play

)

(
Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.012,
		//\fshift, -148,
		\lpmix, 0.41,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.0002,0.0011].integrate.postln,[0.12,8.4]) ],
		],inf),
		\pos, 0.1,
		\levelScale, 8,
		\timeScale, 2,
		\range, 0.0001,
		\ffreq, 100,
		\note, Pseq([
			0,3,5,
		],inf).stutter(8),
		\octave, 3,
		\bufnum, BufDef('voices/feynman.flac'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.21) ],
		],inf),
		\legato, 8.0,
		\dur, 1/4,
		\isRest, Pseq([
			1,0,0,0,
			0,0,0,0,
		],inf).coin.not,
		\amp, 1 * Pkey(\amp),
	)
).play
)


//////

(
SynthDef(\oscsampler3b, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*\harmtab.kr([1.001,0.999,1]));
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
)

Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3b,
		\pos, 0.012,
		//\fshift, -148,
		//\fshift, 100,
		\lpmix, 0.41,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.000001,0.0001].integrate.postln,[0.02,8.4]) ],
		],inf),
		\harmtab, Pseq([
			[ [1,1.01,1.001] ],
			[ [1.0001,1,1.00001] ],
			[ [1.011,1,0.991] ],
			[ [1,2,3] ],
		],inf).stutter(8),
		\pos, 0.42,
		\levelScale, 8,
		\timeScale, 2,
		\range, 0.0001,
		\ffreq, 1000,
		\note, Pseq([
			0,3,5,
		],inf).stutter(8),
		\octave, 3,
		\bufnum, BufDef('voices/feynman.flac'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,1.91) ],
		],inf),
		\legato, 5.0,
		\dur, 1/4,
		\isRest, Pseq([
			1,0,0,0,
			0,0,0,0,
		],inf).coin.not,
		\amp, 1 * Pkey(\amp),
	)
).play

//////
(
SynthDef(\oscsampler3c, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*\harmtab.kr([1.001,0.999,1]));
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	bufsig = Compander.ar(bufsig, bufsig, \cpt.kr(0.4), \cpbelow.kr(0.50), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
)
(
Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3c,
		\pos, 0.012,
		\fshift, -148,
		//\fshift, 100,
		\lpmix, 0.81,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.0005100,0.001].integrate.postln,[0.02,8.4]) ],
		],inf),
		\harmtab, Pseq([
			//[ [1,1.01,1.001] ],
			//[ [1.000001,1,1.00001] ],
			//[ [1.011,1,0.991] ],
			[ [1,2,3] ],
			[ [1,4/3,3] ],
		],inf).stutter(8),
		\pos, Pseg(Pseq([0,1],inf),32),
		\levelScale, 8,
		\timeScale, 1.5,
		\range, 0.0001,
		\ffreq, 5000,
		\freq, Pexprand(60.0,1400),
		\freq, Pbrown(60,100,1),
		\octave, 3,
		\bufnum, BufDef('voices/feynman.flac'),
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.1) ],
		],inf),
		\legato, 1.0,
		\dur, 1/4,
		\legato, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf)*0.1,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\amp, Pseq([
			1,0.5,0.7,0.2,
		],inf) + Pwhite(-1.0,1)/2 * 0.1,
		\amp, 1 * Pkey(\amp),
	)
).play
)

//////
(
SynthDef(\oscsampler3d, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,4,0.9,1],[0.1,0.1,0.8]), gate);
	osc = SinOsc.ar(freq*\harmtab.kr([1.001,0.999,1]));
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	bufsig = Compander.ar(bufsig, bufsig, \cpt.kr(0.4), \cpbelow.kr(0.50), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (freq * \lpfr.kr(1) * ffreqtab * env1).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
)
/////////////////////////////////////////////



(
~buf = BufDef(\crepe, "field/crepe.flac");

Pdef(\sample,
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.208,
		\freq, 187,
		\range, 0.00001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,0.1]) ],
			[ Env([0.00,0.01,0.012].integrate.postln,[0.21,0.4]) ],
		],inf),
		\finepos, 4/400,
		\legato, Pseq([
			0,0,0,0,
			1,1,0,1,
			0,0,1,0,
			1,0,1,0,
		],inf).linlin(0,1,0.5,4)/2,
		//\legato, 1,
		\dur, 1/3 * 1/2,
		\fshift, 400,
		\lpmix, 1,
		\rq, 0.1,
		\hpmix, 0,
		\hpfreq, 100,
		\isRest, Pseq([
			1,0,0,
			1,0.5,0,
			1,1,1,
			1,0,1,
		],inf).coin.not,
		\ffreq, Pseq([
			1000,5000,150,500,
		],inf) * Pseq([1,2,1/2],inf).stutter(4),
		\amp, 0.2,
		\bufnum, ~buf,

	) 
).play;
)

(
	// loop
Pdef(\sample, Pdef(\zed, 
	Ppar([
		
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 4/400,
		\legato, Pseq([
			2,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4),
		\amp, 0.1,
			\bufnum, BufDef('voices/feynman.flac'),

	) 
	])
)).play;
)

(
	// perc
Pdef(\sample, Pdef(\zed, 
	Ppar([
		
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([
			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4),
		\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

	) 
	])
)).play;
)
//////////////////////////////////////////


(
Ndef(\sample, { arg amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1;
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1/4*~t,pi).range(0,1) * 0.04 + 0.11;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou1 = HPF.ar(ou, 7000);
	//ou1 = ou;
	ou2 = LPF.ar(ou, 200);
	ou = ou1 + ou2;
	ou = Splay.ar(ou, 1, amp);
}).play;
);

/////////////////////////////////////////////////////////
// famous strange perc noise


		(
		Pdef(\sample, Pbind(
			\instrument, \oscsampler3,
			\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
			\pos, 0.577,
			\freq, 187,
			\range, 0.0000001,
			\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
			\posenv, Prand([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.00011,0.01011].integrate.postln,[0.01,2.4]) ],
				[ Env([0.00,0.00011,0.01111].integrate.postln,[0.01,2.4]) ],
				[ Env([0.00,0.00011,0.01051].integrate.postln,[0.02,2.4]) ],
			],inf).stutter(2),
			\legato, 0.2,
			\dur, 1,
			\isRest, false,
			\adsr, Pseq([
				Pwrand([
					[ Env.adsr(0.01,0.3,0.5,0.9) ],
					[ Env.adsr(0.01,0.3,0.5,0.19) ],
					[ Env.adsr(0.01,0.3,0.5,0.29) ],
					[ Env.adsr(0.01,0.3,0.5,0.49) ],
				], [2,0.1,0.1,0.1].normalizeSum),
			],inf),
			\bufnum, BufDef(\table, "field/table.flac"),
			\rq, 0.1,
			\fshift, Pwrand([0,-400,-300,200],[1.90, 0.1,0.1,0.1].normalizeSum,inf),
			\lpmix, 1,
			\ffreq, 200 + Pwhite(0.0,100),
			\amp, 89.0 * Pkey(\amp),

		)).play	 
		)

///////////////////////////
/// racle perc 

(

~buf = BufDef(\crepe, "field/crepe.flac");
	Pdef(\sample, Pbind(
		\instrument, \oscsampler3,
		\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
		\pos, 0.44474474474474 + Pwhite(0,0.0001),
		\freq, 187,
		\range, 0.0000001,
		\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
			Pseq([
				[ Env([0.00,0.00111,0.00011].integrate.postln,[0.01,0.4]) ],
				[ Env([0.00,0.00211,0.00011].integrate.postln,[0.01,0.4]) ],
			],4),
			Pseq([
				[ Env([0.00,0.00121,0.00011].integrate.postln,[0.01,0.4]) ],
				[ Env([0.00,0.00151,0.00015].integrate.postln,[0.04,0.4]) ],
			],4),
		],inf).stutter(2),
		\legato, 1.0,
		\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
		\isRest, false,
		\adsr, Pseq([
			[ Env.adsr(0.0001,0.3,0.5,0.11) ],
		],inf),
			\bufnum, ~buf,
		\rq, 0.3,
		\fshift, 0,
		\lpmix, 0.81,
		\ffreq, 8800,
		\hpmix, 0.9,
		\hpfreq, Pseq([1,100,200,500,1,1000],inf).stutter(4),
		\amp, 1.1,
	)).play;
)


/////////////////////////


(
Pdef(\rand, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('loop/clean7_135bpm.flac'),
	\pos, Pwhite(0,2.0),
	\speed, Pseg(Pseq([0,4],inf),8),
	\pos, Pseg(Pseq([0,1,1/4],inf),1),
	\dur, 1/16,
	\amp, 0.1,
)).play;
);

///////////////////////// like a scratch which start the sample
(
SynthDef(\playersec_zix2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	speed = speed * EnvGen.kr(Env([0.21,1,1],[0.12,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = FreqShift.ar(LPF.ar(sig, 4000), 2300) + HPF.ar(sig, 4000);
	sig = HPF.ar(sig, 6000)*18;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)


////////////////////////////::
/////// granulation


(
SynthDef(\simplegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)
BufDef.mono('voices/feynman.flac').play
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,1.4]+0.4,1), 1/2),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/2),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, 2,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4],1), 8*8),
				~pmodenv.(Pseq([1,1.4]+0.4,1), 1/2),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/2),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,3],
				[0,4],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

///////////////////////////////////


(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('fix4/snare1.flac'),
			\bufnum, BufDef.stereo(\ukraine, "bruit1/07_ukraine.flac"),
			\speed, 1.031 * Pseq([
				1,
			],inf),
			\pos, Pseq([
				4,2,5
			],inf),
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, Pn(1/2,inf),
			\gain, 2,
			\out, BusDef(\smpbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus3),
			\time, 1/16/~t * Pseq([1],inf).stutter(2),
			\mix, Pseq([
				0,1,0,1, 1,0,1,1,
				1,0,1,0, 1,1,0,1,
			],inf),
			\dur, 1/8,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\speed, 2.031 * Pseq([
				1,0.7,1.2,0.5,
			],inf),
			\pos, Pseq([
				0,1,2,2,
				0.1,1,2,2.4,
				0,1,2,2,
				0,1/2,5,3,
			],inf),
			\isRest, Pseq([
				1,0,1,0,
				1,1,1,1,
			],inf).coin.not,
			\dur, Pn(1/2,inf),
			\gain, 1/2,
			\out, BusDef(\smpbus2, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus2),
			\time, 1/16/~t,
			\mix, Pseq([
				0,1,0,1,
				0,1,1,1,
			],inf),
			\dur, 1/8,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\speed, 1.031,
			\pos, Pseq([
				0,1,2,2,
				0.1,1,2,2.4,
			],inf),
			\dur, Pn(1/2,inf),
			\gain, 1/2,
			\out, BusDef(\smpbus, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus),
			\time, 1/16/~t,
			\mix, Pseq([
				0,0,1,1,
				0,1,0,1,
			],inf),
			\dur, 1/8,
		),
	])
)).play;
)

////////////////// vocoder with grains




(
	// from cave45
SynthDef(\gregrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,1,10],1), 2).loop,
			\gdur, 0.1,
			\note, Pseq([
				0,4,2,
			],inf),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/80,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 4,
			\legato, 1,
			\dur, 1/2,
			\gain, 1.3,
		)
		
	])
)).play;
);

(
SynthDef(\gregrain_pan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/80,1) + Pwhite(0.01,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 4,
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 5,
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/2,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 6,
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/1,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 3,
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 3,
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/80,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 4,
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\legato, 0.3,
			\dur, 1/6,
			\amp, 0.1/2 * Pseq([1,0.2],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				3,0,5,
			],inf),1),
			\octave, 3,
			\legato, 0.9,
			\dur, 1/8,
			\amp, 0.1 * Pseq([1,0.2,0.4,0.2],inf),
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Ptuple  (
				[
				~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
				~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
				]
			),
			\gdur, Ptuple  (
				[
				~pmodenv.(Pseq([10,1,0,2,10]/180,1) , 3).loop,
				~pmodenv.(Pseq([0,5,10]/180,1) , 8).loop,
				]
			),
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, Ptuple(Prand([4,5,6],inf).stutter(Prand([1,2,3,4],inf))!2),
			\pan, [-1,1],
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1)-
				Pseq([
					[0,12,5],
					[0,12,6],
					[0,12,7],
				],inf),
			\octave, 6,
			\legato,  Ptuple(
				Pwhite(0.3,1)!2
			),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);


///////////////////////// auto breakbeat loop
~t = 165/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.5,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 136/4/60,
			\speed, 1/Pseq([8,1,2,2,1,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					1, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				Plazy({ arg ev;
					var seq;
					Pseq([
						seq = Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),
						Pseq([
							1,1,1,1, 1,1,0,0,
						].scramble,1),
						seq,

						Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),


						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					],1);
				}).loop,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([1,2,8,2,4],inf), 1/4),
			\gain, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1119].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([2,1,1/2,1],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 2,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([2,8,1,1,1,1,8],inf), 1/2),
			\gain, 0.5,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1119].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([
					1,1,1,1,
					1,2,2,2,
					1,1,1,4,
					4,1,1,1,
					1,1,2,1,
					1,4,2,1,
				1,2,4,1,
				1/2,1,1/2,1,
			],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 1,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					1, 2,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([
				Pseq([4,1],8),
				2,8,1,1, 1,1,1,8,
			],inf), 1/2),
			\gain, 0.5,
		),
	])
)).play;
);

///////// new kind of oscsampler


(
SynthDef(\oscsmp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var osc;
	var phase;
	var posenv;
	osc = SinOsc.ar(freq) *  \oscrange.kr(1);
	posenv = EnvGen.kr(\posenv.kr(Env([0,1,1.1,0],[0.1,1,2.8])), 1, levelScale:\levelScale.kr(1));
	phase = \pos.kr(0) + posenv * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase + osc % BufFrames.kr(bufnum), 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 160,
			\legato, 1,
			\dur, 4,
			\amp, 0.4,
		),
		
	])
)).play;
);
