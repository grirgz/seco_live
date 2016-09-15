(
SynthDef(\oscsampler4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou.debug("oscsampler4");
	ou = ou.clump(2).flop.collect({
		DelayL.ar(ou, 0.02,0.02.rand) + ou;
	})/3;
	ou.debug("oscsampler4, 2");
	ou = ou.flat;
	ou.debug("oscsampler4, 3");
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
BufDef(\metal, "vipere/metal.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
)

(
	// chords
	Pdef(\xoscsampler, 
		Pbind(
			\instrument, \oscsampler4,
			\degree, Pseq([0,3,5,4],inf).stutter(8) + [0,3,7],
			\octave, 4,
			\bufnum, BufDef(\oeuf),
			\bufnum, BufDef(\metal),
			\bufnum, BufDef(\ukraine),
			\hpfreq, 50,
			\ffreq, 4700,
			//\freq, Pseq([100,1000,10000,10],inf).stutter(8),
			\range, 0,
			\framerange, 313,
			\posenv, [ Env([0,0.01,0.15,0.4953, 0.05], [0.01,1.1,3.6,3.6]) ],
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.6) ],
			],inf),
			\timeScale, 7,
			\levelScale, 0.45* Pseg(Pseq([0.01,0.1,1,10,100],inf),32),
			\levelScale, 0.0021,
			//\out, BusDef(\fx1),
			\pos, Pseq([0.43,0.67,0.423,0.52].rotate(1),inf)+0.1,
			\pos, Pseq([0.43,0.67,0.423,0.52,0.8].rotate(1),inf)+0,
			//\pos, 0.2,
			\hpmix, 1,
			\lpmix, 1,
			//\sustain, 1,
			//\legato, a[8].linlin(0,9,0.1,0.5),
			\legato, 2,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.4
		)
	).play;
)


(
	BufDef(\amen, "vipere/amenbreak.wav");
	Pdef(\drumkit, 
		Pbind(
			\instrument, \oscsampler4,
			//\degree, Pseq([0,3,5,4],inf).stutter(8) + [0,3,7],
			\octave, 4,
			\bufnum, BufDef(\ukraine),
			\bufnum, BufDef(\metal),
			\bufnum, BufDef(\oeuf),
			\bufnum, BufDef(\amen),
			\hpfreq, 50,
			\ffreq, 4700,
			//\freq, Pseq([100,1000,10000,10],inf).stutter(8),
			\range, 0,
			\framerange, 33,
			\posenv, [ Env([0,0.01,0.1,0.0, 0.0], [0.01,0.1,3.6,3.6]) ],
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.5,0.06) ],
			],inf),
			\timeScale, 1,
			\levelScale, 0.45* Pseg(Pseq([0.01,0.1,1,10,100],inf),32),
			\levelScale, 0.51,
			//\out, BusDef(\fx1),
			\pos, Pseq([0.43,0.67,0.423,0.52].rotate(1),inf)+0.1,
			\pos, Pseq([0.43,0.67,0.423,0.52,0.8].rotate(1),inf)+0,
			\pos, 0.66,
			//\pos, 0.2,
			\hpmix, 1,
			\lpmix, 1,
			//\sustain, 1,
			//\legato, a[8].linlin(0,9,0.1,0.5),
			\legato, 1/2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.4
		)
	);
	Pdef(\main, 

		Pdef(\drumseq1,
			Ppar([
				Pbind( 
					\pos, 0.66,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not
				) <> Pdef(\drumkit),
				Pbind( 
					\pos, 0.20,
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.5,0.16) ],
					],inf),
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,0, 1,0, 1,0,
					],inf).coin.not
				) <> Pdef(\drumkit),
				Pbind( 
					\pos, 0.19,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not
				) <> Pdef(\drumkit),

			].collect({ arg x; x
				//Pbind(\out,)
			}))

		)
	).play;
	Pdef(\drumseq1).set(\out, BusDef(\fx1));

)

	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;
