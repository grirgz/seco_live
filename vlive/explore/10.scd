
// gen pattern with x(t) and y(t)

(
Pdef(\pox, Pbind(
	\degree, Pseq((1..8),inf),
	\dur, Plazy({ arg ev; 
		var time = (1..8);
		var res = sin(time)+1;
		res = (res/2).normalizeSum;
		res = res * 8;
		Pseq(res);
	}).loop.trace,

)).play;

Pdef(\clock, Pbind(
	\degree, Pseq([[0,2,4]],inf),
	\legato, 0.1,
	\dur, 1,
)).play;
)

(
Pdef(\pox, Pbind(
	\time, Ptime(),
	\degree, Pseq((1..8),inf),
	\degree, Pfunc({ arg ev;
		sin(ev[\time]%8)+1*8
	}),
	//\sustain, 0.3,
	\dur, Plazy({ arg ev; 
		var len = 8;
		var rate = 4;
		var time = Array.series(len*rate, 0,1/rate);
		var res = sin(time)+1;
		res = (res/2).normalizeSum;
		res = res * len;
		Pseq(res);
	}).loop,

).trace).play;

Pdef(\clock, Pbind(
	\degree, Pseq([[0,2,4]],inf),
	\legato, 0.1,
	\dur, 1,
)).play;
)

(
Pdef(\pox, Pbind(
	\time, Ptime(),
	\degree, Pseq((1..8),inf),
	\degree, Pfunc({ arg ev;
		sin(ev[\time]%8)+1*8
	}),
	//\sustain, 0.3,
	\len, 16,
	\z, Ptime() % Pkey(\len),
	\dur, Pfunc({ arg ev; 
		var len = 8;
		var rate = 4;
		var time = Array.series(len*rate, 0,1/rate);
		// fait planter!! dur trop petit
		//var res = sin(ev[\z])+1 / 2;
		res = res ;
	}).loop,

).trace).play;

Pdef(\clock, Pbind(
	\degree, Pseq([[0,2,4]],inf),
	\legato, 0.1,
	\dur, 1,
)).play;
)
