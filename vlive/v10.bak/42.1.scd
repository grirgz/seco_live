Pdef(~name +++ \pre, Pbind(
	\freq, 100,

));

(
t = TempoClock.default.tempo;
Ndef(~name+++\fx, {
	var in;
	var sig, sig2;
	var spread = 0.8, amp=1, pan=0;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	//sig = RLPF.ar(sig, SinOsc.ar([64/2,64.1,64.11*2]/8*t).range(100,19000));
	//sig = FreqShift.ar(sig, SinOsc.ar(1/8+[0.01,0.02,0.03]*[1,0.5,2]*10*t).range(-90,SinOsc.ar(4*8).range(90,500)));
	//sig = DelayC.ar(sig, 0.2,LFSaw.ar([1,2,4,0.5,1/3,8]).range(1/4,1/16));
	sig2 = sig;
	//sig2 = Decay.ar(Impulse.ar(6),1.4) * PitchShift.ar(sig2, 0.1, SinOsc.ar(4.759).range(1/4,1/8)) + sig2;
	//sig2 = PitchShift.ar(sig, 0.1, 2);
	//sig = FreqShift.ar(sig, -400);
	sig2 = FreqShift.ar(sig, LPF.ar(sig,110).range(-2000,1900)) + sig;
	//sig2 = FreqShift.ar(sig2, LPF.ar(sig2,1).range(-200,190)) + sig2;
	//sig2 = FreqShift.ar(sig2, LPF.ar(sig,1).range(-2000,1900)) + sig2;
	sig2 = LPF.ar(sig2,3500+(LFNoise1.kr(10)*3000));
	sig = sig + sig2;
	sig = (sig*20).tanh/10;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});
Ndef(~name+++\fx).quant = 1;
);
[~name, ~namex, ~index].debug("index");

// END
Sdef(~namex, \myaudio).record(8);
Sdef(~namex, \myaudio).record;
~namex
	Sdef(~name, \myaudio).get(0).bufnum;

	Sdef(~name, \myaudio).get(0).buf
	Sdef('43', \myaudio).get(0).buf

