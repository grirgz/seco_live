(
SynthDef(\basicbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig.debug("basicbas");
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
)

//////////// simple pulse bass
// stereo by detune
// mono synth with octave jump, glissando and legato
(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	sig = Pulse.ar(freq * [1,1.0001]);
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2,1), 8).loop,
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);


////////// add cutoff env, much better!

(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
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

////////////// change waveform with env

(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = Saw.ar(freq * [1,1.0001]);
	sig1 = Pulse.ar(freq* [1,1.0001]);
	sig = SelectX.ar(env2, [sig1, sig]);
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
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

////////////// add high frequencies with a distorted BPF, adjust high freq with LPF, add env to dynamize
// the BPF is multichannel with offset from pitch

(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([0,1,0,1],[0.01,0.18,0.18]), \trigx.tr(1));
	sig = Saw.ar(freq * [1,1.0001]);
	sig1 = Pulse.ar(freq* [1,1.0001]);
	sig = SelectX.ar(env2, [sig1, sig]);

	sig1 = sig;
	sig1 = BPF.ar(sig1, freq+( [100,300,200]/8 * env3 )*2 * [ [1,1.001] ],0.1).sum;
	sig1 = ( sig1 * 100 ).clip2(1)/2;
	sig1 = LPF.ar(sig1, 7000);


	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig + sig1 / 2;


	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
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

/////////////////////////////////////////////////////// start again
////////////// AM applied by env
(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.4,1.1]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,2,2],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig = sig * SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
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

/////////////////////////////////////////////////////// 
//////////////  lfo folding with env
(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.2,1.4]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,0,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig * sig1;
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);

	sig1 = SinOsc.ar(2*~t).exprange(0.1,1);
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig/4 + LPF.ar(sig.fold2( sig1 ), 10000);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
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


///////////////////////////////////////////////////

(
SynthDef(\swirl, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr( Env([1,2,1,1/2],[0.1,0.1,1.8]) ), 1);
	env2 = EnvGen.kr(\env2.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env3 = EnvGen.kr(\env3.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env4 = EnvGen.kr(\env4.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env5 = EnvGen.kr(\env5.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	freq = freq * env5;
	//sig = Pulse.ar(freq * ( 1 + ( SinOsc.ar((1..8) * env1) * (1..8) * env1 ))).mean;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar((1..8) * env4) * (1..8)*\fmamp.kr(1/2) * env1 ))).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(2.1) * freq * env3 ).clip(20,20000), \rq.kr(0.5));
	sig = sig + FreqShift.ar(sig, 0.1 * SinOsc.kr(1 * env2).range(0,100));
	sig = ( sig * env2 * 2).tanh /2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \swirl,
			\freq, 200,
			\env1, [ Env([1,1,1,1]/175,[0.01,0.44,0.1]) ],
			\env2, [ Env([1,1,1,1],[0.2,0.1,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.1,0.1]) ],
			\env4, [ Env([1,1,1,1]*2,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1/2,2,1]/2,[0.2,0.1,0.1]) ],
			\dur, 1/4,
			\fmamp, 1,
			\legato, Pseq([
				3,0,0,0, 0,0,1,0,
				6,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.2
		),
	]),
).play;
)

//////////////////////// FMGrain


(
SynthDef(\fm_grain_test, {arg out=0, gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(\grainfreq.kr(200)), 0.14, freq, freq*fratio,
		LFNoise1.ar(\grainindexfreq.kr(500)!2).range(1, 10),
	);
	sig = sig * EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		doneAction: 2
	);
	sig = sig / 4;
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(out, sig);
}).add;
SynthDef(\fm_grain2, {arg out=0, gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(\grainfreq.kr(200)), 0.14, freq, freq*fratio,
		\grainindex.kr(1)*[1,1.001]
	);
	sig = sig * EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		doneAction: 2
	);
	sig = sig / 4;
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(out, sig);
}).add;
)

(
Pdef(\demo, Pbind(
	\instrument, \fm_grain_test,
	\fratio, Pseq([1,2,3/2,1.21314],inf),
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\demo, Pbind(
	\instrument, \fm_grain_test,
	\fratio, Pseq([1,2,3/2,1.21314],inf),
	\degree, Pseq([0,2],inf),
	\grainfreq, ~pmodenv.(Pseq([1,20,100,400],inf), 8),
	\grainindexfreq, Pseq([
		500,0.1,
	],inf).stutter(16),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\demo, Pbind(
	\instrument, \fm_grain2,
	\fratio, Pseq([1.21314],inf),
	\degree, Pseq([0,2],inf),
	//\grainfreq, ~pmodenv.(Pseq([1,20,100,400],inf), 8),
	\grainfreq, 100,
	\grainindex, 1,
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);



(
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				3,\r,2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			//\out, BusDef(\sendbus1, \audio),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/8
		),
	])
).play;
)


/////////////////////////////////////////////
// crepuscule


(
Ndef(\crepufx, { arg amp=0.5, pan=0, freq=200, mbufnum,
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
	var pwidth;
	var pfreq;

	[~t,128/60].debug("tempo");
	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1;
	time_stretch = Duty.kr(1/2/~t,0,Dseq([
		1,2,0.1,0.1,
	],inf)).lag(0.1);
	pitch_stretch = Duty.kr(1/4/~t,0,Dseq([
		1,0.7,0.1,1,
	],inf)).lag(0.01);
	pos = 0.11;
	trate = 210;
	//pos = SinOsc.kr(1/64*~t).range(0,0.01) + pos;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(TDuty.kr(4/~t), time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);


	ou = LFSaw.ar(
		Duty.kr(1/1/~t, 0, Dseq([
			60,60, 60,80,
		],inf) 	
	) * [1,4.001,0.99,4.01]
	);
	pwidth = Duty.kr(1/2/~t, 0, Dseq([
		0.8,0.4,0.8,0.2,
	],inf)).lag(4);
	pfreq = Duty.kr(1/2/~t, 0, Dseq([
		780
	],inf));
	ou = ou * LFPulse.ar(pfreq ,0,pwidth);
	ou1 = HPF.ar(ou, 100 * SinOsc.kr(1/52*~t).range(0.5,3.1));
	//ou1 = ou;
	ou1 = RLPF.ar(ou1, 
		320 * Duty.kr(
			Dseq([
				1/2,
			]/4,inf)/~t, 0, Dseq([
			1,1,1,1,
			1,1,1,1,
			4,4,4,4,
			1,1,1,1,

			2,1,2,1,
			1,4,1,1,
			4,4,4,4,
			1,1,1,1,
		],inf)).lag(0.1),
		0.1 * Duty.kr(Dseq([
				0.5,
			]/4,inf)/~t, 0, Dseq([
			1,4,3,4,
			4,4.64,1,6,
		],inf)).lag(0.1),
	);
	ou2 = LPF.ar(ou1, 800) + DelayL.ar((ou1/4),0.1,0.001+[
		Duty.kr(1/~t, 0, Dseq([
			1,0,0,0,
		],inf))/100,
		Duty.kr(1/~t, 0, Dseq([
			0,1,0,2,
		],inf))/100,
	]);
	ou = ou1;
	amp = amp * Duty.kr(1/4/~t, 0, Dseq([
		1, 1, 1, 1,
	],inf)).lag(0.1);
	ou = ou * amp / 2;

	//ou = CombL.ar(ou, 2, 1/2/~t,1/2/~t)/2 + ou;
	//ou = CombL.ar(ou, 2, 1/2/~t,1/~t) * Duty.kr(1/~t, 0, Dseq([
	//	1,0.7,0.8,0.7,
	//],inf)) + ou;

	ou = Splay.ar(ou, 1);
}).play;
);


//////////////////////////////////////////////

// kick bass

(
SynthDef(\kickbass, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env2, env3, env4;
	var distlim = 1;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = 1 + ([1,0,-1] * freqpan);
	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son1 = LFSaw.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son2 = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son3 = SinOsc.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = SelectX.ar(\oscmix.kr(0.5)*2, [son1, son2, son3]);
	son = son + WhiteNoise.ar(1);
	env2 = \env2.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	//env3 = EnvGen.ar(\env3.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.41], [-4, -2, -4])),timeScale:timeScale,doneAction:2);
	env3 = EnvGen.ar(\env3.kr(Env([0, 1, 0.5, 0], [0.105, 0.016, 00.011], [-4, -2, -4])),timeScale:timeScale,doneAction:0);
	son = LPF.ar(son, env1m*fratio) * env3;

	son1 = LFSaw.ar(env1m);
	son1 = RLPF.ar(son1, env1m * \fratio1.kr(1));
	son2 = LFPulse.ar(env1m);
	son2 = RLPF.ar(son2, env1m * \fratio2.kr(1));
	son3 = SinOsc.ar(env1m,0.5);
	sig1 = SelectX.ar(\osc2mix.kr(0.999)*2, [son1, son2, son3]);
	sig1 = sig1 * env0;
	son = son + sig1;
	
	son = son * 1.2;
	sig = son;
	distlim = \distlim.kr(0.1);
	sig1 = sig.clip2(distlim);
	sig2 = sig.distort(distlim);
	sig3 = sig.tanh(distlim);
	sig4 = sig.wrap2(distlim);
	sig5 = sig.fold2(distlim);
	sig = SelectX.ar(\distmix.kr(0.5)*4, [sig1, sig2, sig3, sig4, sig5]);

	sig = sig / 1;

	sig = Splay.ar(sig, spread, amp, pan);
	
	
	OffsetOut.ar(out, sig);
}).add;

Pdef(\demo, Pbind(
	\instrument, \kickbass,
	\amp, 0.1,
	\env0, [ Env.new([0.5, 4, 1.5, 0], [0.105, 0.46, 1.4], [-4, -2, 4]) ],
	\env1, [ Env.new([110, 36, 30.cpsmidi], [0.015, 0.29], [-4, -5]) ],
	\env3, Env([0, 1, 0.5, 0], [0.105, 0.016, 00.411], [-4, -2, -4]),
	\timeScale, 1,

	\freqpan, 0.001,
	\oscmix, 0.4,
	\osc2mix, 0.4,
	\fratio1, 4.5,
	\fratio2, 4,
	\distlim, 0.9,
	\distmix, 1.5,
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([
		0.21,0.52,
		0.21,0.72,
		0.31,0.52,
		0.11,0.72,
	],inf).stutter(8),
	\dur, 1/8,
	\isRest, Pseq([
		Pser([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],inf),
	],inf).coin.not,
)).play;
)

///////////////////////////////////////////
// simple bass



(
SynthDef(\simplebass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);

	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\demo, Pbind(
	\instrument, \simplebass,
	\degree, Pseq([0,2b,4,-4],inf),
	\lpf, 200,
	\octave, 3,
	\dur, 1,
	\amp, 0.1,
)).play;
);

//////////////////////////////////////////////
// shift bass
(
Ndef(\shiftbass).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5, seq6;
	var dscale = 4/~t;
	seq1 = Duty.ar(1/2*dscale, 0, Dseq([
		4,8,4,4, 1,8,1,8,
	]*~t,inf));
	seq2 = Duty.ar(1*dscale, 0, Dseq([80,50],inf)).lag(0.1);
	seq3 = Duty.ar(1/4*dscale, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						0,
						7,
						-4,
						7,
				],inf).stutter(2) 
				+ Pseq([
					0,5,1,6,
				]).stutter(16)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/4*dscale, 0, Dseq([
		1,2,1,4,
		1,1,2,2,

		1,2,1,4,
		1,4,1,2,

		1,2,1,4,
		1,1,2,2,

		1,1/2,4,1,
		1,1,2,2,
	],inf)).lag(0.1);
	seq5 = Duty.ar(1/2*dscale, 0, Dseq([
		1,1/2,4,1,
	]*~t,inf));
	sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig = sig * SinOsc.ar(seq1);
	sig1 = LPF.ar(sig, 100);
	sig1 = FreqShift.ar(sig1, seq3.lag(0.4)*seq4) + sig1;
	sig2 = HPF.ar(sig, 100);
	sig2 = RLPF.ar(sig, LFPulse.ar(seq1).range(100,1000));

	sig = sig2 + sig1;

	sig1 = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)], mul: SinOsc.kr(seq5).unipolar);
	sig1 = RLPF.ar(sig1, LFPulse.ar(seq5).range(100,2000));
	sig1 = sig1 / 1.3;
	sig = sig + sig1;
	//sig2 = FreqShift.ar(sig1, seq2);
	sig = Pan2.ar(sig, pan, amp).sum;


}).play;
)


///////////////////////////////////


(
SynthDef(\distbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\demo, Pmono(\distbass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
)).play;
)

////////////////////////////////////////////


(
SynthDef(\delbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq);
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig2 = RLPF.ar(sig, \lpfr2.kr(1.1) * freq, \rq2.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1, sig2]);

	thisThread.randSeed = 123133;
	
	sig1 = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.7) * 100 ) + sig;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01) * \delay1.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay2.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp2.kr(10) ).tanh * \distpostamp2.kr(1/2);
			}.value(isig),
		].mean;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay3.kr) + sig;
				};
				isig;
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay4.kr) + sig;
				};
				isig;
			}.value(isig),
		].mean;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);

	sig = sig * \gain.kr(1);

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\demo, 
	Pbind(
		\instrument, \delbass,
		\note, Pseq([
			0,1,1,1,
		],inf),
		\octave, 3,
		\dur, 1,
		\amp, 0.1,

		'lpfr', 0.77601093560068,
		'rq', 0.069397810604479,
		'lpfr2', 2.0548273159042,
		'rq2', 0.17652800371952,
		'lpmix', 0.85921569567667,
		'fb', 0.009756305902278,
		'delay1', 0.0012003147810941,
		'distamp', 4.7688547724285,
		'distpostamp', 9.6597787422967,
		'delay2', 0.019532098181673,
		'distamp2', 1.1762092256774,
		'distpostamp2', 166.9754399721,
		'delay3', 0.00053317803124595,
		'delay4', 0.030830941282943,
		'delmix', 1.4710510771126,
		'gain', 0.32039742573121,
		'adsr', [ Env([ 0.0, 0.97959184646606, 1.0, 0.0 ], [ 0.10999999940395, 0.25059666607289, 0.20262526598068 ], [ -4.0, -4.0, -4.0 ], 2.0)],
		\delay3, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 4),
	)
).play;
);

////////////////////////
// deep bass with autopitch

(
Ndef(\demo, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmfreq;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,1,1,
		1,0,0,1,
		1,0,0,0,
	],inf)).lag(0.01);
	fmfreq = freq * ( 1 + ( SinOsc.ar(freq * 1 * env1) * 2.2 ));
	sig = LFSaw.ar(fmfreq * [1,1.0001]);
	sig = RLPF.ar(sig, freq*2 * [1,2 * SinOsc.kr(1/8).range(2,1),1], 0.2 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, 0, amp).flop;
}).play
);

// disto
(
Ndef(\demo, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf)).lag(0.31);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * env1) * 1.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 4001, 8000 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(0.1,4)] * 1.1 * Amplitude.kr(sig)**1.8 ) ).clip(5,18000));
	sig = (sig * 40).tanh / 2;
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).flop;
}).play
);

/////////// dirtylongbass
(
Ndef(\demo, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf)).lag(0.31);
	freq =  freq * Duty.kr(1/2/~t, 0, Dseq([
		1,0,0,0,
		4,4,4,4,
		5,5,5,5,
	],inf)).midiratio * ( 1 + ( SinOsc.kr(1/42 * [1,1.1]) * 0.01 ));
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 ) * 1.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 4001, 8000 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(0.1,4)] * 1.1 * Amplitude.kr(sig)**1.8 ) ).clip(5,18000));
	sig = (sig * 40).tanh / 2;
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).flop;
}).play
);

///////////// more washed disto long bass
(
Ndef(\demo, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf)).lag(0.31);
	freq =  freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		4,4,4,4,
		5,5,5,5,
	],inf)).midiratio * ( 1 + ( SinOsc.kr(1/42 * [1,1.1]) * 0.01 ));
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*[1,2,4] * 1.0 ) * 1.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 4001, 8000 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(0.1,4)] * 1.1 * Amplitude.kr(sig)**1.8 ) ).clip(5,18000));
	sig = (sig * 40).tanh / 2;
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).flop;
}).play
);

/////////////////////
(
SynthDef(\basscomb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([1,1/5,1],[1.1,0.8]), 1);
	sig = Saw.ar(freq + [0,0.001]).mean;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(100)) * \fmamp.kr(1) )));
	sig = ( sig*env1*3 ).tanh;
	sig = CombL.ar(sig, 0.1,1/freq*\delayfac.kr(1.01),\combdecay.kr(0))+sig;
	sig = ( sig*env1*1/2 ).tanh;
	sig = sig /1;
	sig1 = sig;
	sig1 = FreqShift.ar(sig1, \shift.kr(1000.01));
	sig1 = sig1 * EnvGen.ar(\shiftenv.kr(Env.adsr(0.01,0.1,0.8,3.7)),gate,doneAction:2);
	sig1 = Pan2.ar(sig, SinOsc.kr(1/2*~t)*0.1, amp);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:0);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
	sig = sig+sig1;
	sig = LeakDC.ar(sig);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\demo, Pdef(\plopdemo, 
	Ppar([
		Pbind(
			\instrument, \basscomb,
			\freq, 70,
			\fmamp, ~pmodenv.(Pseq([1,2,4,10],inf), 8),
			//\fmfreq, ~pmodenv.(Pseq([1,200,1,4],inf), 8),
			\combdecay,1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

//////////////////



(
SynthDef(\bigbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1.2,1/2],[0.011,1.7]), 1);
	sig = LFSaw.ar(freq * env1 * [1,1/2,1.005]) * [1,1,1];
	//sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	//sig = BPF.ar(sig, freq/2, 0.1) * 3 + sig;
	sig = sig + SinOsc.ar(freq); 
	sig = LPF.ar(sig, \lpfr.kr(2.1) * env1 * freq);
	sig = ( sig*2 ).tanh * 3;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.4,1.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
	Pdef(\demo, 
		Pbind(
			\instrument, \bigbass,
			\degree, Pseq([0],inf),
			\octave, 3,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\dur, 1/4,
			\amp, 0.1
		),
	).play
);

//////////////////////
(
SynthDef(\emergency, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(1);
	lfo1 = LFPulse.kr(4, 0, 0.84).range(-1,1) * 0.9;
	lfo1 = LPF.kr(lfo1, 10);
	env1 = EnvGen.kr(\adsr.kr(Env.dadsr(0.2,0.4,0.0,1,0.1,1,4)), gate, doneAction:0);
	sig = LFPulse.ar(freq * ( 1 + ( LFSaw.ar(freq/2) * 1.4 )) * ( 1 + ( SinOsc.ar(freq*2 * [1,1.0001]) * 0.4 )));
	sig1 = sig;
	sig1 = BPF.ar(sig1, ( freq/4  + ( env1 * freq ) * ( lfo1.lag(0.1) + 1 )), 0.8);
	sig1 = ( sig1 * 1000 ).clip2(1)/2;
	sig = sig1 + sig;
	sig = LPF.ar(sig, ( freq*2+100  + ( env1 * freq ) * ( lfo1 + 1 )).clip(80,20000));
	sig = LPF.ar(sig, 10000);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.5),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pbind(
	\instrument, \emergency,
	\degree, Pseq([0,2,4,2],inf),
	\octave, 3,
	\dur, 2,
	\amp, 0.1
)).play;
);

//////////////////////////

(
SynthDef(\rawbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var spread = ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	sig2 = SinOsc.ar(freq *[1,2]* ( SinOsc.ar(freq * ( 3/2 )) * 1 + 1 )).sum;
	sig1 = LFPulse.ar(freq*[1,2]).sum;
	sig3 = LFSaw.ar(freq *1* ( SinOsc.ar(freq * ( 6/4 )) * 1 + 1 ));
	sig = LocalIn.ar(8) * \fb.kr(0.7);
	sig = SelectX.ar(sig.range(0,2) * \selectffac.kr(1) * spread, [sig1, sig2, sig3]) + sig /2;
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + LFNoise1.kr((1..8)/45);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pmono(\rawbass,
			\note, Pstep(Pseq([
				0,3,2,1,
			],inf),1/1),
			\octave, 3,
			\dur, 1/8,
			\fb, Pseq([
				1,0.9, 1,0.5,
				1,1.1, 0.51,0.5,
			],inf),
			\fspread, ~pmodenv.(Pseq([0.000001,2,1/21,4],inf), 1),
			\selectffac, ~pmodenv.(Pseq([1,2,1,4,0.1],inf), 1/2),
			\selectffac, Pseq([
				1,2,2,2,
				1,1,1,2,
				1,2,2,2,
				5,45,4,5,
			],inf),
			\fspread, Pseq([
				1/11112,
				1/21112,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
)

///////////////////////////////////:
(
SynthDef(\basscorde, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2)) * \fmamp.kr(1) + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2)) * \amamp.kr(1) + 1 );
	sig = sig * 0.8;
	sig = SelectX.ar( LFNoise1.ar((1..8)/12).range(0,1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \basscorde,
			\note, Pseq([
				0,
			],inf),
			\detune, Pseq([
				0,20,10,30,
			],inf),
			\octave, 3,
			\fspread, 1/Pkey(\freq) * Pseq([1,1.2,4,8],inf).stutter(8),
			\amr, 1.01,
			\fmr, 1.1,
			\fmr, ~pmodenv.(Pseq([1,1.002,1.01,0.97,1.04],inf), 3),
			\ampamp,1,
			\dur, 2,
			\legato, 1/2,
			\amp, 0.1/4,
		),
	])
)).play;
)

////////////

(
SynthDef(\somebass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1/8,1/20],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1/10],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([0.1,1/21,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq + [0,1]).mean;
	sig2 = RLPF.ar(sig2, \lpf.kr(1000) * env1, \rq.kr(0.5));
	sig3 = LFNoise1.ar(1000 + [0,1]).mean;
	sig3 = WhiteNoise.ar;
	sig3 = sig3 * ( LFSaw.ar(freq / env2)  * env3 + 1);
	//sig3 = RHPF.ar(sig3, 19000 * env2, \rq.kr(0.5));
	sig3 = BPF.ar(sig3, 19000 * env2, \rq.kr(0.5));
	sig3 = sig3 * EnvGen.kr(Env([0,1/12,0],[0.4,0.8], [1,-1]), 1);
	sig4 = LFSaw.ar(freq *8 );
	sig4 = RHPF.ar(sig4, 8000 * EnvGen.kr(Env([1,2,3],[0.1,0.8]), 1), \rq.kr(0.5));
	sig4 = sig4 * EnvGen.kr(Env([0,1/1.2,1],[0.1,4.8]), 1);
	sig = [sig1,sig2,sig3,sig4].sum;
	//sig = sig4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\zed, 
	Pbind(
		\instrument, \somebass,
		\degree, Pseq([0],inf),
		\octave, 3,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


///////// fm bass

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(SinOsc.ar(freq + [0,0.07]) * freq * LFNoise1.kr(0.21).range(1,30) + LFNoise1.kr(0.2).exprange(0.01,2) );
	sig2 = SinOsc.ar(SinOsc.ar(freq*2 + [0,0.27]) * freq*2  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig3 = SinOsc.ar(SinOsc.ar(freq*3 + [0,1.27]) * freq*3  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig = sig1 + sig2 + sig3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0,2,-1,3],inf),
		\octave, Prand([2,2,2,3],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


//////////////


(
Ndef(\zed, { arg freq=(65.4), pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = LFSaw.ar(freq * [1,1.01] * ( Saw.ar(freq+[0.01,0.02]) * LFNoise1.kr(0.1).range(0.0,0.8) + 1 ) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), LFNoise1.kr(0.1!2).range(0.1,0.9));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=(65.4), pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = Pulse.ar(freq * [1,1.01] * ( Saw.ar(freq+[0.01,0.02]) * LFNoise1.kr(0.1).range(0.0,0.8) + 1 ) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), LFNoise1.kr(0.1!2).range(0.1,0.9));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);



(
Ndef(\zed, { arg freq=(65.4), pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = Blip.ar(freq * [1,1.01] * ( Saw.ar(freq+[0.01,0.02]) * LFNoise1.kr(0.1).range(0.0,0.8) + 1 ), LFNoise1.kr(0.1!2).range(9.0,90) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), LFNoise1.kr(0.1!2).range(0.1,0.9));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\zed, { arg freq=65.4, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = Pulse.ar(freq/4 * [ [1,1.001] ] *[1,2,3,4], LFNoise1.kr(0.1).range(0.0,1.0)).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=65.4, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = Pulse.ar(freq/2 * ( SinOsc.ar(freq+0.01) * 0.1 + 1 ), LFNoise1.kr(0.1).range(0.0,1.0));
	sig = sig * SinOsc.ar(freq * ( SinOsc.ar(freq+0.01) * 0.51 + 1 ), LFNoise1.kr(0.1).range(0.0,1.0));
	sig = SoftClipAmp.ar(sig, 13,0.5);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.1)) + sig / 2;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=65.4, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	//sig = LFSaw.ar(freq) * LFPulse.ar(freq/2 * LFNoise1.kr(1/2).range(0.0,1.0)+0.01).range(0.5,1);
	sig = LFSaw.ar(freq * [1,1.01]).sum; 
	sig = CombL.ar(sig, 0.1, freq.reciprocal,1.1)*0.1;
	sig = RLPF.ar(sig, \lpfr.kr(6.1) * freq * LFNoise1.ar(0.1 + [0,0.01]).range(1/4,4), \rq.kr(0.1) *LFNoise1.ar(0.1 + [0.01,0]).range(1,4) );
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


////////////////////////



(
SynthDef(\fmbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var freqenv = EnvGen.kr(Env([10,freq,freq],[0.001,0.1]), 1);
	var fmfreq;
	var fmampenv;
	var freqtab, fmfreqtab;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freqtab = [1/2,1,2];
	fmfreqtab = [1/2,1,2];
	fmfreq = EnvGen.kr(Env([freq,freq,freq],[0.051,4.1]), 1);
	fmampenv = EnvGen.kr(Env([0,2.1,1,0],[0.01,3.01,0.1]), 1) * \fmampenvamt.kr(4) + 1;
	sig1 = SinOsc.ar(freqenv * freqtab * ( SinOsc.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig2 = LFPulse.ar(freqenv * freqtab * ( LFPulse.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * freq, \rq.kr(0.5)) * 1.4;
	sig3 = LFSaw.ar(freqenv * freqtab * ( LFSaw.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5)) * 1.4;
	sig = SelectXFocus.ar(\wavemix.kr(0.0)*2, [sig1, sig2, sig3], \wavefocus.kr(1), true);
	sig = SelectXFocus.ar(\freqmix.kr(0.5)*2, sig, \freqfocus.kr(1), true);
	sig = SelectXFocus.ar(\fmfreqmix.kr(0.5)*2, sig, \fmfreqfocus.kr(1), true);
	sig.debug("sig");
	sig = sig * 2;
	//sig = sig + ( SinOsc.ar(freqenv * 1/2 * ( LFPulse.ar(fmfreq * 1/2 * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 )) * 0.5 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	wavemix: \unipolar,
	freqmix: \unipolar,
	fmfreqmix: \unipolar,
))).add;
);


(
Pdef(\zed, 
		Pbind(
			\instrument, \fmbass2,
			\note, Pstep(Pseq([
				0,0,0,1,
				4,3,2,1,
			],inf),1/2),
			\octave,3,
			\epsilon, ~pmodenv.(Pseq([0.0001,0.007],1), 8).loop,
			\legato, Pseq([
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fmampenvamt, 1,
			\wavemix, ~pmodenv.(Pwhite(0,0.0,inf), Pwhite(1.0,4)).loop,
			\wavemix, 0,
			\lpfr, ~pmodenv.(Pseq([1,2.4],1), 8).loop,
			\freqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\fmfreqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\amp, 0.1/2,
		),
).play;
);

/////////// /////////// /////////// ///////////


(
SynthDef(\simplegran_adsr, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsr,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,2,1,0,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				2,0,0,3, 0,0,2,0,
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsr,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,2,1,0,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, ~pmodenv.(Pseq([0.8,0.3,0.8,0.5,0.5],1), Pseq([1/4,1/4,1,2/4],1)).loop,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\gdur, ~pmodenv.(Pseq([0.8,0.3,0.8,0.5,0.5]/20,1), Pseq([1/4,1/4,1,2/4]*2,1)).loop,
			//\out, BusDef(\fx1, \audio),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				2,0,0,3, 0,0,2,0,
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		
	])
)).play;
);

////////

(
SynthDef(\bassfmenkor2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/1) * 1; 
	sig = SinOsc.ar(freq * \freqfac1.kr(1) * ( SinOsc.ar(freq * \freqfac2.kr(1) * ( LFNoise1.ar(0.1) * (1..10)* \fma2.kr(1) + 1 ))  * \fma1.kr(1)*lfo1 + 1 ));
	sig = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig * \fma3.kr(4) + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma4.kr(0.8) + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \bassfmenkor2,
			\note, Pseq([
				Ppatlace([0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma2, ~pmodenv.(Pseq([0.1,20,1,4],1), 3).loop,
			\freqfac1, 2,
			\freqfac3, 1/4,
			\freqfac2, Pseq([1,1/2,1/4],inf),
			\legato, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\bassfmenkor_env, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig = SinOsc.ar(freq * \freqfac1.kr(1) * ( SinOsc.ar(freq * \freqfac2.kr(1) * ( LFNoise1.ar(0.1) * (1..10)* \fma2.kr(1) + 1 ))  * \fma1.kr(1)*lfo1 + 1 ));
	sig = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig * \fma3.kr(4) + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma4.kr(0.8) * lfo2 + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\instrument, \bassfmenkor_env,
			\note, Pseq([
				Ppatlace([0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma1, 1000,
			\fma2, 1000,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma4, 1,
			\freqfac1, 8,
			\freqfac2, 8,
			\freqfac3, 1/4,
			\legato, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
////////////


(
SynthDef(\gransinfm, { arg out=0, freq=100, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = SinOsc.ar(freq * [1,1 + \fdelta.kr(0.001)] * ( LFSaw.ar(sig*\fmffac.kr(100)+(\freqfac.kr(1)*freq)) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,
			],inf).stutter(4),
			\fmffac, 100,
			\freqfac, Pseq([1,2,4,1/2],inf),
			\octave, 3,
			\fdelta, 1,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				2,0,0,3, 0,0,2,0,
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\gain, 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		
	])
)).play;
);


//////////:


(
SynthDef(\bass_fmek, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bass_fmek,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0.1,
			\fma2, 0.1,
			\fma3, 0.2,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac1, 1,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				Pstep(Pseq([0,-2,-4,1],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);
