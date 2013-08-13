~name = \a;

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
	sig = sig.tanh + (sig/12);
	sig = sig / 35;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.01),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)
[1,2].extend(5,1)

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\octave, 2,
	\freq, Pseq([200,100,50]/2,inf),
	\degree, Pseq([0,2,4]+10,inf),
	\isRest, ~sceneset.seq.prythm(1),
	\fmfreq, Pseq([0.1,20,5,10],inf),
	\freqtab, [[0.9,1.2,1.01,1.3, 0.99,0.997,1,1]],
	\klanktab, [[0.9,1.2,1.01,1.3, 0.99,0.997,1,1] *30],
	\amp, 0.1,
	\dur, 1/4,
));
)
Pdef(~name).play

Pdef.defaultQuant = 4
