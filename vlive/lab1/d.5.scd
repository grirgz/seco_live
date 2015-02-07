
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	bufnum = BufDef(\scream, "vipere/scream.flac");
	pos = 00.34;
	loop = 1;
	trigger = 1;
	speed = Duty.kr(1/~t, 0, Dseq([
		1,2,0,4,
	],inf)).lag(4.5);
	speed = Duty.kr(1/2/~t, 0, Dseq([
		4,1,8,4,
		3,2,4,2,
	],inf)).lag(0.1)*~t*1;
	speed = SinOsc.ar(speed)*1.1+
	Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
		-1,0,2,1,
	],inf)).lag(0.1) / 4;
	speed = SinOsc.ar(speed)*1.1+
	Duty.kr(1/2/~t, 0, Dseq([
		-1,0,2,1,
	],inf)).lag(0.1) / 2;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	sig = sig * 1;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
