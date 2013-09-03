(
Pdef(~name +++ \pre, Pbind(
	\rq, Pseg(Pseq([0.01,0.5],inf),8),
	\freq, Pseq([500,2000],inf) * Pwhite(0.4,4.2),
	\hpfreq, 2,
	\rq, Pseq([0.14,0.5,0.3],inf),
	\rq, 0.4,
	\isRest, Veco(~name).isrest,
	\legato, 0.3,
	\out, BusDef(~name+++\fx),
	\dur, Pseq([1/8],inf) ,
));


Ndef(~name+++\fx, { arg spread=0.8, pan=0, mul=10, fbamp=0.05, delaytime=0.5, ffreq=200, rq=0.6;
	var sig;
	var in;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	//sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	mul = mul.lag(0.5);
	pan = pan.lag(0.1);
	sig = in + Fb({ arg feedback; // this will contain the delayed output from the Fb unit
		var si;
		si = feedback * fbamp + in;
		//si = BPF.ar(feedback*fbamp + in, 2000+SinOsc.kr(0.4).range(-1500,900), 3.8).distort;
		ffreq = SinOsc.kr(0.5).range(50,700);
		//si = LPF.ar(si, ffreq);
		si = FreqShift.ar(si, SinOsc.kr(5.5).range(-10,10)*100) + si;
	},delaytime);
	sig = Splay.ar(sig,spread, 1, pan);
	sig;
	
});
Ndef(~name+++\fx).set(\delaytime, 1.00/~tempo);
~tempo = TempoClock.default.tempo;
);

// END
0.25/~tempo
Ndef(~name+++\fx).xset(\delaytime, 0.25/~tempo)
Ndef(~name+++\fx).xset(\fbamp, 0.92)
Ndef(~name+++\fx).xset(\fbamp, 0.92)
Ndef(~name+++\fx).xset(\fbamp, 0.62)
Ndef(~name+++\fx).xset(\delaytime, 0.28)
Ndef(~name+++\fx).set(\fbamp, 0.42)
Ndef(~name+++\fx).set(\fbamp, 0.22)
Ndef(~name+++\fx).set(\ffreq, 100)
Ndef(~name+++\fx).fadeTime = 2

~newfx.(\fx);

Ndef(~name+++\fx, { arg spread=0.8, pan=0, mul=10;
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	//sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	mul = mul.lag(0.5);
	pan = pan.lag(0.1);
	sig = CombL.ar(sig, 0.1,0.02+(SinOsc.ar([0.9,1,0.99,1.01,1.02]*mul)*0.001),4) + sig;
	sig = Splay.ar(sig,spread, 1, pan);
	sig;
	
});




b = Buffer.read(s,Platform.userAppSupportDir+/+"sounds/a11wlk01.wav")


(

{

var in = PlayBuf.ar(1,b);

var out = in + Fb({

arg feedback; // this will contain the delayed output from the Fb unit


// filter and distort the feedback signal.  

// Note that the input signal is fed in here as well:

BPF.ar(feedback*0.9 + in, 2000+SinOsc.kr(4).range(-1500,900), 3.8).distort;

// for fun effects, try changing the 0.8 to something greater than one

},0.1);

DetectSilence.ar(out,doneAction:2);

out!2;

}.play;

)



