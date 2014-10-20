
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
	var pwidth;
	var pfreq;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1;
	time_stretch = Duty.kr(1/2/~t,0,Dseq([
		1,2,0.1,0.1,
	],inf)).lag(0.1);
	pitch_stretch = Duty.kr(1/4/~t,0,Dseq([
		1,0.7,0.1,1,
	],inf)).lag(0.01);
	pos = 0.11;
	trate = 210;
	//pos = SinOsc.kr(1/64*~t).range(0,0.01) + pos;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(TDuty.kr(4/~t), time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);


	ou = LFSaw.ar(
		Duty.kr(1/1/~t, 0, Dseq([
			60,60, 60,80,
		],inf) 	
	) * [1,1.001,0.99]
	);
	pwidth = Duty.kr(1/4/~t, 0, Dseq([
		0.8,0.4,0.8,0.2,
	],inf)).lag(1);
	pfreq = Duty.kr(1/2/~t, 0, Dseq([
		80,120,200,120,
		180,120,200,120,
	],inf));
	ou = ou * LFPulse.ar(pfreq ,0,pwidth);
	ou1 = HPF.ar(ou, 200 * SinOsc.kr(1/52*~t).range(0.9,1.1));
	//ou1 = ou;
	ou1 = RLPF.ar(ou1, 
		SinOsc.kr(1/4*~t).range(100,120) * Duty.kr(
			Dseq([
				1/2,
			]/4,inf)/~t, 0, Dseq([

			1,1,1,1, 1,1,1,1,
			4,4,4,4, 1,1,1,1,
			1,1,1,1, 1,1,1,1,
			4,4,4,4, 4,4,4,4,

			1,1,1,1, 1,1,1,1,
			4,4,1,1, 1,1,1,1,
			1,1,2,2, 4,8,1,1,
			4,4,4,4, 4,4,4,4,
		],inf)).lag(0.1),
		0.1 * Duty.kr(Dseq([
				0.5,
			]/4,inf)/~t, 0, Dseq([
				1,0.5,
				2,2,2,2,
		],inf)).lag(0.1),
	);
	ou2 = LPF.ar(ou1, 1200) + DelayL.ar((ou1/4),0.1,0.001+[
		Duty.kr(1/2/~t, 0, Dseq([
			1,0,0,0,
			1,0,0,0,
			1,0,0,0,
			1,10,0,0,
		],inf))/10/~t,
		Duty.kr(1/~t, 0, Dseq([
			0,1,0,2,
		],inf))/10/~t,
	]);
	ou = ou2;
	amp = amp * Duty.kr(1/4/~t, 0, Dseq([
		1, 1, 1, 0,
		1, 0, 1, 0,
	],inf)).lag(0.1);
	ou = ou * amp / 4;

	//ou = CombL.ar(ou, 2, 1/2/~t,1/2/~t)/2 + ou;
	//ou = CombL.ar(ou, 2, 1/2/~t,1/~t) * Duty.kr(1/~t, 0, Dseq([
	//	1,0.7,0.8,0.7,
	//],inf)) + ou;

	ou = Splay.ar(ou, 1);
});
);
(
Ndef(~name+++\fx).fadeTime=1;
)

// END
~t
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

