~name = \a;

SynthDef(~name, { |out, freq=440, amp=0.1, impdecay=0.01, attack=0.0001,xsustain=0.1, famt=3, ffreq=1000, hdur=0.1,pan=0, gate=1|
	var snd, trig, decay;
	trig = Impulse.ar(0);
	decay = Decay2.ar(trig, attack, impdecay) * 1;
	snd = Ringz.ar(decay, freq*[1,2], xsustain);
	//snd = SinOsc.ar(500);
	snd = snd + SinOsc.ar(freq*[Rand(1,1.1),Rand(1.4, 1.6), Rand(1.9,2.1), Rand(3.9, 4.1)], mul:Decay2.ar(trig, 0.01,hdur));
	snd = BLowPass.ar(snd, ffreq * decay.linexp(0,1,1,famt), 0.1);
	//snd = snd * EnvGen.ar(Env.linen(0, 0.1, 0.1), doneAction:2);
	snd = snd * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	snd = Splay.ar(snd, 1, amp, pan);
	Out.ar(out, snd);
}).add;

Veco(~name).make_mixer;
~newfxmix.(\fx);

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
