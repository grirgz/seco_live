

(
SynthDef(\grancru, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum, gdur=0.1, gfreq=8, pos=0, pitch_stretch=1;
	var sig;
	var clk = Impulse.ar(gfreq);
	pos = pos + LFNoise1.ar(gfreq,mul:0.01);
	//pitch_stretch = pitch_stretch + LFNoise1.ar(10, mul:0.1);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \grancru,
			\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
			\pos, ~pmodenv.(Pseq([1,2,1,4]+3,inf), 8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.4) ],
			],inf),
			\gfreq, 740,
			\gdur, 0.02,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 2,
			\gain, 1,
		)
		
	])
)).play;
)
