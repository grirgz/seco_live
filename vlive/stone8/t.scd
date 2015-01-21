~name = 'stone8-t';


~pdef_channel.();

(
// nord modular 909 implementation
// modified
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;

	lfo1 = LFTri.ar(330 * EnvGen.ar(Env([8,1 + Rand(0.0,0.4),1],[0.00001,1.8]), gate) * [1,1.1,1.2]).sum;
	lfo1 = lfo1 * EnvGen.ar(Env.perc(0.0005, 0.0255), gate);
	lfo2 = LFTri.ar(185);
	lfo2 = lfo2 * EnvGen.ar(Env.perc(0.0001, 0.0475), gate);

	sig = WhiteNoise.ar(WhiteNoise.ar);
	sig = BRF.ar(sig, [100,200,300,400]+42*0.8).mean;
	sig = LPF.ar(sig, 7040 * [1,1.1,0.2] * EnvGen.kr(Env([1,[0.5+Rand(0.0,0.2),0.1+Rand(0.0,0.2)]],[0.01]), gate)) * [0.4,0.7,1];

	sig1 = sig * EnvGen.ar(Env.perc(0.005, 0.320+Rand(0.0,0.1)), gate, doneAction:2);

	sig2 = HPF.ar(sig, 523);
	sig2 = BRF.ar(sig2, [100,200,300,400]+12*2.0).mean;
	sig2 = sig2 * EnvGen.ar(Env.perc(0.005, 0.183), gate);
	sig2 = (sig2*10).tanh;

	sig = ( sig1 * 0.7 ) + ( sig2 * 0.4 ) + lfo1 + lfo2;
	//sig = sig ! 2;
	//sig = sig * 4;
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;


SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;

	lfo1 = LFTri.ar(330 * EnvGen.ar(Env([8,1 + Rand(0.0,0.4),1],[0.00001,1.8]), gate) * [1,1.1,1.2]).sum;
	lfo1 = lfo1 * EnvGen.ar(Env.perc(0.0005, 0.0255), gate);
	lfo2 = LFTri.ar(185);
	lfo2 = lfo2 * EnvGen.ar(Env.perc(0.0001, 0.0475), gate);

	sig = WhiteNoise.ar(WhiteNoise.ar);
	sig = BRF.ar(sig, [100,200,300,400]+42*0.8).mean;
	sig = LPF.ar(sig, 7040 * [1,1.1,0.2] * EnvGen.kr(
		[
			\lpfenv1.kr(Env([1,0.5],[0.01])),
			\lpfenv2.kr(Env([1,0.1],[0.01])),
			\lpfenv3.kr(Env([1,0.3],[0.01])),
		],
		gate, levelScale:\levelScale.kr(1)
	));

	sig1 = sig * EnvGen.ar(Env.perc(0.005, \sig1rel.kr(0.220)+Rand(0.0,0.1)), gate, doneAction:0);

	sig2 = HPF.ar(sig, 523);
	sig2 = BRF.ar(sig2, [100,200,300,400]+12*2.0).mean;
	sig2 = sig2 * EnvGen.ar(Env.perc(0.005, \sig2rel.kr(0.120)), gate);
	sig2 = (sig2*10).tanh;

	sig = ( sig1 * 0.7 ) + ( sig2 * 0.4 ) + lfo1 + lfo2;
	//sig = sig ! 2;
	//sig = sig * 4;
	DetectSilence.ar(sig, doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\oscsampler, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);

	ou.debug("ou");
	//ou = FreqShift.ar(ou, fshift);
	//ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	//ou = SelectX.ar(lpmix, [ou, ou2]);
	//ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	//ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	//ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	//ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	//ou = Limiter.ar(ou, \limit.kr(1));
	ou = Splay.ar(ou, spread, amp, pan);

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
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
