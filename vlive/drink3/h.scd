~name = 'drink3-h';
(
SynthDef(~name, { arg out=0, spread=0.8, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpfspread;
	var det;
	det = 1 + (1 / \det.kr(100));
	freq = freq * [2,1.001,1,2.001];
	freq = freq * Select.kr(\freqmix.kr(0), [
		[2,1*det,1,2*det],
		[2,1*det,1,2*det].rotate(1),
		[4*det,2*det,1,2].rotate(1),
	]);

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2 * [0.1,0.5,0.9], [sig1, sig2, sig3]);
	//sig[2] = (sig[2]*10).tanh;
	//sig = sig * [LFPulse.kr(1/7).range(0,1),1,1,SinOsc.kr(1/42).range(0,1)];
	sig = (sig*1000).tanh / 3;

	lpfspread = (((0..8) - 4)/8*\lpfspread.kr(0.51)+1);
	sig = RLPF.ar(sig, \lpf.kr(100).lag(0) * lpfspread,0.2);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.31)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).flop;
	sig.postln;
	sig = Splay.ar(sig, spread, amp, pan);

	Out.ar(out, sig);
}).add;
);

~pdef_channel.();

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
