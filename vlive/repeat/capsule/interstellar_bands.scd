

(
SynthDef(\ploux2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1,0.1],[0.1,0.8,1])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([1,2,1,0.1],[0.1,0.8,1])), 1);
	sig = SinOsc.ar(freq * env1.round(\roundfreq.kr(0.3)));
	sig = sig + SinOsc.ar(freq * env1);
	sig = sig.fold(\fold.kr(1) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,3],inf),8)*200,
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1],[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,1,1],inf),8),
			\sustain, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([Pwhite(0,0.041,inf)+Pwhite(0,0.041,inf).stutter(9)+1],inf),0.1)*[100,230,721.4],
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1]/100+1,[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,1,1],inf),8),
			\sustain, 1/3,
			\amp, 0.01,
		),
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,3],inf),8)*40,
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1],[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([1/16,0.1,0.05,1,1],inf),7),
			\sustain, 1,
			\amp, 0.01,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([Pwhite(0,0.041,inf)+Pwhite(1,0.041,inf).stutter(9)+1],inf),0.1)*[100,230,721.4],
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1]/100+1,[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,0.2,0.12],inf),8),
			\sustain, 1/3,
			\amp, 0.01,
		),
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,3],inf),8)*40,
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1],[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([1/16,0.1,0.05,0.4],inf),7),
			\sustain, 1,
			\amp, 0.01,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([Pwhite(0,0.041,inf)+Pwhite(0,0.041,inf).stutter(9)+1],inf),0.1)*[100,130,121.4],
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1]/100+1,[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,0.2,0.12],inf),8),
			\sustain, 1/3,
			\amp, 0.01,
		),
		
	])
)).play;
);
