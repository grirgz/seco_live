Ndef(~name+++\lfo1).quant = 2;
Pdef(~name +++ \pre, 
	Pbind(
		//\fratioc, Pwhite(0.1,1),
	\amp, Pkey(\amp) * 0.2,

	) <>

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, Veco(~namex).isrest(32),
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(8),
	\fratio, 2,
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	//\modamp, Ndef(~name+++\lfo1),
	\rq, 0.9,
));
//Ndef(~name+++\lfo1, { SinOsc.ar(2*t).range(0.2,1) });


// END

Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset).get_active_score.get_event.asCompileString

(

Pdef(~name +++ \pre, 
	Pbind(\instrument, ~name, \amp, 0.2) <>
	Pseq([( 
		'fratioc': 0.67942016044464, 
		'doneActiona': 0.0, 
		'env0b': [ Env([ 0.001, 3.9192986051749, 8.0, 0.001  ], [ 0.01, 0.03183850023695, 0.28514530228853  ], [ -4, -2, -4  ])  ], 
		'doneActionb': 0.0,
		'rq': 2.0, 
		'doneActionc': 0.1, 
		//'dmix': 0.48255813953488, 
		'dmix': 0.98255813953488, 
		'distmix': 0.38953488372093, 
		'dmix2': 0.16279069767442,
		'rqc': 1.568461287356, 
		'amp': 1.0, 
		'pan': 0.0, 
		'env0': [ Env([ 0.001, 1.0000001392097, 0.50000000352667, 0.001  ], [ 0.01, 0.07406809444692, 0.23484117149916  ], [ -4, -2, -4  ])  ], 
		'fratiob': 0.32249949601659,
		'drive': 2.5, 
		'env1': [ Env([ 5.0, 125.31636619568, 5.0  ], [ 0.01, 6.0147651653305  ], [ -4, 5  ])  ], 
		'fratio': 0.38510476728503, 
		'driveamp': 2.8347354651163, 
		'env0c': [ Env([ 0.001, 8.0, 7.9133244676473, 0.001  ], [ 0.01, 0.048770101334993, 0.12467354721218  ], [ -4, -2, -4  ])  ],
		'pwidth': 0.5, 
		'env1c': [ Env([ 5.0, 90.195294566435, 5.0  ], [ 0.038442061266311, 0.86278728174395  ], 1.296)  ], 
		'env1b': [ Env([ 73.65636363636, 29.79045527469, 27.14  ], [ 0.10947448794399, 1.8549443678928  ], -2.34)  ], 
		'cliplevel': 0.69853488372093 
	)],inf) 
).play

)
