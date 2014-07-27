(
SynthDef(\warp, { |pan, out, freq=440, amp=0.8, gate=1, reflect, env|
	var phuse;
	var snd;
	phuse = VarSaw.ar(reflect, 1, 1);//700 7 27
	snd = Splay.ar(SinOsc.ar(freq * [1, 2, 3, 4], phuse, mul:0.25));
	snd.debug("snd");
	snd = snd * EnvGen.ar(Env.adsr(0.01, 0.1, 0.09, env), gate, doneAction:2);
	snd = Pan2.ar(snd, pan);
	snd.debug("pan");
	OffsetOut.ar(out, snd * amp)
}).draw;
)
(
(Pdef(\3,
	Pbind(\instrument, \warp,
		\degree, Place([Pseq([2, 5, 1.2, 5, 2, 1]), Pseq([4, 4, Place([5, 4, 3, 2, 1, -4])])], inf),
		\dur, Pseq([0.1, 0.2, 0.4, 0.1, 0.2, 1.1, 1.4], inf),
		\reflect, Place([Pseq([17, 30], 6), 27, 700], inf),
		\env, Place([Pseq([0.1, 0.1, 0.9], 4), 2, 2.9], inf),
		\pan, Pseq([-1, 1, 1, -1], inf),
		\amp, 1
	));
Pdef(\3).play;
)
)

DotViewer.viewer = "kgraphviewer";



(
5.do{

{FreeVerb.ar(1 / pow(2.718281, LFSaw.ar(rrand(10,100),1,1).squared / (2 * (Latch.ar(WhiteNoise.ar(1).range(0.001, 0.15), LFSaw.ar(4,1,0.5,0.5) > 0.99)).squared)) * 0.1, 0.33, 2) * EnvGen.kr(Env.linen(20, 40, 20, 1), doneAction: 2) ! 2}.play
}
)

(
5.do{

{1 / pow(2.718281, LFSaw.ar(rrand(10,100),1,1).squared / (2 * (Latch.ar(WhiteNoise.ar(1).range(0.001, 0.15), LFSaw.ar(4,1,0.5,0.5) > 0.99)).squared)) * 0.1 * EnvGen.kr(Env.linen(20, 40, 20, 1), doneAction: 2) ! 2}.play
}
)
