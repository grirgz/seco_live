

~chat = ~name;
BufDef(\ukraine, "bruit1/07_ukraine.flac");
Ndef(~name+++\speed, { 1 });
Ndef(~name+++\speedamp, { 1 });
Ndef(~name+++\fade, { 1 });
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum = \bufnum.kr(BufDef(\ukraine));
	var speed = 1;
	var trigger = \trigger.tr(1);
	var pos = \pos.kr(0);
	var doneAction = 0;
	var loop = 1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var phase;

	speed = SinOsc.kr(4*~t);
	speed = SelectX.kr( 
		Duty.kr(1/~t, 0, Dseq([
			1,0,0,0,
		],inf)),
		[
			-1,
			speed,
			1
		]
	);
	speed = Ndef.kr(~name+++\speed,1) * Ndef.kr(~name+++\speedamp, 1);
	speed = speed.lag(\speedlag.kr(0));

	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = SinOsc.ar(2*~t).lag(0.1) * 5000; 
	//sig = BufRd.ar(2, bufnum, phase);
	sig1 = Duty.kr(1/4/~t, 0, Dseq([
		8,4,4,2,
	],inf));
	//sig = sig * ( LFCub.kr(sig1*~t).range(0,1) );
	sig = sig * Ndef.kr(~name+++\fade,1);
	sig = sig * 1.2;
	sig = sig * \ampcomp.kr(1);

	
	sig = sig * 6;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

(
~myq = 1/8;
Ndef(~name+++\speed).quant = ~myq;
Ndef(~name+++\fade).quant = ~myq;
Ndef(~name+++\pos).quant = ~myq;
Ndef(~name+++\trigger).quant = ~myq;
Ndef(~name+++\speedamp).quant = ~myq;
);

~set_macro.(\k1, Ndef(~name+++\fx), \speedlag, ControlSpec(0.0001,0.8,\exp));

// END


