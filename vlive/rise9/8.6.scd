
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

	freq = 440;
	freq = EnvGen.kr(Env([300,400],[8]/~t),1,doneAction:0);

	//ou = SinOsc.ar(freq*(2**(6/12))  * ([1,1/2,3/5,8/7] *.t [1.001,1.0051,1.0001]), Amplitude.ar(ou) * 15) * 2;
	ou1 = LFSaw.ar(4.468);
	ou2 = SinOsc.ar(freq*(2**(6/12))  * ([1,1/2,3/5,8/7] *.t [1.001,1.0051,1.0001]).flatten);
	ou = SinOsc.ar(freq * [1,1/2,1/3,1/4]+ Latch.ar(Amplitude.ar(ou1) * 25,Impulse.ar(1.2) ).lag(0.4), ou2 * 10) * 2;
	ou = (ou + ou2 * 7).tanh;
	baseffreq = baseffreq * LFNoise1.ar(1).range(0.7,1);
	ou = DelayC.ar(ou, 0.1,0.001+LFNoise1.ar(1/8).range(0,0.001)) + ou;
	ou1 = HPF.ar(ou, baseffreq);
	ou1 = LPF.ar(ou1, baseffreq*4);
	//ou1 = ou;
	ou2 = FreqShift.ar(ou, [-500,800] *.t [ 0.2,1,0.6 ]);
	ou = ou1;
	ou = ou * EnvGen.kr(Env([0,1,1,0],[0.25,7.5,0.05]/~t),1,doneAction:0);
	ou = Splay.ar(ou, 1, amp);
});
);
(
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\bomb));
Ndef(~name+++\fx).set(\pos, 0.1);
Ndef(~name+++\fx).xset(\amp, 0.4);
Ndef(~name+++\fx).set(\time_stretch, 0);
Ndef(~name+++\fx).set(\pitch_stretch, 2);
//Ndef(~name+++\fx).play;
)

// END

Ndef(~name+++\fx).clear
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
