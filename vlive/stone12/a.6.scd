
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	bufnum = BufDef(\scream, "vipere/scream.flac");
	bufnum = BufDef(\moeten);
	pos = 00.04;
	loop = 1;
	trigger = Impulse.kr(1);
	speed = SinOsc.ar(4*~t).lag(0.1 * SinOsc.kr(1/14).range(1,4))* Duty.kr(1/~t, 0, Dseq([
		1,4,2,8,
	],inf)) + Duty.kr(1/~t, 0, Dseq([
		1,0,-1,0,
		0,2,-1,0,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 4;
	sig = sig * 1;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
