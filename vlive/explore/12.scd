
(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/2 * (1..9)/4).range(0.26,1.0)) * (1..9)/9 )));
	sig = sig * 10;
	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig.tanh * 0.21;
		//isig = isig.fold2(0.7);
		//isig = isig * 10;
		isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
		isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
		//isig = RLPF.ar(isig, freq, 0.01);
	
		//isig = isig.abs < 0.3 * isig;
		//isig = Limiter.ar(isig);
		isig;
	};
	sig = Limiter.ar(sig);
		sig = RLPF.ar(sig,( 2000 * Amplitude.kr(sig) )+160, 0.1);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.4),gate,doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3,2,6,5,1],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

////////////////

(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	sig = sig + DelayC.ar(sig, 0.1,1/8/freq * SinOsc.ar(1/2 * ( (1..8)/2 +1)).range(1,2) );
	sig = sig.fold2(0.7);
	//sig = Limiter.ar(sig);
	//	sig = RLPF.ar(sig,( 2000 * Amplitude.kr(sig) )+160, 0.1);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.4),gate,doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3,2,6,5,1],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

////////////////

(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	//sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	sig = sig + CombL.ar(sig, 0.1, 1/2300 * Amplitude.kr(sig).lag(0.1) * ( 1 + ( SinOsc.kr(2 * (1..8)/8) * 0.01 )),0.71);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	sig = sig.clip2(1.7);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
	//	sig = RLPF.ar(sig,( 2000 * Amplitude.kr(sig) )+160, 0.1);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.4),gate,doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3,2,6,5,1],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

////////////////

(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	//sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	sig = sig + CombL.ar(sig, 0.1, Latch.ar(sig, Impulse.ar(freq*[1/4,1,2,4])).lag(1/1000).clip(1/15000,1/50) * ( 1 + ( LFNoise1.kr(2 * (1..8)/8).unipolar * 1 )),0.04);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	env = EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.7),gate,doneAction:2);
	sig1 = sig.wrap2(1.7 * env.lag(0.1) + 0.31);
	sig2 = sig.clip2(1.7 * env);
	sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/8).range(0.0,1.0)*2, [
		sig1,
		sig2,
		sig.abs < 4.3 * sig,
	]);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
		sig = sig + RLPF.ar(sig,( freq * Amplitude.kr(sig) )+160, 0.4);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3],inf).stutter(4),
	\legato, 0.1,
	\legato, Pseq([0.9,0.4,0.1,0.2],inf).stutter(4),
	\isRest, Pseq([
		1,0.5,0.81,0.5,
		1,1,1,1,
	],inf).coin.not,
	\octave, 3,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

////////////////

(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	var env1;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	//sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	sig = sig + CombL.ar(sig, 0.1,  1/2000 * ( 1 + ( LFNoise1.kr(2 * (1..8)/8).unipolar * 1 )),0.4);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	env = EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.41),gate,doneAction:2);
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), gate);
	sig1 = sig.wrap2(4.7 * ( 1-env.lag(0.1) ));
	sig2 = sig.clip2(1.7 * env);
	sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/2).range(0.0,1.0)*2, [
		sig1,
		sig2,
		sig.abs < 4.3 * sig,
	]);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
	sig = sig + RLPF.ar(sig,( freq * 2* Amplitude.kr(sig) )+160, 0.4);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3,2,6,5,1],inf),
	\legato, 1.1,
	\octave, 3,
	\dur, 4,
	\amp, 0.1
)).play;
);

////////////////

(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	var env1;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	//sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	sig = sig + CombL.ar(sig, 0.1,  1/2000 * ( 1 + ( LFNoise1.kr(2 * (1..8)/8).unipolar * 1 )),0.4);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	env = EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.41),gate,doneAction:2);
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), gate);
	sig1 = sig.wrap2(4.7 * ( 1-env.lag(0.1) ));
	sig2 = sig.clip2(1.7 * env);
	sig = sig.mean;
	sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/2).range(0.0,1.0)*2, [
		sig1,
		sig2,
		sig.abs < 4.3 * sig,
	]);
	sig = sig.mean;
	sig.debug("sig");
	sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/3).range(0.0,9.0), [
		LFPulse.kr(8) * sig,
		1 * sig,
		LFPulse.kr(16) * sig,
		1 * sig,
		LFPulse.kr(2) * sig,
		LFPulse.kr(1) * sig,
		1 * sig,
		LFPulse.kr(10) * sig,
		LFPulse.kr(4) * sig,
	]);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
	sig = sig + RLPF.ar(sig,( freq * \lpfreqfac.kr(2)* Amplitude.kr(sig) )+160, 0.4);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3,2,6,5,1],inf),
	\lpfreqfac, Pseq([1,2,4,1/2,1/4],inf),
	\legato, 1.0,
	\octave, 3,
	\dur, Pseq([
		Pser([4],4),
//		Pser([1/8],8*4),
	],inf),
	\amp, 0.1
)).play;
);

////////////////

(
SynthDef(\rayz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	var env1;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	//sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	sig = sig + CombL.ar(sig, 0.1,  1/2000 * ( 1 + ( LFNoise1.kr(2 * (1..8)/8).unipolar * 1 )),0.4);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	env = EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.41),gate,doneAction:2);
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), gate);
	sig1 = sig.wrap2(4.7 * ( 1-env.lag(0.1) ));
	sig2 = sig.clip2(1.7 * env);
	sig = sig.mean;
	sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/2).range(0.0,1.0)*2, [
		sig1,
		sig2,
		sig.abs < 4.3 * sig,
	]);
	sig = sig.mean;
	sig.debug("sig");
	sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/3).range(0.0,9.0), [
		LFPulse.kr(8) * sig,
		1 * sig,
		LFPulse.kr(16) * sig,
		1 * sig,
		LFPulse.kr(2) * sig,
		LFPulse.kr(1) * sig,
		1 * sig,
		LFPulse.kr(10) * sig,
		LFPulse.kr(4) * sig,
	]);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
	sig = sig + RLPF.ar(sig,( freq * \lpfreqfac.kr(2)* Amplitude.kr(sig) )+160, 0.4);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\rayz2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	var env1;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	//sig = sig + CombL.ar(sig, 0.1,  1/2000 * ( 1 + ( LFNoise1.kr(2 * (1..8)/8).unipolar * 1 )),0.4);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	env = EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.41),gate,doneAction:2);
	//env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), gate);
	//sig1 = sig.wrap2(4.7 * ( 1-env.lag(0.1) ));
	sig2 = SelectX.kr( LFNoise1.kr(1/2).range(0.0,4.0),
		SinOsc.kr([1,2,4,6,8]*\wrapfreqf.kr(2))
	);
	//sig1 = sig.wrap2(4.7 * ( 1 + ( sig2 * 1 )) );
	sig1 = sig.clip2(1.7 * ( 1 + sig2 * 1 ));
	//sig = sig.mean;
	sig = sig1;
	//sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/2).range(0.0,1.0)*2, [
	//	sig1,
	//	sig2,
	//	sig.abs < 4.3 * sig,
	//]);
	//sig = sig.mean;
	sig.debug("sig");
	//sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/3).range(0.0,9.0), [
	//	LFPulse.kr(8) * sig,
	//	1 * sig,
	//	LFPulse.kr(16) * sig,
	//	1 * sig,
	//	LFPulse.kr(2) * sig,
	//	LFPulse.kr(1) * sig,
	//	1 * sig,
	//	LFPulse.kr(10) * sig,
	//	LFPulse.kr(4) * sig,
	//]);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
	//sig = sig + RLPF.ar(sig,( freq * \lpfreqfac.kr(2)* Amplitude.kr(sig) )+160, 0.4);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\rayz3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	var env1;
	freq = freq * [1,2,4];
	sig = SinOsc.ar(freq);
	sig = sig * 10;
	//sig = sig + Fb { arg fb;
	//	var isig;
	//	isig = ( fb * \fb.kr(1) ) + sig;
	//	isig = isig.tanh * 1.21;
	//	isig = isig.fold2(0.7);
	//	//isig = isig * 10;
	//	//isig = RLPF.ar(isig,( freq * Amplitude.kr(isig) ), 0.01);
	//	isig = RLPF.ar(isig,( 2000 * (Amplitude.kr(sig)**2).lag(0.2) + 100 ), 0.1);
	//	//isig = RLPF.ar(isig, freq, 0.01);
	//
	//	//isig = isig.abs < 0.3 * isig;
	//	//isig = Limiter.ar(isig);
	//	isig;
	//};
	//sig = sig + DelayC.ar(sig, 0.1,1/8/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,2) );
	//sig = sig + DelayC.ar(sig, 0.1,1/32 * LFNoise1.ar(1/2 * ( (1..8)/4 +1)).range(1,1.02) );
	sig = sig + CombL.ar(sig, 0.1,  1/4000 * ( 1 + ( LFNoise1.kr(2 * (1..8)/8).unipolar * 1 )),0.4);
	//sig = sig.wrap2(0.7) + sig.round(0.1);
	env = EnvGen.ar(Env.adsr(0.04,0.1,0.8,0.41),gate,doneAction:2);
	//env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), gate);
	//sig1 = sig.wrap2(4.7 * ( 1-env.lag(0.1) ));
	sig2 = SelectX.kr( LFNoise1.kr(1/2).range(0.0,4.0),
		SinOsc.kr([1,2,4,6,8]/4)
	);
	//sig1 = sig.wrap2(4.7 * ( 1 + ( sig2 * 1 )) );
	sig2 = sig.clip2(1.7 * env);
	//sig = sig.mean;
	sig = sig2;
	//sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/2).range(0.0,1.0)*2, [
	//	sig1,
	//	sig2,
	//	sig.abs < 4.3 * sig,
	//]);
	//sig = sig.mean;
	sig.debug("sig");
	//sig = SelectX.ar( LFNoise1.kr(1/2 * (1..8)/3).range(0.0,9.0), [
	//	LFPulse.kr(8) * sig,
	//	1 * sig,
	//	LFPulse.kr(16) * sig,
	//	1 * sig,
	//	LFPulse.kr(2) * sig,
	//	LFPulse.kr(1) * sig,
	//	1 * sig,
	//	LFPulse.kr(10) * sig,
	//	LFPulse.kr(4) * sig,
	//]);
	sig = sig / 1;
	//sig = sig / 10;
	//sig = Limiter.ar(sig);
	sig = sig + RLPF.ar(sig,( freq * \lpfreqfac.kr(2)* Amplitude.kr(sig) )+160, 0.4);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = Splay.ar(sig, \spread.kr(0.21), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \rayz,
	\note, Pseq([0,3,2,6,5,1],inf),
	\lpfreqfac, Pseq([1,2,4,1/2,1/4],inf),
	\legato, 1.0,
	\octave, 3,
	\dur, Pseq([
		Pser([4],4),
//		Pser([1/8],8*4),
	],inf),
	\amp, 0.1/1
)).play;
Pdef(\plop2, 
	
	Pbind(

		\isRest, Pseq([1,0.7,0.9,0.5],inf).coin.not,
		\note, Pkey(\note) + Pseq([-12,0,0,0,1,0,0,0,5,0,0,0],inf),
		\warpfreqf, Pseq([4,2,1/8,8,1/4],inf) * Prand([1/8,0,1/4],inf),
	) <>
	Pbind(
		\instrument, \rayz2,
		\note, Pseq([0,3,2,6,5,1],inf)+3+12 ,
		\lpfreqfac, Pseq([1,2,4,1/2,1/4],inf),
		\legato, 0.7 * Pseq([0.2,1.1,0.5],inf),
		\octave, 4,
		\dur, Pseq([
			Pser([4/8],4),
	//		Pser([1/8],8*4),
		],inf),
		\amp, 0.1/5
	).stutter(8)
).play;
Pdef(\plop3, 
	
	Pbind(

		\isRest, Pseq([
			1,0.7,0.9,0.5,
			0,0,0,0,
			1,1,1,1,
			0,0,0,0,
		],inf).coin.not,
		\note, Pkey(\note)+7+Pseq([0,12,0,0,-12,0,5,0,0],inf),
	) <>
	Pbind(
		\instrument, \rayz3,
		\note, Pseq([0,3,2,6,5,1],inf),
		\lpfreqfac, Pseq([1,2,4,1/2,1/4],inf),
		\legato, 0.7,
		\octave, 4,
		\dur, Pseq([
			Pser([4/4],4),
	//		Pser([1/8],8*4),
		],inf),
		\amp, 0.1/5
	).stutter(4)
).play;
);
