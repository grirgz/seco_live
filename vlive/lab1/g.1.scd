
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;
	var phasor;
	var time_stretch =1;
	var finepos = 0;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	bufnum = BufDef(\march);
	bufnum = BufDef(\amen, "vipere/amenbreak.wav");
	bufnum = BufDef(\ukraine, "bruit1/07_ukraine.flac");
	bufnum = BufDef(\scream, "vipere/scream.flac");
	bufnum = BufDef(\moeten);
	pos = 00.14 * BufFrames.kr(bufnum);
	loop = 1;
	trigger = 1;
	speed = Duty.ar(1/2/~t, 0, Dseq([
		1/2,1,4,3,
	],inf)).lag(0.5)*1;
	speed = SinOsc.ar(speed*~t)* Duty.kr(1/2/~t, 0, Dseq([
		4,2,1,1/2,
	],inf));
	phasor = Phasor.ar(Impulse.kr(2*~t), speed, 0,  BufFrames.kr(bufnum), Duty.kr(1/2/~t, 0, Dseq([
		1/4,1/8,1/4,1/2,
	],inf))*s.sampleRate);
	//phasor = Select.ar(time_stretch.sign + 1 /2, [
	//	pos - phasor,
	//	phasor + pos,
	//]).poll;

	pos = pos + phasor  + finepos;
	//pos = pos + ( Duty.ar(1/~t, 0, Dseq([
	//	1,0,0,0,
	//],inf)).lag(4.4)*100000 );
	pos.poll;
	//pos.poll;
	sig = BufRd.ar(2, bufnum, pos );
	//sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	sig = sig * 2;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
