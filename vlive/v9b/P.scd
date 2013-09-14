~name = 'P';

SynthDef(\zegrainer2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0;
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
	//ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos.clip(0, BufDur.kr(bufnum)), dur, pan, 1);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.005,0.1,0.8,0.1)),gate,doneAction:doneAction);

	//pitch = Tartini.kr(ou);
	//pitch = Pitch.kr(ou);
	//pitch.poll;
	ou = Splay.ar(ou, 1, amp);
	Out.ar(out, ou);
}, metadata: (specs:(
	gdur: ControlSpec(1,30,\lin,0,12),
	finepos: ControlSpec(-0.3,0.3,\lin, 0, 0),
	randframes: ControlSpec(0.000001,1,\exp,0,0.01),
	time_stretch: ControlSpec(-8,8,\lin,0,0),
	pitch_stretch: ControlSpec(-8,8,\lin,0,0),
	release: ControlSpec(0.001,8,\exp,0,0.2),

))).store;

BufDef.mono(\moeten, "voices/02_moeten.flac");
BufDef.mono(\booba, "vipere/booba.flac");

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \zegrainer2,
	\mbufnum, BufDef.mono(\booba),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1
))
);

// END

~buf = Buffer.read(s, "/home/tytel/Musique/sc/samplekit/voices/02_moeten.flac")
~buf

~mbuf = Buffer.readChannel(s, "/home/tytel/Musique/sc/samplekit/voices/02_moeten.flac", 0, -1, [0]); //FIXME: can't choose the channel
~mbuf
