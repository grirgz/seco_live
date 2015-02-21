
(
SynthDef(\playbuf, { arg out=0, sframe, eframe, buf, amp;
		var frame, sig, dur, env;	
		dur = (BufDur.kr(buf)/BufSamples.kr(buf)) * (eframe - sframe) * 2;
		dur = dur * \xdur.kr(1);
		frame = Line.ar(sframe, eframe, dur,doneAction:0);
		env = EnvGen.kr(Env.linen(0.01, max(0,dur-0.03), 0.01),doneAction:2);
		sig = BufRd.ar(2, buf, frame) * env;
		sig = sig * amp;
		Out.ar(out, sig); 
}).add
);
  
(
	~buf = BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \stereosampler_sec,
	\index, Pseq([0,7,0,2,12,12,12,12],inf)+50,
	\index, Pseq((0..(~list.size-1))),
	\start, Pindex(~list, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~list ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~list ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~list ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	\xdur, 1,
	\amp, 0.1,
	\dur, 1/4,

).trace).play;
);

(
	~buf = BufDef(\amen, "vipere/amenbreak.wav");
	~xlist = ~mlist[1];
Pdef(\amen, Pbind(
	\instrument, \stereosampler_sec,
	\index, Pseq([0,7,0,2,12,12,12,12],inf)+50,
	\index, Pseq((0..(~xlist.size-1))),
	\start, Pindex(~xlist, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	\xdur, 1,
	\amp, 0.1,
	\dur, 1/2,

).trace).play;
);

(
	~buf = BufDef(\oeuf, "field/oeuf.flac");
	~xlist = ~mlist.last;
	~xlist.size;
Pdef(\amen, Pbind(
	\instrument, \stereosampler_sec,
	//\index, Pseq((0..(~xlist.size-1))),
	\index, Pseq([12,8],inf),
	\start, Pindex(~xlist, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	\xdur, 1,
	\legato,0.1,
	\amp, 0.5,
	\dur, 1/1,

).trace).stop;
	~xlist = ~mlist[3];
Pdef(\amen2, Pbind(
	\instrument, \stereosampler_sec,
	//\index, Pseq((0..(~xlist.size-1))),
	\index, Pseq([
		28,
	],inf),
	\start, Pindex(~xlist, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	\speed, Pseq([1,1,5],inf),
	\legato,0.1,
	\xdur, Pseq([0.4,0.3,0.2],inf).stutter(1),
	\amp, 1.3,
	\dur, 1/8,

).trace).play;
);

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
	~buf = BufDef(\oeuf, "field/oeuf.flac");
	~xlist = ~mlist[3];
	~xlist.size;
Pdef(\amen, Pbind(
	\instrument, \stereosampler_sec2,
	//\index, Pseq((0..(~xlist.size-1))),
	\index, Pseq([1,0,0,2],inf),
	\start, Pindex(~xlist, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	\xdur, 1,
	\legato,0.9,
	\amp, 0.5,
	\dur, 1/1,

).trace).play;
	~xlist = ~mlist[2];
	~xlist.size;
Pdef(\amen2, Pbind(
	\instrument, \stereosampler_sec2,
	//\index, Pseq((0..(~xlist.size-1))),
	\index, Pseq([
		6,5,7,
		6,5,7,
		6,5,7,
		6,5,7,
		6,5,7,7
	],inf),
	\start, Pindex(~xlist, Pkey(\index))/s.sampleRate,
	\buf, ~buf,
	\end, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1)/ s.sampleRate,
	\xend, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)+1),
	\xstart, Pindex(~xlist ++ [~buf.numFrames], Pkey(\index)),
	//\buf, BufDef(\oeuf),
	\speed, Pseq([1,1,5,2],inf).stutter(Pseq([Pn(3,4),Pn(1,8)],inf)),
	\legato,0.5,
	\amp, 1.3,
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
~get_sample_slices.(BufDef(\amen), ~getme, [0.5,1]);
~get_sample_slices.(BufDef(\oeuf), ~getme, [0.3,0.5,1,1.5,2]);
~get_sample_slices.(BufDef(\amen), { arg x; ~list = x; ~list.size.debug("size") }, [1]);
~list

BufDef(\oeuf, "field/oeuf.flac");
~list.size
~list = ~list.drop(-1)
