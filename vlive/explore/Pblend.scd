// blend between env like Pseg

(
~p=	Ptuple(Pseg(
	Pseq([
		Env.adsr(0.01,0.1,0.8,0.1),
		Env.adsr(0.01,0.1,0.8,0.4),
		Env.adsr(0.4,0.1,0.8,0.04),
	],1),
),1)
)

(
// can't work because env get inlined as a pattern
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\adsr, Pseq([
			Pseg(Pseq([
				Env.adsr(1.1,0.1,0.8,0.01),
				Env.adsr(0.01,0.1,0.8,1.1),
			],1),8),
		],inf).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
// Pseg ok if input is array
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\xx, Pseq([
			Pseg(Pseq([
				[ 0,0],
				[ 1,10],
			],1),8),
		],inf).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
// Pseg ok if input is array of array
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\xx, Pseq([
			Pseg(Pseq([
				[ [ 0,0] ],
				[ [ 1,10] ],
			],1),8),
		],inf).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
// Pseg raise error if input is env in array
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\adsr, Pseq([
			Pseg(Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],1),8),
		],inf).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
// OK!!!!
// Pseg ok if input is env as array in array
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\adsr, Pseq([
			Pseg(Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.01).asArray ],
				[ Env.adsr(0.01,0.1,0.8,0.01).asArray ],
				[ Env.adsr(0.01,1.1,0.3,0.01).asArray ],
			],1),8),
		],inf).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
			(
			~pblend.(Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.01).asArray ],
				[ Env.adsr(0.01,0.1,0.8,1.1).asArray ],
			],1),8)
			)

(
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\adsr, Pseq([
			~pblend.(Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.01).asArray ],
				[ Env.adsr(0.01,0.1,0.8,0.01).asArray ],
			],1),8),
		],10).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0],inf),
		\adsr, Pseq([
			~pblend.(Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],1),8),
		],10).trace,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\part).clear;

(
~p =Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],1);
)
~ps = ~p.asStream;
~ps.next

[Env.adsr].asArray
(
~pblend = { arg envpat, durpat, curvepat=0, repeats=1;
	envpat.debug("e");
	envpat = envpat.collect({ arg x; x.debug("x"); x.collect{ arg y; y.asArray } });
	Pseg(envpat, durpat, curvepat, repeats);
}
)

(
~pblend = { arg envpat, durpat, curvepat;
	Prout({ arg ev;
		var envpatstr, durpatstr;
		var env, nextenv, fac;
		var curdur;
		var clock = thisThread.clock;
		var starttime;
		envpatstr = envpat.asStream;
		durpatstr = durpat.asStream;
		block { arg break;
			100.do {
				var elapsed;
				var debugcount = 100;
				env = envpatstr.next;
				nextenv = envpatstr.next;
				curdur = durpatstr.next;
				[env, nextenv, curdur].debug("inputs");
				starttime = clock.beats;
				if(env.isNil or: { nextenv.isNil } or: { curdur.isNil }) {
					break.value;
				};
				while { 
					elapsed = ( clock.beats - starttime );
					debugcount = debugcount - 1;
					elapsed < curdur and: { debugcount > 0 };
				} {
					fac = elapsed / curdur;
					fac.debug("fac");
					env.blend(nextenv, fac).yield;
				};
			}
		};
		1.yield; // debug
	})
}
)
