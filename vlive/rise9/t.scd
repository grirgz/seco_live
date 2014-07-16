~name = 'rise9-t';

SynthDef(~name, { arg out=0, gate=1, pan=0, phase=0, bufnum=0, amp=0.1, pos=0, rate=1, ratefreq=3;
	var s1;
	var sig;
	//rate = LFTri.ar(ratefreq, phase) * rate;
	rate = EnvGen.ar(\envrate.kr(Env([0.3,-0.3,0.51,0.38],[0.1,0.051,0.1],[-2,-2,0])),gate,doneAction:0) * rate;
	//sig = BufRd.ar(2, bufnum, K2A.ar(pos));
	//pos = 0.1  + LFNoise0.kr(20).unipolar(0.014) * BufFrames.kr(bufnum);
	pos = pos * BufFrames.kr(bufnum);
	sig = PlayBuf.ar(2, bufnum, rate, 1, pos);
	sig = sig * 14.8;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(10)/2, amp).mean;
	sig.debug("hihi");
	Out.ar(out, sig);


}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\bufnum, BufDef(\moeten),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
