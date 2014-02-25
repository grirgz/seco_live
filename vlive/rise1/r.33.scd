(

Ndef(~name+++\lfo1, { 
	var hir;
	var sig;
	hir = SinOsc.ar([0.1,0.4]).range(0.2,2);
	sig = SinOsc.ar([440,100]).range(0.1,hir);
	sig = sig.sum;
});

Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, Pseq([
		[ Env.new([0.5, 9, 1.1, 0], [0.105, 0.06, 0.04], [-4, -2, 4]) ],
		[ Env.new([0.5, 4, 1.1, 0], [0.105, 0.06, 0.04], [-4, -2, 4]) ],
	],inf).stutter(2),
	\freqrat, Ndef(~name+++\lfo1),
	\env1, Pseq([
		[ Env.new([80, 75, 80], [0.005, 0.29], [-4, -5]) ],
	],inf).stutter(2)
));

);

// END

Ndef(~name+++\mixer).edit
