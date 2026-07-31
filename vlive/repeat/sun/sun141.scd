// drift

(
~t = 143/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
)

(
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.3], [-4, -2, -4]));
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
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\envamt, 2,
			\lpf, 250,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2,
			//\out, BusDef(\ping, \audio),
			\pan, Pseq([0.5,-0.5],inf).stutter(4) * ( Pwhite(0.0,1,inf)*0.2+1 ),
		),
		
	])
)).play;
);

ClipTimeline(\ref).edit

SampleTimeline(\ref).edit

(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1,1/2]).mean;
	sig = RLPF.ar(sig, \lpf.kr(100),0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig *8;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq) * 100;
	sig = LFPulse.ar(freq + mod1 * [1,1/2]).mean;
	sig = RLPF.ar(sig, \lpf.kr(400),0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * 1/2);
	sig = RLPF.ar(sig, \lpf.kr(1) * freq*2,0.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig *8;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Formant.ar(freq,100,100);
	//sig = sig.tanh;
	sig = LFPulse.ar(freq/4);
	sig = RHPF.ar(sig, \hpf.kr(200),0.1);
	sig = RLPF.ar(sig, 1400,0.1);
	sig = sig.tanh;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig *8;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \bip,
			\note, Pseq([
				8,
			],inf),
			\octave, 5,
			\envamt, 20,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			//\out, BusDef(\ping, \audio),
			\pan, Pseq([0.5,-0.5]*0.2,inf).stutter(4) * ( Pwhite(0.0,1,inf)*0.2+1 ),
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\out, BusDef(\rlpf, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\rlpf, \audio),
			\addAction, \addToTail,
			\lpf, 422.04068571372,
			\rq, 0.1,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\lpf, 1000,
		\amp, 0.1,
	),
).play;
);


(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Formant.ar(freq,100,100);
	//sig = sig.tanh;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0002) + 1)).mean;
	sig = RHPF.ar(sig, \hpf.kr(140),0.7);
	sig = RLPF.ar(sig, 800,0.1);
	sig = sig.tanh;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.05,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig *8;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Formant.ar(freq,freq*6,freq*2);
	//sig = sig.tanh;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0002) + 1)).mean;
	sig = HPF.ar(sig, \hpf.kr(480));
	//sig = RHPF.ar(sig, \hpf.kr(480),0.1);
	//sig = RLPF.ar(sig, 2000,0.1);
	sig = LPF.ar(sig, \lpf.kr(1300));
	//sig = sig.tanh;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.05,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig *8;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \bip,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\envamt, 20,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			//\out, BusDef(\ping, \audio),
			\pan, Pseq([0.5,-0.5]*0.2,inf).stutter(4) * ( Pwhite(0.0,1,inf)*0.2+1 ),
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			//\out, BusDef(\rlpf, \audio),
			\addAction, \addToTail,
			\room, 0.4,
			\mix, 0.3,
			\lag, 0.0009,
			\dur, 1,
		),
		//Pmono(\fx_rlpf,
			//\inbus, BusDef(\rlpf, \audio),
			//\addAction, \addToTail,
			//\lpf, 422.04068571372,
			//\rq, 0.1,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		
	])
)).play;
)


///////// other sd

(
SynthDef(\evpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,2400],[0.1,0.1]), 1);
	env2 = EnvGen.kr(Env([0,1,800],[1.1,2.1]), 1);
	mod2 = SinOsc.ar(freq) * 10 * env1;
	mod3 = Pulse.ar(freq * SinOsc.ar(1*~t,mul:0.01,add:1) ).bipolar * 1 * env2.poll;
	mod1 = SinOsc.ar(freq + mod2) * 100;
	sig = SinOsc.ar(freq * [0.99,1,1.01] + mod1 + mod3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \evpad,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////////////////////////////
// continue with others sounds


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\envamt, 2,
			\lpf, 250,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2,
			//\out, BusDef(\ping, \audio),
			\pan, Pseq([0.5,-0.5],inf).stutter(4) * ( Pwhite(0.0,1,inf)*0.2+1 ),
		),
		
	])
)).play;
);



(
SynthDef(\clak, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1) + 1;
	env1 = EnvGen.kr(Env([1,2,2400],[0.1,0.1]), 1);
	env2 = EnvGen.kr(Env([0,1,800],[1.1,2.1]), 1);
	mod2 = SinOsc.ar(freq) * 10 * env1;
	mod3 = Pulse.ar(freq * SinOsc.ar(1*~t,mul:0.01,add:1) ).bipolar * 1 * env2.poll;
	mod1 = SinOsc.ar(freq + mod2) * 100;
	//sig = LFSaw.ar(freq * lfo1 * [0.99,1,1.01] + mod1 + mod3);
	sig = WhiteNoise.ar;
	sig = BPF.ar(sig, freq * lfo1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.05,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \clak,
			\note, Pseq([
				0,
			],inf),
			\octave, 6,
			\dur, 1,
			\sustain, 0.1,
			\amp, 0.1,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_pingpong,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 0.20000000298023,
			\fb, 0.7,
			\mix, 0.5,
			\gain, 1.0,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\hifm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,240],[0.1,0.8]), 1);
	mod3 = SinOsc.ar(freq) * 100;
	mod2 = SinOsc.ar(1*~t + mod3) * 2900;
	mod1 = SinOsc.ar(freq + mod2) * 100;
	sig = SinOsc.ar(freq + mod2);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bobass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1) * [1,2]) * \fmamp.kr(7.5) + 1 ), mul:[1,1/2]).sum;
	sig = BPF.ar(sig, \bpf.kr(480*3),0.2)*7 + sig;
	sig = HPF.ar(sig, \hpf.kr(300));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \hifm,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \bobass,
			\note, Pseq([
				8,
			],inf),
			\octave, 2,
			\envamt, 2,
			\lpf, 250,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2,
			//\out, BusDef(\ping, \audio),
			\pan, Pseq([0.5,-0.5],inf).stutter(4) * ( Pwhite(0.0,1,inf)*0.2+1 ),
		),
		
	])
)).play;
);



(
SynthDef(\hinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([5000,17000,1400],[0.05,0.1]), 1);
	env2 = EnvGen.kr(Env([1100,9200,1400],[0.1,0.8]), 1);
	sig = WhiteNoise.ar;
	sig = SinOsc.ar(env1/2)*0.2 + sig; 
	sig = LPF.ar(sig, env1);
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \hinoise,
			\freq, 200,
			\dur, 1,
			\sustain, 0.1,
			\amp, 0.1,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_pingpong,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 0.20000000298023,
			\fb, 0.7,
			\mix, 0.5,
			\gain, 1.0,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\bobass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1) * [1,2]) * \fmamp.kr(7.5) + 1 ), mul:[1,1/2]).sum;
	sig = BPF.ar(sig, \bpf.kr(480*3),0.2)*7 + sig;
	sig = HPF.ar(sig, \hpf.kr(300));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \bobass,
			\note, Pseq([
				8,
			],inf),
			\octave, 2,
			\envamt, 2,
			\lpf, 250,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2,
			//\out, BusDef(\ping, \audio),
			\pan, Pseq([0.5,-0.5],inf).stutter(4) * ( Pwhite(0.0,1,inf)*0.2+1 ),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[845].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1636].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sneverb, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\sneverb, \audio),
			\addAction, \addToTail,
			\room, 6,
			\lpf, 8000,
			\hpf, 400,
			\lag, 0.0009,
			\gain, 1/2,
			\dur, 1,
			\out, BusDef(\sneverb2, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\sneverb2, \audio),
			\addAction, \addToTail,
			\delay, PmodEnv(Pseq([0,0,0.04,0,0.02,0,0],1), Pseq([1.6,0.2,0.2,0.2,0.4,0.1,7.8])).loop,
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1022].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,1,
					0,0,0,1,
					0,0,0,1,
					1,1,1,1,
					0,0,0.3,1,
					0.2,0,1,1,
					0.2,0,0,1,
					1,1,1,1,
				],inf),
			],inf).coin.not,
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.05,
			\out, BusDef(\snfil, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\snfil, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,200,500,4000,2000],1), 8).loop,
			\lpf, PmodEnv(Pseq([20000,200,500,4000,2000],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
