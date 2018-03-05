
(
SynthDef(\delbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq);
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig2 = RLPF.ar(sig, \lpfr2.kr(1.1) * freq, \rq2.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1, sig2]);

	thisThread.randSeed = 123133;
	
	sig1 = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.7) * 100 ) + sig;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01) * \delay1.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay2.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp2.kr(10) ).tanh * \distpostamp2.kr(1/2);
			}.value(isig),
		].mean;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay3.kr) + sig;
				};
				isig;
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay4.kr) + sig;
				};
				isig;
			}.value(isig),
		].mean;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);

	sig = sig * \gain.kr(1);

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\reter).clear
(
	Pdef(\reter, 
		Ppar([
			Pbind(
				\instrument, \delbass,
				\note, Pseq([
					0,1,1,1,
				],inf),
				\octave, 3,
				\dur, 1,
				\amp, 0.1,

				'lpfr', 0.77601093560068,
				'rq', 0.069397810604479,
				'lpfr2', 2.0548273159042,
				'rq2', 0.17652800371952,
				'lpmix', 0.85921569567667,
				'fb', 0.009756305902278,
				'delay1', 0.0012003147810941,
				'distamp', 4.7688547724285,
				'distpostamp', 9.6597787422967,
				'delay2', 0.019532098181673,
				'distamp2', 1.1762092256774,
				'distpostamp2', 166.9754399721,
				'delay3', 0.00053317803124595,
				'delay4', 0.030830941282943,
				'delmix', 1.4710510771126,
				'gain', 0.32039742573121,
				'adsr', [ Env([ 0.0, 0.97959184646606, 1.0, 0.0 ], [ 0.10999999940395, 0.25059666607289, 0.20262526598068 ], [ -4.0, -4.0, -4.0 ], 2.0)],
				\delay3, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 4),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,

					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,

					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,1,1, 1,1,1, 1,0,1, 1,1,1,

					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,0,1, 1,1,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.2,0.01,0.12,
					0.01,0.01,0.01,
				],inf),
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0, 0,0,1,  0,0,0, 0,0,0,
					1,0,0, 0,1,0,  0,0,0, 1,0,0,
					1,0,0, 0,0,1,  0,0,0, 0,0,1,
					1,0,0, 0,1,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,0,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,0,
					0,0,0, 0,0,0,  0,0,1, 0,0,0,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,1, 1,0,0,  0,0,0, 0,0,1,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,1, 0,0,0,
					1,0,0, 1,0,1,  0,0,0, 0,0,1,
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
			Pseq([
				//Event.silent(4),
				Pdef(\critaz)
			],1),

		])
	).play;
);


(
SynthDef(\critaz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4]/100+1,[0.1,0.8,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4]/100+1,[1.1,1.8,4]), 1);
	sig = SinOsc.ar(freq * 1 * ( 1 + ( SinOsc.ar(freq * env1) * env2 )));
	sig = sig + LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * env2) * env1 )) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4]/100+1,[0.1,0.8,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4]/100+1,[1.1,1.8,4]), 1);
	sig = SinOsc.ar(freq * [1,8/5,6/5] * ( 1 + ( SinOsc.ar(freq * env1) * env2 ))).mean;
	sig = sig + LFSaw.ar(freq * 0.95 *( 1 + ( SinOsc.ar(freq * env2) * env1 )) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mod1=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[0.1,0.8,4,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[1.1,1.8,4,4]), 1);
	sig = SinOsc.ar(freq* ( 1 + ( SinOsc.ar(freq * env1) * env2 )));
	sig = sig * ( 1+LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * env2) * env1 )) ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mod1=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[0.1,0.8,4,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[1.1,1.8,4,4]), 1);
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq * env1) * env2 )));
	sig = sig * ( 1+LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * env2) * env1 )) ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz5, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mod1=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4,1/2]*10,[0.1,0.8,4,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4,1/2]*10,[1.1,0.8,0.1,4]), 1);
	env3 = EnvGen.kr(Env([1,2,10,4,1/2],[1.1,0.8,0.1,4]), 1);
	sig = Pulse.ar(freq * [1,1.01,1.001]);
	sig = sig * ( 1+LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * [1,1.001]* env2) * env1 )) ) );
	sig = sig * ( 1+SinOsc.ar(freq *( 1 + ( SinOsc.ar(freq) * env3 )) ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = SinOsc.ar((1..sig.size)/100) * 0.4;
	sig = Pan2.ar(sig, pan, amp);
	sig = sig.mean;
	sig = sig /2;
	Out.ar(out, sig);
}).add;
Pdef(\critaz, 
	Pseq([
		Pseq([
			//Pfindur(144,PmonoArtic(\critaz5)),
			Pfindur(4,PmonoArtic(\critaz)),
			Pfindur(4,PmonoArtic(\critaz2)),
			Pfindur(4,PmonoArtic(\critaz3)),
			Pfindur(4,PmonoArtic(\critaz4)),
			Pfindur(4,PmonoArtic(\critaz5)),
		].collect({ arg pat;
			pat <> Pbind(
				\note, Pstep(Pseq([0,1,1,1],inf),1),
				\mod1, ~pmodenv.(Pseq([1/50,1/100,1,4],inf), 8),
				\legato, Pseq([
					1,1,1,1, 1,1,1,0.8,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,0.8,
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)
			
		}),inf)
	],inf)
).play;
);


///////////////////////////////////////// DRAFT

(
Pdef(\bass, PmonoArtic( \delbass,
	\degree, Pseq([0,3,2,1],inf),
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,0,
	],inf),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1,
)).play;
);

(
Pdef(\lead, Pbind(
	\instrument, \delbass,
	\note, Pseq([
		[0,3,7]
	],inf),
	\dur, 1,
	\amp, 0.1/4,
)).play;
);

FileSystemProject.load("libdef/tracks.scd")
WindowDef(\PdefEditor).front(Pdef(\bass))
WindowDef(\PdefEditor).front(Pdef(\lead))
Pdef(\bass).addHalo(\instrument, \delbass)
(
[\distamp2, \distpostamp2, \delmix, \lpmix, \fb, \delay1, \delay2,\delay3,\delay4, \distamp, \distpostamp, \lpfr, \lpfr2, \rq, \rq2 ].do { arg ke;
Pdef(\bass).setBusMode(ke, true);
Pdef(\lead).setBusMode(ke, true);

};
[Pdef(\lead), Pdef(\bass)].do { arg pdef;
	
pdef.addSpec(\delay1, ControlSpec(0.0001,10,\exp));
pdef.addSpec(\delay2, ControlSpec(0.0001,10,\exp));
pdef.addSpec(\delay3, ControlSpec(0.0001,10,\exp));
pdef.addSpec(\delay4, ControlSpec(0.0001,10,\exp));
pdef.addSpec(\lpfr, ControlSpec(0.01,10,\exp));
pdef.addSpec(\lpfr2, ControlSpec(0.01,10,\exp));
pdef.addSpec(\rq, ControlSpec(0.01,2,\exp));
pdef.addSpec(\rq2, ControlSpec(0.01,2,\exp));
}

)

Param(Pdef(\lead), \delay1).spec
SynthDesc(\delbass).spec


(
Pdef(\reter, 
	Ppar([
		Pbind(
			\instrument, \delbass,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,

			'lpfr', 0.77601093560068,
			'rq', 0.069397810604479,
			'lpfr2', 2.0548273159042,
			'rq2', 0.17652800371952,
			'lpmix', 0.85921569567667,
			'fb', 0.009756305902278,
			'delay1', 0.0012003147810941,
			'distamp', 4.7688547724285,
			'distpostamp', 9.6597787422967,
			'delay2', 0.019532098181673,
			'distamp2', 1.1762092256774,
			'distpostamp2', 166.9754399721,
			'delay3', 0.00053317803124595,
			'delay4', 0.030830941282943,
			'delmix', 1.4710510771126,
			'gain', 0.32039742573121,
			'adsr', [ Env([ 0.0, 0.97959184646606, 1.0, 0.0 ], [ 0.10999999940395, 0.25059666607289, 0.20262526598068 ], [ -4.0, -4.0, -4.0 ], 2.0)],
			\delay3, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 4),
		)

	])
).play;
);

Pdef(\bass).asParamGroup.getPbindCompileString.editorInsert
(

Pbind(
	'dur', 1.0,
	'legato', 0.8,
	'amp', 0.1,
	'pan', 0.0,
	'freq', 261.6255653006,
	'lpfr', 0.77601093560068,
	'rq', 0.069397810604479,
	'lpfr2', 2.0548273159042,
	'rq2', 0.17652800371952,
	'lpmix', 0.85921569567667,
	'fb', 0.029756305902278,
	'delay1', 0.0012003147810941,
	'distamp', 4.7688547724285,
	'distpostamp', 9.6597787422967,
	'delay2', 0.019532098181673,
	'distamp2', 1.1762092256774,
	'distpostamp2', 166.9754399721,
	'delay3', 0.00053317803124595,
	'delay4', 0.030830941282943,
	'delmix', 1.4710510771126,
	'gain', 0.32039742573121,
	'adsr', Env([ 0.0, 0.97959184646606, 1.0, 0.0 ], [ 0.10999999940395, 0.25059666607289, 0.20262526598068 ], [ -4.0, -4.0, -4.0 ], 2.0),
)

);

