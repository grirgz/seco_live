
(
Ndef(~name+++\fx, { arg pan=0, amp=0.1;
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var freq;
	freq = 380 * SinOsc.kr(1/23 * ( 1 + ( SinOsc.kr(1/12) * 1 ))).range(2,1);
	freq = freq * [0,3,7,0-12,7-12].midiratio;
	sig = SinOsc.ar(freq);
	sig = sig * 0.28;
	sig = Pan2.ar(sig, \pan.kr(0), amp).flop;
	sig;
});
)
