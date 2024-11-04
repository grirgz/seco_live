
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,12],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\zed).edit

Param( Pdef(\zed), \dur ).edit

Log(\Param).level = \info

(
WindowDef(\win, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\zed)),
		Param( Pdef(\zed), \dur ).asView,
		Param( Pdef(\zed), \degree ).asView,
		nil
	)
	
}).front;
);


TrackMixerDef(\bla)
TrackMixerDef(\bla).edit

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\zed).edit


/////////



{ LFNoise1 }
(
	{
		var siga, sigb;
		RandSeed.kr(1, 100);
		siga	= LFNoise0.kr(5);
		RandSeed.kr(1, 100);
		sigb	= LFNoise0.ar(5);
		[siga, sigb];
	}.plot(1)
)

{ [ LFNoise0.kr(5), LFNoise0.ar(5) ] }.plot(1)

(
{
SinOsc.ar( Lag.kr( LFNoise0.kr(5).range(500, 1500), mul: 0.1)) * 0.05
}.play;
)

"+"
"++P"
(
{
	SinOsc.ar(
		Lag.kr(60, 2) * LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1, 1.05);
	) * 0.05;
}.play(s);
)

(
var freq = 60;
var chorus = { Lag.kr(freq, 2) * LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1, 1.05); };
FreqScope.new(400, 200, 0, server: s);

{SinOsc.ar(
    chorus.value
)

}.play(s);
)

{  }SinOsc.ar(freq) 
{ SinOsc.ar(500) ! 2 * 0.1}.play;
FreqScope(400,200)


(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
