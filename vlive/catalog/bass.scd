
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
SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(200), 0.14, freq, freq*fratio,
		LFNoise1.ar(500!2).range(1, 10),
	);
	sig = sig * EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		doneAction: 2
	);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(0, sig);
}).add;
)

(
Pdef(\plop, Pbind(
	\instrument, \fm_grain_test,
	\fratio, Pseq([1,2,3/2,1.21314],inf),
	\degree, Pseq([0,2],inf),
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
Pdef(\bass, 
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
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1
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

Pdef(\bass, Pbind(
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
Pdef(\bass, Pbind(
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
Pdef(\bass, Pmono(\distbass,
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
