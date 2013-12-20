~name = '3';

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						posmfreq=1, posmrange=0.1, mixmpos=2;
	var ou;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;
	var pos1, pos2;
	var env;

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

	pos = phasor * BufDur.kr(bufnum) + finepos;
	pos1 = pos + TRand.kr(0, randframes, randclk);
	pos2 = pos + SinOsc.kr(posmfreq) * posmrange;
	pos2 = pos + SinOsc.kr(posmfreq) * posmrange;
	pos = SelectX.ar(mixmpos, [pos, pos1, pos2]);
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos.clip(0, BufDur.kr(bufnum)), dur, pan, 1);

	env = EnvGen.ar(Env([0,1,1,0],[4.0,8.0,0.05]/t/4,[3,0,0],2),gate,doneAction:0)*1;
	ou = RLPF.ar(ou, env*15000+50, 0.6);
	//ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(17.405,0.01,0.1,0.1,1)),gate,doneAction:doneAction);
	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(1.405,0.01,0.1,0.1,1)),gate,doneAction:doneAction);
	//ou = ou * env*2;

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

))).add;

BufDef.mono(\moeten, "voices/02_moeten.flac");
Veco(~name).make_mixer;
~newfxmix.(\fx);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\mbufnum, BufDef.mono(\moeten),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
