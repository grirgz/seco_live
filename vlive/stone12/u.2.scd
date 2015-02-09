
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	bufnum = BufDef(\scream, "vipere/scream.flac");
	bufnum = BufDef(\moeten);
	pos = 00.04;
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
	sig1 = ( (1..8)/8 * Duty.kr(1/~t, 0, Dseq([
		1/700,1,1,1,
		1/700,1/8000,1/100,1,
	],inf)) +1).lag(1);
	speed = SinOsc.ar(speed*1/16/4*~t).lag(0.1 * SinOsc.kr(1/14).range(1,4))*0.2 * sig1 + [ 0.3,0.4 ];
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	sig = sig * 1;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
