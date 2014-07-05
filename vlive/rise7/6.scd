~name = '6';

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\woodshop, "vipere/woodshop.flac");

(
SynthDef(~name+++\snare, { |out=0, amp=0.1, pan=0, fratio=1.5, rq=0.5, fratiob=2, dmix=0.5, rqc=0.5, fratioc=2,
					dmix2=0.2, pwidth=0.5, driveamp=0.2, distmix=0.5, drive=2, cliplevel=1,
					doneAction=2, doneActiona=0, doneActionb=0, doneActionc=0,
					modamp=1, timeScale=1|
	var env0, env1, env1m, son;
	var env0b, env1b, env1mb, sonb;
	var env0c, env1c, env1mc, sonc;
	var sondist;
	
	env0 =  EnvGen.ar(\env0.kr(Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, 0.1], [-4, -2, -4])), timeScale: timeScale, doneAction:doneActiona);
	env1 = EnvGen.ar(\env1.kr(Env.new([80, 19, 70], [0.05, 0.09], [-4, 5])), timeScale: timeScale);
	env1m = env1.midicps;

	env0b =  EnvGen.ar(\env0b.kr(Env.new([0.5, 1, 0.5, 0], [0.05, 0.006, 0.1], [-4, -2, -4])), timeScale: timeScale, doneAction:doneActionc);
	env1b = EnvGen.ar(\env1b.kr(Env.new([120, 39, 21], [0.005, 0.29], [4, -5])), timeScale: timeScale);
	env1mb = env1b.midicps;
	
	son = WhiteNoise.ar(1);
	son = BPF.ar(son, env1m*fratio, rq);
	son = son * env0;

	sonb = LFPulse.ar(env1mb, 0, pwidth, 1, -0.5);
	sonb = sonb + WhiteNoise.ar(1);
	sonb = LPF.ar(sonb, env1mb*fratiob);
	sonb = sonb + SinOsc.ar(env1mb, 0.5);
	sonb = sonb * env0b;
	
	son = SelectX.ar(dmix, [son , sonb]);

	sondist = son * drive;
	sondist = sondist.clip2(cliplevel);
	sondist = sondist * driveamp;
	son = SelectX.ar(distmix, [son , sondist]);

	DetectSilence.ar(son, amp:0.1, time:0.1, doneAction:2);
	son = son * amp;
	son = son * modamp;
	son = Pan2.ar(son, pan);
	
	//OffsetOut.ar(out, son);
	Out.ar(out, son);
}, metadata:(specs:(
	env0: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, 0.1], [-4, -2, -4])],
	env1: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([80, 19, 70], [0.05, 0.09], [-4, 5])],
	env0b: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, 0.1], [-4, -2, -4])],
	env1b: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([80, 19, 70], [0.05, 0.09], [-4, 5])],
	distmix: \unipolar.asSpec,
	dmix: \unipolar.asSpec,
	cliplevel: \wideamp.asSpec,
	driveamp: \wideamp.asSpec,
	pwidth: \unipolar.asSpec,
	modamp: \amp.asSpec,

))).add;


SynthDef(~name+++\oscsampler, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	var ou, ou2, ou3;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([0.01,0,0.5], [0.2,0.1])),gate) + pos;
	//pos = EnvGen.kr((Env([0.0,0.1,0.5], [4.2,0.1])),gate) + pos;
	//pos = 0.2;
	phase = osc * range + pos + finepos;

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, ffreq * ffreqtab, rq);
	ou3 = RHPF.ar(ou, \hffreq.kr(100), \hrq.kr(0.5));
	ou = SelectX.ar(lpmix*2, [ou, ou2, ou3]);
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
))).add;
);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \oscsampler,
	\bufnum, BufDef(\moeten),
	\bufnum, BufDef(\woodshop),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/8,
	\amp, 0.21 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

