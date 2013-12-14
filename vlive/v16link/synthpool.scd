
(

"loading synthpool".debug;

SynthDef(\oscsampler, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5], [0.2,0.1])),gate) + pos;
	phase = osc * range + pos + finepos;

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, ffreq * ffreqtab, rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);
	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5], [0.2,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
	//pos: \bipolar,
))).store;

SynthDef(\stereosampler, {| out = 0, amp=0.1, bufnum = 0, gate = 1, pos = 0, speed = 1, loop=0, doneAction=2, pan=0|

	var player,env;
	env =  EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	player = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, 1, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	player = Pan2.ar(player, pan, amp * 2);
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).store;
SynthDef(\zegrainer, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
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
	//ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos.clip(0, BufDur.kr(bufnum)), dur, pan, 1);

	ou = ou * EnvGen.ar(Env.adsr(0.005,0.1,0.8,release),gate,doneAction:doneAction);

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

);
