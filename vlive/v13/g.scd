~name = \g;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffscale=1;
	var sig, sig1, sig2, sig3;
	var freq2;
	var freq3;
	freq2 = freq * SinOsc.kr(freq).range(0.1,1);
	freq2 = freq * SinOsc.kr(freq * [1,2,3,8,16,0.5]/7).range(0.1,1);
	//freq3 = freq2 * LFSaw.kr(freq2 / [1,2,3,8,16,0.5]).range(0.1,1);
	freq3 = freq * [1,1.001];
	//freq2 = SelectX.kr(LFNoise1.kr(1.01).range(0,2) * 1, [freq, freq2, freq3]);
	freq2 = freq2;
	//freq2 = SelectX.kr(LFNoise1.kr(1.01).range(0,2) * freqsel_scale + freqsel_base, [freq, freq2, freq3]);
	sig = SinOsc.ar(freq2 * Array.geom(8,1,1.002).scramble);
	sig2 = LFSaw.ar(freq2 * Array.geom(8,1,1.002).scramble) ;
	sig3 = Pulse.ar(freq2 * Array.geom(8,1/4,1.002).scramble) ;
	//sig = [sig, sig2,sig3].sum;
	sig = SelectX.ar(LFNoise1.kr(1.01).range(0,2), [sig, sig2,sig3]);
	sig.debug("sig1");
	sig1 = RLPF.ar(sig, ffscale * freq* Array.geom(8,1/2,1.002).scramble, 0.3);
	sig2 = RLPF.ar(sig, ffscale  * freq* (Array.geom(8,1,1.002).scramble), 0.4);
	sig = SelectX.ar(LFNoise1.kr(1.1).range(0,1), [sig1, sig2]);
	sig3 = EnvGen.kr(Env([0,1,0],[0.01,0.01]), Impulse.kr([2,1/5])) * sig;
	sig = SelectX.ar(LFNoise1.kr(1.1).range(0,1), [sig, sig3]);
	sig = sig.flat;
	sig.debug("sig2");
	//sig = sig + sig3;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Ndef(~name+++\lfo1, { XLine.kr(300,800,8)  });

(
~dur = 1;
Ndef(~name+++\lfo1, { LFSaw.kr(t / ~dur).range(1300,2800)  });
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Prand([0,2,4,7],inf),
	//\freq, Pseq([100,50],inf).stutter(4),
	//\freq, 50,
	\degree, Prand([0,1,2,3,4,5,6,7,8],inf).stutter(4),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\mtranspose, Pstep(Pseq([
		-2,-1, 5,5,4,2,
		0,2,0,4,4,-3,
	],inf),2),
	\mtranspose, Pseq([0,0],inf),
	\octave, 5,
	//\detune, [1,0.401],
	\isRest, Veco(~name).isrest,
	//\sustain, Prand([2,1.3,0.6,0.3,0.1],inf),
	//\lag, Prand([0.01,0],inf),
	//\sustain, 0.2,
	//\sustain, Prand([0.2,0.3,0.1],inf),
	\legato, Pseq([2,1],inf),
	\legato, 1,
	\dur, ~dur,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);


// END


(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var freq2;
	var freq3;
	freq2 = freq * SinOsc.kr(freq).range(0.1,1);
	freq2 = freq * SinOsc.kr(freq * [1,2,3,8,16,0.5]/7).range(0.1,1);
	//freq3 = freq2 * LFSaw.kr(freq2 / [1,2,3,8,16,0.5]).range(0.1,1);
	freq3 = freq * [1,1.001];
	//freq2 = SelectX.kr(LFNoise1.kr(1.01).range(0,2) * 1, [freq, freq2, freq3]);
	freq2 = freq2;
	//freq2 = SelectX.kr(LFNoise1.kr(1.01).range(0,2) * freqsel_scale + freqsel_base, [freq, freq2, freq3]);
	sig = SinOsc.ar(freq2 * Array.geom(8,1,1.002).scramble* LFNoise1.kr([0.3,0.2,1.35]).range(0.99,1.01));
	sig2 = LFSaw.ar(freq2 * Array.geom(8,1,1.002).scramble * LFNoise1.kr([0.3,0.2,1.35]).range(0.99,[1,1.01])) ;
	sig3 = Pulse.ar(freq2 * Array.geom(8,1/4,1.002).scramble * LFNoise1.kr([0.3,0.2,1.35]).range(0.99,1.01)) ;
	sig = SelectX.ar(LFNoise1.kr(1.01).range(0,2), [sig, sig2,sig3]);
	sig1 = RLPF.ar(sig, freq* Array.geom(8,1/2,1.002).scramble, 0.3);
	sig2 = RLPF.ar(sig, freq* (Array.geom(8,1,1.002).scramble+LFNoise1.kr([1,0.2,1.3]).range(0,4.43)), 0.4);
	sig = SelectX.ar(LFNoise1.kr(1.1).range(0,1), [sig1, sig2]);
	sig3 = EnvGen.kr(Env([0,1,0],[0.01*LFNoise1.kr(0.11).range(0.5,18),0.01*LFNoise1.kr(0.11).range(0.5,11)]), Impulse.kr([2,1/5])) * sig;
	sig = SelectX.ar(LFNoise1.kr(1.1).range(0,1), [sig, sig3]);
	//sig = sig + sig3;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
