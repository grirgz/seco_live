~name = 'y';

/// TO CLEANUP
// busdef not declared
// fx not declared
// tempo not correct

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=5200, rq=0.3, hpfreq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = RLPF.ar(sig, freq, rq);
	sig = HPF.ar(sig, hpfreq);

	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.001),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;


//Ndef(~name+++\lfo1, { SinOsc.kr(XLine.kr(0.5,32,32)).range(2,100) });
(
//Ndef(~name+++\lfo1, { 
//	var lfo = SinOsc.kr(0.1);
//	var lfo2 = SinOsc.kr(0.3, pi/2);
//	var sig = SinOsc.kr(lfo.range(0.5,32)).range(2,lfo2.range(0.5,50)*100);
//	Pulse.kr(4.73).range(0.5,1)*300 + sig/5;
//});

// TODO: use t, and set in in init
~tempo = TempoClock.default.tempo;

if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	//\freq, Ndef(~name+++\lfo1).bus.asMap,
	\freq, Pseq([50,200,500,2000],inf) * Pwhite(0.4,1.2),
	\hpfreq, 2,
	\rq, 0.4,
	\rq, Pseq([0.14,0.5,0.3],inf),
	\isRest, Veco(~name).isrest,
	\legato, 1.4,
	\dur, Pseq([1/16, Pwhite(0.01,0.3,1)],inf) ,
	\amp, 0.3 * Pkey(\amp),
) <> Veco(~name).mixer)
);
