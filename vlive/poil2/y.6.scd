
~mypatmod = Pbind(
	//\degree, Pkey(\degree) + Pseq([-7,0,-7,0],1),
	\ffreq, Pseq([
		Ndef(\bla, { SinOsc.kr(2).range(1000,8000) }),
	],16),
	\isRest, Pseq([false],inf),
);
