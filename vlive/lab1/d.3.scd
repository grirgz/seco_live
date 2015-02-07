
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;

	bufnum = BufDef(\moeten);
	pos = 00.4;
	loop = 1;
	trigger = 1;
	speed = Duty.kr(1/~t, 0, Dseq([
		1,2,0,4,
	],inf)).lag(4.5);
	speed = Duty.kr(1/2/~t, 0, Dseq([
		4,4,2,4,
	],inf)).lag(0.5)*~t*1;
	speed = SinOsc.ar(speed)*2+1.0;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
