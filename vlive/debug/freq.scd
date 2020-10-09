
SynthDef(\dr_oscsampler, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([0.5,0.6,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(1)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh * \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	pos: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	ffreq: \freq.asSpec,
	hpmix: \unipolar.asSpec,
	hpfreq: \freq.asSpec,
	distamp: \amp.asSpec,
	distpreamp: ControlSpec(0,100,\lin),
	distmix: \unipolar.asSpec,
))).add;



///////////////////////////////////////////////
///////////////// simplest reproducer
// bug even with no quarks
Main.version // -> 3.11.0

Spec.specs[\freq] // -> a ControlSpec(20, 20000, 'exp', 0, 440, " Hz")

SynthDef(\haha, { arg out=0;
	Out.ar(out, DC.ar(0) * \abc.kr(1)); // doesn't bug if not abc not an argument
}, metadata:(specs:(
	abc: \freq.asSpec, // doesn't bug if no \freq.asSpec
))).add;

Spec.specs[\freq] // -> a ControlSpec(0.0, 1.0, 'linear', 0.0, 0.0, "")
