~name = 'h';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
Veco(~name).make_mixer;
//Veco(~name)[\master_bus] = BusDef(~masterfx+++\fx, \audio);

Sdef(~name, \mypreset, \preset, \zegrainer2);
Pdef(~name+++\pre).fadeTime = 4;

Pdef(~name+++\mod).quant = 0;

(
Veco(~name).lib.macros = [
	[ Sdef(~name, \mypreset), \pitch_stretch ],
	[ Sdef(~name, \mypreset), \pos ],
];
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0;
	var ou;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	//pitch_stretch = [0.3,1,0.8,1.2] * pitch_stretch;
	//pos = [0.3,0.2,0.05,0.4];
	//time_stretch = 0.011;
	//time_stretch = [1,0,0.1,0.1] * time_stretch;
	//trate = [0.1,1,10] * trate;

	clk = Impulse.ar(trate);
	//clk = Dust.ar(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = gdur/trate;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	//pos = phasor * BufDur.kr(bufnum) + finepos + TRand.kr(0, randframes, randclk);
	pos = phasor * BufDur.kr(bufnum) + finepos;
	//pitch_stretch = Demand.ar(clk, 0, Dseq([2.8,0.2,0.3],inf)) * pitch_stretch;
	//pitch_stretch = Demand.ar(clk, 0, Dseq([1,2,3,2,1]/100+0.5 * SinOsc.ar(0.1).range(1,1.1),inf));
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, TRand.kr(0.6, 1.2, clk));
	//ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos.clip(0, BufDur.kr(bufnum)), dur, pan, 1);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.005,0.1,0.8,0.1)),gate,doneAction:doneAction);

	pan = TRand.ar(-1,1, clk).lag(0.1);
	//pitch = Tartini.kr(ou);
	//pitch = Pitch.kr(ou);
	//pitch.poll;
	//ou = RLPF.ar(ou, 7000,0.5);
	ou = Splay.ar(ou, 1, amp, pan);
	Out.ar(out, ou);
}, metadata: (specs:(
	gdur: ControlSpec(1,30,\lin,0,12),
	finepos: ControlSpec(-0.3,0.3,\lin, 0, 0),
	randframes: ControlSpec(0.000001,1,\exp,0,0.01),
	time_stretch: ControlSpec(-8,8,\lin,0,0),
	pitch_stretch: ControlSpec(-8,8,\lin,0,0),
	release: ControlSpec(0.001,8,\exp,0,0.2),
	pos: \unipolar.asSpec,

))).store;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
if(Pdef(~name +++ \mod).source.isNil) { Pdef(~name +++ \mod, Pbind()) };
Pdef(~name, 
	~patfx.(~name+++\patfx) <>
	Pdef(~name+++\mod) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\mbufnum, BufDef.mono(\ukraine),
	\pos, 0.2,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 1.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);


// END


s.sendMsg(\b_allocRead, 10, "sounds/a11wlk01.wav");

(
{
    var b = 10, trate, dur, clk;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    clk = Dust.kr(trate);
    TGrains2.ar(2, clk, 10, 1.0, LFNoise2.kr(0.5).range(0, BufDur.kr(b)), dur, 0, TRand.kr(0.1, 0.2, clk), MouseX.kr(0.003, 0.01), 0.007, 4);
}.play;
)

