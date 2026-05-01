
~t = 183/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	env0: ParamEnvSpec(\amp),
	env1: ParamEnvSpec(\freq),
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([ 0.0, 1.0, 0.5, 0.0 ], [ 0.0049999998882413, 0.15999999642372, 0.20000000298023 ], [ -4.0, -2.0, -4.0 ]) ],
			\env1, [ Env([ 210.0, 52.0, 69.0 ], [ 0.025000001788139, 0.48999999165535 ], [ -4.0, -5.0 ]) ],
			\fratio, 1.5,
			\freqpan, 0.0099999997764826,
			\spread, 0.079999998211861,
			\timeScale, 1.0,
			\lpf, 2000.0,
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1510].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\hpf, 100,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([ 0.0, 1.0, 0.5, 0.0 ], [ 0.0049999998882413, 0.15999999642372, 0.20000000298023 ], [ -4.0, -2.0, -4.0 ]) ],
			\env1, [ Env([ 210.0, 60.0, 59.0 ], [ 0.045000001788139, 0.28999999165535 ], [ -4.0, -5.0 ]) ],
			\fratio, 1.5,
			\freqpan, 0.0099999997764826,
			\spread, 0.079999998211861,
			\timeScale, 1.0,
			\lpf, 2000.0,
			\dur, 1/8,
			\lag, -0.01,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_grain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			//\pos, Ndef(\lfo1, { SinOsc.kr(0.1).range(0,5)  }).asMap,
			\pos, BusDef(\smpos).asMap,
			\legato, 1,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \amodsin,
			\out, BusDef(\smpos, \control),
			\freq, 0.1 * Pseq([1,1.1],inf),
			\amphi, 5 * Pseq([2.1,2],inf),
			\add, Pseq([4,4.1],inf),
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1777].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		
		
	])
)).play;
);

(
SynthDef(\amodsin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq).range(\amplo.kr(0),\amphi.kr(1)) * \mul.kr(1) + \add.kr(0);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.kr(out, sig);
}).add;
);


/////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\legato, 1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fxkickdel,
			\inbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			//\delfac, BusDef(\delfac,\control).asMap,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\kicktrack2, \audio),
		) <>
		Pdef(\fxkickdel, Pbind()),
		Pmono(\fxkickdel,
			\inbus, BusDef(\kicktrack2, \audio),
			\addAction, \addToTail,
			//\delfac, BusDef(\delfac,\control).asMap,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pdef(\fxkickdel, Pbind()),
		
	])
)).play;
);

Param(BusDef(\delfac)).edit
Pdef(\fxkickdel).addHalo(\instrument, \fxkickdel)
Pdef(\fxkickdel).edit

(
SynthDef(\fxkickdel, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(sig*2000);
	sig = Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.79) ) + sig;

		//isig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.1) * SinOsc.ar(0.1).range(0.5,2) ) + isig;
		isig = DelayL.ar(isig, \maxdelay.kr(0.4), \delfac.kr(1) * 1/8/~t ) + isig;
		//isig = DelayL.ar(isig, \maxdelay.kr(0.4), 1/4/~t * SinOsc.ar(10.1).range(0.95,1.02)  ) + isig;
		isig = DelayL.ar(isig, \maxdelay.kr(0.4), \delfac.kr * 1/4/~t * SinOsc.ar(\delLfoFreq.kr(10.9), mul:\delLfoMul.kr(0.01), add:\delLfoAdd.kr(1))  ) + isig;
		//isig = FreqShift.ar(isig, 1);
		isig = HPF.ar(isig, 90);
		isig = [ SelectX.ar(0.3, isig),  SelectX.ar(0.7, isig) ];
		isig = isig / 2;
		isig = SelectX.ar(\ihpmix.kr(0.3), [isig, HPF.ar(isig, \ihpf.kr(290))]);
		isig = SelectX.ar(\ilpmix.kr(0.3), [isig, LPF.ar(isig, \ilpf.kr(7000))]);
		isig = Limiter.ar(isig,0.1,dur:0.001);
	
		isig;
	});
	sig = Limiter.ar(sig,dur:0.001);
	sig = HPF.ar(sig, \hpf.kr(290));
	sig = LPF.ar(sig, \lpf.kr(7000));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ihpmix: \unipolar,
	ilpmix: \unipolar,
))).add;
Pdef(\part).reset;
);
