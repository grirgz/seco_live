~name = 'stone7-i';

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var itrig;
	var igate;
	itrig = \itrig.tr(1);
	//igate = \igate.kr(1);
	igate = Trig.kr(itrig, \isustain.kr(0.1));
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	pos = EnvGen.kr(\iposenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),igate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	phase = osc * (range + (\framerange.kr(0)/BufFrames.ir(bufnum))) + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),igate,doneAction:0);
	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;

(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var xfreq = [1/2,1,1.01,1.001];
	xfreq = SelectX.kr( SinOsc.kr(1/14, \phase.kr(1)).range(0,1), [
		xfreq,
		xfreq.rotate(2),
	]);
	sig = SinOsc.ar(freq*xfreq +0.0001);
	sig = SinOsc.ar(freq * xfreq, sig * \fmamp1.kr(1));
	sig = RLPF.ar(sig, 1000 * [1,2,3]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\c, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var xfreq = [1/2,1,1.01,1.001];
	var xfreq2 = [1/2,0.5001];
	xfreq = SelectX.kr( SinOsc.kr(1/14, \phase.kr(1)).range(0,1), [
		xfreq,
		xfreq.rotate(2),
	]);
	xfreq2 = SelectX.kr( SinOsc.kr(1/14, \phase.kr(1)).range(0,1), [
		xfreq2,
		xfreq2.rotate(1),
	]);
	sig = SinOsc.ar(freq*xfreq +0.0001);
	sig = SinOsc.ar(freq * xfreq, sig * \fmamp1.kr(1));
	sig1 = SinOsc.ar(freq * xfreq2, sig * \fmamp2.kr(1));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig1 = RLPF.ar(sig, (\lpf.ar(1000) * \lpftab.kr([1,2,3])).clip(1,20000));
	sig = SelectX.ar(\mixf.kr(0.5), [sig, sig1]);
	sig1 = HPF.ar(sig, ( \hpf.ar(40) * \hpftab.kr([1,2,3]) ).clip(1,20000));
	sig = SelectX.ar(\mixhpf.kr(0), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

~pdef_channel.();

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\woodshop, "vipere/woodshop.flac");

Sdef(~name, \mypreset, \preset, \oscsampler);

(
~pdef_init.(
	Pbind(
		\instrument, \oscsampler3,
		\bufnum, BufDef(\moeten),
		\bufnum, BufDef(\woodshop),
		\degree, Pseq([0],inf),
		\isRest, Veco(~name).isrest(32),
		\dur, 1/8,
		\amp, 0.31 * Pkey(\amp),
	)
);
)

// END

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01;
	var ou;
	var osc;
	var bufsig;
	var phase;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	phase = osc * range + pos + finepos;

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ou = ou * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	ou = Pan2.ar(ou, pan, amp);
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	//pos: \bipolar,
))).store;

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
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
);
