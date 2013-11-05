(
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([1,0,-2,4, 0,-1,6,0],inf).stutter(1),
	\octave, 3,
	\dur, 1/8,
	\mtranspose, Pstep(Pseq([0,2],inf),2),
	\isRest, Veco(~namex).isrest(16),
));

Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	//sig = CombL.ar(sig, 0.4,t/2,1/2) + sig;
	sig = CombL.ar(sig, 0.4,t/8,1/8) + sig;
	sig;
});
)
