(
SynthDef(\kick1, {
    var snd;
    snd = DC.ar(0);
    snd = snd + (SinOsc.ar(XLine.ar(200, 40, 0.01)) * Env.perc(0.015, 0.01).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), XLine.ar(800, 100, 0.01), 0.6) * Env.perc(0.001, 0.02).delay(0.001).ar);
    snd = snd + (SinOsc.ar(XLine.ar(172, 50, 0.01)) * Env.perc(0.0001, 0.3, 1, \lin).delay(0.005).ar(2));
    snd = snd.tanh;
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

Synth(\kick1, [amp: 0.4]);

(
SynthDef(\kick2, {
    var snd;
    snd = DC.ar(0);
    snd = snd + (HPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.003, 0.03).ar * 0.5);
    snd = snd + (SinOsc.ar(XLine.ar(750, 161, 0.02)) * Env.perc(0.0005, 0.02).ar);
    snd = snd + (SinOsc.ar(XLine.ar(167, 52, 0.04)) * Env.perc(0.0005, 0.3).ar(2));
    snd = snd.tanh;
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

Synth(\kick2, [amp: 0.4]);

(
SynthDef(\kick3, {
    var snd;
    snd = DC.ar(0);
    snd = snd + (SinOsc.ar(XLine.ar(1500, 800, 0.01)) * Env.perc(0.0005, 0.01, curve: \lin).ar);
    snd = snd + (BPF.ar(Impulse.ar(0) * SampleRate.ir / 48000, 6100, 1.0) * 3.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.9) * Env.perc(0.001, 0.02).ar);
    snd = snd + (SinOsc.ar(XLine.ar(472, 60, 0.045)) * Env.perc(0.0001, 0.3, curve: \lin).delay(0.005).ar(2));
    snd = snd.tanh;
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

Synth(\kick3, [amp: 0.4]);


/*
contributors so far: nathan ho

i use Hasher.ar(Sweep.ar) as a quick way to generate deterministic white noise, so i can get exactly the same kick each time for a precise digital sampler effect. you are free to replace it with WhiteNoise.ar.

the DC.ar(0) does nothing, it's just so i can reorder all the "snd = snd +" lines and/or comment out parts of the synth.

some of the attacks are so fast that Env:kr doesn't correctly handle them. that's why i always use Env:ar, so i don't have to think about ar/kr when i'm messing with sharp envelope attacks. i'm sure many of them could be refactored to kr for CPU, but idc
*/



(
SynthDef(\neurosnare, {
    var snd;
    // a percussive click to give it some attack
    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    // sine sweep body. very important!
    snd = snd + (SinOsc.ar(Env([800, 416, 480], [0.01, 0.2], \exp).ar) * Env.perc(0.01, 0.01).ar * 6.dbamp).tanh;
    // sound of snare coils rattling
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 1200, 0.5, 3), 300) * Env.perc(0.05, 0.1).delay(0.01).ar(2) * -3.dbamp);
    // another sound sweep to improve the attack, optional
    snd = snd + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
    // distortion helps glue everything together and acts as a compressor
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;
)
Synth(\neurosnare, [amp: 0.4]);

(
Pdef(\neurosnare, Pbind(
	\instrument, \kick1,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);



p = ProxySpace.push(s.boot);

~out.play(0,2);

// taube eule und maus
(
~out = {  
	var tr, e, eg, fm, maus;
	maus = MouseX.kr(0.1, 2);
	e =  Env([0, 1, 0.4, 1, 0], [0.03, 0.2 * maus, 0.2, maus]);
	tr = Dust.kr(0.3);
	eg = EnvGen.kr(e, tr);
	fm = SinOsc.ar(30, 0, 0.2 * (1 - eg), 1);
	SinOsc.ar(100 * eg + 200 * fm) * 0.1 * eg
};
)

// taube eulen und maus
(
~out = {  
	var tr, e, eg, fm, maus;
	maus = MouseX.kr(0.1, 2);
	e =   { Env([0, 1, 0.4, 1, 0], [0.03, 0.2.rand, 0.2, maus]) };
	tr = { Dust.kr(0.3) };
	eg = [
			EnvGen.kr(e.value, tr.value), 
			EnvGen.kr(e.value, tr.value)
	];
	fm = SinOsc.ar(30, 0, 0.2 * (1 - eg), 1);
	SinOsc.ar(100 * eg + 200 * [1, 1.15] * fm) * 0.1 * eg
};
)


// eulenschlag und maus
(
~out = {  
	var tr, e, eg, fm, maus, n, u;
	n = 6;
	maus = MouseX.kr(0.1, 2);
	e =   { Env([0, 1, 0.4, 1, 0], [0.03, 0.2.rand, 0.2, maus]) };
	tr = { Dust.kr(0.1) };
	eg =  (e ! n).collect { arg env; EnvGen.kr(env, tr.value) };
	fm = SinOsc.ar({ 30 + 2.0.rand2 } ! n, 0, 0.2 * (1 - eg), 1);
	u = SinOsc.ar(100 * eg + 200 * { rrand(0.9, 1.1) } ! n * fm) * 0.1 * eg;
	u.clump(2).sum
};
)

/*
authors so far:
jrh
*/
