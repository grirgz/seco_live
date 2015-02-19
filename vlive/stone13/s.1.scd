
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
)
  
(
Pdef(\amen, Pbind(
	\instrument, \stereosampler_sec,
	\index, Pseq((0..(~list.size/2-1)))*2,
	\index, Pseq([0,7,0,2,12,12,12,12],inf)+50,
	\start, Pindex(~list, Pkey(\index))/s.sampleRate,
	\end, Pindex(~list ++ [d.numFrames], Pkey(\index)+1)/s.sampleRate + 0.01,
	\buf, BufDef(\amen, "vipere/amenbreak.wav"),
	\buf, BufDef(\oeuf),
	\xdur, 1,
	\amp, 0.1,
	\dur, 1/4,

)).play;
)

// END

~get_sample_slices.(BufDef(\amen), { arg x; ~list = x; });
~get_sample_slices.(BufDef(\oeuf), { arg x; ~list = x; });

BufDef(\oeuf, "field/oeuf.flac");
~list.size
~list = ~list.drop(-1)
