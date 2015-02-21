
(
SynthDef(\stereosampler_sec2, {| out = 0, amp=0.1, buf = 0, gate = 1, start=0, end=1, xdur=1, speed = 1, loop=0|

	var player,env;
	var rate;
	var bufnum = buf;
	env =  EnvGen.kr(Env([0,1,1,0],[0.01,(end-start)/speed*xdur,0.01]), gate, doneAction:0);
	env =  env * EnvGen.kr(Env([1,1,1],[0.01,0.01], releaseNode: 1, loopNode:0), gate, doneAction:2);
	//BufFrames.kr(bufnum).poll;
	rate = BufRateScale.kr(bufnum) * speed;
	player = PlayBuf.ar(2, bufnum, rate, 1, startPos: (start*BufSampleRate.kr(bufnum)), doneAction:2, loop: loop);
	player = player * env * amp;
	Out.ar(out, player);

}, metadata:(specs:(
	bufnum: (numchan: 2)
))).add;
)

(
	~xlist = ~mlist[0];
	~xlist.size;
Pdef(\amen2, Pbind(
	\instrument, \stereosampler_sec2,
	//\index, Pseq((0..(~xlist.size-1))),
	\index, Pseq([
		6,5,6,7
	],inf)+3,
	\start, Pindex(~xlist, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	//\speed, Pseq([1,1,5,2],inf).stutter(Pseq([Pn(3,4),Pn(1,8)],inf)),
	\speed, 1/8,
	\legato,0.4,
	\amp, 0.3,
	\dur, 1/8,

).trace).play;
);


// END


(
~getme = { arg x,y; 
	~list = x; 
	~mlist = y;
	~list.debug("list");
	~mlist.debug("mlist");
	~list.size.debug("size");
};
)
~buf = BufDef(\rocksteady, "vipere/rocksteady.flac");
~get_sample_slices.(~buf, ~getme, (1..10)/5);
