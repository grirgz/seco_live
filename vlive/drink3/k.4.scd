
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

	//freq = 440;

	//ou = SinOsc.ar(freq*(2**(6/12))  * ([1,1/2,3/5,8/7] *.t [1.001,1.0051,1.0001]), Amplitude.ar(ou) * 15) * 2;
	//ou1 = LFSaw.ar(190.468 * \freqfac.kr(1) * ((1..8)/Ndef.kr(\bla)+1));
	ou1 = LFSaw.ar(190.468 * \freqfac.kr(1) * ((1..8)/8*0.2+1));
	//ou2 = SinOsc.ar(freq*(2**(6/12))  * ([1,1/2,3/5,8/7] *.t [1.001,1.0051,1.0001]).flatten);
	ou = LFCub.ar(freq*([0,3,6,11].midiratio *.t [1.001,1.0051,1.0001,2,1/2,1/4]).flatten);
	ou = ou * LFSaw.ar(freq*((2**([0]/12))).flatten * SinOsc.kr(1/8).range(1,2.12));
	ou.postln;

	//ou = ou.collect( { arg si, x;
	//	si * SinOsc.kr(1/(x+1)+1.0.rand).unipolar
	//});

	//ou = SinOsc.ar(freq * [1,1/2,1/3,1/4]+ Latch.ar(Amplitude.ar(ou1) * 25,Impulse.ar(1.2) ).lag(0.4), ou2 * 10) * 2;
	//ou = (ou1 + ou2 * 7).tanh;
	//baseffreq = baseffreq * LFNoise1.ar(1).range(0.7,1);
	//ou = DelayC.ar(ou, 0.1,0.001+LFNoise1.ar(1/8*(1..8)).range(0,0.001)) + ou;
	//ou = DelayC.ar(ou, 0.1,0.001+SinOsc.ar([8,8.1012]).range(0,0.0001)) + ou;
	ou = DelayC.ar(ou, 0.1,0.001+SinOsc.ar(1/[8,8.1012]).range(0,0.01)) + ou;
	//ou1 = HPF.ar(ou, baseffreq);
	ou = RLPF.ar(ou, (freq*8*(2**([0,4,9,12]/12))).clip(50,18000), 0.1);
	ou = ou;
	amp = Veco(~name).amp_level * amp;
	//ou2 = FreqShift.ar(ou, [-500,800] *.t [ 0.2,1,0.6 ]);
	ou = ou;
	ou = ou / 4;
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
Ndef(~name+++\fx).set(\freq, 230*2*(2**(2/12)));

2.midiratio
2**(2/12)


Ndef(\bla, {4})
Ndef(\bla, {SinOsc.kr(1).range(0.1,8)})
Ndef(\bla, {XLine.kr(1,8,4)})
Ndef(~name+++\fx).map(\freqfac, Ndef(\blaf, {SinOsc.kr(3).range(0.4,8)}).asMap)
Ndef(~name+++\fx).map(\freqfac, Ndef(\blaf, {LFNoise1.kr(3).range(1.4,4)}).asMap)
Ndef(~name+++\fx).set(\freqfac, 1)



Ndef(~name+++\fx).quant = 1
Ndef(~name+++\fx).play
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).edit

Veco.gui

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
