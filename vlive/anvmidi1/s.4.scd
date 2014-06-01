//Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { arg val=1, vlag=0.1; val.lag(vlag) });
//Ndef(~name+++\lfo1).put(1, \set -> Pbind(
//	\val, Pseq([10,50,20],inf),
//	\dur, 1,
//));
//Ndef(~name+++\lfo1, { arg val=1, vlag=0.1; EnvGen.kr(Env([40,20,50,10,20,30,35],1/4).circle) });

Pdef(~name +++ \pre, 
	Pbind(
		\freq, ~envNdefq.(~name+++\lfo1, Env([
			80,60, 100,30,
		].flatten,1/4/t,0)).asMap,
		\isRest, Pseq([
			1,0,1,0,
			1,0.81,1,0,
			0.5,1,1,0,
			1,1,1,0,
		],inf).coin.not,
		\lag, 0,
		\dur, 1/4,
		\timeScale, 0.421,
		\cuspfreq, Pwhite(10.0,10000),

	) <>
	
	Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.11], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\cuspfreq, Pseq([500,3000],inf).stutter(2) + Prand([Pwhite(0,100),Pwhite(5000,6000)],inf).stutter(4),
	//\amp, Pkey(\amp),
	\cuspfreq, Pseq([100,200],inf)  + Pseq([0,1000,5000,500],inf).stutter(16),
	\cuspfreq, Pseq([
		Pser([100,200],16),
		Pser([1000,4200],4),
	],inf),
	\cuspfreq, ~switchsplit.(
		[
			Pser([100,200,500,100],inf),
			Pser([7000,4200],inf),
		],
		3/4,
		64,
	),
	\legato, 0.4,
	\isRest, Pseq([
		1,0.4,0.4,0, 0.0,0,0.0,0,
		1,0,0.1,0, 0.8,0.5,0.1,0,
	],inf).coin.not,
	\timeScale, Pseq([
		Pseq([0.7,0.2, 0.7,0.2]),
		Pseq([0.7,0.2, 0.7,0.2]),
		Pseq([1.7,1.2, 1.7,1.2]),
		Pseq([1.7,1.2, 1.7,1.2]),
	],inf)/1.22,


	\pan, ~switchsplit.([
			Pseq([0],inf),
			Pwhite(-1.0,1.0,inf) * 0.6,
		],
		3/4,
		32
	),
	\lag, 0.15,
	\lag, Pseq([0,0.15,0.010,0.05],inf).stutter(32),
	\lag, Pseq([0,0.01],inf)/t,
	\dur, 1/8,
));

// END

[0.6]

(
~switchsplit = { arg arr, split, size, repeat=inf;
	//Pswitch1(arr, prob*size)
	[(split*size).floor, ( 1-split*size +0.5).floor, (split*size).floor+ ( 1-split*size +0.5).floor].debug("switchsplit");
	Pswitch1(arr, Pseq([Pn(0,(split*size).floor), Pn(1, (1-split*size +0.5).floor)],repeat))
};
~switchsplit.([Pseq([100],inf),Pseq([2000,inf])], 3/4, 8);
)

prob*size
