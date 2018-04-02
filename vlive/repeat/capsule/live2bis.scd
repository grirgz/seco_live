

			~drums.embedInStream
			~drums[\embedInStream]
			~drums.embedInStream = { arg self; self.proxy.embedInStream }
			~drums
			~drums.calm
			~drums.trans3
			~bass.new
			~bass.short
			Pdef(\part).embedInStream

	(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			~drums.proxy,
			~bass.proxy,
			~fxdrums.proxy,
			~fxbass.proxy,
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pseg(Pseq([0,4],inf),8),
				\pos, Pseg(Pseq([0,1,1/4],inf),1),
				\dur, 1/16,
				\gain, 1/2,
			)
		])
	)).play;
	)

	(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			~drums.proxy,
			~fxdrums.proxy,
			~fxbass.proxy,
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('loop/clean7_135bpm.flac'),
				\pos, Pseq([
					0.1,
					0.051,
					0.451,
					0.8,
				],inf).stutter(8),
				\posenv, Pseq([
					[ Env([0,0.0027,0],[0.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					0,0,0,0, 4,0,0,0,
					1,0,1,0, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/8,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
			),
		])
	)).play;
	)


	(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			~drums.proxy,
			~fxdrums.proxy,
			~fxbass.proxy,
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('loop/clean7_135bpm.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.7,
				],inf).stutter(8),
				\posenv, Pseq([
					[ Env([0,0.000027,0],[0.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1.02,1],[0.1,4.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 470,
				\gfreq, Pkey(\freq),
				\gdur, 0.09,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					16,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/4,
				\gain, ~pmodenv.(Pseq([
					3,0, 0,
				].stutter(2),inf), Pseq([
					0.9,0.1,
				]/16,inf)),
				\amp, 0.1,
				\out, BusDef(\csendbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\csendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('loop/clean7_135bpm.flac'),
				\pos, Pseq([
					0.7,
				],inf).stutter(8),
				\posenv, Pseq([
					[ Env([0,0.000027,0],[0.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1/2,1],[0.1,4.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 470,
				\gfreq, Pkey(\freq),
				\gdur, 0.09,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					16,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/4,
				\gain, ~pmodenv.(Pseq([
					1,0, 1,0,
					1,0, 0,1,
					1,0, 1,1,
					1,1, 0,0,
					1,0, 1,0,
					2,0, 2,0,
				].stutter(2),inf), Pseq([
					0.9,0.1,
				]/16,inf)),
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('loop/clean7_135bpm.flac'),
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\pos, Pseq([
					0.8,
				],inf).stutter(8),
				\posenv, Pseq([
					[ Env([0,0.000027,0],[0.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1/2,1],[0.1,4.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 70,
				\gfreq, Pkey(\freq),
				\gdur, 0.09,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					16,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/4,
				\gain, ~pmodenv.(Pseq([
					1,0, 1,0,
					1,0, 0,1,
					1,0, 1,1,
					1,1, 0,0,
					1,0, 1,0,
				].stutter(2),inf), Pseq([
					0.9,0.1,
				]/16,inf)),
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('loop/clean7_135bpm.flac'),
				\pos, Pseq([
					0.1,
					0.051,
					0.451,
					0.8,
				],inf).stutter(8),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					0,0,0,0, 4,0,0,0,
					1,0,1,0, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/8,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bsendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			),
		])
	)).play;
	)
