Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0, 9, 0.5, 0], [0.005, 0.09, 0.4], [-4, -2, -4]) ],
	\env1, Prout({
		var val = ~cdegcps.([0,2,1,0], 3, 60.midicps, Scale.minor);
		val.do { arg x;
			var res = [ Env.new([110, x.cpsmidi*1, x.cpsmidi/1.333], [0.015, 0.39], [-4, -2]) ];
			res.asCompileString.postln;
			(4*8).do {
				res.yield;
			};
		};
	}).loop,
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\isRest, Pseq([
		Pser([
			1,0,1,0, 1,0,0,0,
			1,0,0,0, 1,0,0,0,
			1,0,1,0, 1,0,0.5,0,
			1,0.5,0,0.5, 1,0,1,0,
		],inf),
	],inf).coin.not,
));


// END

[0.6]

(
Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var control = Ndef.ar(Veco('q').uname+++\mixer);
	var freq, hasfreq;
	sig = in;
	#freq, hasfreq = Tartini.kr(control);
	sig = LPF.ar(sig, freq+400);
	//sig = control;


	sig;
});
);
