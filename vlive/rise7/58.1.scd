
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4),\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2)
	);

	sig;
})


// END

//b = Buffer.alloc(s, s.sampleRate * 0.125 * 9,2);
(
//Ndef(~name+++\fx, { arg in, mix=0.5, amp=1,
Ndef(~name+++\fx, { arg mix=0.5, preamp=1, amp=1, delay= 0.5, tail=1;
	var sigin, sig;
	var numdelay = 8;
	var bufnum;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	//sigin = SinOsc.ar(200) !2;
	//bufnum = b;
	sig = sigin;
	sig = Greyhole.ar(sig, delay,\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2))+sig;
	sig = sig * 1;
	//sig = sigin;
	//sig[0] = DelayN.ar(sig[0], delays, delays) * [del1, del2, del3, del4, del5, del6, del7, del8];
	//sig[1] = DelayN.ar(sig[1], delays, delays) * [del1, del2, del3, del4, del5, del6, del7, del8];
	//sig[0] = sig[0].sum;
	//sig[1] = sig[1].sum;
	sig.postln;
	//sig.poll;
	//sig = sig * EnvGen.ar(Env.asr(0.0001,1,0.0001),gate,doneAction:2);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * amp;
	//Out.ar(out, sig);
});
)
