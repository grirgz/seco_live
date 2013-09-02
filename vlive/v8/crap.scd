// 8-bit magic
(
play {
    var t = PulseCount.ar(Impulse.ar(8e3));
    HPF.ar(
        (
            ((t * 15) & (t >> 5)) |
            ((t * 5)  & (t >> [3, 4])) |
            ((t * 2)  & (t >> 9)) |
            ((t * 8)  & (t >> 11))
            - 3 % 256
        ) / 127-1 * 3
        , 20
    ).tanh
}
)

(
Ndef(\fou2, {
    var t = PulseCount.ar(Impulse.ar(8e3));
    HPF.ar(
        (
            ((t * 15) & (t >> [5,4]))
        ) / 127-1 * 3
        , 20
    )
}).play
)

s.volume.gui




(
~name = 'xfiles';
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, 
						ifreq=5, maxdelaytime=0.05, delaytime= 0.05, decaytime=0.2, ffreq=1000, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = BPF.ar(
		Pluck.ar(
			Crackle.ar(\crackle.kr([1.9,1.8].extend(4,1))),
			Impulse.ar(ifreq),
			maxdelaytime,
			delaytime,
			decaytime
		),
		ffreq,
		rq
	);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(

Pdef(~name, Pbind(
	\instrument, ~name,
	\maxdelaytime, 0.15,
	\delaytime, Pwhite(0.0001,0.010),
	\delaytime, Pn(Pseries(0.0001, 0.0001, 8*8)),
	\ifreq, Pwhite(4.1,18.1),
	\ifreq, Pn(Pseq(Array.series(8*1,0.1,0.1).reverse)),
	\ifreq, Pseq([3,5.2,2,4.33],inf),
	\crackle, [[1.5,4.8,1.3,1.3]+0.01],
	\legato, 0.5,
	\dur, 1/8 * Pwhite(0.9,1.9),
	\dur, 1/1,
	\amp, 4.0
)).play;

);

(
~name = 'xglitch';
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, 
						ifreq=5, maxdelaytime=0.05, delaytime= 0.05, decaytime=0.2, ffreq=1000, rq=0.3, lpfreq=1000;
	var sig, sig1, sig2, sig3;
	sig = BPF.ar(
		Pluck.ar(
			Crackle.ar(\crackle.kr([1.9,1.8].extend(4,1))),
			Impulse.ar(ifreq),
			maxdelaytime,
			delaytime,
			decaytime
		),
		ffreq,
		rq
	);
	sig = LPF.ar(sig, lpfreq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(

Pdef(~name, Pbind(
	\instrument, ~name,
	\maxdelaytime, 0.15,
	\delaytime, Pwhite(0.0001,0.010),
	//\delaytime, Pn(Pseries(0.0001, 0.0001, 8*8)),
	\lpfreq, 5400,
	\delaytime, 0.017,
	\ifreq, Pwhite(4.1,18.1),
	\ifreq, Pn(Pseq(Array.series(8*1,0.1,0.1).reverse)),
	\ifreq, Pseq([3,5.2,2,4.33],inf),
	\crackle, [[1.5,9.8,1.3,1.3]+0.01],
	\legato, 0.5,
	\dur, 1/8 * Pwhite(0.9,1.9),
	\dur, 1/1,
	\amp, 1
)).play;

);
