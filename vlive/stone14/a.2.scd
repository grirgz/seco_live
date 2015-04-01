

~chat = ~name;
BufDef(\ukraine, "bruit1/07_ukraine.flac");
Ndef(~name+++\speed, { 1 });
Ndef(~name+++\speedamp, { 1 });
Ndef(~name+++\fade, { 1 });
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	//var bufnum = \bufnum.kr(BufDef(\ukraine));
	var speed = 1;
	var trigger = \trigger.tr(1);
	var pos = \pos.kr(0);
	var doneAction = 0;
	var loop = 1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var phase;

	var bufnum = LocalBuf(s.sampleRate * 4,2);
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack=0.01, decay=0.01, stutter;
	var env;
	bufnum.clear;

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


	sig = InFeedback.ar(\inbus.kr(BusDef(\in0, \audio)), 2); 
	
	bufgate = Duty.kr(1/4, 0, Dseq([
		0,0,0,0, 1,1,0,0,
		0,1,0,1, 0,1,0,0,
	],inf));
	choosetrig = bufgate > 0;
	stutter = DC.kr(1/4);
	stutter = Duty.kr(1/4, 0, Dseq(1/[
		1,2,4,8,
	],inf));
	stuttrig = TDuty.ar(stutter, choosetrig + Changed.kr(stutter), 1);
	recordtrig = Trig1.kr(choosetrig, 0.01);
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:0,trigger: recordtrig,doneAction:0);


	sig1 = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger:stuttrig, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: 0);
	sig1 = sig1 * env * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01), [sig, sig1]);
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


