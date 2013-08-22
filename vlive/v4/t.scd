~name = \t;


(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, tsustain=0.2, 
	fmrange=400, fmfreq=300, freq2=100;
	var sig, sig1, sig2, sig3;
	var env1;
	var modsig1;
	var cartab, fmtab;
	env1 = EnvGen.kr(\env1.kr(Env([0.01,2,0.1,2],[0.001,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	fmtab = \fmtab.kr([1,2,3,4,5,6,7,8]) * fmfreq * env1;
	modsig1 = SinOsc.ar(fmtab);
	cartab = \cartab.kr([1,2,3,4,5,6,7,8]) * fmrange * env1;
	sig = LFSaw.ar(modsig1 * cartab + freq);
	sig2 = LFPulse.ar(modsig1 * cartab + freq) /4;
	sig2 = SinOsc.ar(freq2);
	sig = sig + sig2;
	sig = sig + sig.tanh;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Ndef(~name, {  SinOsc.kr(2.6).range(1,800)  });
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
//Pdef(~name, Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	\isRest, Veco.main.seq.pryn(~name),
	\freq, Pseq([40,20,80,10],inf) + Pn(Pseq([Pseries(1,10,8*4), Pseries(8*4*10+1,-30,8*4)])),
	\freq, Pseq([40,40,80,80],inf) + Pn(Pseries(1,1,8*2)),
	\freq, [460,200,700],
	\freq, Pseq([
		Pseq([160,100,110,140],4),
		Pseq([360,200,300,400],4),
		Pseq([
			[460,200,700],
			[160,100,120],
		],4),
	],inf),
	\freq, Ndef(~name +++ \freq, { LFPulse.kr(8).range(100,400) + LFTri.kr(0.1).range(0,200) }).bus.asMap,
	\freq, ~mybus[1].asMap,
	\freq2, Pkey(\freq),
	//\freq2, Pseq([360,200,300,400],inf),
	\fmrange, Pseq([360,200,300,400].reverse,inf),
	\fmrange, 30,
	//\cartab, [[1,1,1,1, 1,1,1,1]] * Pwhite(0.1,2.0),
	//\cartab, [[1,1,1,1, 1,1,1,1]],
	//\fmtab, [[1,1,1,1, 1,1,1,1]] * Pwhite(0.1,2.0),
	//\fmtab, [[1,1,1,1, 0.1,1,1,1]],
	\tsustain, 1.1,
	\fmfreq, 40.1,
	\fmfreq, Pseq([718.4,0.1],inf),
	\fmfreq, Ndef(~name, { XLine.kr(0.01,1300,10) }),
	\legato, 0.81,
	\dur, 1,
	\amp, 0.051,
	\cartab, Pn(Prout{
		var ar;
		4.do { arg i;
			ar = Array.fill(8, {1.0.rand});
			ar = [ar];
			Pseq([ar,ar],i+1*2).embedInStream;
		};
	}), 
	\cartab, Pn(Prout{
		var ar;
		4.do { arg i;
			ar = Array.fill(8, {4.0.rand});
			ar = [ar];
			Pseq([ar],i+1*2).embedInStream;
			ar = ar * 1 + 0.1.rand;
			Pseq([ar],i+1*2).embedInStream;
		};
	}), 
	\fmtab, Pn(Plazy{
		var ar;
		ar = Array.fill(8, {4.1.rand});
		ar = [ar];
		Pseq([ar,ar],8);
	}), 

))
);
