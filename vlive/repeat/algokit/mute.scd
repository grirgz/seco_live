
(
SynthDef(\muter, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig; 
	env2 = EnvGen.kr(Env([0,0,1],[0.1,0.1]), 1);
	trig = In.kr(BusDef(\mutebus)) * env2;
	env1 = EnvGen.kr(Env([1,0.5,0.5],[0.1,0.8]), trig);
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));
	sig1 = LFSaw.ar(freq) * EnvGen.kr(Env([0,1,0],[0.01,0.4]), trig);
	sig = SinOsc.ar(freq) * env1;
	sig = sig * ( sig1 + 1 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\muter, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig; 
	env2 = EnvGen.kr(Env([0,0,1],[0.1,0.1]), 1);
	trig = In.kr(BusDef(\mutebus)) * env2;
	env1 = EnvGen.kr(Env([1,0.5,0.5],[0.1,0.8]), trig);
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));
	sig1 = LFSaw.ar(freq) * EnvGen.kr(Env([0,1,0],[0.01,0.4]), trig);
	sig = SinOsc.ar(freq) * env1;
	sig = sig * ( sig1 + 1 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\muter, Pbind(
	\instrument, \muter,
	\degree, Pseq([0,2],inf),
	\sustain,2,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\muter, 
	Ppar([
		Pbind(
			\instrument, \muter,
			\degree, Pseq([0],inf),
			\dur, [1,1/2,1/4].choose,
			\amp, 0.1
		),
		Pbind(
			\instrument, \muter,
			\degree, Pseq([0],inf),
			\dur, [1,1/2,1/4].choose,
			\amp, 0.1
		),
		
	])
).play;
)

///////////////////////////////

(
SynthDef(\mutecymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	var mutetrig, muteenv;

	mutetrig = In.kr(BusDef(\mutebus)) * EnvGen.kr(Env([0,0,1],[0.01,0.1]), 1);
	muteenv = EnvGen.kr(Env([1,0.5,0.0],[0.1,0.1]/2), mutetrig, doneAction:2);
	//muteenv = 1;
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));


	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([8261, 11410, 1460], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1180,6810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([3171,7470,13845],[0.04,\rel.kr(2.4)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env1 = env1 * muteenv;
	sig = pop/2 + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.71,0.9) * XLine.kr(1.3,1,1) * (muteenv + 0.51)) + LPF.ar(WhiteNoise.ar(0.1), 11300 );
	sig = ( pop/2 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, 17000);
	sig = LPF.ar(sig, 11000) + ( sig/2 );
	//sig = BRF.ar(sig, MouseX.kr(20,20000).poll, MouseY.kr(0.1,1));
	sig = BRF.ar(sig, 12000);
	sig = sig * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.1,0.1,0.8,2.4,1,-8) ),gate,doneAction:2) * muteenv;
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\muter, 
	Ppar([
		Pbind(
			\instrument, \mutecymbal,
			\degree, Pseq([0],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,0,1,1, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1
		),
		//Pbind(
		//	\instrument, \mutecymbal,
		//	\degree, Pseq([0],inf),
		//	\dur, 1,
		//	\amp, 0.1
		//),
		
	])
).play;
)

Pdef(\muter).clear


////////////////////////////////////////

(
SynthDef(\bassmuter, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var mutetrig, muteenv;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	mutetrig = In.kr(BusDef(\mutebus)) * EnvGen.kr(Env([0,0,1],[0.01,0.1]), 1);
	//muteenv = EnvGen.kr(Env([1,0.25,0.25],[0.4,0.1]/2), mutetrig, doneAction:0);
	//muteenv = EnvGen.kr(Env([1,0.5,0.5],[0.4,0.1]/2), mutetrig, doneAction:0);
	muteenv = EnvGen.kr(Env([1,2,2],[0.04,0.1]/2), mutetrig, doneAction:0);
	//muteenv = 1;
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));

	env1 = EnvGen.kr(Env([1,7400,1],[0.1,4.8]), 1);

	freq = freq * muteenv * [1,1+(1/muteenv*0.00001),1/2,2];
	sig = LFSaw.ar(freq);
	sig = Select.ar(sig+1*2, [LFCub.ar(freq), Saw.ar(freq), Pulse.ar(freq)]);
	sig = Select.ar(sig+1*2, [LFCub.ar(freq), Saw.ar(freq), Pulse.ar(freq)].rotate(1));
	sig = Select.ar(sig+1*2, [LFCub.ar(freq), Saw.ar(freq), Pulse.ar(freq)]);
	//sig = sig.mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq + env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	//sig = sig *amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\muter, Pbind(
	\instrument, \bassmuter,
	\degree, Pseq([0,2,4,2],inf),
	\pan, Pwhite(-1,1.0,inf),
	\pan, Pseq([-1,1],inf),
	\legato, 1.2,
	\isRest, Pseq([
		1,0,0,0, 1,1,0,0,
		1,1,1,1, 1,1,0,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

ProtoDef(\piano).startControl(Pdef(\muter))





////////////////////////////////////////

(
SynthDef(\bassmuter, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mutetrig, muteenv;

	mutetrig = In.kr(BusDef(\mutebus)) * EnvGen.kr(Env([0,0,1],[0.01,0.1]), 1);
	//muteenv = EnvGen.kr(Env([1,0.25,0.25],[0.4,0.1]/2), mutetrig, doneAction:0);
	//muteenv = EnvGen.kr(Env([1,0.5,0.5],[0.4,0.1]/2), mutetrig, doneAction:0);
	muteenv = EnvGen.kr(Env([0.001,1,1],[1.24,0.1]/2), mutetrig, doneAction:0);
	//muteenv = 1;
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));

	env1 = EnvGen.kr(Env([1,7400,1],[0.1,4.8]), 1);

	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * muteenv + 1));
	sig = sig / 2;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq + env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	//sig = sig *amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\muter, Pbind(
	\instrument, \bassmuter,
	\degree, Pseq([0,2,4,2],inf),
	\pan, Pwhite(-1,1.0,inf),
	\pan, Pseq([-1,1],inf),
	\legato, 1.2,
	\isRest, Pseq([
		1,0,0,0, 1,1,0,0,
		1,1,1,1, 1,1,0,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

ProtoDef(\piano).startControl(Pdef(\muter))


//////////////////////////////////////////////////

SynthDef(\playersec_mute, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var mutetrig, muteenv;

	mutetrig = In.kr(BusDef(\mutebus)) * EnvGen.kr(Env([0,0,1],[0.01,0.1]), 1);
	//muteenv = EnvGen.kr(Env([1,0.25,0.25],[0.4,0.1]/2), mutetrig, doneAction:0);
	//muteenv = EnvGen.kr(Env([1,0.5,0.5],[0.4,0.1]/2), mutetrig, doneAction:0);
	muteenv = EnvGen.kr(Env([1,0,0],[0.1,0.1]/2), mutetrig, doneAction:2);
	//muteenv = 1;
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction) * muteenv;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;


(
Pdef(\muter, 
	Pbind(
		\instrument, \playersec_mute,
		\bufnum, BufDef('heavy/kick3.flac'),
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
			1,1,1,1, 1,0,0,0,
		],inf).coin.not,
		\pos, 0.04,
		\sustain, 1.9,
		\dur, 1/16,
		\amp, 0.1,
	)
	
).play;
);

ProtoDef(\piano).startControl(Pdef(\muter))


//////////////////////////////////////////////////


(
// acid kick
// very small rq variation
// add a compander to shape overblowing
SynthDef(\bigkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mutetrig, muteenv;

	mutetrig = In.kr(BusDef(\mutebus)) * EnvGen.kr(Env([0,0,1],[0.01,0.1]), 1);
	//muteenv = EnvGen.kr(Env([1,0.25,0.25],[0.4,0.1]/2), mutetrig, doneAction:0);
	//muteenv = EnvGen.kr(Env([1,0.5,0.5],[0.4,0.1]/2), mutetrig, doneAction:0);
	muteenv = EnvGen.kr(Env([1,0.2,0],[0.1,0.1]), mutetrig, doneAction:2);
	//muteenv = 1;
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));

	env1 = EnvGen.ar(Env([0801,109,60],[0.01,0.4]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, env1, \rq.kr(0.0001));
	sig = RLPF.ar(sig, env1, \rq.kr);
	sig = RLPF.ar(sig, env1, \rq.kr);
	sig = sig / 4;
	sig = Compander.ar(sig, sig, \cpt.kr(0.5), \cpbelow.kr(1.001), \cpabove.kr(0.2), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig / 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,4.1),gate,doneAction:2);
	sig = ( sig * 10 ).tanh / 2;
	sig = sig * muteenv;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\muter, 
	Pbind(
		\instrument, \bigkick,
		\bufnum, BufDef('heavy/kick3.flac'),
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
			1,1,1,1, 1,0,0,0,
		],inf).coin.not,
		\pos, 0.04,
		\sustain, 1.9,
		\dur, 1/16,
		\amp, 0.1,
	)
	
).play;
);


(
Pdef(\muter, 
	Ppar([
		Pbind(
			\instrument, \bigkick,
			\bufnum, BufDef('heavy/kick3.flac'),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, 1.9,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_mute,
			\bufnum, BufDef('heavy/kick3.flac'),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, 1.9,
			\dur, 1/4,
			\amp, 0.1,
		)
	]),
	
).play;
);

//////////////////////////////////////////////////////

(
	// raise samplerate, bad results
SynthDef(\playersec_mute, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var mutetrig, muteenv;
	var muteenv2;

	mutetrig = In.kr(BusDef(\mutebus)) * EnvGen.kr(Env([0,0,1],[0.01,0.1]), 1);
	//muteenv = EnvGen.kr(Env([1,0.25,0.25],[0.4,0.1]/2), mutetrig, doneAction:0);
	//muteenv = EnvGen.kr(Env([1,0.5,0.5],[0.4,0.1]/2), mutetrig, doneAction:0);
	muteenv = EnvGen.kr(Env([1,0,0],[0.4,0.4]/2), mutetrig, doneAction:2);
	muteenv2 = EnvGen.kr(Env([1,8,2],[1.4,0.4]/2), mutetrig, doneAction:0);
	//muteenv = 1;
	Out.kr(BusDef(\mutebus, \control), Impulse.kr(0));
	speed = speed * muteenv2;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction) * muteenv;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)

//////////////////////////////////////////////////

~t = 115/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\muter, 
	Ppar([
		Pbind(
			\instrument, \playersec_mute,
			\bufnum, BufDef('heavy/kick6.flac'),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, 1.9,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_mute,
			\bufnum, BufDef('heavy/kick9.flac'),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,1,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, 1.9,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.7,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.4,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),
	]),
	
).play;
);

//////////////////////////////////////////////////

~t = 115/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\muter, 
	Ppar([
		Pbind(
			\instrument, \playersec_mute,
			\bufnum, BufDef('heavy/kick9.flac'),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, 1.9,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_mute,
			\bufnum, BufDef('heavy/snare1.flac'),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,1,0,
			],inf).coin.not,
			\pos, 0.04,
			\speed, 0.6,
			\gain, 1/2,
			\sustain, 1.9,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.7,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.4,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),
	]),
	
).play;
);


c=NodeProxy(s,\control,1);
c.source={arg y=2; var x=1-3*y;x.poll;x}; 
c.source={arg y; x=1-3*y;x.poll}; 
c
c.set(\y, 2)

s.controlRate
s.dumpAllMethods
ServerTree
