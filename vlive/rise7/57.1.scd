
//b = Buffer.alloc(s, s.sampleRate * 0.125 * 9,2);
(
//Ndef(~name+++\fx, { arg in, mix=0.5, amp=1,
Ndef(~name+++\fx, { arg mix=0.5, preamp=1, amp=1, delay= 0.5, tail=5;
	var sigin, sig;
	var numdelay = 8;
	var bufnum;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	//sigin = SinOsc.ar(200) !2;
	//bufnum = b;
	sig = sigin;
	sig = sig * SinOsc.ar(100);
	sig = CombL.ar(sig, delay,delay,tail)+sig;
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


// END

~set_macro.(\k1, Ndef(~name+++\fx), \delay, \delay.asSpec)

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop

Ndef(\multitap8).edit
Ndef(\fx2).edit
Ndef(\fx2).play

 metadata:(specs:(
	del1: \amp.asSpec,
	del2: \amp.asSpec,
	del3: \amp.asSpec,
	del4: \amp.asSpec,
	del5: \amp.asSpec,
	del6: \amp.asSpec,
	del7: \amp.asSpec,
	del8: \amp.asSpec,
	//workbufnum: (numChannels:2, numFrames: Buffer.alloc(s, s.sampleRate * 0.125 * 9,2),
)
)
