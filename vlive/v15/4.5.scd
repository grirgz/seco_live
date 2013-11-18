(
Pdef(~name, 
        Pmono(\singrain,
			\freq, Pseq([
				55,50,60,50,

			],inf),
			\doneAction, 0,
			\isRest, Veco(~namex).isrest(32),
			\ffreq, Pseq([
				100,100,100,9000,
				5100,100,9000,90,
				100,100,100,9000,
				5100,100,9000,90,
			],inf),
			\mixrlp, Pseq([
				Pseq([0],inf),
				0.51,0.9,0.1,0.5,
				0.51,0.9,0.1,0.5,
				0.51,0.9,0.1,0.5,
				0.51,0.9,0.1,0.5,
			],inf),
			\rq, 0.1,
            \amp, 0.1,
            \dur, Pseq([1/8],inf),
			\doneAction, 0,
            \legato, Pseq([
				4.8,1,2,2,
				4.8,1,2,2,
				4.8,4,4,4,
				4.8,4,2,4,

				4.8,4,4,4,
				4.8,4,4,4,
				4.8,4,4,4,
				4.8,4,4,4,
			],inf),
			\tsustain, Pkey(\sustain),
        )
	
);
)

// END

(
~n = 1;
Pdefn(~name+++\period, 100);
Pdef(~name, Ppar(
    Array.fill(~n, { arg i;
        Pbind(
            \instrument, \singrain,
            \freq, 55 + (i * 30),
			\ffreq, 100 * (i+1),
			\ii, i,
            \amp, 0.1/~n,
            \dur, 10,
            \legato, 0.8
        )
    })
));
)


p = Pmono(\default, \dur, 0.2, \freq, Pwhite(1,8) * 100 ).play

p.stop

// multi channel expansion is supported:
p = Pmono(\default, \dur, 0.2, \freq, Pwhite(1,8) * 100, \detune, [0,2,5,1]).play

p.stop


// the following example will end after 5 seconds
// or you can stop it sooner with a stop message
(
p = Pfindur(5,
    Pset(\detune,Pwhite(0,1.0) * [0,1,3,7],
        Ppar([
            Pmono(\default, \dur, 0.2, \freq, Pwhite(1,8) * 100 ),
            Pmono(\default, \dur, 0.1, \freq, Pwhite(1,8) * 300)
        ])
    )
).play;
)
p.stop;
