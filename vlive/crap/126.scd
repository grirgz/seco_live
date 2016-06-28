
{ SinOsc.ar(200) ! 2 * 0.1}.play;

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(MouseY.kr(0,1000) * ( 1 + ( SinOsc.ar(100 * SinOsc.ar(1) *  (1..8))) * MouseX.kr(0,0.1) * SinOsc.ar(1/5).range(0,1)  ));
	sig = SinOsc.ar(MouseX.kr(50,1000, \exponential)) ;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig1.kr(Impulse.kr(3),1/2), doneAction:0);
	sig = RLPF.ar(sig, MouseX.kr(100,10000));
	sig = CombL.ar(sig, 1,MouseX.kr(0,1), MouseY.kr(0,1)) + sig;
	sig = sig * 30;
	sig = sig.tanh;
	sig = sig * 30;
	sig = sig.tanh;
	sig = Pan2.ar(sig, pan, amp) * 1;
}).play;
);
