~name = 'r';

(
SynthDef(~name, {| out = 0, amp=0.1, bufnum = 0, gate = 1, pos = 0, speed = 1, loop=0, doneAction=2, pan=0|

	var player,env;
	env =  EnvGen.kr(\adsr.kr(Env.adsr(0.05,0.0,1,0.01)), gate, doneAction:doneAction);
	player = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, 1, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	player = Pan2.ar(player, pan, amp * 2);
	player = player * env;
	Out.ar(out, player);

}, metadata:(specs:(
))).add;
);

BufDef(\fear, "voices/01_fear.flac");

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\bufnum, BufDef(\fear),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
