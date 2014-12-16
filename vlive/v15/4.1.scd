
(
~n = 48;
Pdefn(~name+++\period, 100);
Pdef(~name, Ppar(
    Array.fill(~n, { arg i;
        Pbind(
            \instrument, \singrain,
            \freq, 55 * (i + 1),
			\ffreq, 100 * (i+1),
			\ii, i,
            \amp, 1/~n,
            \dur, Pdefn(~name+++\period) / (i + 1),
            \legato, 0.8
        )
    })
));
)

// END


play{Splay.ar({Pluck.ar(BPF.ar(f=product({|i|product({LFSaw.ar(2**rrand(-9,1),2.rand)>0}!(i+2))/(1+i)+1}!8)*86,43).sin,Saw.ar,1,1/f,9)}!9)}
(
Ndef(\plop, {
	var sig;
	sig = {Pluck.ar(
		BPF.ar(
			f=product({|i|
				product({
					LFSaw.ar(2**rrand(-4,1),2.rand)>0
				}!(i+2))/(1+i)+1
			}!8)*746,743 * SinOsc.ar(1/8).range(1.1,1.13)
		).sin,
		Saw.ar,1,1/f,9
	)}!9;
	Splay.ar(sig)
}).play
)
