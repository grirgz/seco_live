~name = '2';


(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, tsustain=0.2, 
	fmrange=400, fmfreq=300;
	var sig, sig1, sig2, sig3;
	var env1;
	var modsig1;
	var cartab, fmtab;
	env1 = EnvGen.kr(\env1.kr(Env([0.01,2,0.1,2],[0.001,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	fmtab = \fmtab.kr([1,2,3,4,5,6,7,8]) * fmfreq * env1;
	modsig1 = SinOsc.ar(fmtab);
	cartab = \cartab.kr([1,2,3,4,5,6,7,8]) * fmrange * env1;
	sig = LFSaw.ar(modsig1 * cartab + freq);
	sig2 = SinOsc.ar(freq);
	sig = sig + sig2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
//Pdef(~name, Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(32),
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
	//\freq, 60,
	//\freq, Pseq([360,200,300,400]/2-50,inf),
	//\freq, Pseq([40,20,80,10],inf) + Pn(Pseq([Pseries(1,10,8*4), Pseries(8*4*10+1,-30,8*4)])),
	//\freq, Pseq([40,40,80,80],inf) + Pn(Pseries(1,1,8*2)),
	\fmrange, Pseq([360,200,300,400].reverse,inf),
	\fmrange, 90,
	//\cartab, [[1,1,1,1, 1,1,1,1]] * Pwhite(0.1,2.0),
	\cartab, [[1,2,3,4,5,6,7,8].scramble],
	//\fmtab, [[1,1,1,1, 1,1,1,1]] * Pwhite(0.1,2.0),
	\fmtab, [[1,1,1,1, 0.1,1,1,1]],
	\tsustain, 2.1,
	\fmfreq, 1.4,
	\fmfreq, 718.4,
	\legato, 0.81,
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
