

// custom env (must not be finite!)
(
	Ndef(\plop, { arg gate=1; 
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550) * EnvGen.kr(Env([1,2,4],[4.1,0.8],0,1), gate););
		sig = EnvGen.kr( Env.adsr(0.1,0.1,0.8,1.1), gate, doneAction:2) * 0.02 * sig;
		sig;
	}).play;

)
	Ndef(\plop).release;

//// definir un synthdef sans le lancer

(
	Ndef(\bla).put(0, {
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550)) * 0.1;
		sig;
	}, now:false);
	// YES!
)

//////// DRAFT

(
	Ndef(\plop, { arg gate=1; 
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550) * EnvGen.kr(Env([1,2,4],[4.1,0.8],0,1), gate););
		sig = EnvGen.kr( Env.adsr(0.1,0.1,0.8,1.1), gate, doneAction:2) * 0.02 * sig;
		sig;
	}).play;

)
	Ndef(\plop).release;

(
	Ndef(\bla, {
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550)) * 0.1;
		sig;
	}).play;

)
	Ndef(\bla).release;
	Ndef(\bla).free;
	Ndef(\bla).isPlaying;
	Ndef(\bla).fadeTime =2;

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\xplop,Pmono(\plop,
	\freq, Pseq([120.rand+70, Pwhite(100,200)],inf),
	\legato, 0.3, // don't use the env :(

)).play;
)
Pdef(\xplop).stop // use the env

(
Ndef(\xpoop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pbind(
	\instrument, Ndef(\xpoop), // ce serait bien si c'etait possible
	// mais comment ca gere si plusieurs nodes dans source du ndef ?
	// bah ca fait juste des spawn et des set sur le proxy
	\freq, Pseq([100,200,2000],inf),
).play
)

//// definir un synthdef sans le lancer

(
	Ndef(\bla, {
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550)) * 0.1;
		sig;
	});
	// no
)

(

	Ndef(\bla).source = {
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550)) * 0.1;
		sig;
	};
	// no

)
(
	Ndef(\bla).put(0, {
		var sig;
		sig = SinOsc.ar([1,1]*Rand(140,550)) * 0.1;
		sig;
	}, now:false);
	// YES!
)
	Ndef(\bla).play;
	Ndef(\bla).release;
	Ndef(\bla).free;
	Ndef(\bla).isPlaying;
	Ndef(\bla).fadeTime =2;
