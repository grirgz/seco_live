(
Pdef(~name +++ \pre, Pbind(
	//\freq, 50+Pseq([10,50,80,89],inf).stutter(2),
	\freq, Pseq([500,100],inf).stutter(2),
	\isRest, Veco(~namex).isrest(16),
));

Ndef(\freqshift, 100);
Ndef(\freqshift, -100);
Ndef(\fb, 0.99);
Ndef(\fb, 1.49);
Ndef(\demmix, 0.1);

Spec.add(\freqshift, ControlSpec(-500, 500, \lin, 0, 0));



Ndef(~name+++\fx, { arg freqshift=0, fblevel=0.8, demmix=0.1, delaytime=0.05, delayfreq=0.5;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var delay = Array.series(8,1/8,1/8);
	var spread = 0.8;
	var pan = 0;
	var trig , itrig;
	var seq;
	var dem;
	pan = SinOsc.kr(4);
	trig = Impulse.kr(8);
	sig = in;
	sig = Fb({ arg fb;
		var isig = fb * fblevel + sig;
		isig = FreqShift.ar(isig, freqshift);
		isig = Limiter.ar(isig, 0.9, 0.21);
		isig = DelayC.ar(isig, 0.1,LPF.kr(delaytime,3)*SinOsc.kr(delayfreq).range(0.899,1));
		itrig = Impulse.kr(16);
		seq = Dseq([1, 0, 1, 0,  1, 0, 1, 1], inf);
		dem = Demand.kr(itrig, 0, seq);
		dem = dem.lag(0.01);
		isig = SelectX.ar(demmix, [isig * dem, isig]);
		//isig = CombL.ar(isig, 1,1/8,2) + isig;
		//isig = isig.tanh * 0.7 * SinOsc.kr(4).range(0.9,1);
		isig = isig.tanh;
		isig;

	},0);
	//sig = sig * SinOsc.kr(4).range(0,1);
	seq = Dseq([1, 0, 1, 0,  1, 0, 1, 1], inf);
	dem = Demand.kr(trig, 0, seq);
	dem = dem.lag(0.01);
	//sig = sig * dem;
	//sig = GrainIn.ar(2, trig, 0.05, sig, pan, -1, 40);
	sig = sig * 0.4;
	sig;
});
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
