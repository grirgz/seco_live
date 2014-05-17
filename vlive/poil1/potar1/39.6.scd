
Ndef(~name+++\fx).quant = 1;
Ndef(~name+++\fx, { arg prelevel=1, bpfreq=200, rq=0.3, limlevel=0.9, delaytime=0.1, freqshift=0, rate=1, time=2, mixfx=1,
					reclevel=1, kf1=0.50, kf2=0.150, kf3=0.200, kf4=0.100, kres=0.05, kamp=0.05, mixsat=1, lpfreq=500, hpfreq=20, inlevel=1, mixk=1,
					mixdelay=1, gain=1, sat=1, sinfreq=10;
	var in = InFeedback.ar(BusDef(~name+++\fx), 2);
	var sig, sig2, sig3, sig4, sig5;
	var infb;
	var sigin;
	var trig;
	var trig2;
	trig = Impulse.kr(1/time);
	trig2 = Impulse.kr(1);
	in = in * inlevel;
	sig = in + Fb ({ arg infb;
		var isig, isig2, isig3, isig4;
		isig = infb * reclevel + in;
		sigin = isig;
		sig2 = isig.clip2(sat);
		sig3 = isig.wrap2(sat);
		sig3 = isig.fold2(sat);
		sig4 = isig.tanh;
		isig = SelectX.ar(mixsat, [isig, sig2, sig3, sig4]);
		//isig = BPF.ar(isig, [100,1000,5000,15000], rq) * [kf1, kf2, kf3, kf4];
		//BPeakEQ.ar(
		//	    isig,
		//		    MouseX.kr(20, 20000, \exponential),
		//			    0.8, // rq
		//				    MouseY.kr(14.0, -14.0, \linear).poll,
		//					    0.5
		//); // mul
		BPeakEQ.ar( isig, [100,1000,5000,15000], rq, [kf1, kf2, kf3, kf4], 0.5); 

		isig = isig.sum;
		isig.postln;
		//isig = LPF.ar(isig, kf1, )
		//isig = FreqShift.ar(isig, freqshift);
		//isig2 = DynKlank.ar(`[[kf1,kf2,kf3,kf4], nil, [1,1,1,1]*kres], isig) * kamp;
		//isig = SelectX.ar(mixk, [isig, isig2]);
		isig = LPF.ar(isig, lpfreq);
		isig = HPF.ar(isig, hpfreq);
		//isig = SelectX.ar(mixfx, [sigin, isig]);
		isig = Limiter.ar(isig, limlevel, 1/4);
		isig = SinOsc.ar(sinfreq).range(0,1) * isig;
		//5.do { arg i;
		//	i = i+1;
		//	isig = DelayC.ar(isig, 0.5,time*(i/2)) + isig;
		//	isig = isig;
		//};
		//isig2 = DelayC.ar(isig, 0.5,time/2) + isig;
		//isig3 = DelayC.ar(isig, 0.5,time) + isig;
		//isig4 = DelayC.ar(isig, 0.5,time*2) + isig;
		//isig = SelectX.ar(mixdelay, [isig2, isig3, isig4]);
		isig = isig * gain;
		isig;

	}, 0);
	sig;
});

// END

Ndef(~name+++\fx, { arg prelevel=1, bpfreq=200, rq=0.3, limlevel=0.9, delaytime=0.1, freqshift=0, rate=1, time=2, mixfx=1,
					reclevel=1, kf1=50, kf2=150, kf3=200, kf4=100, kres=0.05, kamp=0.05, mixsat=1, lpfreq=500, hpfreq=20, inlevel=1, mixk=1,
					mixdelay=1, gain=1;
	var in = InFeedback.ar(BusDef(~name+++\fx), 2);
	var sig, sig2;
	var infb;
	var sigin;
	var trig;
	var trig2;
	trig = Impulse.kr(1/time);
	trig2 = Impulse.kr(1);
	in = in * inlevel;
	sig = in + Fb ({ arg infb;
		var isig, isig2, isig3, isig4;
		isig = infb * reclevel + in;
		sigin = isig;
		sig2 = isig.tanh;
		isig = SelectX.ar(mixsat, [isig, sig2]);
		isig = FreqShift.ar(isig, freqshift);
		isig2 = DynKlank.ar(`[[kf1,kf2,kf3,kf4], nil, [1,1,1,1]*kres], isig) * kamp;
		isig = SelectX.ar(mixk, [isig, isig2]);
		isig = LPF.ar(isig, lpfreq);
		isig = HPF.ar(isig, hpfreq);
		isig = SelectX.ar(mixfx, [sigin, isig]);
		isig = Limiter.ar(isig, limlevel, 0.2);
		5.do { arg i;
			i = i+1;
			isig = DelayC.ar(isig, 0.5,time*(i/2)) + isig;
			isig = isig;
		};
		isig2 = DelayC.ar(isig, 0.5,time/2) + isig;
		isig3 = DelayC.ar(isig, 0.5,time) + isig;
		isig4 = DelayC.ar(isig, 0.5,time*2) + isig;
		isig = SelectX.ar(mixdelay, [isig2, isig3, isig4]);
		isig = isig * gain;
		isig;

	}, 0);
	sig;
});
