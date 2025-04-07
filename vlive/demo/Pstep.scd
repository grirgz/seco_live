(
Pdef(\zed, 
    Pbind(
        \note, Pseq([0,1,4,5],inf),
        \dur, 1/8,
    ) <> Pstep(Pbind(\octave, Pseq([6,5],inf), \legato, Pseq([1,0.1],inf)), Pseq([1,1,1/2,1/2],inf))
).play;
);


////////////////////////
(
Pdef(\zed, 
	Pseq([
		Pfindur(7,Pbind()),
		Pfindur(1,Pbind(\type, \rest)),
	],4) 
	<> Pdef(\seq1),
).play;
);



(
Pdef(\zed, 
    Pbind(
        \note, Pseq([0,1,4,5],inf),
        \dur, 1/8,
    ) <> Pstep(Pbind(\type, Pseq([\rest,\note],inf)), 2)
).play;
);

(
// not working
Pdef(\zed, 
	Pstep(Pbind(\type, Pseq([Pkey(\type).keep(1),\rest],inf)), 1)
	<>
    Pbind(
        \note, Pseq([0,1,4,5],inf),
        \dur, 1/8,
    ) 
).play;
);

(
Pdef(\zed, 
	Pbind(\isRest, Pstep(Pseq([Pkeyd(\isRest, false).keep(1),true],inf), 1))
	<>
    Pbind(
        \note, Pseq([0,1,4,5],inf),
        \dur, 1/8,
    ) 
).play;
);
