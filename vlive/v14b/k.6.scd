(
Pdef(~name +++ \pre, Pbind(
	\freq, 50+Pseq([10,50,80,89],inf).stutter(4),
	\isRest, Veco(~namex).isrest(16),
	\dur, 1/8,
));

Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	sig = DelayL.ar(sig, 0.02,0.01+SinOsc.kr(1).range(0,0.01))+sig;
	//sig = CombL.ar(sig, 0.4,t/2,1) + sig;
	//sig = CombL.ar(sig, 0.4,t/8,1) + sig;
	sig;
});
)
