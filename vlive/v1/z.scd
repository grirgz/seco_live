~name = \z;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fmfreq=40.1, spread=0.8;
	var sig, sig2;
	var freqtab, klanktab;
	sig = LFSaw.ar(fmfreq) * freq;
	freqtab = \freqtab.kr([0.9,1.2,1.01,1.3, 0.99,0.997,1,1]);
	klanktab = \klanktab.kr([700,200,300,500].extend(8,500));
	klanktab = klanktab * SinOsc.ar(freqtab).range(0.8,1.2);
	sig = SinOsc.ar(freq * freqtab + sig);
	sig = DynKlank.ar(Ref([klanktab]),sig);
	sig = sig / 15;
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.01),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\degree, Pseq([0,2,4]+10,inf),
	\freq, ~mybus.asMap,
	//\isRest, ~sceneset.seq.prythm(1),
	\isRest, Veco.main.seq.pryn(~name),
	\fmfreq, Pseq([0.1,20,5,10],inf),
	\freqtab, [[0.9,1.2,1.01,1.3, 0.99,0.997,1,1]*2],
	\freqtab, [[0.9,1.2,1.01,1.3, 0.99,0.997,1,1]],
	\klanktab, [[0.9,1.2,1.01,1.3, 0.99,0.997,1,1] *850],
	\klanktab, [[0.9,1.2,1.01,1.3, 0.99,0.997,1,1] *250],
	\klanktab, Pseq([
		[[0.9,1.2,1.01,1.3, 0.99,0.997,1,1] *250],
		[[0.2,3.2,0.11,1.3, 0.99,0.597,1.5,0.71] *850],
	],inf),
	\sustain, Pseq([0.34,0.01,0.2],inf),
	\sustain, Pseq([1,0.1,0.2],inf),
	\sustain, 0.2,
	\out, ~myfxbus,
	\amp, 0.04,
	\dur, 1/4 * 1,
));
);
