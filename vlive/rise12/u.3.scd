
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

	amp = 0.5;
	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1;
	time_stretch = 1;
	trate = SinOsc.kr(1*~t).range(10,200);
	pos = SinOsc.kr(1).range(0,1) * 0.01 + 0.11;
	pos = EnvGen.ar(Env([0,0.01,0.02,0.03,0.05],[0.1,0.1,0.1,0.1]),LFPulse.kr(1/4*~t),doneAction:0);
	pos = 0;
	//pos = pos + 0.20 + Duty.kr(4/~t,0,Dseq([0,0.04],inf));
	//pos = pos + 0.24;
	//pos = pos + 0.60;
	pos = Duty.kr(4/~t,0,Dseq([0.24,0.60],inf));
	//pos = pos + (LFPulse.kr(1/8*~t)/10);
	//pos = pos + (LFPulse.kr(1/16*~t)/7);
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(LFPulse.kr(2/1*~t), time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou1 = HPF.ar(ou, 280);
	//ou1 = ou;
	ou2 = LPF.ar(ou1, 8200);
	ou = ou2;
	ou = ou * Duty.kr(1/4/~t,0,Dseq([
			Dseq([
				0,0,0,0, 1,0,0,0,
			]),
		Drand([
			Dseq([
				0,0,0,0, 1,0,1,0,
			]),
			Dseq([
				0,0,0,0, 1,0,0,0,
			]),
			Dseq([
				0,0,0,0, 1,0,0,0,
			]),
			Dseq([
				0,0,0,0, 1,0,0,0,
			]),
			Dseq([
				0,0,1,0, 1,0,0,0,
			]),
		])
	].rotate(0),inf)).lag(0.1);
	ou = Splay.ar(ou, 1, amp);
	ou = Limiter.ar(ou, 0.8);
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
