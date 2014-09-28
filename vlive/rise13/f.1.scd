
(
Ndef(~name+++\fx, { arg amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;
	var delay;
	var end1, end2, end3, end4;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1 * LFNoise1.kr(8).range(0.51,2.01);
	pos = 0.3 + LFNoise1.kr(8).range(0,0.01);
	dur = 0.01 * LFNoise1.kr(8).range(0.51,2.01);
	clk = Impulse.kr(100 * LFNoise1.kr(1/8).range(0.5,1.01)) * Duty.kr(1/2/~t, 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf));
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);

	end1 = ou;
	delay = 1/~t;
	ou = DelayL.ar(ou, delay, delay);
	//ou = HPF.ar(ou, 1200 * SinOsc.kr(1/52*~t).range(0.5,3.1));
	ou = FreqShift.ar(ou, 100);
	end2 = ou;
	//delay = 0.1;
	ou = DelayL.ar(ou, delay, delay);
	//ou = LPF.ar(ou, 7200 * SinOsc.kr(1/32*~t).range(0.5,2.1));
	ou = FreqShift.ar(ou, -700);
	end3 = ou;

	ou = DelayL.ar(ou, delay, delay);
	//ou = LPF.ar(ou, 7200 * SinOsc.kr(1/32*~t).range(0.5,2.1));
	ou = FreqShift.ar(ou, -700);
	end4 = ou;
	//amp = LFTri.kr(1*~t).range(1,0.2) * amp;
	ou = end1 + end2 + end3 + end4;
	ou = Splay.ar(ou, 1, amp);
});
);
(
Ndef(~name+++\fx).fadeTime=1;
)

// END
BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
Ndef(~name+++\fx, \zegrainer2).play;
Ndef(~name+++\fx).set( \mbufnum, BufDef.mono(\ukraine))
Ndef(~name+++\fx).set( \pos, 0.1)
Ndef(~name+++\fx).set( \amp, 0.4)
Ndef(~name+++\fx).set( \time_stretch, 0.4)


Ndef(~name+++\fx).clear
Pdef(~name).clear
(
Ndef(~name+++\fx2, { arg amp=0.1, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = gdur/trate;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos + TRand.kr(0, randframes, randclk);
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Splay.ar(ou, 1, amp);
});
Ndef(~name+++\fx2).set(\mbufnum, BufDef.mono(\ukraine));
Ndef(~name+++\fx2).set(\pos, 0.1);
Ndef(~name+++\fx2).set(\time_stretch, 0);
Ndef(~name+++\fx2).play;
)
