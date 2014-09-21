~name = 'rise13-y';
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var seq1,seq2;
	sig = LFSaw.ar(freq * [1,1.001,0.5*SinOsc.kr(4).range(0.9,1.1)] * XLine.kr(7,1,0.008));

	seq1 = Duty.kr(1/1/~t,0,Dseq([
		2,8,4,2,
		8,2,5,2,
	],inf));
	seq2 = Duty.kr(1/2/~t,0,Dseq([
		0,1,0.5,0.21,
		4,1,5,01,
		0,1,0.5,4.21,
		0.3,0.8,5,01,
	],inf));
	seq1 = SinOsc.kr(seq1*~t).range(0.1,2);
	sig1 =  sig | (Pulse.ar(110 * [1,1.001])*seq2*10);
	sig1 = sig1 | (LFSaw.ar(470 * [1,1.001] * 1.5 * seq1)*10);
	sig = SelectX.ar(seq2,[sig , sig1/10]);
	sig = RLPF.ar(sig,8300,0.2);
	sig = HPF.ar(sig, 400);
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),\igate.kr(1).poll,doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var seq1,seq2;
	sig = LFSaw.ar(freq * [1,1.001,0.5*SinOsc.kr(4).range(0.9,1.1)] * XLine.kr(7,1,0.008));

	seq1 = Duty.kr(1/1/~t,0,Dseq([
		2,8,4,2,
		8,2,5,2,
	],inf));
	seq2 = Duty.kr(1/2/~t,0,Dseq([
		0,1,0.5,0.21,
		4,1,5,01,
		0,1,0.5,4.21,
		0.3,0.8,5,01,
	],inf));
	seq1 = \seq1.kr(4);
	seq2 = \seq2.kr(0.4);
	seq1 = SinOsc.kr(seq1*~t).range(0.1,2);
	sig1 =  sig | (Pulse.ar(\pfreq.kr(110) * [1,1.001])*seq2*10);
	sig1 = sig1 | (LFSaw.ar(\sfreq.kr(470) * [1,1.001] * 1.5 * seq1)*10);
	sig = SelectX.ar(seq2,[sig , sig1/10]);
	sig = RLPF.ar(sig,\lpf.kr(8300),\lpfrq.kr(0.2));
	sig = HPF.ar(sig, \hpf.kr(400));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
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
	//\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
