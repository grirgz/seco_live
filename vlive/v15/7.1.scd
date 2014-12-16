
(
Ndef(~name+++\fx, {
	var sig;
	sig = {Pluck.ar(
		BPF.ar(
			f=product({|i|
				product({
					LFSaw.ar(2**rrand(-4,1),2.rand)>0
				}!(i+2))/(1+i)+1
			}!8)*746,743
		).sin,
		Saw.ar,1,1/f,9
	)}!9;
	Splay.ar(sig)
})
)
