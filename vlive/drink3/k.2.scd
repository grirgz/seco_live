
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
	var baseffreq = 2000;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var chord;
	baseffreq = \baseffreq.kr(1000);

	//freq = 440;

	chord = Select.kr(\chord.kr(0), [
		[0,3,5,7].midiratio,
		[0,2,4,6].midiratio,
		[0,2,5,9].midiratio,
		[11,2,5,9].midiratio,
	]).lag(0.9);

	freq = freq* (chord *.t [1.001,1.0051,1.0001]).flatten;

	ou = LFSaw.ar(freq);
	ou = SinOsc.ar(freq, ou * \fma1.kr(1));
	ou = SinOsc.ar(freq, ou * \fma2.kr(1));
	baseffreq = baseffreq * LFNoise1.ar(1).range(0.7,1);

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = ou;
	ou = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);

	ou1 = HPF.ar(ou, baseffreq);
	ou1 = LPF.ar(ou1, (baseffreq*\ffreqfac.kr(4)).clip(10,18000));
	//sig2 = ou1;
	ou = ou1;

	//ou1 = ou;

	sig1 = FreqShift.ar(ou, [-500,800]*\freqshift.kr(1));
	ou = SelectX.ar(\mix.kr(0.5), [ou, sig1]);

	sig1 = DelayC.ar(ou, 0.1,0.001+(LFNoise1.ar(1/8).range(0,0.001)*\delfac.kr(1))) + ou;
	ou = SelectX.ar(\delmix.kr(0.5), [ou, sig1]);

	amp = amp * \gain.kr(1).poll;
	ou = Splay.ar(ou, 1, amp);
});
);
(
Ndef(~name+++\fx).xset(\amp, 0.2);
//Ndef(~name+++\fx).play;
)

// END

~set_macro.(\k1, Ndef(~name+++\fx), \baseffreq, \freq.asSpec);
~set_macro.(\k2, Ndef(~name+++\fx), \freqshift, \bipolar.asSpec);
~set_macro.(\k3, Ndef(~name+++\fx), \mix, \unipolar.asSpec);
~set_macro.(\k4, Ndef(~name+++\fx), \delmix, \unipolar.asSpec);
~set_macro.(\k5, Ndef(~name+++\fx), \freq, \freq.asSpec);
~set_macro.(\k6, Ndef(~name+++\fx), \fma1, \lofreq.asSpec);
~set_macro.(\k7, Ndef(~name+++\fx), \fma2, \lofreq.asSpec);
~set_macro.(\k8, Ndef(~name+++\fx), \chord, ControlSpec(0,4,\lin,1,0));
~set_macro.(\s1, Ndef(~name+++\fx), \ffreqfac, ControlSpec(1,16,\exp,0,1));
~set_macro.(\s2, Ndef(~name+++\fx), \oscmix, \unipolar);



"vim --servername scvim --remote-send '<Esc>cchello<Esc>'".unixCmd;

Ndef(~name+++\fx).addSpec(\delmix, \unipolar.asSpec);
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
