~name = 'x';

{
	var suffix = \fx;
	var fxname = ~name+++suffix;
	~name.debug("rrrrrrrrrrrrrrrrrrrrrrrr");
	BusDef(fxname, \audio);
	//BusDef(~name+++\fxgate, \audio);

	Veco(~name).play_node_hook = {
		fxname.debug("play FX");
		Ndef(fxname).send;
		//Ndef(fxname).play;
		Pdef(~name+++\fxgate).play;
	};

	Veco(~name).stop_node_hook = {
		fxname.debug("stop FX");
		Ndef(fxname).end(Ndef(fxname).fadeTime);
		Pdef(~name+++\fxgate).stop;
	};
}.value;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

);


//Ndef(~name+++\fx, {
//	var in = In.ar(BusDef(~name+++\fx),2);
//	var sig;
//	var sig1,sig2,sig3,sig4,sig5;
//	sig = in;
//	//sig = CombL.ar(sig, 0.4,t/8,4) + sig;
//	sig;
//});

Ndef(~name+++\fx, { arg freqshift=0, fblevel=0.8, demmix=0.1, delaytime=0.05, delayfreq=0.5;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var delay = Array.series(8,1/8,1/8);
	var spread = 0.8;
	var pan = 0;
	var trig , itrig;
	var seq;
	var dem;
	pan = SinOsc.kr(4);
	trig = Impulse.kr(8);
	sig = in;
	sig = Fb({ arg fb;
		var isig = fb * fblevel + sig;
		isig = FreqShift.ar(isig, freqshift);
		isig = Limiter.ar(isig, 0.9, 0.21);
		isig = DelayC.ar(isig, 0.1,LPF.kr(delaytime,3)*SinOsc.kr(delayfreq).range(0.899,1));
		//isig = DelayC.ar(isig, 0.1,LPF.kr(delaytime,3));
		//isig = CombL.ar(isig, 1,1/8,2) + isig;
		//isig = isig.tanh * 0.7 * SinOsc.kr(4).range(0.9,1);
		isig = isig.tanh;
		isig;

	},0);
	//sig = sig * SinOsc.kr(4).range(0,1);
	seq = Dseq([1, 0, 1, 0,  1, 0, 1, 1], inf);
	dem = Demand.kr(trig, 0, seq);
	dem = dem.lag(0.01);
	//sig = sig * dem;
	//sig = GrainIn.ar(2, trig, 0.05, sig, pan, -1, 40);
	sig = sig * 0.4;
	sig;
});

(
SynthDef(~name+++\fxgate, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3, freqshift=0;
	var sig, sig1, sig2, sig3;
	sig = InFeedback.ar(Ndef(~name+++\fx).bus,2);
	sig = FreqShift.ar(sig, freqshift);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\out, BusDef(~name+++\fx),
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer);

if(Pdef(~name +++ \prefxgate).source.isNil) { Pdef(~name +++ \prefxgate, Pbind()) };
Pdef(~name+++\fxgate, Pdef(~name +++ \prefxgate) <> Pbind(
	\instrument, ~name+++\fxgate,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer);
);
