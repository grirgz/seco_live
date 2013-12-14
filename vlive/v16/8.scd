~name = '8';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.2, freq=200, doneAction=2, oscmix=0.5,
					ffratio=1.0, rq=0.1;
	var sig, sig1, sig2, sig3;
	var env, env1, env2;
	//sig = Silent.ar;
	//sig = LFSaw.kr(freq) * LFSaw.kr(freq+0.1) * LFSaw.kr(freq+(SinOsc.kr(1)*0.01));
	env = EnvGen.ar(Env([1, 0.0201,0.0001],[0.07,1.4]),gate,doneAction:0);
	env1 = EnvGen.ar(Env([1, 0.0201,0.4001],[0.07,1.4]),gate,doneAction:0);
	//sig = LFSaw.kr(freq) * LFSaw.kr(freq+(LFNoise1.kr(1)*4.001));
	//sig = LFSaw.ar(freq * [1,1.001]) * SinOsc.ar(freq+(env*4.1));
	oscmix= env1;
	//oscmix = SinOsc.kr(1).range(0,1);
	sig1 = SelectX.ar(oscmix, [
		LFPulse.ar(freq+(env*49.1)),
		SinOsc.ar(freq+(env*49.1)),

	]);
	sig = LFSaw.ar(freq * [1,2,2.01,1.1,0.5,0.250,0.23]) * sig1;
	//sig = sig * LFSaw.ar(freq * [1.001,1.0001]);
	//sig = sig * SinOsc.ar(freq+(env*0.01));

	sig = sig.wrap(env*0.5+[0.1,0.4]);
	//sig = SelectX.ar(oscmix, [sig, sig2]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
Pdef(~name).quant = 8;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/4,
	\amp, 0.4 * Pkey(\amp)
) <> Veco(~name).mixer)
);

// END

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, oscmix=0.5,
					ffratio=1.0, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = [
		LFSaw.ar((LFNoise0.ar(freq*10)*0.5+1) * freq * [0.5,1,1.5,1,0.5,2,4*LFNoise0.ar(20).range(0.0,1)]),
		SinOsc.ar(freq * [1,1.01]),
		LFSaw.ar(freq*[1,1.01]*(LFNoise0.ar(freq*10)*0.5+1)),
	].sum;
	sig = CombL.ar(sig, 0.1,1/freq * [1,1.11,2],0.4)+sig;
	sig = (sig * 4).tanh;
	sig = sig.distort;
	sig = sig / 2;
	sig2 = ClipNoise.ar(1);
	sig2 = BPF.ar(sig2, ffratio * freq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = SelectX.ar(oscmix, [sig, sig2]);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.2, freq=200, doneAction=2, oscmix=0.5,
					ffratio=1.0, rq=0.1;
	var sig, sig1, sig2, sig3;
	sig = Silent.ar;
	sig2 = Fb({ arg fb;
		var sigin = fb * 0.4;
		//sig2 = ClipNoise.ar(190*[2.01,1,0.5,1.01,2]) * 0.5;
		//sig2 = ClipNoise.ar(190) * 0.5;
		sig2 = WhiteNoise.ar(1);
		sig2 = sigin + sig2;
		//sig2 = RLPF.ar(sig2, ffratio * freq * [0.999,1,1.01,1.02,1.001], rq);
		//sig2 = FreqShift.ar(sig2, -800);
		sig2 = DelayL.ar(sig2, 0.1, 0.01*SinOsc.kr(4.1).range(0.001,4));
		sig2 = DelayL.ar(sig2, 0.1, 0.01*SinOsc.kr(2.1).range(0.001,4));
		//sig2 = FreqShift.ar(sig2, 200);
		//sig2 = sig2.clip(1);
		sig2 = sig2.clip(0.001);
		//sig2 = Limiter.ar(sig2, 0.805,1/freq);
		//sig2 = Limiter.ar(sig2, 0.495,0.0001);
		//sig2 = RLPF.ar(sig2, ffratio * freq, rq);
		//sig2 = RLPF.ar(sig2, ffratio * freq, rq);
		sig2 = sig2 * 1;
		//sig2 = sig2.distort;
	});
		sig2 = LPF.ar(sig2, 1500);

	sig2 = sig2/10;
	sig = SelectX.ar(oscmix, [sig, sig2]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
