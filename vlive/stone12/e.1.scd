
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = [0,3,7].midiratio * 50 * 4;
	freq = Duty.kr(1/~t, 0, Dseq([
		[0,3,7,15]
	],inf)).midiratio * 50 * 4 *.t [1/4,8/9,1,2];
	sig = LFCub.ar(freq);
	sig = sig.collect({ arg isig, x;
		//isig = isig - Latch.ar(LPF.ar(isig.clip(0.1),100), Impulse.ar(50));
		//isig = LPF.ar(isig, 200*12);
		isig = ( isig < 0.03 ) * isig;
		isig = isig * DelayL.ar(isig,1,0.1 * SinOsc.kr(1/14).range(1,1.1));
		isig = isig * DelayL.ar(isig,1,0.041 * SinOsc.kr(1/44).range(1,1.1));
		isig = SelectX.ar( SinOsc.kr(x+1/10).range(0,1) * (isig.size-1), isig);
		//isig = isig * SinOsc.kr(1/17).range(0,1);
	});

	sig.debug("sig");
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
