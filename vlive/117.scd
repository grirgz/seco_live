
 n=nil;a=flat([1,1,1,n,1,1,n,1,n,1,1,n]!12);k=0;b=a;z={Impulse.ar(0)};Task{loop{a[k]!?{play{Out.ar(0,z)}};b[k]!?{play{Out.ar(1,z)}};k=k+1;if(k==144){k=0;b=b.rotate};0.2.wait;}}.play


a=b=flat(3798.asDigits(2)!12);r{loop{144.do({|i|play{[a[i],b[i]]*Env.perc.ar(2,mul:10)};0.2.wait});b=b.rotate}}.play

(
	Tdef(\bla, {
		3.do {

			a=b=flat(3798.asDigits(2)!12);r{loop{144.do({|i|play{[a[i],b[i]]*FreeSelf.kr(Saw.ar(1))};0.2.wait});b=b.rotate}}.play;
			(1.00 + 0.02.rand).wait;
		};
		1.wait;
		3.do {

			a=b=flat(3798.asDigits(2)!12);r{loop{144.do({|i|play{[a[i],b[i]]*FreeSelf.kr(Saw.ar(1))};0.2.wait});b=b.rotate}}.play;
			(1.00 + 0.02.rand).wait;
		};
	}).play
)

(
SynthDef(\aride, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq = freq * ( (1..8)/Rand(8000,1000) + 1 );
	sig1 = SinOsc.ar(freq)!8;
	sig2 = SinOsc.ar(xfreq);
	sig3 = LFSaw.ar(xfreq);
	sig = SelectX.ar(\mix.kr(0.5)*2, [sig3, sig1, sig2]);
	sig = HPF.ar(sig, 200) * LFPulse.ar(xfreq) + sig;
	//(21000-[20,20000]).log/4
	sig = RLPF.ar(sig, freq * ( 21000-freq ).log/4, \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.41,0.1,0.8,0.4),Trig1.kr(gate,1/9),doneAction:2);
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * EnvGen.kr(Env.adsr(0.01,0.1,0.8,\rel.kr(0.1)), gate, doneAction:2);
	sig = sig * 3/4;
	sig = sig * AmpComp.kr(freq);
	sig = Pan2.ar(sig, \pantab.kr(0!sig.size), amp).mean;
	Out.ar(out, sig);
}).add;
);


{ SinOsc.kr(4,3/2* pi) }.plot(1/4)
(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\yap,
	Prout({
		14.collect({ arg sx;
			var scale = Scale.choose;
			var deg1, deg2, deg3;
			var pdeg;
			var deg;
			deg1 = (0..21).scramble.keep(8);
			deg2 = (0..21).scramble.keep(8);
			deg3 = (0..21).scramble.keep(8);
			pdeg = Pseq([deg1,deg1,deg2,deg1, deg1,deg1,deg2,deg3].collect({ arg x; Pseq(x) }));

			[deg,scale].debug("NEWWWWWWWWWWWWWWW");
			Ppar(
				8.collect { arg x;
					Pbind(
						\instrument, \aride,
						\isRest, Prout({
							var rotate = 0;
							loop  {
								Pseq(3798.asDigits(2),inf,rotate).coin.not.embedInStream;
								rotate = rotate + 1;
							};
						}),
						//\isRest, false,
						\mix, Ndef(\yaplfo1_+++x),
						\rel, Ndef(\yaplfo2_+++x),
						\dur, 1/4,
						\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
						\scale, Scale.enigmatic,
						\scale, scale,
						\pantab, [ rrand(-1,1.0!8) ].debug("[]"),
						//\octave, if(x.odd) { 3 } { 4 } + if(sx.odd) { 0 } { 1 } + Pseq([0,1],inf).stutter(4),
						\degree, 0,
						\octave, 3,
						\degree, Pseq([x,x, x*2,x*2+1, x*4,x*4+1],4,sx*x).stutter(4),
						\degree, Pseq([7,0,4,2, 5,4,3,1],inf),
						\degree, Pseq((0..14).scramble,inf),
						//\degree, Pseq(deg,8),
						\degree, pdeg,
						\lag, x + 0.02.rand + Prand([0,1,2,3,4],inf),
						\lag, 0 + 0.02.rand + ( (0..4).choose/4  ) + ( (0..4).choose/2 ),
					)
				}
			).embedInStream;

		})
	})
).play;
);

(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\yap,
	Prout({
		14.collect({ arg sx;
			var scale = Scale.choose;
			var deg1, deg2, deg3;
			var pdeg;
			var deg;
			deg1 = (0..21).scramble.keep(8);
			deg2 = (0..21).scramble.keep(8);
			deg3 = (0..21).scramble.keep(8);
			pdeg = Pseq([deg1,deg1,deg2,deg1, deg1,deg1,deg2,deg3].collect({ arg x; Pseq(x) }));

			[deg,scale].debug("NEWWWWWWWWWWWWWWW");
			Ppar(
				8.collect { arg x;
					Pfindur(16,Pbind(
						\instrument, \aride,
						\isRest, Prout({
							var rotate = x;
							loop  {
								Pseq(3798.asDigits(2),inf,rotate).coin.not.embedInStream;
								rotate = rotate + 1;
							};
						}),
						//\isRest, false,
						\mix, Ndef(\yaplfo1_+++x),
						\rel, Ndef(\yaplfo2_+++x),
						\dur, Pseq([1,1/rrand(1,2),1,1/rrand(1,4)],inf),
						\dur, Pseq((1..4).scramble.normalizeSum*4),
						\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
						\scale, Scale.enigmatic,
						\scale, scale,
						\pantab, [ rrand(-1,1.0!8) ].debug("[]"),
						//\octave, if(x.odd) { 3 } { 4 } + if(sx.odd) { 0 } { 1 } + Pseq([0,1],inf).stutter(4),
						\degree, 0,
						\octave, 3,
						\degree, Pseq([x,x, x*2,x*2+1, x*4,x*4+1],4,sx*x).stutter(4),
						\degree, Pseq([7,0,4,2, 5,4,3,1],inf),
						\degree, Pseq((0..14).scramble,inf),
						//\degree, Pseq(deg,8),
						\degree, pdeg.stutter(1).loop,
						\lag, x + 0.02.rand + Prand([0,1,2,3,4],inf),
						\lag, 0 + 0.02.rand + ( (0..4).choose/4  ) + ( (0..4).choose/2 ),
						\lag, 0 + 0.02.rand,
					))
				}
			).embedInStream;

		})
	})
).play;
);

(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\yap,
	Prout({
		14.collect({ arg sx;
			var scale = Scale.choose;
			var deg1, deg2, deg3;
			var pdeg;
			var deg;
			var lag;
			deg1 = (0..21).scramble.keep(8);
			deg2 = (0..21).scramble.keep(8);
			deg3 = (0..21).scramble.keep(8);
			pdeg = Pseq([deg1,deg1,deg2,deg1, deg1,deg1,deg2,deg3].collect({ arg x; Pseq(x) }));
			lag = (1..8).scramble.normalizeSum.integrate;

			[lag,deg1,scale].debug("NEWWWWWWWWWWWWWWW");
			Ppar(
				8.collect { arg x;
					Pfindur(16,Pbind(
						\instrument, \aride,
						\isRest, Prout({
							var rotate = 0;
							loop  {
								Pseq(3798.asDigits(2),inf,rotate).coin.not.embedInStream;
								rotate = rotate + 1;
							};
						}),
						\isRest, false,
						\mix, Ndef(\yaplfo1_+++x),
						\rel, Ndef(\yaplfo2_+++x),
						\dur, Pseq([1,1/rrand(1,2),1,1/rrand(1,4)],inf),
						\dur, 1,
						\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
						\scale, Scale.enigmatic,
						\scale, scale,
						\pantab, [ rrand(-1,1.0!8) ].debug("[]"),
						//\octave, if(x.odd) { 3 } { 4 } + if(sx.odd) { 0 } { 1 } + Pseq([0,1],inf).stutter(4),
						\degree, 0,
						\octave, 3,
						\degree, Pseq([x,x, x*2,x*2+1, x*4,x*4+1],4,sx*x).stutter(4),
						\degree, Pseq([7,0,4,2, 5,4,3,1],inf),
						\degree, Pseq((0..14).scramble,inf),
						//\degree, Pseq(deg,8),
						\degree, pdeg.stutter(1).loop,
						\degree, deg1[x],
						\lag, x + 0.02.rand + Prand([0,1,2,3,4],inf),
						\lag, 0 + 0.02.rand + ( (0..4).choose/4  ) + ( (0..4).choose/2 ),
						\lag, 0 + 0.02.rand,
						\lag, lag[x],
					))
				}
			).embedInStream;

		})
	})
).play;
);

////////////////////////////////////////////////////////////////


(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\yap,
	Prout({
		14.collect({ arg sx;
			var scale = Scale.choose;
			var deg1, deg2, deg3;
			var pdeg;
			var deg;
			var lag;
			deg1 = (0..21).scramble.keep(8);
			deg2 = (0..21).scramble.keep(8);
			deg3 = (0..21).scramble.keep(8);
			pdeg = Pseq([deg1,deg1,deg2,deg1, deg1,deg1,deg2,deg3].collect({ arg x; Pseq(x) }));
			lag = (1..8).scramble.normalizeSum.integrate;

			[lag,deg1,scale].debug("NEWWWWWWWWWWWWWWW");
			Ppar(
				8.collect { arg x;
					Pfindur(16,Pbind(
						\instrument, \aride,
						\isRest, Prout({
							var rotate = 0;
							loop  {
								Pseq(3798.asDigits(2),inf,rotate).coin.not.embedInStream;
								rotate = rotate + 1;
							};
						}),
						\isRest, false,
						\mix, Ndef(\yaplfo1_+++x),
						\rel, Ndef(\yaplfo2_+++x),
						\dur, Pseq([1,1/rrand(1,2),1,1/rrand(1,4)],inf),
						\dur, 1,
						\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
						\scale, Scale.enigmatic,
						\scale, scale,
						\pantab, [ rrand(-1,1.0!8) ].debug("[]"),
						//\octave, if(x.odd) { 3 } { 4 } + if(sx.odd) { 0 } { 1 } + Pseq([0,1],inf).stutter(4),
						\degree, 0,
						\octave, 3,
						\degree, Pseq([x,x, x*2,x*2+1, x*4,x*4+1],4,sx*x).stutter(4),
						\degree, Pseq([7,0,4,2, 5,4,3,1],inf),
						\degree, Pseq((0..14).scramble,inf),
						//\degree, Pseq(deg,8),
						\degree, pdeg.stutter(1).loop,
						\degree, deg1[x],
						\lag, x + 0.02.rand + Prand([0,1,2,3,4],inf),
						\lag, 0 + 0.02.rand + ( (0..4).choose/4  ) + ( (0..4).choose/2 ),
						\lag, 0 + 0.02.rand,
						\lag, lag[x],
					))
				}
			).embedInStream;

		})
	})
).play;
);


////////////////////////////////////////////////////////////////

(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\dru, 

	Ppar(
		8.collect({ arg x;
			Plazy({
				Pbind(
					\instrument, \aride,
					\mix, Ndef(\yaplfo1_+++x),
					\rel, Ndef(\yaplfo2_+++x),
					\degree, 28.rand,
					\octave, 3,
					\legato, 0.1,
					\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
					\dur, Pn(2,rrand(7,14)),
					\amp, 0.1,
					\lag, 2.0.rand,
				);
			}).loop
		})
	)

).play;
)


////////////////////////////////////////////////////////////////



3798.asDigits(2)!12 flat: nil
2000+1000 add: 2
2.

Scale.random


(
	Pseq(( 0..3 )).collect({ arg x;
		x.debug("xx");
		Pbind(
			\instrument, \default,
			\freq, 200 + (x*20),
			\dur, Pn(1,4),
			\amp, 0.1
		).embedInStream;
		1
	}).play
)

(
	Prout({
		3.do({ arg x;
			"1".debug;
			Pbind(
				\instrument, \default,
				\freq, 200 + (x*20),
				//\freq, 400,
				\dur, Pn(1,4),
				//\lag, x,
				\amp, 0.4
			).embedInStream(Event.default);
			"2".debug;
		})

	}).play
)


(
{
    var mx = MouseX.kr(-200, 200);
    var my = MouseY.kr(-200, 200);
    SinOsc.ar(SinOsc.kr(0.3) * 20 gcd: [mx, my] * 30 + 500) * 0.1
}.play;
)

rand(dksfj)
sdkfj.rand
dfklsfkj rand: nil

40+10.rand
40+10 rand: nil
40+rand(10)
rand(40+10)



