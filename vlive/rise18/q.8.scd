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
		],inf),
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.8,1.8) ],
			[ Env.adsr(0.015,0.1,1.8,1.8) ],
			[ Env.adsr(0.005,0.1,1.8,1.4) ],
			[ Env.adsr(0.005,0.1,1.8,1.0) ],
			[ Env.adsr(0.005,0.1,1.8,2.0) ],
		],1),
	],inf),
	\legato, 0.2,
	[\adsr, \legato], 
	Pseq([
		[
			[ Env.adsr(0.005,0.1,1.8,1.8) ],
			0.2,
		],
		Ptuple([
			[ Env.adsr(0.005,0.1,1.8,0.1) ],
			Pfuncn({ arg ev;
				ev[\degree].debug("degree");
				[
					1.2,
					0.5,
					0.1,
				];
				1.2;
			},1)
		]).trace,
	],inf),
	\isRest, false,
));


// END


(
Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\degree, Pseq([
		//[0,2], [4], [0,4],
		//[0,2,4],
			[0,2,4],
			[0,2,4] + Pclump(3,Pxrand([0,0,12],3)).trace,
			[0,2,4] + Pclump(3,Pxrand([0,0,1],3)).trace,
			[0,2,4] + Pclump(3,Pxrand([0,0,11],3)).trace,
	],inf),
	//\root, Pstep(Pseq([0,5,7,5],inf),4),
	//\root, Pstep(Pseq([0,4,2,5],inf),8),
	//\root, Pstep(Pseq([0,1,0,2],inf),12),
	\mtranspose, Pstep(Pseq([5,4,2,3],inf),4),
	\mtranspose, Pstep(Pseq([
		Pseq([0,4,1,2]),
		Pseq([
			5,4,2,3
		],1),
		Pseq([0,4,0,4]),
	],inf),4),
	//\mtranspose, Pstep(Pseq([0,3,4,3],inf),8),
	//\ctranspose, Pstep(Pseq([0,5,7,5],inf),4),
	\scale, Scale.major,
	\octave, 4,
	\dur, 1/1,
	[\adsr, \legato], 
	Pseq([
		[
			[ Env.adsr(0.005,0.1,1.8,1.8) ],
			0.2,
		],
		Ptuple([
			[ Env.adsr(0.005,0.1,1.8,0.1) ],
			Pfuncn({ arg ev;
				//ev[\degree].debug("degree");
				[
					1.2,
					0.5,
					0.1,
				].keep(ev[\degree].size);
			},1)
		]),
	],inf),
	\isRest, false,
)).play;
)


Pclump(3,Pxrand([0,0,12],inf)).asStream.nextN(20)
