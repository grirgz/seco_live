
(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2,4,2, 0,2,4],inf),
	\dur, PdurStutter(Pseq([4,3],inf), 1).trace,
	\amp, 0.1
).stutter(1)).play;
);

(
Pdef(\plop, 
	Pbind(\sustain, 0.1) <>
	Pseq([
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,2,4,2],inf),
			\dur, Pseq([
				1/4,
			],8),
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,2,4],inf),
			\dur, Pseq([
				1/3
			],6),
			\amp, 0.1
		),
	],inf),
).play;
);


(
b=4.collect{Pbind(\degree, Pwhite(0,5), \dur, Pwhite(1,10) ).asStream};
c=r{
		arg inval=();
		var min, copy;
		var a=(degrees: [], deltas:[]);
		b.collect({|x| x.next(inval) })
		.do({|x|
				a.degrees=a.degrees.add(x.degree) ;
				a.deltas=a.deltas.add(x.dur) });
		loop{
				min=a.deltas.minItem;
				a.deltas.collectInPlace{arg x, i;
						x=x-min; if(x==0)
						{
								var niouEv;
								niouEv=b[i].next(inval);
								a.degrees[i]=niouEv.degree;
								niouEv.dur
						}
						{x}
				};
				(degree:a.degrees, dur:min).yield // consider the + 0
		}
}

)
c.next
MIDIOut.con
