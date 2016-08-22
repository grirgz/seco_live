
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

	var side;
	side = InFeedback.ar(BusDef(Veco('1').uname+++\mixer),2);
	side = side + InFeedback.ar(BusDef(Veco('2').uname+++\mixer),2);
	side = side + InFeedback.ar(BusDef(Veco('3').uname+++\mixer),2);
	side = side + InFeedback.ar(BusDef(Veco('4').uname+++\mixer),2);

	freq = Duty.ar(8,0,Dseq([40,60,400,800,20,50,30,20],inf));


	ou = LFPulse.ar(freq * (1/(1..8))) | SinOsc.ar(SinOsc.ar(freq * (1..8))+1*200,0,10);
	//ou = Splay.ar(ou, 1, amp);
	ou = ou.sum;
	ou = BRF.ar(ou, 50 * (SinOsc.kr(1/(1..8)).unipolar *8));
	ou = ou * -25.dbamp;
	ou = ou.sum;
	ou = [ou, ou.tanh];
	ou = ou / 6;
	ou = Compander.ar(ou, side, 0.1,1,0.01, relaxTime:0.1);
	ou = Compander.ar(ou, side, 0.1,3,1, relaxTime:1.1 * SinOsc.kr(1/4).range(0.1,1));
	ou = ou / 2;
	ou = ou.collect({ arg sig,x;
		Pan2.ar(sig, SinOsc.kr((x+1+freq)), amp);
	}).sum;
});
);


// END

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
