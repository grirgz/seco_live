~name = \k;

Veco(~name).make_mixer;

(
SynthDef(~name, {| out = 0, amp=0.1, bufnum = 0, gate = 1, pos = 0, speed = 1, loop=0, doneAction=2, pan=0, reprate=4, envmix=1, spread=0.8|

	var player,env;
	var trigger=1;
	reprate = 100;
	//reprate = reprate * [1, EnvGen.ar(Env([1,1.1,1],[1,1]/4),gate,doneAction:0)];
	pos = pos + EnvGen.ar(Env([0,0.001 + [0,0.001],0],[1,1]),gate,doneAction:0);
	//pos = pos + Duty.ar([1/4,1/8], 0, Dseq([0,0.02,0.01],inf)).lag(0.1) + [0,0.001,0.002];
	//pos = pos + Duty.ar([1/4,1/8], 0, Dseq([0,0.02,0.01],inf)).lag(0.1) + [0,0.001,0.002];
	trigger = Impulse.kr(reprate);
	env =  EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:doneAction);
	player = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	player = BPF.ar(player, [10000,1000,12000] * EnvGen.ar(Env([0,1,0],[1,1]/1),gate,doneAction:0) + 100, 0.9);
	player = player * 8;
	player = Splay.ar(player, spread, amp, pan);
	player = player * SelectX.kr(envmix, [1,env]);
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \stereosampler_stutter,
	\bufnum, BufDef(\crepe),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

(
SynthDef(~name, {| out = 0, amp=0.1, bufnum = 0, gate = 1, pos = 0, speed = 1, loop=0, doneAction=2, pan=0, reprate=4, envmix=1, spread=0.8|

	var player,env;
	var trigger=1;
	reprate = 100;
	reprate = reprate * [1, EnvGen.ar(Env([1,1.1,1],[1,1]/4),gate,doneAction:0)];
	pos = pos + EnvGen.ar(Env([0,0.001 + [0,0.001],0],[1,1]/4),gate,doneAction:0);
	//pos = pos + Duty.ar([1/4,1/8], 0, Dseq([0,0.02,0.01],inf)).lag(0.1) + [0,0.001,0.002];
	//pos = pos + Duty.ar([1/4,1/8], 0, Dseq([0,0.02,0.01],inf)).lag(0.1) + [0,0.001,0.002];
	trigger = Impulse.kr(reprate);
	env =  EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:doneAction);
	player = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	//player = Pan2.ar(player, pan, amp * 2);
	player = Splay.ar(player, spread, amp, pan);
	player = player * SelectX.kr(envmix, [1,env]);
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).add;
);
