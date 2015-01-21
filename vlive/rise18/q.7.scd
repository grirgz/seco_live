Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\degree, Pseq([
		Pwalk(
			[
				[0,2,4, 7],
				[0,2,4, 9],
				0,2,4,
				[0,2+12],
				[0,4+12],
				0+12,2+12,4+12,
				[2,4],
			],
			Pseq([
				1,-2,Pwhite(0,3), Pwhite(0,-3)
			],inf),
		),
	],inf),
	//\root, Pstep(Pseq([0,5,7,5],inf),4),
	//\root, Pstep(Pseq([0,4,2,5],inf),8),
	//\root, Pstep(Pseq([0,1,0,2],inf),12),
	\mtranspose, Pstep(Pseq([5,4,2,3],inf),4),
	//\mtranspose, Pstep(Pseq([0,3,4,3],inf),8),
	//\ctranspose, Pstep(Pseq([0,5,7,5],inf),4),
	\scale, Scale.major,
	\octave, 4,
	\dur, 1/1,
	\lag, 
		Pseq([
			Pseq([0,0],8) / ~t,
			Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
			Pseq([0,0],4) / ~t,
			Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
			Pseq([0,0],4) / ~t,
			Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
			Pseq([0,0],Pwhite(4,8,1)) / ~t,
			Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
		],inf),
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			//[ Env.adsr(0.015,0.1,1.8,1.8) ],
			//[ Env.adsr(0.005,0.1,1.8,1.4) ],
			//[ Env.adsr(0.005,0.1,1.8,1.0) ],
			//[ Env.adsr(0.005,0.1,1.8,2.0) ],
		],1),
	],inf),
	\legato, 0.2,
	\isRest, false,
));


// END

