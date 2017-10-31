(
SynthDef(\playersec_looper, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec_osc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec_osczig, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	var speedtrigger = Impulse.ar(\trigfreq.kr*2);
	speed = speed * Demand.ar(speedtrigger, 0, Dseq([
		1,-1,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec_osczig_stereo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	var speedtrigger = Impulse.ar(\trigfreq.kr*2);
	speed = speed * Demand.ar(speedtrigger, 0, Dseq([
		1,-1,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos+[0,0.01]*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig.debug("sig");
	sig = sig.flop.sum.debug("sig");
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec_fixzig_stereo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	var speedtrigger = Impulse.ar(\trigfreq.kr);
	speed = speed * Demand.ar(speedtrigger, 0, Dseq([
		1,-1,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, 1, startPos: (pos+[0,0.01]*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig.debug("sig");
	sig = sig.flop.sum.debug("sig");
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\evol, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]/1), 1);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(72 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * env4 )));
	sig = sig * (LFSaw.ar(freq)*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
	dis = 16/10;
	sig = SinOsc.ar(freq * [1,1] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
	dis = 16/10;
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
	dis = SelectX.kr( SinOsc.kr(1/16).exprange(0.0001,1), [1, 16/10]);
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chocho, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, freq2=100;
	var sig;
	var ff;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,20, 40,1,70,40],[1,1.1,1.8,3, 0.5,10,10]), 1);
	env2 = EnvGen.kr(Env([0,0,0,0.01, 0,0,0.71,1.1240],[1,10.1,4.8,3, 0.5,10,10]), 1);
	ff = EnvGen.kr(Env([freq,freq,freq2],[0.1,0.08]), 1);
	sig = SinOsc.ar(ff * ( 1 + ( SinOsc.ar(freq * ( 1 + ( SinOsc.ar(12) * env2 ))) * \fmamp.kr(1) * env1 )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\filterfx, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = LPF.ar(sig, \lpf.kr(18000));
	sig = SelectX.ar(\lpmix.kr(0), [sig, sig1]);
	sig1 = HPF.ar(sig, \hpf.kr(50));
	sig = SelectX.ar(\hpmix.kr(0), [sig, sig1]);
	sig = LeakDC.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0,1,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

);

(
	
Pdefn(\chords, Pstep(Pseq([
	0,-1,0,-1,
	0,-1,-2,-1,
],inf),4));
Pdef(\evoltreb, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				\evoltreb,
				\evoltreb2,
				\evoltreb3,
				\evoltreb3,
			],inf).stutter(8*4*4),
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([

				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,1, 0,2,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				10,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1.8,0,1,
				7,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
		);
	])
);
Pdef(\evolbass, 
	Ppar([
		Pbind(
			\instrument, \evol,
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		);
	])
);
Pdef(\chocho, 
	Ppar([
		PmonoArtic( \chocho,
			\note, Pdefn(\chords),
			\fmamp, 1,
			\legato, Pseq([
				1,1,1,1, 1,1,1,0.8,
				1,1,1,1, 1,1,1,0.8,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.8,
			],inf),
			\freq2, Pkey(\freq)*2/3,
			\dur, 1,
			\amp, 0.1/2,
		);
	])
);
);


ProtoDef(\rdn).edit
ProtoDef(\rdn2).edit
//////////////////////////////////////////////////////////// PARTS

(
// haha!
	~master.();
Pdef(\part, Pdef(\haha, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,1,0,1,
					1,0,0,1, 1,1,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,1,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,0,1, 1,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pmono(\filterfx,
				\lpmix, ~pmodenv.(Pseq([0,0,0,1],inf), 1),
				\hpmix, ~pmodenv.(Pseq([0,0,0,1],inf), 1.2),
				\hpmix, 0,
				\lpmix, 0,
				\hpf, ~pmodenv.(Pseq([20,20,10000],inf), Pseq([5,2,1],inf)),
				\lpf, ~pmodenv.(Pseq([1000,1100,1200],inf), Pseq([2,1-0.1,0.1],inf)),
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2),
			),
			Pbind( // haha
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osczig,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\legato, Pseq([
					1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\dur, 1/8,
				\gain, 30,
				\gain, 1/2,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				
			//Pdef(\chocho),
				//Pdef(\evolbass),
			//	Pdef(\evoltreb),
		]) <> Pbind(
			\out, BusDef(\fx1,\audio),
		)
		
	])
)).play;
)

(
// bassy experiment 
	~master.();
Pdef(\part, Pdef(\bassy,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\pos, Pseq([
				~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
				~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
			],inf),
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				7, 0,0,0, 0,0,0,0,
				7, 0,0,0, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				4,0,0,0, 1,0,1,0,
				4,0,0,0, 0.81,0.8,0.81,0.8,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		//Pbind( // bass
			//\instrument, \playersec_fixzig_stereo,
			//\instrument, \playersec_osczig_stereo,
			//\instrument, Pseq([
				//\playersec_osc,
				//\playersec_osczig_stereo,
				//\playersec_osczig,
				//\playersec_osczig_stereo,
			//],inf),
			//\trigfreq, 400 * 1/4 * Pseq([
				//0,0,0,-1,
			//],inf).midiratio,
			//\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			//\pos, 0.4,
			//\speed, Pseq([
				//1,1.1,0.8,
			//],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodenv.(Pseq([0.1,1,0.1,2]/4,inf), 8)+2.0,
			//\lpfr, 8,
			//\legato, Pseq([
				//3,0,0,0, 1.82,0,1,0,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\bufnum, BufDef(\table, "field/table.flac"),
			//\bufnum, BufDef('loop/clean7_135bpm.flac'),
			//\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			//\bufnum, BufDef('voices/feynman.flac'),
			//\freq, 200,
			//\dur, 1/2,
			//\gain, 30,
			//\gain, 1/8,
			//\amp, 0.1,
		//),
			//0,Pdef(\chocho),
			Pdef(\evolbass),
			//12,Pdef(\evoltreb),
		
		
	])
)).play;
)

(
// bassy experiment + violin
	~master.();
Pdef(\part, Pdef(\bassyviolin,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//Pser([
						//0,
					//],16),
					Pseq([
						0,0,1,0, 1,0,1,0, 0,0,1,0, 1,1,0,1,
						0,0,1,0, 1,1,1,0, 0,0,1,0, 1,1,0,1,
					],3*90),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					Pser([
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.74,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.74,

						0.04, 0.04, 0.04, 0.04,  0.74, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.74,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.74,

						0.04, 0.04, 0.04, 0.04,  0.04, 0.74, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.74,
						0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.74,
					],inf),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Pbind( // violin
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),

			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),

			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
			],inf),

			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\speed, 1.2,
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(2/1*~t).range(0.2,2.2)+1.2 },2),
			],inf),
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				0,0,1,0, 4,0,0,0,
				0,0,0,0, 2,0,2,0,
				1,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		//Pbind( // bass
			//\instrument, \playersec_fixzig_stereo,
			//\instrument, \playersec_osczig_stereo,
			//\instrument, Pseq([
				//\playersec_osc,
				//\playersec_osczig_stereo,
				//\playersec_osczig,
				//\playersec_osczig_stereo,
			//],inf),
			//\trigfreq, 400 * 1/4 * Pseq([
				//0,0,0,-1,
			//],inf).midiratio,
			//\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			//\pos, 0.4,
			//\speed, Pseq([
				//1,1.1,0.8,
			//],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodenv.(Pseq([0.1,1,0.1,2]/4,inf), 8)+2.0,
			//\lpfr, 8,
			//\legato, Pseq([
				//3,0,0,0, 1.82,0,1,0,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\bufnum, BufDef(\table, "field/table.flac"),
			//\bufnum, BufDef('loop/clean7_135bpm.flac'),
			//\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			//\bufnum, BufDef('voices/feynman.flac'),
			//\freq, 200,
			//\dur, 1/2,
			//\gain, 30,
			//\gain, 1/8,
			//\amp, 0.1,
		//),
			//0,Pdef(\chocho),
			Pdef(\evolbass),
			//12,Pdef(\evoltreb),
		
		
	])
));
Pdef(\part).play;
)

//////////////////////////////////////////////////////////// PARTS TRANS
(
// haha intro
	~master.();
Pdef(\part, Pdef(\haha_intro, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,0,0,0, 0,0,0,0,
				],8*80),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,0.02,
			],inf).stutter(1),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pser([
					1, 0, 0, 0,  1, 1, 1, 0,
				],16),
				Pser([
					1, 0, 1, 0,  1, 0, 1, 1,
					1, 0, 1, 1,  1, 0, 1, 1,
					1, 0, 0, 1,  1, 0, 1, 1,
				],16*80),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pmono(\filterfx,
				\lpmix, ~pmodenv.(Pseq([1,1],inf), 1),
				\hpmix, ~pmodenv.(Pseq([1,1],inf), 1.2),
				\hpf, ~pmodenv.(Pseq([1000,150,150],inf), Pseq([8],inf)),
				\lpf, ~pmodenv.(Pseq([8020,18000,18000],inf), Pseq([8],inf)),
				\inbus, BusDef(\fx1, \audio),
				\gain, ~pmodenv.(Pseq([1/4,1/2,1,1],inf), 8),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2),
			),
			Pbind( // haha
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osczig,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/48*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\legato, Pseq([
					1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\dur, 1/8,
				\gain, 30,
				\gain, 1/2,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					2,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				
			//Pdef(\chocho),
				//Pdef(\evolbass),
			//	Pdef(\evoltreb),
		]) <> Pbind(
			\out, BusDef(\fx1,\audio),
		)
		
	])
)).play;
)


(
// bassy experiment 
	~master.();
Pdef(\part, Pdef(\bassy_trans,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pser([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,1,0,

						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,1,1,0,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,1,1, 0,0,0,1,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8*14),
					Pser([
						0,0,1,0, 0,0,0,0, 
						0,1,0,0, 1,0,1,1,
					],8*2),
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pser([
						1,0,0,0, 1,0,0,0,
					],16*14),
					Pser([
						0,0,0,0, 0,0,0,0,
					],16*2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pser([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,1,0,0,
				],16*14),
				Pser([
					0,0,0,0, 0,0,0,0,
				],16*2),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\pos, Pseq([
				~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
				~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
			],inf),
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				7, 0,0,0, 0,0,0,0,
				7, 0,0,0, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				4,0,0,0, 1,0,1,0,
				4,0,0,0, 0.81,0.8,0.81,0.8,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		//Pbind( // bass
			//\instrument, \playersec_fixzig_stereo,
			//\instrument, \playersec_osczig_stereo,
			//\instrument, Pseq([
				//\playersec_osc,
				//\playersec_osczig_stereo,
				//\playersec_osczig,
				//\playersec_osczig_stereo,
			//],inf),
			//\trigfreq, 400 * 1/4 * Pseq([
				//0,0,0,-1,
			//],inf).midiratio,
			//\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			//\pos, 0.4,
			//\speed, Pseq([
				//1,1.1,0.8,
			//],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodenv.(Pseq([0.1,1,0.1,2]/4,inf), 8)+2.0,
			//\lpfr, 8,
			//\legato, Pseq([
				//3,0,0,0, 1.82,0,1,0,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\bufnum, BufDef(\table, "field/table.flac"),
			//\bufnum, BufDef('loop/clean7_135bpm.flac'),
			//\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			//\bufnum, BufDef('voices/feynman.flac'),
			//\freq, 200,
			//\dur, 1/2,
			//\gain, 30,
			//\gain, 1/8,
			//\amp, 0.1,
		//),
			//0,Pdef(\chocho),
			Pdef(\evolbass),
			//12,Pdef(\evoltreb),
		Pbind(
			\instrument, Pseq([
				\evoltreb3,
			],inf).stutter(8*4*4),
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				Pser([
					0
				],8*4),
				32-1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, ~pmodenv.(Pseq([0,0,0,0, 1,1,1,1],inf) * 0.2, 2),
			\octave, 5,
			\dur, 1/8,
		),
		
		
	])
)).play;
);

(
// haha!
	~master.();
Pdef(\part, Pdef(\haha_trans, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,1,

					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,1,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,1,

					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,1,0,1,
					1,0,0,1, 1,1,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,1,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,0,1, 1,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pmono(\filterfx,
				\lpmix, ~pmodenv.(Pseq([0,1],inf), 1),
				\hpmix, ~pmodenv.(Pseq([0,1],inf), 1.2),
				\hpmix, 0,
				\lpmix, 0,
				\hpf, ~pmodenv.(Pseq([20,20,10000],inf), Pseq([5,2,1],inf)),
				\lpf, ~pmodenv.(Pseq([1000,1100,1200],inf), Pseq([2,1-0.1,0.1],inf)),
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2),
			),
			Pbind( // haha
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osczig,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\legato, Pseq([
					1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\dur, 1/8,
				\gain, 30,
				\gain, 1/2,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),

			Pbind( // rise
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, 2,
				\pos, ~pmodenv.(Pseq([1,2,1,3]/4,inf), 1),
				\pos, 0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0, 0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, ~pmodenv.(Pseq([
					200,200,200,200,
					200,200,200,200,
					4000,
				],inf), 2),
				\gain, 30,
				\gain, 1/8,
				\dur, 1/2,
				\amp, 0.1,
			),
			Pbind( // hipitch
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, 2,
				\pos, ~pmodenv.(Pseq([1,2,1,3]/84+0.8,inf), 1),
				\lpfr, 8,
				\legato, Pseq([
					0,0,
					0,0,
					0,0,
					0,0,

					0,0,
					0,0,
					0,0,
					1,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 1200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				
			//Pdef(\chocho),
				//Pdef(\evolbass),
			//	Pdef(\evoltreb),
		]) <> Pbind(
			\out, BusDef(\fx1,\audio),
		)
		
	])
)).play;
);

(
// bassy experiment + violin

SynthDef(\breakfx, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = Disintegrator.ar(sig, 0.5, -0.1);
	sig1 = Decimator.ar(sig, 12200.5, 20);
	sig1 = CombL.ar(sig, 0.2,0.02,1)+sig1;
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = LeakDC.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

	~master.();
	Pdef(\part, Pdef(\bassyviolin_trans,
		Ppar([

			Ppar([
				Pmono(\breakfx,
					\dur, 1,
					\inbus, BusDef(\fx2, \audio),
					\mix, ~pmodenv.(Pseq([
						0,0,0,0, 
						0,0,0,0,
						0,0,0,0,
						1,1,1,1,
					],inf), 2),
					\out, BusDef(\sendbus1),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,1,0,

						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,1,1,0,
					],inf).coin.not,
					\dur, 1/8,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snapclap,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/1,
					\dur, 1/8,
					\amp, 0.28,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/8,
					\amp, 0.1/2,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.1/4,
					\dur, 1/8,
					\amp, 0.1/5,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						//Pser([
						//0,
						//],16),
						Pseq([
							0,0,1,0, 1,0,1,0, 0,0,1,0, 1,1,0,1,
							0,0,1,0, 1,1,1,0, 0,0,1,0, 1,1,0,1,
						],3*90),
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						Pser([
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.74,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.74,

							0.04, 0.04, 0.04, 0.04,  0.74, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.74,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.74,

							0.04, 0.04, 0.04, 0.04,  0.04, 0.74, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.74,
							0.04, 0.04, 0.04, 0.04,  0.04, 0.04, 0.74, 0.04,
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.74,
						],inf),

					],inf),
					\dur, 1/16,
					\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.02,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0,
					],inf).stutter(8),
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 1,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
							1,0,1,1, 0,1,0,0,
						],4),
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.1,
						],8*2)*1,
					],inf),
					\gain, 0.6,
					\dur, 1/16,
					\amp, 0.1,
				),
			]) <> Pbind(\out, BusDef(\fx2)),

			Ppar([
				Pmono(\breakfx,
					\dur, 1,
					\inbus, BusDef(\fx1, \audio),
					\mix, ~pmodenv.(Pseq([
						0,0,0,0, 
						0,0,0,0,
						0,0,0,0,
						1,1,1,1,
					],inf), 2),
					\out, 0,
					\amp, 0.1,
				),
				Pbind( // violin
					\instrument, \playersec_fixzig_stereo,
					\instrument, \playersec_osczig_stereo,
					\instrument, Pseq([
						\playersec_osc,
						\playersec_osczig,
						\playersec_osczig_stereo,
					],inf),
					\trigfreq, 400 * 1/1 * Pseq([
						0,0,0,-1,
					],inf).midiratio,
					\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
					\pos, 0.4,
					\speed, Pseq([
						1,1.1,0.8,
					],inf),
				
					//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
					//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
					//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\speed, Pseq([
						4,4,4,1
					],inf).stutter(16*1),
				
					\pos, Pseq([
						~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
					],inf),
				
					\lpfr, 8,
					\legato, 0.5,
					\bufnum, BufDef(\table, "field/table.flac"),
					\bufnum, BufDef('loop/clean7_135bpm.flac'),
					\bufnum, BufDef('loop/loop3b_185bpm.flac'),
					\bufnum, BufDef('voices/feynman.flac'),
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\legato, Pseq([
						4,0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\freq, 200,
					\dur, 1/8,
					\gain, 30,
					\gain, 1/8,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \playersec_fixzig_stereo,
					\instrument, \playersec_osczig_stereo,
					\instrument, Pseq([
						\playersec_osc,
						\playersec_osczig,
						\playersec_osczig_stereo,
					],inf),
					\trigfreq, 400 * 1/4 * Pseq([
						0,0,0,-1,
					],inf).midiratio,
					\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
					\pos, 0.4,
					\speed, Pseq([
						1,1.1,0.8,
					],inf),
					//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
					\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
					\speed, 1.2,
					\pos, Pseq([
						~pmodsynth.({ SinOsc.kr(2/1*~t).range(0.2,2.2)+1.2 },2),
					],inf),
					\lpfr, 8,
					\legato, 0.5,
					\bufnum, BufDef(\table, "field/table.flac"),
					\bufnum, BufDef('loop/clean7_135bpm.flac'),
					\bufnum, BufDef('loop/loop3b_185bpm.flac'),
					\bufnum, BufDef('voices/feynman.flac'),
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\legato, Pseq([
						0,0,0,0, 4,0,0,0,
						0,0,1,0, 4,0,0,0,
						0,0,0,0, 2,0,2,0,
						1,0,0,0, 4,0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\freq, 200,
					\dur, 1/8,
					\gain, 30,
					\gain, 1/8,
					\amp, 0.1,
				),
				Pdef(\evolbass),
			]) <> Pbind(\out, BusDef(\fx1)),
		])
	));
	Pdef(\part).play;
)

/////////////////////// main
(
	~master2.();
Pdef(\part,Pdef(\main, 
	Pseq([
				//Pfindur(8,Pdef(\haha_intro)),
		Ppar([
			Pdef(\supx),
			Pseq([
				//Pfindur(12,Pdef(\haha_trans)),
				//Pfindur(4,Pdef(\haha_trans3)),
				Pfindur(16,Pdef(\bassy_trans)),
				Pfindur(16,Pdef(\bassyviolin_trans)),
				Pfindur(16,Pdef(\bassy_trans2)),
				Pfindur(16,Pdef(\bassy_trans3)),
				Pfindur(8,Pdef(\bassy_trans)),
				Pfindur(8,Pdef(\haha_trans)),
			],1),
		]),
		
	])
)).play;
);

////////////////////////////
////////////////////////////
////////////////////////////
////////////////////////////

Pdef(\bassyviolin).clear
Pdef(\part).clear
Pdef(\main).clear
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;

(
Pdef(\supx, 
	Ppar([
		Pbind(\instrument, \cling,
			\degree, Pseq([0],inf),
			\legato, Pseq([
				0.1, 0.1, 0.1,1.3,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0,
				0,1,0,0,
			],inf).coin.not,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
).play;
);




(
// haha!
	~master.();
Pdef(\part, Pdef(\haha_trans2, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 1,0,0,1,
					1,0,0,1, 0,0,0,0,

				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([

					1,0,0,1, 1,1,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([

					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pmono(\filterfx,
				\lpmix, ~pmodenv.(Pseq([0,1],inf), 1),
				\hpmix, ~pmodenv.(Pseq([0,1],inf), 1.2),
				\lpmix, 0,
				\hpmix, 0,
				\hpf, ~pmodenv.(Pseq([20,20,10000],inf), Pseq([5,2,1],inf)),
				\lpf, ~pmodenv.(Pseq([1000,1100,1200],inf), Pseq([2,1-0.1,0.1],inf)),
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2),
			),
			Pbind( // haha
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osczig,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,1,1,1, 0,0,0,0,
					1,0,0,1, 0,1,1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\gain, 30,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,1,
					0,1,
					0,0,
					0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\gain, 30,
				\gain, 1/8,
				\dur, 1/2,
				\amp, 0.1,
			),

			Pbind( // rise
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, 2,
				\pos, ~pmodenv.(Pseq([1,2,1,3]/4,inf), 1),
				\pos, 0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0, 0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, ~pmodenv.(Pseq([
					200,200,200,200,
					200,200,200,200,
					4000,
				],inf), 2),
				\gain, 30,
				\gain, 1/8,
				\dur, 1/2,
				\amp, 0.1,
			),
			Pbind( // hipitch
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, 2,
				\pos, ~pmodenv.(Pseq([1,2,1,3]/84+0.8,inf), 1),
				\lpfr, 8,
				\legato, Pseq([
					0,0,
					0,0,
					0,0,
					0,0,

					0,0,
					0,0,
					0,0,
					1,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 1200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				
			//Pdef(\chocho),
				//Pdef(\evolbass),
			//	Pdef(\evoltreb),
		]) <> Pbind(
			\out, BusDef(\fx1,\audio),
		)
		
	])
)).play;
);

(
// haha!
	~master.();
Pdef(\part, Pdef(\haha_trans3, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 1,0,0,1,
					1,0,0,1, 0,0,0,0,

				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([

					1,0,0,1, 1,1,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 1,0,1,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([

					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pmono(\filterfx,
				\lpmix, ~pmodenv.(Pseq([0,1],inf), 1),
				\hpmix, ~pmodenv.(Pseq([0,1],inf), 1.2),
				\lpmix, 0,
				\hpmix, 0,
				\hpf, ~pmodenv.(Pseq([20,20,10000],inf), Pseq([5,2,1],inf)),
				\lpf, ~pmodenv.(Pseq([1000,1100,1200],inf), Pseq([2,1-0.1,0.1],inf)),
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2),
			),
			Pbind( // haha
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osczig,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,1,1,1, 0,0,0,0,
					1,0,0,1, 0,1,1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\gain, 30,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,1,
					0,1,
					0,0,
					0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\gain, 30,
				\gain, 1/8,
				\dur, 1/2,
				\amp, 0.1,
			),

			Pbind( // rise
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, 2,
				\pos, ~pmodenv.(Pseq([1,2,1,3]/4,inf), 1),
				\pos, 0.7,
				\lpfr, 8,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0, 0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, ~pmodenv.(Pseq([
					200,200,200,200,
					200,200,200,200,
					4000,
				],inf), 2),
				\gain, 30,
				\gain, 1/8,
				\dur, 1/2,
				\amp, 0.1,
			),
			Pbind( // hipitch
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, 2,
				\pos, ~pmodenv.(Pseq([1,2,1,3]/84+0.8,inf), 1),
				\lpfr, 8,
				\legato, Pseq([
					0,0,
					0,0,
					0,0,
					0,0,

					0,0,
					0,0,
					0,0,
					1,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 1200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				
			//Pdef(\chocho),
				//Pdef(\evolbass),
			//	Pdef(\evoltreb),
		]) <> Pbind(
			\out, BusDef(\fx1,\audio),
		)
		
	])
)).play;
);

(
// bassy experiment 
	~master.();
Pdef(\part, Pdef(\bassy_trans2,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pser([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
					Pser([
						0,0,1,0, 0,0,0,0, 
						0,1,0,0, 1,0,1,1,
					],8*2),
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pser([
						1,0,0,0, 0,0,0,0,
					],16*14),
					Pser([
						0,0,0,0, 0,0,0,0,
					],16*2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],16*14),
				Pser([
					0,0,0,0, 0,0,0,0,
				],16*2),
			],inf).coin.not,
			\speed, 1,
			\lag, 0.051,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\pos, Pseq([
				~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
				~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
			],inf),
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				7, 0,0,0, 0,0,0,0,
				7, 0,0,0, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				4,0,0,0, 1,0,1,0,
				4,0,0,0, 0.81,0.8,0.81,0.8,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		//Pbind( // bass
			//\instrument, \playersec_fixzig_stereo,
			//\instrument, \playersec_osczig_stereo,
			//\instrument, Pseq([
				//\playersec_osc,
				//\playersec_osczig_stereo,
				//\playersec_osczig,
				//\playersec_osczig_stereo,
			//],inf),
			//\trigfreq, 400 * 1/4 * Pseq([
				//0,0,0,-1,
			//],inf).midiratio,
			//\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			//\pos, 0.4,
			//\speed, Pseq([
				//1,1.1,0.8,
			//],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodenv.(Pseq([0.1,1,0.1,2]/4,inf), 8)+2.0,
			//\lpfr, 8,
			//\legato, Pseq([
				//3,0,0,0, 1.82,0,1,0,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\bufnum, BufDef(\table, "field/table.flac"),
			//\bufnum, BufDef('loop/clean7_135bpm.flac'),
			//\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			//\bufnum, BufDef('voices/feynman.flac'),
			//\freq, 200,
			//\dur, 1/2,
			//\gain, 30,
			//\gain, 1/8,
			//\amp, 0.1,
		//),
			//0,Pdef(\chocho),
			Pdef(\evolbass),
			//12,Pdef(\evoltreb),
		Pbind(
			\instrument, Pseq([
				\evoltreb3,
			],inf).stutter(8*4*4),
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				Pser([
					0
				],8*4),
				32-1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, ~pmodenv.(Pseq([0,0,0,0, 1,1,1,1],inf) * 0.2, 2),
			\octave, 5,
			\dur, 1/8,
		),
		
		
	])
)).play;
);

(
	// test triphop beat
	~master.();
Pdef(\part, Pdef(\bassy_trans3,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pser([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						1,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,

					//	1,0,0,0, 0,0,0,0,
					//	0,0,0,0, 0,0,0,0,
					//	1,0,0,0, 0,0,0,0,
					//	0,0,0,0, 0,0,0,0,
					],8*14*2),
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,

					//0,0,0,0, 0,0,0,1,
					//0,1,0,0, 0,0,0,1,
					//0,0,0,0, 0,0,1,0,
					//0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
					],8*14),
				],inf).coin.not,
				//\lag, 0.05,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,0,

					//	0,0,0,0, 0,0,0,0,
					//	1,0,1,0, 0,0,0,0,
					//	0,0,0,0, 0,0,0,1,
					//	0,0,1,0, 0,0,0,1,
					],16*14*2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\sustain, 0.02,
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					//0.31, 0.31, 0.31, 0.31,
					0.01, 0.01, 0.01, 0.01,
			
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.15,0.1,0.8,0.02) ],
				],inf),
				\dur, 1/8,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0272,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pser([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,

						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					],16*14),
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					Pseq([
						0.1,
					],inf),
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],16*14),
				Pser([
					0,0,0,0, 0,0,0,0,
				],16*2),
			],inf).coin.not,
			\speed, 1,
			\lag, 0.051,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),
		Pbind(\out, BusDef(\sendbus2))<>Ppar([
			Pbind(
				\amp, ~pmodenv.(Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf)* 0.1, 1/4)
			)<> Pdef(\evolbass),
		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\pos, Pseq([
				~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
				~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
			],inf),
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				7, 0,0,0, 0,0,0,0,
				7, 0,0,0, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				4,0,0,0, 1,0,1,0,
				4,0,0,0, 0.81,0.8,0.81,0.8,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		])

		
		
	])
)).play;
);

(
	// test triolet beat
	~master.();
Pdef(\part, Pdef(\bassy_trans3,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				// 13 !!!!
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1, 0,1,0,
					0,0,0, 1,0,0,

				],inf).coin.not,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,1,0, 0,1,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/9,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					0
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0
				],inf).coin.not,
				//\lag, 0.05,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\sustain, 0.02,
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					//0.31, 0.31, 0.31, 0.31,
					0.01, 0.01, 0.01, 0.01,
			
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.15,0.1,0.8,0.02) ],
				],inf),
				\dur, 1/8,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0272,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1, 1,0,1, 0,0,1, 1,0,1,
					1,1,1, 1,0,1, 0,0,1, 1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					Pseq([
						0.1,
					],inf),
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],16*14),
				Pser([
					0,0,0,0, 0,0,0,0,
				],16*2),
			],inf).coin.not,
			\speed, 1,
			\lag, 0.051,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),
		Pbind(\out, 0)<>Ppar([
			Pbind(
				\amp, ~pmodenv.(Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf)* 0.1, 1/4)
			)<> Pdef(\evolbass),
		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\pos, Pseq([
				~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
				~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
				~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
			],inf),
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				7, 0,0,0, 0,0,0,0,
				7, 0,0,0, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				0.8,0.8,0.8,0.8, 0,0,0,0,
				4,0,0,0, 1,0,1,0,
				4,0,0,0, 0.81,0.8,0.81,0.8,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
		])

		
		
	])
)).play;
);

(
	// test triolet beat 2
	~master.();
	Pdef(\part, Pdef(\bassy_trans3,
		Ppar([

			Pbind(\out, BusDef(\sendbus1))<>Ppar([
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,1,0,1, 1,0,0,1,0,0,
						1,0,0,1,0,1, 1,0,0,1,0,0,

						1,0,1,1,0,1, 1,0,0,1,0,0,
						0,0,1,0,0,0, 1,0,0,1,0,0,
						1,0,1,1,0,1, 1,0,0,1,0,0,
						1,0,0,0,0,0, 1,0,0,1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,

						1,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0, 0,0,0,

						0,0,0, 0,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind(
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.2) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/3,
				),
				Pbind(
					\instrument, \snapclap,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/1,
					\dur, 1/8,
					\amp, 0.28,
					\isRest, true,
				),
				Pbind(
					\instrument, \snaretuned2,
					\isRest, Pseq([
						0
					],inf).coin.not,
					//\lag, 0.05,
					\sustain, 0.1/4,
					\dur, 1/8,
					\amp, 0.04,
					\isRest, true,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						0
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\sustain, 0.02,
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						//0.31, 0.31, 0.31, 0.31,
						0.01, 0.01, 0.01, 0.01,

					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.15,0.1,0.8,0.02) ],
					],inf),
					\dur, 1/8,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0272,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0,
					],inf).stutter(8),
					\isRest, Pseq([
						Pseq([
							1,0,1, 0,0,0, 1,0,0, 0,0,1,
							1,0,0, 1,0,0, 1,0,0, 0,0,1,
						],4),
						Pseq([
							1,0,1, 0,0,0, 1,0,0, 0,0,1,
							0,0,1, 1,0,0, 0,0,0, 0,1,0,
						],4),
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.1,
						],8*2)*1,
					],inf),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
			]),
			Pbind(\out, 0)<>Ppar([
				Pbind(
					\instrument, \playersec_fixzig_stereo,
					\instrument, \playersec_osczig_stereo,
					\instrument, Pseq([
						\playersec_osc,
						\playersec_osczig,
						\playersec_osczig_stereo,
					],inf),
					\trigfreq, 400 * 1/4 * Pseq([
						0,0,0,-1,
					],inf).midiratio,
					\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
					\pos, 0.4,
					\speed, Pseq([
						1,1.1,0.8,
					],inf),
					//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
					\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
					\pos, Pseq([
						~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
						~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
						~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
						~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
					],inf),
					\lpfr, 8,
					\legato, 0.5,
					\bufnum, BufDef(\table, "field/table.flac"),
					\bufnum, BufDef('loop/clean7_135bpm.flac'),
					\bufnum, BufDef('loop/loop3b_185bpm.flac'),
					\bufnum, BufDef('voices/feynman.flac'),
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\legato, Pseq([
						7, 0,0,0, 0,0,0,0,
						7, 0,0,0, 0,0,0,0,
						0.8,0.8,0.8,0.8, 0,0,0,0,
						0.8,0.8,0.8,0.8, 0,0,0,0,
						4,0,0,0, 1,0,1,0,
						4,0,0,0, 0.81,0.8,0.81,0.8,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\freq, 200,
					\dur, 1/8,
					\gain, 30,
					\gain, 1/8,
					\amp, 0.1,
					\isRest, true,
				),
			])



		])
	)).play;
)

///////////////////////////////////////////////////////////////////

(
Pdef(\glitch, 
	Ppar([
		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodenv.(Pseq([0.1,1,0.1,2]/4,inf), 8)+2.0,
			\lpfr, 8,
			\legato, 1,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\freq, 200,
			\dur, 1/2,
			\gain, 30,
			\gain, 1/2,
			\amp, 0.1,
		);
		
	])
).play;
)

{ SinOsc.ar(200) ! 2 * 0.1}.play;

(
Pdef(\glitch, 
	Ppar([
		Pbind(
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/4 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
			\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			\lpfr, 8,
			\legato, 1,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\freq, 200,
			\dur, 1/2,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		);
		
	])
).play;
)


(
	~master.();
Pdef(\glitch, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1,0,
					1,0,1,0,
					0,0,1,0,
					1,1,0,1,
					0,0,1,0,
					1,1,1,0,
					0,0,1,0,
					1,1,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,0,1, 1,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pbind(
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					0,0,0,0, 4,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\dur, 1/8,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					3,0,0,0, 1.82,0,1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				Pdef(\chocho),
				//Pdef(\evolbass),
				Pdef(\evoltreb),
		]) <> Pbind(\out, BusDef(\sendbus2))
		
	])
).play;
)

(
	~master.();
Pdef(\glitch, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1,0,
					1,0,1,0,
					0,0,1,0,
					1,1,0,1,
					0,0,1,0,
					1,1,1,0,
					0,0,1,0,
					1,1,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
			
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,0,1, 1,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),

		Ppar([
			Pmono(\filterfx,
				\lpmix, ~pmodenv.(Pseq([0,1],inf), 1),
				\hpmix, ~pmodenv.(Pseq([0,1],inf), 1.2),
				\hpf, ~pmodenv.(Pseq([20,20,10000],inf), Pseq([5,2,1],inf)),
				\lpf, ~pmodenv.(Pseq([1000,1100,1200],inf), Pseq([2,1-0.1,0.1],inf)),
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2),
			),
			Pbind(
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					0,0,0,0, 4,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\freq, 200,
				\dur, 1/8,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \playersec_fixzig_stereo,
				\instrument, \playersec_osczig_stereo,
				\instrument, Pseq([
					\playersec_osc,
					\playersec_osczig_stereo,
					\playersec_osczig,
					\playersec_osczig_stereo,
				],inf),
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
				\pos, 0.4,
				\speed, Pseq([
					1,1.1,0.8,
				],inf),
				\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\pos, ~pmodenv.(Pseq([1,2,1,3]/14,inf), 8)+0.7,
				\lpfr, 8,
				\legato, Pseq([
					3,0,0,0, 1.82,0,1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\bufnum, BufDef(\table, "field/table.flac"),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\bufnum, BufDef('loop/loop3b_185bpm.flac'),
				\bufnum, BufDef('voices/feynman.flac'),
				\freq, 200,
				\dur, 1/2,
				\gain, 30,
				\gain, 1/8,
				\amp, 0.1,
			),
				Pdef(\chocho),
				//Pdef(\evolbass),
				Pdef(\evoltreb),
		]) <> Pbind(
			\out, BusDef(\fx1,\audio),
		)
		
	])
).play;
)
