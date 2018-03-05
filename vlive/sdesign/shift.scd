
(
Ndef(\shifttreb).put(0, { arg pan=0, amp=0.1;

	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5, seq6, seq7, seq8;
	var dscale = 4/~t;
	seq1 = Duty.ar(1/2*dscale, 0, Dseq([
		4,8,4,4, 1,8,1,8,
	]*~t,inf));
	seq2 = Duty.ar(1*dscale, 0, Dseq([80,50],inf)).lag(0.1);
	seq3 = Duty.ar(1/4*dscale, 0, Dseq([
		Dseq([0,1,3,4].midiratio * 100)
	],inf)).lag(0.1);
	seq6 = Duty.ar(1/2*dscale, 0, Dseq([
		Dseq([4,3,2,1].midiratio * 400)
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/8*dscale, 0, Dseq([
		1,2,1,4,
		1,1,2,2,

		1,2,1,4,
		1,4,1,2,

		1,2,1,4,
		1,1,2,2,

		1,1/2,4,1,
		1,1,2,2,
	],inf)).lag(0.1);
	seq5 = Duty.ar(1/2*dscale, 0, Dseq([
		1,1/2,4,1,
	]*~t,inf));
	sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig = sig * SinOsc.ar(seq1);

	sig1 = LPF.ar(sig, 700);

	sig1 = FreqShift.ar(sig1, seq3.lag(0.4)*seq4) + sig1;
	sig2 = HPF.ar(sig, 100);
	sig2 = RLPF.ar(sig2, LFPulse.ar(seq1).range(100,1000));

	sig3 = FreqShift.ar(sig1, seq6.lag(0.0)*seq4) + sig1;

	sig = sig2 + sig1 + sig3;

	sig1 = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)], mul: SinOsc.kr(seq5).unipolar);
	sig1 = RLPF.ar(sig1, LFPulse.ar(seq5).range(100,2000));
	sig1 = sig1 / 1.3;
	sig = sig + sig1;
	//sig2 = FreqShift.ar(sig1, seq2);
	sig = Pan2.ar(sig, pan, amp).sum;


}).play;
)



(
SynthDef(\shiftman, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*\fmfac.kr(1) * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)) * 1.6 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig1 = FreqShift.ar(sig, \shift.kr(1).lag(0.2));
	sig2 = FreqShift.ar(sig, \shift2.kr(1).lag(0.2));
	sig = sig + sig1 + sig2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8)/8);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part2, Pdef(\plopxxx, 
	Ppar([
		Pmono(\shiftman,
			\note, Pseq([
				4, 0, 2, 1,
			],inf),
			\octave, Prand((3..8),inf).stutter(8),
			\fspread, Pseq([
				0.1,0.000001,0.01,
			],inf),
			\lpfr, 3,
			\shift, 100* Pseq([2,4,1,2],inf).stutter(2),
			\shift, 200 * Pseq([4,1,3,2],inf).stutter(2) * Pseq([
				1,2,4,1/2,
			],inf),
			\fmfac, Pseq([4,1,3,2],inf).stutter(4),
			\dur, PdurStutter(Pseq([1,4,1,2],inf), 1),
			\amp, 0.1,
		),
	])
)).play;
)



(
SynthDef(\bufshiftman, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, speed=1, trigger=1, pos=0, bufnum=0, loop=1, fspread=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	speed = ((0..7)/7 - 0.5 * fspread + 1) * speed;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	//sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = RHPF.ar(sig, 400, 0.1);
	sig1 = FreqShift.ar(sig, \shift.kr(1).lag(0.2));
	sig2 = FreqShift.ar(sig, \shift2.kr(1).lag(0.2));
	sig = sig + sig1 + sig2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8)/8);
	sig = sig * \prelimgain.kr(1);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, \gain.kr(1)).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part2).reset;
);


(
Pdef(\part2, Pdef(\plopxxx, 
	Ppar([
		Pmono(\bufshiftman,
			\note, Pseq([
				4, 0, 2, 1,
			],inf),
			\bufnum, BufDef('voices/feynman.flac'),
			\octave, Prand((4..8),inf).stutter(8),
			\fspread, Pseq([
				0.00001
			],inf).stutter(8),
			\lpfr, 3,
			\shift, 80* Pseq([2,4,1,2],inf).stutter(2),
			\shift, 50 * Pseq([4,1,3,2],inf).stutter(2) * Pseq([
				1,2,4,1/2,
			],inf),
			\fmfac, Pseq([4,1,3,2],inf).stutter(4),
			\dur, PdurStutter(Pseq([1,4,1,2],inf), 1),
			\gain ,1/4,
			\prelimgain ,4,
		),
	])
)).play;
)


