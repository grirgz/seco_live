~name = 'n';


BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\woodshop, "vipere/woodshop.flac");

Sdef(~name, \mypreset, \preset, \oscsampler);

~newfx.(\fx);

//Veco(~name).make_mixer;
(

Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	sig = CombL.ar(sig, 0.1,0.1,0.5) + sig;
	sig;
}).play;

);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \oscsampler,
	\bufnum, BufDef(\moeten),
	\bufnum, BufDef(\woodshop),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(32),
	\out, BusDef(~name+++\fx),
	\dur, 1/8,
	\amp, 0.21 * Pkey(\amp),
) <> Veco(~name).mixer)
);

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
