
(
Ndef(~name+++\fx, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
	],inf)).lag(0.1);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * env1) * 1 )));
	sig = LPF.ar(sig, 700);
	sig = Pan2.ar(sig, pan, amp);
})
);
