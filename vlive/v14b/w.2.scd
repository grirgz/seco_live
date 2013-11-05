(
Pdef(~name +++ \pre, Pbind(
	//\freq, 50+Pseq([10,50,80,89],inf).stutter(2),
	\freq, Pseq([50,60,500,100],inf),
	\isRest, Veco(~namex).isrest(16),
));


Ndef(~name+++\fx).set(
	\freqshift, 200
);

)


// END
Ndef(~name+++\fx).edit;

Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var delay = Array.series(8,1/8,1/8);
	var spread = 0.8;
	var pan = 0;
	sig = in;
	sig1 = DelayL.ar(sig[0], delay,delay, DC.kr([1,0,0,0, 1,0,1,0]));
	//sig1 = FreqShift.ar(sig1, Array.series(8,1/8,0) * SinOsc.ar(0.40) * 180);
	sig1 = LeakDC.ar(sig1);
	sig1 = sig1.sum;
	//sig1 = FreqShift.ar(sig1, Array.series(8,0,10));
	//sig1 = FreqShift.ar(sig1, Array.series(8,0,10) * SinOsc.kr(2).range(0,1));
	sig2 = DelayL.ar(sig[1], delay,delay, DC.kr([1,0,0,0, 0,1,0,1]));
	sig2.postln;
	sig2 = LeakDC.ar(sig2);
	//sig2 = FreqShift.ar(sig2, Array.series(8,1/8,0) * SinOsc.ar(2.8) * 80);
	sig2 = sig2.sum;
	sig = [sig1, sig2];
	//sig = Splay.ar(sig, spread, 1, pan) + in;
	//sig = CombL.ar(sig, 0.4,t/2,1) + sig;
	sig = CombL.ar(sig, 0.4,t/8,1) + sig;
	sig = sig * 0.4;
	sig;
});
)
