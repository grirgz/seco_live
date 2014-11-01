
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

	[~t,128/60].debug("tempo");
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
	) * Duty.kr(2/~t, 0, Dseq([
		[1,4.001,0.99,4.01],
		[1,4.001,0.99,4.01],
		[1,4.001,0.99,4.01],
		[1,2.001,3.99,2.01],
	],inf))
	);
	pwidth = Duty.kr(1/2/~t, 0, Dseq([
		//0.8,0.4,0.8,0.2,
		Dseq([
			0.8,0.4,0.8,0.2,
		],8),
		Dseq([
			0.1,0.5,0.5,0.5
		],8),
	],inf)).lag(4);
	pfreq = Duty.kr(1/2/~t, 0, Dseq([
		780,100,230,1120,
		780,100,230,1120,
		780,100,230,1120,
		Drand([70,100,1100,7000,4100]),100,230,1120,
	],inf)).lag(1/2/~t);
	pfreq = 7010;
	ou = ou * LFPulse.ar(pfreq ,0,pwidth);
	ou1 = HPF.ar(ou, 100 * SinOsc.kr(1/52*~t).range(0.5,3.1));
	//ou1 = ou;
	ou1 = RLPF.ar(ou1, 
		Duty.kr(
			Dseq([
				1,
			]/4,inf)/~t, 0, Dseq([
				50 * Dser([
					Dseq([
						1,2,3,4,
						5,6,7,8,
					],2),
					Dseq([
						1,2,3,4,
						5,6,7,8,
					]+8,2),

				],64),
				Dseq( 320 * [
					Drand([1,2,4]),1,Drand([1,4,2]),1,
					1,1,Drand([1,2,4]),1,
					4,4,4,4,
					1,1,1,1,
					
					Drand([1,2,4]),1,Drand([1,4,2]),1,
					Drand([1,2,4]),Drand([1,2,4]),Drand([1,2,4]),1,
					4,4,Drand([1,2,4]),4,
					1,1,Drand([1,2,4]),1,
					
					Drand([1,2,4]),1,Drand([1,4,2]),1,
					1,1,Drand([1,2,4]),1,
					4,4,4,4,
					Drand([1,2,4]),1,1,1,
					
					Drand([1,2,4]),1,Drand([1,4,2]),1,
					Drand([1,2,4]),Drand([1,2,4]),Drand([1,2,4]),1,
					Drand([1,2,4]),4,Drand([1,2,4]),4,
					1,1,Drand([1,2,4]),1,
				],1),
		],inf)).lag(0.1),
		0.1 * Duty.kr(Dseq([
				0.5,
			]/4,inf)/~t, 0, Dseq([
			1,4,3,4,
			4,4.64,1,6,
		],inf)).lag(0.1),
	);
	ou2 = LPF.ar(ou1, 800) + DelayL.ar((ou1/4),0.1,0.001+[
		Duty.kr(1/~t, 0, Dseq([
			1,0,0,0,
		],inf))/100,
		Duty.kr(1/~t, 0, Dseq([
			0,1,0,2,
		],inf))/100,
	]);
	ou = ou1;
	amp = amp * \gain.kr(1);
	amp = amp * Duty.kr(1/4/~t, 0, Dseq([
		1, 1, 1, 1,
	],inf)).lag(0.1);
	ou = ou * amp / 2;

	//ou = CombL.ar(ou, 2, 1/2/~t,1/2/~t)/2 + ou;
	//ou = CombL.ar(ou, 2, 1/2/~t,1/~t) * Duty.kr(1/~t, 0, Dseq([
	//	1,0.7,0.8,0.7,
	//],inf)) + ou;

	ou = Splay.ar(ou, 1);
});
);

// END
Ndef(~name+++\fx).fadeTime=0.1;
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

