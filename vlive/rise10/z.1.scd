~rowpat = { arg dur, idx;
	Pbind(
		\clip, Pseq([ 0!7 + idx ]),
		\dur, dur,
	);
};
Pdef(~name+++\pre, 

	Pseq([
		~rowpat.(8,		9),
		~rowpat.(4,		6),
		~rowpat.(4,		10),

		~rowpat.(14,	3),
		~rowpat.(2,	1),
		~rowpat.(14,	3),
		~rowpat.(2,	2),

		~rowpat.(12,		6),
		~rowpat.(4,		10),

		~rowpat.(14,	7),
		~rowpat.(2,		1),
		~rowpat.(14,	7),
		~rowpat.(2,		2),
	],inf),
);
