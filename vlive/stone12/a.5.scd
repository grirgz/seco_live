
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	bufnum = BufDef(\scream, "vipere/scream.flac");
	pos = 00.34;
	loop = 1;
	trigger = 1;
	speed = Duty.kr(1/2/~t, 0, Dseq([
		1,2,0,2,
		0,6,0,4,
		4,0,0,2,
		2,0,8,4,
	],inf)/4).lag( Duty.kr(1/2/~t, 0, Dseq([
		1,2,0,0,
		0.2,0,0,0.2,
		0,0.1,0,0,
		0,0.1,0,2,
	],inf)));
	speed = SinOsc.ar(speed*4*~t).lag(0.1 * SinOsc.kr(1/14).range(1,4))+1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	sig = sig * 1;

	sig = HPF.ar(sig, 1700 * Duty.kr(1/~t, 0, Dseq([
		8,4,1,6,
	],inf)/8));
	sig = LPF.ar(sig, 7700 * Duty.kr(1/~t, 0, Dseq([
		1,8,4,3,
	],inf)/4));
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
