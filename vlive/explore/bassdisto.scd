(

SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqtab;
	freqtab = [1,1/2,1/4] * freq.lag(0.101);
	freqtab = [1,1] * freq.lag(0.101);
	sig = Pluck.ar(WhiteNoise.ar(1), 1, 0.1, 1/freqtab,93);
	//sig = LFSaw.ar(freqtab *.x [1,1.0001]);
	//sig = CombC.ar(sig, 0.1, 1/freq, 0);
	//sig = sig * 0.1;
	sig = sig * 0.5;
	//sig = sig + LPF.ar(sig, 200);
	//sig = Limiter.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,1,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\bassdisto, Pbind(
	\instrument, 
	\bass,
	\octave, 3,
	\degree, Pseq([
		2,0,0,0,
		\r,\r,
		\r,\r,
		Pseq([
			2,0,0,0,
		],1)-4,
		\r,\r,
	],inf),
	\legato,0.1,
	\dur, 1/8,
	\amp, 0.1,
	\out, BusDef(\fx1, \audio),
)).play;

Ndef(\disto, {
	var sig, in;
	var fbnode;
	in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	sig = in;

	sig = sig + ( \fb.kr(0.5) * LocalIn.ar(2) );
	5.do {
		sig = DelayC.ar(sig, 0.01,0.001.rand * \delay.kr(1)) + sig / 2;
	};
	5.do {
		sig = DelayC.ar(sig, 0.01, SinOsc.ar(\lfo.kr(1) * 0.4.rand).range(0,\lfoamp.kr(1000)) * 0.001.rand * \delay.kr(1)) + sig / 2;
	};
	5.do {
		sig = DelayC.ar(sig, 0.01,0.001.rand * \delay.kr(1)) + sig / 2;
	};
	//sig = FreqShift.ar(sig, -10000.001) + sig;
	sig = Limiter.ar(sig);
	sig = sig * ( Amplitude.ar(in) * \ampm.kr(133) + \ampa.kr(0.7) );
	sig = LPF.ar(sig, \lpf.kr(11000));
	sig = BRF.ar(sig, Pitch.kr(sig)[0]);
	sig = ( sig * \drive.kr(10) ).tanh * \dpamp.kr(0.5);
	sig = ( sig.abs < \shred.kr(0.5) ).tanh(\shred.kr * \shredt.kr(0.9)) * sig + ( ( sig.abs > \shred.kr ) * sig );
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	//5.do {
	//	sig = DelayC.ar(sig, 0.01,0.01.rand * SinOsc.kr(0.1.rand).range(20,1) * \delay.kr(1)) + sig / 2;
	//};
	sig = Limiter.ar(sig);
	sig = sig * \gain.kr(1);

	sig;
});
Ndef(\disto).play;
)

RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play;
Ndef(\fx1).edit;


Ndef(\disto).edit
