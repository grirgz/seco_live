
//////////////////////////////////////////////////////////////////////////////
//////////// Fb quark


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

//////////////////////////////////////////////////////////////////////////////
//////////// FbNode

(
Ndef(\demo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fbnode;
	sig = SinOsc.ar(freq);
	fbnode = FbNode(1);
	sig = sig + ( fbnode * \fb.kr(0.99) );
	sig = DelayL.ar(sig, 0.1, 0.1);
	fbnode.write(sig);

	sig = Pan2.ar(sig, pan, amp);
}).play;
);
