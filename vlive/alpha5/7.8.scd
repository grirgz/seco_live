
(
Ndef(~name+++\fx, { arg freq=90, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var freq2;
	var pitch;
	env1 = EnvGen.kr(Env([10,80,40],[0.01,0.08]), Impulse.kr(1*~t));
	pitch = Duty.kr(1/~t, 0, Dseq([
		0,0,3,3,
		0,0,2,2,
	],inf));
	sig = SinOsc.ar( env1 * ( 2 ** (pitch/12) ) * [1,2,1.001] * 4); 
	sig = sig + LFSaw.ar( 80 * [1,2] * ( 2 ** (pitch/12) ), mul: SinOsc.kr([2,4]*~t).range(0,1) );
	sig1 = FreqShift.ar(sig, 1)+sig;
	sig2 = RLPF.ar(sig, 100 * SinOsc.kr(1/8*~t).range(8,1),0.1);
	sig = SelectX.ar( SinOsc.kr(4*~t).range(0,1)*2, [sig, sig1, sig2]);
	sig = BRF.ar(sig, freq * SinOsc.kr(1*~t).range(1/2,4), 0.8);
	sig = LPF.ar(sig, 1000);
	env1 = Duty.kr(1/~t, 0, Dseq([
		1,4,1/2,8,
	],inf));
	sig = FreqShift.ar(sig, 411 * SinOsc.kr(env1*~t).range(0,1))+sig;
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,

		0,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,

		1,1,0,1,
		1,1,1,1,
		1,0,1,1,
		1,1,1,1,

		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,0,0,
	],inf));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)*~t).range(-1,1), amp).flop;
	sig = sig / 4;
})
);

