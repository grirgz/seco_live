
Ndef(~name, { arg ffreq = 200, freqfac=15, freq=8000;
	var t = PulseCount.ar(Impulse.ar(freq));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			((t * freqfac) & (t >> 5)) wrap2:
			((t * 5) + (t >> [3, 4])) fold2:
			((t * 2) & (t >> 9)) fold2:
			((t * 8) & (t >> 11))
		) % 256
		, 20
	) * 0.002;
	sig = RLPF.ar(sig, ffreq,0.5)

}).play;

// END

(
MIDIBoard.map(\k1, Ndef(~name), \freq, \freq.asSpec);
MIDIBoard.map(\k2, Ndef(~name), \freqfac, ControlSpec(0.01,20,\lin, 0,15));
MIDIBoard.map(\k3, Ndef(~name), \ffreq, \freq.asSpec);
)
