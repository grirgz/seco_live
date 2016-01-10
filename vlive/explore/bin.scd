


g = File("/bin/ls".standardizePath,"rb");
(
100.do({
	(g.getInt8 % 10).asString.postln;
});
)
    g.inspect;
    g.close;

g = File("/tmp/ttt".standardizePath,"rb");
(
100.do({
	(g.getInt8 % 10).asString.postln;
});
)


(
	(
	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(freq);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);
)

ParamProto.init;
SynthDesc(\dr_oscsampler).params.inspect
(
	Pdef(\matin, 
		Ppar(
			5.collect {
				Pspawner({ arg sp;
					inf.do {
						var a = { rrand(0,9) } ! 10;
						a.debug("aaaaaaa").dump;
						sp.seq(Pfindur(a[0]+1, Pbind(
							\instrument, \dr_oscsampler,
							\degree, Pseq([0],inf),
							\timeScale, a[0],
							\levelScale, exprand(0.1,8),
							\hpfreq, exprand(1,17000.0),
							\ffreq, exprand(1,17000.0),
							\pos, rrand(0.0,1),
							\hpmix, rrand(0,8.0)/8,
							\lpmix, rrand(0,8.0)/8,
							\sustain, rrand(0.05,0.1) + Pseq([0,0,0,0,0,Pwhite(0,0.1,3)],inf),
							//\dur, Pn(1/rrand(1,8),rrand(4,16) * 4),
							//\dur, Pn([1/8,1/4].choose),
							//\isRest, Pseq([
							//	[
							//		//Pseq([1],inf),
							//		Pseq([1,0,1,0, 0,0,0,0],inf),
							//		Pseq([1,1,0,0, 0,0,0,0],inf),
							//		Pseq([1,1,0,0, 0,1,0,0],inf),
							//		Pseq([1,0,0,1, 0,0,1,0],inf),
							//		//Pseq([1,0.1],inf),
							//		//Pseq([1,0.91,1,0.1],inf),
							//		//Pseq([0,1],inf),
							//		//Pseq([0.1,1],inf),
							//	].choose
							//],inf).coin.not,
							\isRest, 
							[
								Pseq(a.keep(2).collect({ arg x; x < 4 }),inf),
								Pseq(a.keep(4).collect({ arg x; x > 4 }),inf),
								false,
							].wrapAt(a[9]),
							\dur, [
								Pseq([2**a[7].wrap(0,6)/8, 1/4],inf),
								Pseq([2**a[7].wrap(0,4)/8, 1/4],inf),
								Pseq([2**a[7].wrap(0,4)/8, 1/8],inf),
								Pseq([2**a[7].wrap(0,5)/8],inf),
								//Pseq([2**8.rand/8],inf),
							].wrapAt(a[4]),
							\amp, 0.1
						)));

						//sp.wait(rrand(1,4));
					}
				})
			}
		)

	).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
)).play;
)
