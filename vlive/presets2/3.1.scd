
(
Ndef(~name+++\fx, { arg amp=0.8, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2, baseffreq=1000;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	gdur = 1/2 * SinOsc.ar(400).range(0.9,1) * trate;
	trate = 18 * SinOsc.ar(401).range(0.9,1) * gdur;
	pitch_stretch = [1,2,3,0.5,8,9] * (LFNoise1.ar([1/2,8,1]).range(0.8,[2,1,0.5])) * pitch_stretch;
	time_stretch = [0.051,0.01,0] * time_stretch;
	time_stretch = 0;
	pos = LFNoise1.kr([1/2,8,1]).range(0,0.001)+[0.1,0.2].rand;
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
	baseffreq = baseffreq * LFNoise1.ar(1).range(0.7,10);
	ou1 = HPF.ar(ou, baseffreq.clip(10,18000));
	ou1 = LPF.ar(ou1, (baseffreq+1000).clip(10,18000));
	//ou1 = ou;
	ou2 = FreqShift.ar(ou, [-500,800]);
	ou = ou1;
	ou = ou * 8;
	ou = Splay.ar(ou, 1, amp);
});
);
(
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\ukraine));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\crepe));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\oeuf));
Ndef(~name+++\fx).set(\mbufnum, BufDef.mono(\bomb));
Ndef(~name+++\fx).set(\pos, 0.1);
Ndef(~name+++\fx).set(\amp, 0.4);
Ndef(~name+++\fx).set(\time_stretch, 0);
Ndef(~name+++\fx).set(\pitch_stretch, 2);
//Ndef(~name+++\fx).play;
Ndef(~name+++\fx).fadeTime=1;
)

// END

~set_macro.(\k1, Ndef(~name+++\fx), \baseffreq, \freq.asSpec);
~set_macro.(\k2, Ndef(~name+++\fx), \time_stretch, ControlSpec(0.0001,1,\exp,0,0.1));
~set_macro.(\k3, Ndef(~name+++\fx), \pitch_stretch, ControlSpec(0.0001,5,\exp,0,0.1));
~set_macro.(\k4, Ndef(~name+++\fx), \gdur, ControlSpec(0.1,10,\exp,0,0.1));
~set_macro.(\k5, Ndef(~name+++\fx), \trate, ControlSpec(0.1,100,\exp,0,0.1));


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
