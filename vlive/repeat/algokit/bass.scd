
FileSystemProject.load("algokit/kits/PatKitDef_kitsec.scd");
FileSystemProject.load("algokit/lines/KitTimeline_secline.scd")
KitTimeline(\secline, PatKitDef(\kitsec)).edit
KitTimeline(\secline2, PatKitDef(\kitsec)).edit

(
	2.do { arg x;

SynthDef(\babass+++x, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	//sig = sig + LFCub.ar(freq * [1,2,1.001]);
	sig = 8.collect({
		[SinOsc, LFSaw, LFCub, LFPulse].choose.ar(freq * [1,2,1 + rrand(0,0.01)].choose * ( 1 + ( SinOsc.ar(exprand(4,100) * ( 1 + ( SinOsc.ar(exprand(0.1,100)) * 1 ))) * rrand(0,1) )), rrand(0.0,pi))
	});
	sig = sig.collect({ arg sig;
		sig + [SinOsc, LFSaw, LFCub, LFPulse].choose.ar(freq * [1,2,1 + rrand(0,0.01)].choose * ( 1 + ( SinOsc.ar(exprand(4,100) * ( 1 + ( SinOsc.ar(exprand(0.1,100)) * 1 ))) * rrand(0,1) )), rrand(0.0,pi))
		//DelayC.ar(sig, 0.1,0.01) + ( sig * [SinOsc, LFSaw].choose.ar(freq * [1,2,1 + rrand(0,0.01)].choose * ( 1 + ( SinOsc.ar(rrand(1/4,10)) * rrand(0,1) ))) )
	});
	sig = ( sig*\distamp.kr(10) * (1..8)/4 ).tanh * \distpostamp.kr(1/2);
	sig = sig.collect({ arg sig;
		var line = [
			XLine.kr(0.1,2,exprand(0.02,4)),
			XLine.kr(2,0.1,exprand(0.02,4)),
		].choose;
		RLPF.ar(sig, rrand(100,1000) * line, rrand(0.1,0.5) * XLine.kr(0.1,2,exprand(0.02,4)));
	});
	sig = HPF.ar(sig, 50);
	sig = LPF.ar(sig, 2500);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.kr((1..8)/21, mul:0.01);
	sig = sig * 2;
	sig = DelayC.ar(sig, 0.01,0.001) + sig;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
	}
);

(
Pdef(\main, 
	Ppar([
		KitTimeline(\secline).asPattern,
		Pdef(\babass),
		
	])
).play;
)

(
Pdef(\babass, PmonoArtic(\babass,
	\degree, Pseq([0],inf),
	\octave, 3,
	\legato, Pseq([
		1,1,0.5,1, 1,0.5,1,0.5,
	],inf),
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\babass, PmonoArtic(\babass,
	\degree, Pseq([0],inf),
	\octave, 3,
	\legato, Pseq([
		1,1,1,1, 1,1,1,0,
		1,1,0.5,1, 1,0.5,1,0,
		1,1,1,1, 1,0.51,1,0,
		1,1,0.51,1, 1,1,1,0,
	],inf),
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
	Pdef(\babass, 
		Pseq(
			[3,1].collect({ arg time, idx;
				time = time;
				Pfindur(time,PmonoArtic([\babass0, \babass1][idx],
					\degree, Pseq([0],inf),
					\octave, 3,
					\legato, Pseq([
						1,1,1,1, 1,1,1,0,
						1,1,0.5,1, 1,0.5,1,0,
						1,1,1,1, 1,0.51,1,0,
						1,1,0.51,1, 1,1,1,0,
					],inf),
					\dur, 1/8,
					\amp, 0.1
				))
			})
			,inf
		),
		).play;
);

(
	Pdef(\babass, 
		Pseq(
			[3,1].collect({ arg time, idx;
				time = time;
				Pfindur(time,PmonoArtic([\babass0, \babass1][idx],
					\degree, Pseq([0],inf),
					\octave, 3,
					\legato, Pseq([
						1,1,1,1, 1,1,1,0,
						0,0,1,1, 1,1,1,0.1,
						1,1,1,1, 1,1,1,0,
						0,0,0,0, 1,1,1,0.1,
					],inf),
					\dur, 1/8,
					\amp, 0.1
				))
			})
			,inf
		),
		).play;
);

//////////////////////////////////////////


PatKitDef(\kitsec).edit
PatKitDef(\kitsec).clear

KitTimeline(\secline, PatKitDef(\kitsec)).edit
KitTimeline(\secline).clear
KitTimeline(\secline2, PatKitDef(\kitsec)).edit
BufferPool.reset

(
SynthDef(\kobass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1/2,1,2] *.x [1,1.00001], 0.7);
	sig = RLPF.ar(sig, \lpfratio.kr(1.7)* freq * SinOsc.kr(1/18 * (1..8)).range(0.5,2), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,0.1,1,-4),gate,doneAction:2);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\kobass, Pbind(
	\instrument, \kobass,
	\degree, Pseq([0],inf),
	\lpfratio, 1,
	\octave, 3,
	\dur, 4,
	\amp, 0.1
)).play;
);

Pdef(\kit_workspace, Pdef(\kobass))



(
TrackDef(\bassgrid2, TrackTemplateDef(\playergrid));
TrackDef(\bassgrid2).source = [
	[
		ProtoDef(\bass_rdn, ProtoTemplateDef(\rdn))
	],
	[
		KitTimeline(\secline),
	],

];

ProtoDef(\bass_rdn).inbus = BusDef(\sendbus0);
);
TrackDef(\bassgrid2).edit
//coolfx: 4-EE6L-9FUL



//momentum density of the electromagnetic field
// coronal heating problem 
// Upper hybrid oscillation
