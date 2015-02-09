~name = 'stone12-t';

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var bufnum, pos, loop, trigger;
	var speed;
	var speedlag =0;

	//bufnum = BufDef(\crepe, "field/crepe.flac");
	//bufnum = BufDef(\scream, "vipere/scream.flac");
	//bufnum = \bufnum.kr(BufDef(\moeten));
	bufnum = \bufnum.kr(BufDef(\scream));
	pos = \pos.kr(00.04);
	loop = 1;
	trigger = 1;
	speed = \fspeed.kr(2).lag( \fspeedlag.kr(0) );
	speedlag = \speedlag.kr(0) * ( 1+(\speedlagfmamp.kr(0) * SinOsc.kr(\speedlagfm.kr(1)).range(0,1)  ));
	speed = SinOsc.ar(speed*2*~t).lag(speedlag)*\speed.kr(1)+\aspeed.kr(1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * 3;
	sig = sig * 1;
	
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
