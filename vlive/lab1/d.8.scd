
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;

	bufnum = BufDef(\scream, "vipere/scream.flac");
	bufnum = BufDef(\crepe, "field/crepe.flac");
	bufnum = BufDef(\march);
	bufnum = BufDef(\ukraine, "bruit1/07_ukraine.flac");
	bufnum = BufDef(\amen, "vipere/amenbreak.wav");
	pos = 00.14;
	loop = 1;
	trigger = 1;
	speed = Duty.kr(1/2/~t, 0, Dseq([
		2,1,0.2,0.3,
	],inf)).lag( Duty.kr(1/~t, 0, Dseq([
		1,2,0,0,
		0.2,0,0,0.2,
	],inf)))/2;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	sig = sig * 2;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
