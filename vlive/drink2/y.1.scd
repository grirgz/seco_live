
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

	trate = EnvGen.ar(Env([12,8,2],[1]).circle,1,doneAction:0);
	gdur = EnvGen.ar(Env([2,9.78,2],[6]).circle,1,doneAction:0);
	gdur = 0.3;
	trate = 80;
	pitch_stretch = [1,2,3,0.5,8,9] * (LFNoise1.ar([1/2,8,1]).range(0.8,[2,1,0.5]));
	pitch_stretch = [1];
	time_stretch = [0.051,0.01,0];
	time_stretch = 0.81;
	pos = LFNoise1.kr([1/2]).range(0,0.001)+[0.1,0.2].rand + 0.4;
	pos = 0.8;
	randclk = Impulse.kr(randrate * trate);
	dur = gdur/trate;
	dur = 1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(Impulse.kr(8), time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1, 0);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);
	pos = 0.051;
	phasor = SinOsc.ar(0.02).range(0,1) * 0.00001 + pos;
	phasor = phasor + (SinOsc.ar(0.01).range(0,1) * 0.000001);
	//phasor = 0.1;
	//phasor = LFPulse.ar(1*~t).range(0,1) * 0.1 + phasor;
	//phasor = Duty.kr(1/4/~t, 0, Dseq([
	//	1,0,0.5,0,
	//].collect({ arg x; if(x.coin) { 2 } { 0 }; x; })/10,inf)) + phasor;
	//phasor = Duty.kr(1/4/~t, 0, Dseq([
	//	0,0,2,0, 0,0,2,0,
	//	0,0,2,0, 2,0,2,0,
	//]/14,inf)) + phasor;
	//phasor = 0.1;
	phasor = Duty.kr(1/2/~t, 0, Dseq([
		Dseq([
			0,0,0,0,
			Drand([
				Dseq([
					0.1,0,0.2+Diwhite(0.0,0.05,1),0,
				]),
				Dseq([
					0,0,0.2+Diwhite(0.0,0.05,1),0,
				]),
				Dseq([
					0,0.1,0.2+Diwhite(0.0,0.05,1),0,
				]),
				Dseq([
					0,0.1,0.0+Diwhite(0.0,0.05,1),0,
				]),
			])
		],7),
		0,0,0,0,
		Drand([
			Dseq([
				0.0,0.8,0.2,0,
			]),
			Dseq([
				0.4,0,0.2,0,
			]),
		])
	],inf)).lag(0) + phasor;

	pitch_stretch = 1;
	pitch_stretch = Duty.kr(1/4/~t, 0, Dseq([
		2,0,0,0, 0,0,0,0,
		2,0,1,0, 0,0,0,0,
		0,0,2,0, 0,0,0,0,
		2,0,1,0, 0,0,0,0,
	],inf)) + 1.1;
	pitch_stretch = Duty.kr(1/4/~t, 0, Dseq([
		2,0,0,0, 0,0,0,0,
		2,0,1,0, 0,0,0,0,
		0,0,2,0, 0,0,0,0,
		2,0,1,0, 0,0,0,0,
	],inf)) + 1;
	pitch_stretch = Duty.ar(8/~t, 0, Dseq(~cdegcps.([0,2,1,0], 6, 60.midicps, Scale.minor),inf))/60.midicps * pitch_stretch;

	//pos = phasor * BufDur.kr(bufnum) + finepos + TRand.kr(0, randframes, randclk);
	finepos = 0;
	dur = 0.051;
	trate = 32 * ~t;
	//phasor = 0.4;
	clk = Impulse.kr(trate);
	pos = phasor * BufDur.kr(bufnum) + finepos;
	//ou = TGrains2.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1, 0.001,0.001);
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//baseffreq = XLine.kr(9000, 10,8);
	baseffreq = 1100;
	ou1 = HPF.ar(ou, baseffreq);
	ou1 = LPF.ar(ou1, baseffreq+2000);
	//ou1 = ou;
	ou2 = FreqShift.ar(ou, [-500,800]);
	ou = ou1;
	ou = ou * 4;
	ou = Limiter.ar(ou, 0.4);
	ou = ou * 2;
	//ou1 = LPF.ar(ou1, baseffreq+1000);
	//ou = ou * XLine.kr(1, 0.1,32);
	ou = Splay.ar(ou, 1, amp);
});
);
(
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\crepe));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\bomb));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\oeuf));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\ukraine));
Ndef(~name+++\fx).set(\pos, 0.1);
Ndef(~name+++\fx).set(\amp, 0.4);
Ndef(~name+++\fx).set(\time_stretch, 0);
Ndef(~name+++\fx).set(\pitch_stretch, 2);
//Ndef(~name+++\fx).play;
Ndef(~name+++\fx).fadeTime=1;
)

// END

Ndef(~name+++\fx).quant = Pdef.defaultQuant;

Ndef(~name+++\fx).play;
Ndef(~name+++\fx, \zegrainer2).play;
Ndef(~name+++\fx).set( \mbufnum, BufDef.mono(\ukraine))
Ndef(~name+++\fx).set( \pos, 0.1)
Ndef(~name+++\fx).set( \amp, 0.4)
Ndef(~name+++\fx).set( \time_stretch, 0.4)


Ndef(~name+++\fx2).clear
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
