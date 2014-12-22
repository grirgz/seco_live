~name = 'stone6-r';
~pdef_channel.();


SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, gdur=0.1, pitch_stretch=1, pos=0.1, bufnum;
	var sig, sig1, sig2, sig3;
	var clk;
	var randpos;
	clk = Impulse.ar(\rate.kr(4));
	randpos = TRand.ar(clk, 0.00001,0.01);
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos + randpos * BufDur.kr(bufnum), gdur, pan, 1);
	//sig = SinOsc.ar(100);
	sig = sig * 5;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, gdur=0.1, pitch_stretch=1, pos=0.1, bufnum;
	var sig, sig1, sig2, sig3;
	var clk;
	var randpos;
	var randclk;
	var rate;
	rate = \rate.kr(4);
	rate = EnvGen.kr(\rateenv.kr(Env([10,140,141,0],[2.1,2.8,0]/~t)), 1) * \rateenvmix.kr(1) + rate * \ratefac.kr(1);
	clk = Impulse.ar(rate);
	randclk = Impulse.ar(\randrate.kr(40));
	randpos = TRand.ar(randclk, \randlow.kr(0.00001),\randhi.kr(0.01));
	randpos = randpos * EnvGen.kr(\randenv.kr(Env([0,80,0],[2.1,1.8]/~t)), 1);
	//randpos = 0;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos + randpos * BufDur.kr(bufnum), gdur, pan, 1);
	//sig = SinOsc.ar(100);
	sig = sig * 5;
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = LPF.ar(sig, \lpf.kr(1000));
	sig = FreqShift.ar(sig, \freqshift.kr(0));
	sig1 = DelayL.ar(sig, 0.01,[\delayl.kr(0.001),\delayr.kr(0.00)])+sig;
	sig = SelectX.ar(\delaymix.kr(0), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

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
