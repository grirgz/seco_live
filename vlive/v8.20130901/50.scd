~name = \50;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2,
					sweepfreq = 300, sweeprate=200, sweepfmfreq=0.1, sfreqscale=100, freqscale=200,
					ffreq=500, rq=0.3, sigmix=0.5, filtmix=0.5;
	var sig, sig1, sig2, sig3;
	var sig4;
	var buf;
	buf = LocalBuf(1e4,2).clear;
	sig= Sweep.ar(BufRd.ar(2,buf,LFSaw.ar(sweepfmfreq)*sweepfreq*sfreqscale+sweepfreq),sweeprate);
	BufWr.ar(SinOsc.ar(SinOsc.kr(\writefreq.kr([2.3,8])+sig).range(1,450)),buf,sig);
	sig1 = LFSaw.ar(sig*freq*freqscale+freq);
	sig2 = SinOsc.ar(sig*freq*freqscale+freq);
	sig3 = BufRd.ar(2,buf,sig2);
	sig = SelectX.ar(sigmix/3, [sig1, sig2, sig3]);
	sig4 = RLPF.ar(sig, ffreq*[0.9,1,1.2], rq);
	sig = SelectX.ar(filtmix/2, [sig4, sig]);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	\freq, 50,
	\sweepfmfreq, Pseq([0.1,0.5,0.40],inf),
	\sweepfreq, Pseq([100,300,500,60],inf),
	\sweepfreq, Pseq([10,30,5,60],inf),
	\writefreq, Pseq([
		[1,1.2],
		[47,72.2],
		[1,1.2]*4,
	],inf),
	\sigmix, Pseg(Pseq([0.1,0.99,0.5],inf), 4),
	\ffreq, Pseq([500,800,600]*2,inf),
	\sweepscale, Pseq([300,500,0.6],inf) * Pwhite(0.8,1.56),
	\sweepscale, Pseq([0.9,0.5,0.6],inf) * Pwhite(0.8,7.56),
	\freqscale, Pseq([0.8,0.54,00.154],inf),
	\sweeprate, Pseq([4000,500,60,3000],inf) * Pwhite(0.8,1.56),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.152
))
);
