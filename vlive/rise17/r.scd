~name = 'rise17-r';

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, freqlag=0.1, ffreq=500, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq.lag(freqlag));
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name+++\mono, { arg freq, ins, n=1;
	var fre = freq;
	Pmono(ins.value,
		\type, \monoSet,
		//\instrument, ~name,
		\freq, Pseq([fre.value,fre.value*0.9,fre.value*0.8],inf),
		\dur, Pseq([1/6,1/8],inf) * n.value,
	)
});
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\type, \phrase,
	\ins, ~name,
	\instrument, ~name+++\mono,
	\transparency, 1,
	\degree, Pseq([0],inf),
		\freq, Pseq([100,200,300],inf),
		\n, 0.5,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);


// END

(
Pdef(~name+++\mono, { arg freq, n=1;
	var fre = freq;
	Pmono(topEnvironment[\name],
		\type, \monoSet,
		//\instrument, ~name,
		\freq, Pseq([fre.value,fre.value*0.9,fre.value*0.8],inf),
		\dur, Pseq([1/6,1/8],inf) * n.value,
	)
});
);

(
Pdef(~name+++\mono, { arg fre, n=1;
	Pmono(topEnvironment[\name],
		//\type, \monoSet,
		//\instrument, ~name,
		\freq, Pseq([fre.value,fre.value*1.1,fre.value],inf),
		\dur, Pseq([1/6,1/8],inf) * n.value,
	)
});
)

(
Pdef(~name+++\mono, { arg fre;
	Pbind(
		\instrument, topEnvironment[\name],
		//\type, \monoSet,
		\type, \note,
		//\instrument, ~name,
		\freq, Pseq([fre.value,fre.value*1.1,fre.value]),
		\dur, 1/8,
	)
});
)

(
	Pdef(~name, Pbind(
		//\transparency, 1,
		//\recursionLevel, 0,
		\type, \phrase,
		\instrument, ~name+++\mono,
		\dur, 1,
		\n, 0.4,
		\fre, Pseq([100,200,700],inf),
	)).play
)
(
	Pbind(
		//\type, \phrase,
		\freq, Pseq([100,200,300],inf),
		\instrument, \z,
		\dur, 1,
	).play
)


(
s.boot;

SynthDef(\pgrain,
    { arg out = 0, freq=800, sustain=0.001, amp=0.5, pan = 0;
        var window;
        window = Env.sine(sustain, amp * AmpCompA.kr(freq));
        Out.ar(out,
            Pan2.ar(
                SinOsc.ar(freq),
                pan
            ) * EnvGen.ar(window, doneAction:2)
        )
    }
).add;

SynthDef(\noiseGrain,
    { arg out = 0, freq=800, sustain=0.001, amp=0.5, pan = 0;
        var window;
        window = Env.perc(0.002, sustain, amp * AmpCompA.kr(freq));
        Out.ar(out,
            Pan2.ar(
                Ringz.ar(PinkNoise.ar(0.1), freq, 2.6),
                pan
            ) * EnvGen.ar(window, doneAction:2)
        )
    }
).add;



Pdef(\sweep, { arg sustain=1, n=8, freq=440, ratio=0.1;
    Pbind(
        \instrument, \pgrain,
        \dur, sustain.value / n,
        \freq, Pseq((1..n)) * ratio + 1 * freq.value // freq is a function, has to be evaluated
    )
});
Pdef(\sweep2, { arg sustain=1, n=8, freq=440, ratio=0.1;
    Pbind(
        \instrument, \noiseGrain,
        \dur, sustain.value / n, // sustain is also a function, has to be evaluated
        \freq, Pseq((1..n).scramble) * ratio + 1 * freq.value,
        \recursionLevel, 2
    )
});
Pdef(\sweep3, { arg freq=440;
    Pbind(
        \type, \phrase,
        \instrument, \sweep,
        \freq, Pfunc({ rrand(0.8, 1.3) }) * freq.value,
        \dur, 0.3,
        \legato, 1.3,
        \n, 5
    )
});
)


c=1
(
{

	//var name = \a; // launch lot of synths
	//var name = \x; // 
	//var name = \z; 
	var name = \x; // works
	SynthDef(name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
		var sig, sig1, sig2, sig3;
		sig = SinOsc.ar(freq);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;

	Pdef(\sweep, { arg sustain=1, n=8, freq=440, ratio=0.1;
		Pbind(
			\type, \note,
			\instrument, name,
			\dur, sustain.value / n,
			\freq, Pseq((1..n)) * ratio + 1 * freq.value // freq is a function, has to be evaluated
		)
	});
}.value;
);

(
Pbind(
    \type, \phrase, // phrase event from global library
    \instrument, \sweep,
    \n, 15,
    \degree, Pseq([0, 4, 6, 3], inf),
    \sustain, Pseq([1.3, 0.2, 0.4],inf)
).play
)

