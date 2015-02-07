

~pdef_channel.();

(
SynthDef(~name+++\premier, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var bufnum, pos, loop, trigger, speed;

	bufnum = BufDef(\moeten);
	pos = 0;
	loop = 1;
	trigger = 1;
	speed = MouseX.kr(-1,1)*4;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\pre1, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var bufnum, pos, loop, trigger, speed;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	pos = 0.49;
	loop = 1;
	trigger = 1;
	speed = EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:0);
	speed = SinOsc.kr(1 * SinOsc.kr(1/2).range(1,2.1))*1;
	speed = LFSaw.ar(4 * SinOsc.kr(1/1).range(0,1));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 10;
	
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var bufnum, pos, loop, trigger, speed;

	bufnum = BufDef(\crepe, "field/crepe.flac");
	pos = 0.49;
	loop = 1;
	trigger = 1;
	speed = EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:0);
	speed = SinOsc.kr(1 * SinOsc.kr(1/2).range(1,2.1))*1;
	speed = LFSaw.ar(8 * SinOsc.kr(1/1).range(0,1));
	speed = LFSaw.ar( Duty.kr(1/4/~t, 0, Dseq([
		8,4,2,6,
	],inf)) );
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 10;
	
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1
))
);
