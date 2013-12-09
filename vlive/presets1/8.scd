~name = '8';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2,
					lrate= 200, la=5, lb=1, lc=1, ld=5, latoscale=200, ffreq=200, rq=0.3;
					//tgate=1;
	var sig, sig1, sig2, sig3;
	var lato;
	la = la * [1.01,1,0.99];
	ffreq = ffreq * [1.01,1,0.99];
	lato = LatoocarfianC.ar(lrate, la, lb, lc, ld);
	sig = LFSaw.ar(lato*latoscale+freq);
	sig1 = SinOsc.ar(lato*latoscale+freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig1 + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = sig * EnvGen.ar(\env.kr(Env.perc(0.1,0.5)),\tgate.tr(1),doneAction:0);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0,2,4],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
	) <> Veco(~name).mixer)
);

// END

{SinOsc.ar(Summer.kr(Impulse.kr(5), 1.5, 0, 0).poll * 100, 0, 0.1)}.play;

(
{
var trig = Dust.kr(5);
var reset = Impulse.kr(0.5);
SinOsc.ar(Summer.kr(trig, [0.5, 0.25], reset, 1) * 100, 0, 0.1)
}.play;
)



// randomly modulate all params
(
{ LatoocarfianC.ar(
        SampleRate.ir/4,
        LFNoise2.kr(2,1.5,1.5),
        LFNoise2.kr(2,1.5,1.5),
        LFNoise2.kr(2,0.5,1.5),
        LFNoise2.kr(2,0.5,1.5)
) * 0.2 }.play(s);
)

(
Ndef(\pol, { 
	LatoocarfianC.ar(
        SampleRate.ir/4,
		7,
		1,
		1,
		1,
	) * 0.2 }
).play;
)

(
Ndef(\pol2, { 
	var freq, sig;
	freq = LatoocarfianC.ar(
        447,
		10,
		2.3,
		7,
		1,
	) * 0.2;
	freq.poll;
	sig = SinOsc.ar(freq*200+200);
	sig = RLPF.ar(sig, 500);
	sig ! 2
}
).play;
)
