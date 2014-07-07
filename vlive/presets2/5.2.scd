
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
	var degree = 8;

	freq = 440*1;


	ou = WhiteNoise.ar(10);
	ou = ou * ClipNoise.ar(1 * LFNoise1.kr(1,1,1.5));
	ou = ou | LFTri.ar(7.1,0,101);
	ou = ou & LFTri.ar(7.2,0,101);
	ou = ou | LFTri.ar(7.5,0,101);
	ou = ou & LFTri.ar(177.1 * [1,1.1,1.01,1.5],0,101);
	ou = ou * 0.017;
	//ou = RLPF.ar(ou, 2000);
	//baseffreq = baseffreq * LFNoise1.ar(1).range(0.7,1);
	//ou = DelayC.ar(ou, 0.1,0.001+LFNoise1.ar(1/8).range(0,0.001)) + ou;
	//ou = DelayC.ar(ou, 0.1,0.001+LFNoise1.ar(1/8).range(0,0.001)) + ou;
	//ou = AllpassL.ar(ou, 0.1,0.1,1.1)+ou;
	//ou1 = HPF.ar(ou, baseffreq);
	//ou1 = LPF.ar(ou1, baseffreq*4);
	//ou1 = ou;
	//ou2 = FreqShift.ar(ou, [-500,800]);
	//ou = ou1;
	ou = Splay.ar(ou, 1, amp);
});
);
(
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\ukraine));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\crepe));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\oeuf));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\bomb));
Ndef(~name+++\fx).set(\pos, 0.1);
Ndef(~name+++\fx).set(\amp, 0.2);
Ndef(~name+++\fx).set(\time_stretch, 0);
Ndef(~name+++\fx).set(\pitch_stretch, 2);
//Ndef(~name+++\fx).play;
Ndef(~name+++\fx).fadeTime=1;
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
