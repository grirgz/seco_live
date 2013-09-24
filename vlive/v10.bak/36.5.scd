Pdef(~name +++ \pre, Pbind(
	\freq, 100,

));

(
t = TempoClock.default.tempo;
Ndef(~name+++\fx, {
	var in;
	var sig, sig2;
	var sig3, sig4;
	var spread = 0.8, amp=1, pan=0;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	sig2 = in;
	//sig = RLPF.ar(sig, SinOsc.ar([64/2,64.1,64.11*2]/8*t).range(100,19000));
	//sig = FreqShift.ar(sig, SinOsc.ar(1/8+[0.01,0.02,0.03]*[1,0.5,2]*10*t).range(-90,SinOsc.ar(4*8).range(90,500)));
	sig = DelayC.ar(sig, 0.2,LFPulse.ar([1,2,4,0.5]*8).range(1/1,1/16)) + sig;
	sig = DelayC.ar(sig, 0.2,LFPulse.ar([1,2,4,0.5]/8).range(1/1,1/16));
	sig = DelayC.ar(sig, 0.2,SinOsc.ar([1,2,4,0.5]/8.5).range(1/1,1/16));
	sig3 = LPF.ar(sig, SinOsc.ar([1,2,4]*2).range(50,[1,1.2,0.7]*10000));
	sig3 = sig3 * Pulse.ar([1,2,4]*2).range(0,1);
	sig3 = sig3 * Pulse.ar([1,2,4]/2.5,0.1).range(0,1);
	sig4= HPF.ar(sig, LFCub.ar([1,2,4]/2).range(50,[1,1.2,0.7]*10));
	sig4 = sig4 * Pulse.ar([1,2,4]/2).range(0,1);
	sig4 = sig4 * Pulse.ar([1,2,4]/2.5,0.1).range(0,1);
	sig4 = sig4 * Pulse.ar(1,0.1).range(0,0.8);
	//sig = LPF.ar(sig, 200);
	sig = sig3 + sig4;
	sig = sig4 * 2;
	sig = sig.round(0.01) + (sig * Pulse.ar(0.5));
	sig = LeakDC.ar(sig);
	//sig2 = Decay.ar(Impulse.ar(8),1.4) * PitchShift.ar(sig, 0.1, 2);
	//sig2 = Decay.ar(Impulse.ar(6),1.4) * PitchShift.ar(sig2, 0.1, SinOsc.ar(0.159).range(1/2,1/8)) + sig2;
	//sig2 = PitchShift.ar(sig, 0.1, 2);
	sig = (sig*20).tanh/10;
	//sig = sig + sig2;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});
);
[~name, ~namex, ~index].debug("index");

// END
Sdef(~namex, \myaudio).record(4);
Sdef(~namex, \myaudio).record;
~namex
	Sdef(~name, \myaudio).get(0).bufnum;
