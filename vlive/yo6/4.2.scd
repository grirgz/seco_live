
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

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1;
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1).range(0,1) * 0.01 + 0.11;
	pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/4*~t),doneAction:0);
	pos = 0.3 + Duty.kr(1/2/~t,0,Dseq([
		0,0.01,0.23,0.01,
		0,0.41,0.23,0.01,
	],inf)).lag(0.14);
	pos = 0.1  + EnvGen.ar(Env([0.11,0.1,0.11,0.15],[0.01,0.1,2]),TDuty.kr(1/8/~t,0,Dseq([1,1,1,1],inf)),doneAction:0);
	pos = SinOsc.kr(1/64*~t).range(0,0.01) + pos;
	//amp = amp * Duty.kr(1/1/~t,0,Dseq([0,0.01,0.3,0.01],inf));
	amp = amp * EnvGen.ar(Env([0,1.0,1.01,0.0],[0.01,0.111,0.02]),TDuty.kr(1/4/~t,0,Dseq([
		1,0,1,0,
		1,0,1,0,
	],inf)),doneAction:0);
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//ou1 = HPF.ar(ou, 2200 * SinOsc.kr(1/52*~t).range(0.5,3.1));
	ou1 = HPF.ar(ou, 2200 * SinOsc.kr(1/52*~t).range(0.9,1.1));
	//ou1 = ou;
	//ou1 = LPF.ar(ou1, 1200);
	//ou1 = LPF.ar(ou1, 1200 * SinOsc.kr(1/32*~t).range(0.5,3.1));
	ou1 = LPF.ar(ou1, 17200 * SinOsc.kr(1/32*~t).range(0.9,1.1));
	ou = ou1;
	//ou = ou * 0.01;
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
