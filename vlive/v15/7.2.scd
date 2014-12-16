
(
Ndef(~name+++\fx, {
	var sig;
	sig = {
		Pluck.ar(
			BPF.ar(
				f=product({|i|
					product({
						LFPulse.ar(2**rrand(-9,1),2.rand)
					}!(i+2))/(2+i)+1
				}!4)*226,243,0.8
			).sin,
			Saw.ar(16),1,1/f,9,0.5
		)
	}!2;
	Splay.ar(sig)
})
)
