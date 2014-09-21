~name = 'sub1-a';

BufDef(\ukraine, "bruit1/07_ukraine.flac");
Veco(~name).make_mixer;

Sdef(~name, \mypreset, \preset, \stereosampler_stutter);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
if(Pdef(~name +++ \mod).source.isNil) { Pdef(~name +++ \mod, Pbind()) };
Pdef(~name, 
	~patfx.(~name+++\patfx) <>
	Pdef(~name+++\mod) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler_stutter,
	\degree, Pseq([0],inf),
	//\buf, BufDef(\ukraine),
	\bufnum, BufDef(\ukraine),
	\pos, 0.2,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 1.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

SynthDef(~name+++\stereosampler_stutter, {| out = 0, amp=0.1, bufnum = 0, gate = 1, pos = 0, speed = 1, loop=0, doneAction=2, pan=0, reprate=4, envmix=1|

	var player,env;
	var trigger=1;
	var p2;
	trigger = Impulse.kr(reprate);
	env =  EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	player = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	p2 = player;
	player = RLPF.ar(player, \lpf.kr(1000));
	player = Pan2.ar(player, pan, amp * 2);
	player = player * SelectX.kr(envmix, [1,env]);
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).add;

// END

Sdef(~name, \mypreset, \preset, \zegrainer2);

Pdef(~name+++\mod).quant = 0;

(
Veco(~name).lib.macros = [
	[ Sdef(~name, \mypreset), \pitch_stretch ],
	[ Sdef(~name, \mypreset), \pos ],
];
);
