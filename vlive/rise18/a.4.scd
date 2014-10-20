
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
	var mod1;

	freq = Duty.ar(8,0,Dseq([20],inf));

	mod1 = Duty.kr(1/~t, 0, Dseq([
		10,4,20,20,
	],inf));
	ou = LFSaw.ar(freq * (1/(1..8))) | SinOsc.ar(SinOsc.ar(freq * (1..8))+1*200,0,10);
	ou = SelectX.ar(
		Duty.kr(1/~t, 0, Dseq([
			0.51,0.4,0.11,0.2,
			0,0.3,0,0.3,
		],inf)).lag(1.1),
		[
			ou,
			ou | LFSaw.ar(SinOsc.kr(1/58).range(600,710) * (1/(1..8)),mul:mod1);
		]
	);
	//ou = Splay.ar(ou, 1, amp);
	ou = ou.sum;
	ou = BRF.ar(ou, 50 * (SinOsc.kr(1/(1..8)).unipolar *8));
	ou = ou * -25.dbamp;
	ou = ou.sum;
	ou = [ou, ou.tanh];
	ou = ou / 6;
	amp = amp * \gain.kr(1);
	ou = ou.collect({ arg sig,x;
		Pan2.ar(sig, SinOsc.kr((x+1*200)), amp);
	}).sum;
});
);

(
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\bomb));
Ndef(~name+++\fx).set(\pos, 0.1);
Ndef(~name+++\fx).set(\amp, 0.2);
Ndef(~name+++\fx).set(\time_stretch, 0);
Ndef(~name+++\fx).set(\pitch_stretch, 2);
//Ndef(~name+++\fx).play;
)

// END

Ndef(~name+++\fx, \zegrainer2).play;
Ndef(~name+++\fx).set( \mbufnum, BufDef.mono(\ukraine))
Ndef(~name+++\fx).set( \pos, 0.1)
Ndef(~name+++\fx).set( \amp, 0.4)
Ndef(~name+++\fx).set( \time_stretch, 0.4)

[10,20,30] *.t [1,1.001]

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
