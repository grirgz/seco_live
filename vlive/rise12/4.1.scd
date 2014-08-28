
(
Ndef(~name+++\fx, { arg amp=0.8, pan=0, freq=200, mbufnum,
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
	var baseffreq = 1000;
	var env1;

	gdur = 5;
	trate = 4;
	amp = 0.1;
	bufnum = BufDef.mono(\ukraine);
	time_stretch = 0.91;
	pitch_stretch = 0.81;
	pos = 0.4;
	clk = Impulse.kr(14);
	dur = 0.2;
	pan = 0;
	sr = SampleRate.ir;
	phasor = Phasor.ar(Impulse.kr(1*~t), time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1,0);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos;
	//pos = 0;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	baseffreq = SinOsc.kr(1/4 * ~t).range(100,10000);
	ou1 = HPF.ar(ou, baseffreq);
	ou1 = LPF.ar(ou1, baseffreq+4000);
	//ou1 = ou;
	ou2 = FreqShift.ar(ou, [-500,800]);
	//ou = SinOsc.ar(100);
	ou = ou1;
	ou = ou * 8;
	env1 = Duty.kr(1/~t,0, Dseq([0,0,1,0, 1,0,1,0],inf));
	ou = ou * EnvGen.ar(Env.adsr(0.01,0.1,1,0.7),env1,doneAction:0);
	//ou = ou * XLine.kr(1, 0.1,32);
	ou = Splay.ar(ou, 1, amp);
});
);

// END

Ndef(~name+++\fx).play;
Ndef(~name+++\fx, \zegrainer2).play;
Ndef(~name+++\fx).set( \mbufnum, BufDef.mono(\ukraine))
Ndef(~name+++\fx).set( \pos, 0.1)
Ndef(~name+++\fx).set( \amp, 0.4)
Ndef(~name+++\fx).set( \time_stretch, 0.4)
Ndef(~name+++\fx).fadeTime = 1;


Ndef(~name+++\fx).clear
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
