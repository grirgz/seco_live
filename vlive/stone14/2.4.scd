

~patfx_gate.(~name+++\patfx, Pbind(
	\pos, 0.71,
	\isRest, false,
	\posenv, Prand([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
		Prand([
			//[ Env([0.00,0.000101,0.00181].integrate.postln,[0.07,2.4]) ],
			[ Env([0.00,0.010101,0.00081].integrate.postln,[0.07,2.4]) ],
			[ Env([0.00,0.010101,0.00081].integrate.postln,[0.07,1.4]) ],
		],8),
	],inf).stutter(1),
))
