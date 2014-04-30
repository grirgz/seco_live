
Ndef(~name, { arg ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0;
	//var t = PulseCount.ar(Impulse.ar(2**13), Impulse.kr(1/(512)));
	var t = PulseCount.ar(Impulse.ar(2**13), Impulse.kr(1/(64)));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	//t = LPF.ar(t, 1);
	t = t + toffset;
	//t = t + (2**28);
	sig = HPF.ar(
		(
			((t * 4*freqfac) | (t >> (2*shift))) |
			((t * freqfac/2) & (t / (4*shift))) |
			((t * 2) & (t >> (8*shift))) 
		) % 256
		, 20
	) * 0.002;
	sig = RLPF.ar(sig, log(ffreq).round(1/2).exp,0.5);
	sig = Splay.ar(sig, spread, amp, pan);

}).play;
Ndef(~name).quant = Pdef.defaultQuant;

// END

1031 >> 2

log(100).exp
(
MIDIBoard.map(\k1, Ndef(~name), \freq, \freq.asSpec);
MIDIBoard.map(\k2, Ndef(~name), \freqfac, ControlSpec(0.01,20,\lin, 0,15));
MIDIBoard.map(\k3, Ndef(~name), \ffreq, \freq.asSpec);
MIDIBoard.map(\k4, Ndef(~name), \shift, ControlSpec(0.01,5,\lin, 0,1));
)
t
Ndef(~name).edit
			((t * freqfac) & (t >> (7*shift)))  |
			((t * freqfac/2) & (t >> (4*shift))) |
			((t * freqfac/4) | (t >> (3*shift))) |

