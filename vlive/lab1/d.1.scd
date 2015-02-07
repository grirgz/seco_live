
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;

	bufnum = BufDef(\moeten);
	pos = 0;
	loop = 1;
	trigger = 1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * MouseX.kr(-1,1)*4, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
