~name = \8;

SynthDef(~name, {| out = 0, amp=0.1, buf = 0, gate = 1, start=0, end=1, speed = 1, loop=0|

	var player,env;
	var rate;
	var sig1, sig2;
	var bufnum = buf;
	env =  EnvGen.kr(Env([0,1,1,0],[0.01,(end-start)/speed,0.1]), gate, doneAction:2);
	//BufFrames.kr(bufnum).poll;
	rate = BufRateScale.kr(bufnum) * speed;
	player = PlayBuf.ar(2, bufnum, rate, 1, startPos: (start*BufSampleRate.kr(bufnum)), doneAction:2, loop: loop);
	player = player * env * amp;
	sig1 = LFSaw.ar(XLine.kr(0.1,0.8,2)).range(200,300);
	//player  = FreqShift.ar(player, [200,1000,500,120]);
	player = Splay.ar(player);

	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).store;

SynthDef(\stereosampler, {| out = 0, amp=0.1, bufnum = 0, gate = 1, pos = 0, speed = 1, loop=0, doneAction=2, pan=0|

	var player,env;
	env =  EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	player = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, 1, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	player = Pan2.ar(player, pan, amp * 2);
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).store;

SynthDef(\stereosampler_sec, {| out = 0, amp=0.1, buf = 0, gate = 1, start=0, end=1, speed = 1, loop=0|

	var player,env;
	var rate;
	var bufnum = buf;
	env =  EnvGen.kr(Env([0,1,1,0],[0.01,(end-start)/speed,0.1]), gate, doneAction:2);
	//BufFrames.kr(bufnum).poll;
	rate = BufRateScale.kr(bufnum) * speed;
	player = PlayBuf.ar(2, bufnum, rate, 1, startPos: (start*BufSampleRate.kr(bufnum)).poll, doneAction:2, loop: loop);
	player = player * env * amp;
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).store;

SynthDef(\audiotrack, { arg out = 0, amp=0.20, bufnum = 0, sustain, delay=0.046;
        var playbuf, ou;
        playbuf = PlayBuf.ar(2,bufnum,startPos:BufSampleRate.kr(bufnum)*delay,doneAction:0);
        //playbuf = PlayBuf.ar(2,bufnum,startPos:0,doneAction:0);
		//ou = playbuf * EnvGen.ar(Env.asr(0.01,1,0.01), gate, doneAction:2);
		ou = playbuf * EnvGen.ar(Env.linen(0.001,sustain,0.001), doneAction:2);
        Out.ar(out, ou * amp);
}).store;

SynthDef(\audiotrack, { arg out = 0, amp=0.20, bufnum = 0, sustain, delay=0.046;
        var playbuf, ou;
        playbuf = PlayBuf.ar(2,bufnum,startPos:BufSampleRate.kr(bufnum)*delay,doneAction:0);
        //playbuf = PlayBuf.ar(2,bufnum,startPos:0,doneAction:0);
		//ou = playbuf * EnvGen.ar(Env.asr(0.01,1,0.01), gate, doneAction:2);
		ou = playbuf * EnvGen.ar(Env.linen(0.001,sustain,0.001), doneAction:2);
        Out.ar(out, ou * amp);
}).store;

SynthDef(\audiotrack_noisegate, { arg out = 0, amp=0.20, bufnum = 0, sustain, noisegate=0.0, at=0.2, rt=0.2, delay=0.046;
        var playbuf, ou;
        playbuf = PlayBuf.ar(2,bufnum,startPos:BufSampleRate.kr(bufnum)*delay,doneAction:0);
        //playbuf = PlayBuf.ar(2,bufnum,startPos:0,doneAction:0);
		//ou = playbuf * EnvGen.ar(Env.asr(0.01,1,0.01), gate, doneAction:2);
		ou = playbuf;
		//ou = ((ou < noisegate) * ou) + ((ou > noisegate) * (ou*100).tanh.distort);
		//ou = (ou*100).distort;
		ou = ou * EnvGen.ar(Env.linen(0.001,sustain,0.001), doneAction:2);
		ou = (Amplitude.kr(ou,at,rt) > noisegate) * ou;
        Out.ar(out, ou * amp);
}, metadata:(specs:(
	noisegate: ControlSpec(0, 0.1, \lin, 0, 0),
	at: ControlSpec(0, 1, \lin, 0.0001, 0),
	rt: ControlSpec(0, 1, \lin, 0.0001, 0)
))).store;

SynthDef(\audiotrack_expander, { arg out = 0, amp=0.20, bufnum = 0, sustain, 
			delay=0.046, fadein=0.001, fadeout=0.001,
			wet=1, threshold=0.0, slopeBelow=1, slopeAbove=1, clampTime=0, relaxTime=0, pos=0;
        var playbuf, ou, cou;
        playbuf = PlayBuf.ar(2,bufnum,startPos:BufSampleRate.kr(bufnum)*delay+(pos*BufFrames.kr(bufnum)),doneAction:0);
		ou = playbuf;
		ou = ou * EnvGen.ar(Env.linen(fadein,sustain,fadeout), doneAction:2);
		cou = Compander.ar(ou, ou, threshold, slopeBelow, slopeAbove, clampTime, relaxTime);
		ou = SelectX.ar(wet, [ou, cou]);
        Out.ar(out, ou * amp);
}, metadata:(specs:(
	delay: ControlSpec(0, 0.1, \lin, 0, 0),
	fadein: ControlSpec(0, 0.01, \lin, 0, 0),
	fadeout: ControlSpec(0, 0.01, \lin, 0, 0),
	threshold: ControlSpec(0, 0.1, \lin, 0, 0),
	clampTime: ControlSpec(0, 1, \lin, 0.0001, 0),
	relaxTime: ControlSpec(0, 1, \lin, 0.0001, 0)
))).store;

SynthDef(\audiotrack_expander2, { arg out = 0, amp=0.20, bufnum = 0, sustain, 
			delay=0.046, fadein=0.05, fadeout=0.05,
			wet=1, threshold=0.0, slopeBelow=1, slopeAbove=1, clampTime=0, relaxTime=0, pos=0;
        var playbuf, ou, cou;
        playbuf = PlayBuf.ar(2,bufnum,startPos:BufSampleRate.kr(bufnum)*delay+(pos*BufFrames.kr(bufnum)),doneAction:0);
		ou = playbuf;
		ou = ou * EnvGen.ar(Env.linen(fadein,sustain-fadein,fadeout), doneAction:2);
		cou = Compander.ar(ou, ou, threshold, slopeBelow, slopeAbove, clampTime, relaxTime);
		ou = SelectX.ar(wet, [ou, cou]);
        Out.ar(out, ou * amp);
}, metadata:(specs:(
	delay: ControlSpec(0, 0.1, \lin, 0, 0),
	fadein: ControlSpec(0, 0.01, \lin, 0, 0),
	fadeout: ControlSpec(0, 0.01, \lin, 0, 0),
	threshold: ControlSpec(0, 0.1, \lin, 0, 0),
	clampTime: ControlSpec(0, 1, \lin, 0.0001, 0),
	relaxTime: ControlSpec(0, 1, \lin, 0.0001, 0)
))).store;

BufDef(\camion, "voices/03_camion.flac");

~newfxmix.(\fx);
Veco(~name).make_mixer;
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };

Pdef(~name, Pdef(~name+++\pre) <> Pbind(
	\instrument, ~name,
	\buf, BufDef(\camion).bufnum,
	\degree, Pseq([0],inf),
	\start, 0.5,
	\end, 3.0,
	\start, Pseq([0.5,0.55],inf),
	\speed, Pseq([
		1,0.5,
		8,0.5,
		4,0.5,
		8,0.5,
		0.1,0.2,0.3,0.1,
	],inf),
	\out, BusDef(~name+++\fx),
	\speed, Pseq([
		0.1,0.2,0.3,0.1,
		0.4,0.02,0.3,0.1,
		0.1,0.2,0.3,0.1,
		0.4,0.52,0.3,0.1,
	],inf)+[Pwhite(0,0.01),Pwhite(0,0.48)],
	\isRest, Veco(~name).isrest(16),
	\end, Pkey(\start)+0.16,
	//\dur, BufDef(\camion),
	\dur, 1/8,
	\amp, 2.4 * Pkey(\amp),
	) <> Veco(~name).mixer
	
)
);

// END

BusDef(~name+++\fx)
BusDef(~name+++\mixer)
