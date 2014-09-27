
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
	var seq1, seq2;
	var delay;
	var seq3;

	//bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	bufnum = BufDef.mono(\moeten, "voices/02_moeten.flac");
	pitch_stretch = 1;
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1).range(0,1) * 0.01 + 0.11;
	pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	pos = EnvGen.ar(Env([0,0.11,0.1131,0.45],[0.01,0.11,0.02]),TDuty.kr(1/2/~t,1,Dseq([1],inf)),doneAction:0);
	pos = SinOsc.kr(1/128*~t).range(0,0.01) + pos + 0.2;
	//pos = pos + 0.6;
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
	ou1 = HPF.ar(ou, 200 * SinOsc.kr(1/52*~t).range(0.5,3.1));
	//ou1 = ou;
	//ou1 = LPF.ar(ou1, 1200);
	ou1 = LPF.ar(ou1, 7200 * SinOsc.kr(1/32*~t).range(0.5,2.1));
	seq1 = Duty.kr(2/~t,0,Dseq([
		8,2,4,2,
		4,4,8,8,

	],inf));
	seq1 = Duty.kr(2/~t,0,Dseq([
		2,

	],inf));
	seq3 = Duty.kr(1/8/~t,0,Dseq([
		Dseq([
			1,0.4,0.8,0.2,
		],4),
		Dseq(
			14.collect{ arg x;
				Dseq(
					[ 1,0.4,0.8,0.2 ].blend(
						[ 1,0.4,0.8,0.2 ].rotate(1),
						x/14
					)
				)
			}
		,1),
	],inf)).lag(0.01);
	seq2 = Duty.kr(1/4/~t,0,Dseq([
		1,0.4,0.8,0.2,
	],inf)).lag(0.01);
	seq2 = seq2 * Duty.kr(1/1/~t,0,Dseq([
		0,0,0,
		Drand([
			Dseq([
				0,0,0,1,
			]),
			Dseq([
				0,0,0,1,
			],4),
			Dseq([
				0,0,0,1,
			],8),
			Dseq([
				0,0,1,0,
			]),

		])
	],inf)).lag(0.01);
	//amp = LFTri.kr(seq1*~t).range(1,0.2) * amp * seq2;
	amp = amp * 1.1;
	ou = ou1;
	//ou = RLPF.ar(ou, 5000 + SinOsc.kr(seq1).range(0,8200));
	delay = 2/1/~t;
	ou = Splay.ar(ou, 1, amp);
	ou = CombL.ar(ou, delay,delay,16) + ou;
	ou = ou * seq3 * LFNoise1.kr(1/48).range(1,1.3);
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
