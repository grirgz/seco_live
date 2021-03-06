
Ndef(Veco('3').uname+++\mixer).set(\send1, 1);

// END

Ndef(~name+++\fx).set(\fb3, 1);
Ndef(~name+++\fx).set(\fbin, 1);

(
Ndef(~name+++\fx, { arg amp=0.2, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2, fb3=1, fbin=1;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;
	var baseffreq = 1000;

	var in;
	//var in = InFeedback.ar(BusDef(Veco('3').uname+++\mixer, 2));
	in = InFeedback.ar(BusDef(Veco('2').uname+++\mixer), 2) * fbin;
	in = in + (InFeedback.ar(BusDef(Veco('3').uname+++\mixer), 2) * fb3);
	in = DelayL.ar(in, ~t/4,~t/4);
	//in = CombL.ar(in, 0.4,0.4,16);
	in = FreqShift.ar(in, -200);
	//in = Limiter.ar(in, 0.81,0.01);
	in = in.tanh * 1.1;
	in.postln;

});
);

Ndef(~name+++\fx).set(\fb3, 1);
Ndef(~name+++\fx).set(\fbin, 1);

~t

(
Ndef(~name+++\fx, { arg amp=0.2, pan=0, freq=200, mbufnum,
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

	var in;
	//var in = InFeedback.ar(BusDef(Veco('3').uname+++\mixer, 2));
	in = InFeedback.ar(BusDef(Veco('3').uname+++\mixer, 2));
	in = CombL.ar(in, 0.4,0.4,16);
	in = FreqShift.ar(in, -200);
	in;

});
);

(
Ndef(~name+++\fx).fadeTime = 0.1;
Ndef(~name+++\mixer).fadeTime = 0.1;
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
//Ndef(~name+++\fx).quant = Pdef.defaultQuant;
)


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
)

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
