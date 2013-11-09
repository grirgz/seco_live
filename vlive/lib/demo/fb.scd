BusDef(\input, \audio, 2);
~buf = Buffer.alloc(s, s.sampleRate * 8.0, 2);

(
Ndef(\head, {
	var in = InFeedback.ar(BusDef(\input), 2);
	var sig;
	//in.poll(label:"in");
	RecordBuf.ar(in, ~buf, 0, 1, 1, 1, 1, 0,0);
	sig = PlayBuf.ar(2, ~buf, 1, loop:1);
	//sig.poll(label:"sig");
	sig;
}).play
)

(

	
	Pdef(\plop, Pbind(
		\freq, Pseq([500,400,300]/2,inf),
		\out, BusDef(\input),
		\dur, 1,
	)).play;
)

(
Ndef(\fx, { arg bpfreq=200, rq=0.3, amp=1, limlevel=0.9, delaytime=0.1, freqshift=0;
	var sig;
	sig = PlayBuf.ar(2, ~buf, 1, loop:1);
	//sig = BPF.ar(sig, bpfreq, rq);
	sig = DelayC.ar(sig, 0.1,delaytime.lag(0.1)) + sig;
	sig = Limiter.ar(sig, limlevel, 0.2);
	sig = FreqShift.ar(sig, freqshift);
	sig = sig.clip;
	RecordBuf.ar(sig, ~buf, 0, 1, amp, 1, 1, 0,0);
	sig;
})
)
Ndef(\fx).edit



(
Ndef(\buffb, { arg prelevel=1, bpfreq=200, rq=0.3, limlevel=0.9, delaytime=0.1, freqshift=0, rate=1, time=2, mixfx=1,
					reclevel=1, kf1=50, kf2=150, kf3=200, kf4=100, kres=0.05, kamp=0.05;
	var in = InFeedback.ar(BusDef(\input), 2);
	var sig;
	var infb;
	var sigin;
	var trig;
	var trig2;
	trig = Impulse.kr(1/time);
	trig2 = Impulse.kr(1);
	infb = PlayBuf.ar(2, ~buf, rate, trig, 0, loop:1);
	sigin = in + infb;
	sig = sigin;
	//bpfreq = EnvGen.kr(Env([0,1,1,0],[0.01,0.2,0.01]).circle, trig2) * bpfreq + 50;
	sig = BPF.ar(sig, bpfreq, rq);
	//sig = DelayC.ar(sig, 0.1,delaytime.lag(0.1)) + sig;
	sig = FreqShift.ar(sig, freqshift);
	sig = DynKlank.ar(`[[kf1,kf2,kf3,kf4], nil, [1,1,1,1]*kres], sig) * kamp;
	sig = sig.clip;
	sig = SelectX.ar(mixfx, [sigin, sig]);
	sig = Limiter.ar(sig, limlevel, 0.2);
	RecordBuf.ar(sig, ~buf, 0, reclevel, prelevel, 1, 1, trig,0);
	sig;
}).play
)

(
Ndef(\buffb, { arg prelevel=1, bpfreq=200, rq=0.3, limlevel=0.9, delaytime=0.1, freqshift=0, rate=1, time=2, mixfx=1,
					reclevel=1, kf1=50, kf2=150, kf3=200, kf4=100, kres=0.05, kamp=0.05, mixsat=1;
	var in = InFeedback.ar(BusDef(\input), 2);
	var sig, sig2;
	var infb;
	var sigin;
	var trig;
	var trig2;
	trig = Impulse.kr(1/time);
	trig2 = Impulse.kr(1);
	infb = PlayBuf.ar(2, ~buf, rate, trig, 0, loop:1);
	sigin = in + infb;
	sig = sigin;
	sig2 = sig.clip;
	sig = SelectX.ar(mixsat, [sig, sig2]);
	sig = SelectX.ar(mixfx, [sigin, sig]);
	sig = Limiter.ar(sig, limlevel, 0.2);
	RecordBuf.ar(sig, ~buf, 0, reclevel, prelevel, 1, 1, trig,0);
	sig;
}).play
)

(
Ndef(\buffb, { arg prelevel=1, bpfreq=200, rq=0.3, limlevel=0.9, delaytime=0.1, freqshift=0, rate=1, time=2, mixfx=1,
					reclevel=1, kf1=50, kf2=150, kf3=200, kf4=100, kres=0.05, kamp=0.05, mixsat=1, lpfreq=500, hpfreq=20, inlevel=1, mixk=1,
					mixdelay=1, gain=1;
	var in = InFeedback.ar(BusDef(\input), 2);
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
}).play
)
Ndef(\buffb).edit
Ndef(\buffb).set(\time, 0.0001);
(

	
	Pdef(\plop, Pbind(
		\freq, Pseq([500,400,300]/2,inf),
		\out, BusDef(\input),
		\sustain, 0.1,
		\dur, 1,
	)).play;
)
Pdef(\plop).stop


Spec.add(\freqshift, ControlSpec(-300,300,\lin,0,0))

(
Pdef(\kick, Pbind(
	\instrument, \stereosampler,
	\bufnum, BufDef(\snare).bufnum,
	\degree, Pseq([0],inf),
	\out, BusDef(\input),
	\sustain, 0.2,
	//\isRest, Veco(~name).isrest(16),
	\dur, 1,
	\amp, 0.3,
)).play
);
Pdef(\kick).quant = 0
Pdef(\kick).stop




Ndef(\buffb).fadeTime=5.5
Ndef(\buffb).map(\bpfreq, Ndef(\lfo1));
Ndef(\lfo1, { SinOsc.kr(1).range(50,500) })

~a = Ndef(\buffb).nodeMap.settings.deepCopy;
~b = Ndef(\buffb).nodeMap.settings.deepCopy;
~aa = Ndef(\buffb).nodeMap.deepCopy;
~bb = Ndef(\buffb).nodeMap.deepCopy;
Ndef(\buffb).nodeMap = ~aa.deepCopy
Ndef(\buffb).nodeMap = ~bb.deepCopy
Ndef(\buffb).fadeToMap
Ndef(\buffb).nodeMap.settings = ~a.deepCopy
Ndef(\buffb).nodeMap.settings = ~b.deepCopy
Ndef(\buffb).nodeMap.settings = ~a
Ndef(\buffb).nodeMap.settings = ~b
~a.deepCopy.keysValuesDo { arg key, val; Ndef(\buffb).nodeMap.settings[key] = val.deepCopy }
~b.deepCopy.keysValuesDo { arg key, val; Ndef(\buffb).nodeMap.settings[key] = val.deepCopy }

~buf.clear
NodeMap
Ndef
NodeProxy




(
Ndef(\plop, { arg freq1=100, freq2=50, ffreq=300, rq=0.3;
	var sig;
	sig = LFSaw.ar([freq1, freq2]);
	sig = RLPF.ar(sig, ffreq, rq);
	sig
}).play
)
Ndef(\plop).edit;

// change settings now

~a = Ndef(\plop).nodeMap.deepCopy;

// change settings now

~b = Ndef(\plop).nodeMap.deepCopy;


///////

Ndef(\plop).nodeMap = ~a.deepCopy
Ndef(\plop).nodeMap = ~b.deepCopy




b = Buffer.read(s,"sounds/a11wlk01.wav")


(

{

var in = PlayBuf.ar(1,b);

var out = in + Fb({

arg feedback; // this will contain the delayed output from the Fb unit


// filter and distort the feedback signal.  

// Note that the input signal is fed in here as well:

BPF.ar(feedback*0.8 + in, 2000, 3.8).distort;

// for fun effects, try changing the 0.8 to something greater than one

},0.6);

DetectSilence.ar(out,doneAction:2);

out!2;

}.play;

)


b.free


// Karplus-Strong style plucked string algorithm (see also Pluck)

(

{

var sig = Impulse.ar(0)!2; // stereo input - feedback will expand to two channels  

var freq = 200;

sig = FbL({arg fb; LPF.ar(LeakDC.ar(fb),8000)*0.99+sig;},1/freq);

DetectSilence.ar(sig,doneAction:2);

sig;

}.play

)


// Multiple instances in one SynthDef: three Karplus-Strong style algorithms in a row

(

{

var sig = Impulse.ar(0);

sig = FbL({arg fb; LPF.ar(LeakDC.ar(fb),8000)*0.99+sig;},1/300);

sig = FbL({arg fb; LPF.ar(LeakDC.ar(fb),8000)*0.99+sig;},1/400);

sig = FbL({arg fb; LPF.ar(LeakDC.ar(fb),8000)*0.99+sig;},1/500);

DetectSilence.ar(sig,doneAction:2);

sig!2;

}.play

)


// You can nest feedback loops inside each other

(

{

var sig = Decay.kr(Impulse.kr(1/2),0.6)*PinkNoise.ar(1!2);

sig = FbL({

arg fb1;

sig = sig + FbL({

arg fb2;

(OnePole.ar(LeakDC.ar(0-fb2),0.2)*0.99*1)+(fb1*9) / 10;

},1/250);

OnePole.ar(sig,-0.01);

},0.1);

sig;

}.play;

)



Main.version
