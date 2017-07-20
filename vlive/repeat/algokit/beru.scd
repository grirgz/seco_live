

KitTimeline(\beru).play
KitTimeline(\beru).clear
KitTimeline(\beru).presetCompileString.editorInsert
(
~t = 174/2/60; TempoClock.default.tempo = ~t;
SynthDef(\distbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq * [1/2,1,2,3,4] * ( 1 + ( SinOsc.ar(freq*1 * XLine.kr(1/2,1,1/~t)) * XLine.kr(0.1,1.5,1) ))) * [0.3,1,1,1,1];
	//sig = SinOsc.ar(freq * [1/2,1,2,3,4] * ( 1 + ( SinOsc.ar(freq*2 * XLine.kr(1/2,1,1/~t)) * XLine.kr(0.1,1.5,1/~t) ))) * [0.3,1,1,1,1];
	//sig = SinOsc.ar(freq * [1/2,1,2,3,4]);
	//sig = LFPulse.ar(freq * [0,4].midiratio * [1,1/2,2,4]);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = CombL.ar(sig, 1/40, 1/freq / [1,2,4]/4,0.0)/4;
	//sig = sig.collect({ arg x, idx; x * SinOsc.kr(1/(1+ idx )*2).range(0,1) });
	//sig = sig.fold2(XLine.kr(1,0.3,3));
	//sig = RLPF.ar(sig, \lpfr.kr(2.8) * [1,2] * freq, \rq.kr(0.5));
	sig = RLPF.ar(sig, freq*[4,8], \rq.kr(0.15));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.051,0.6,0.4,1,2)),gate,doneAction:2);
	sig = sig*2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
	Pdef(\bass, Pbind(
		\instrument, \distbass,
		//\degree, Pseq([0],inf),
		//\dur, 1,
		//\out, BusDef(\sendbus0, \audio),
		//\amp, 0.1
	));

KitTimeline(\beru, PatKitDef(\algokit));
KitTimeline('beru').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.375, \kitIndex: 1.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 0.375, \dur: 0.125, \kitIndex: 3.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.375, \kitIndex: 4.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 0.875, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

NoteTimeline(\berubass, Param(Pdef(\bass), \midinote));
NoteTimeline('berubass').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.375, \midinote: 40.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 0.375, \dur: 0.375, \midinote: 40.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 0.75, \dur: 0.5, \midinote: 43.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.0, \midinote: 43.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.05, ),
	(\absTime: 1.25, \dur: 0.25, \midinote: 43.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.5, \dur: 0.0, \midinote: 43.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.05, ),
	(\absTime: 1.5, \dur: 0.25, \midinote: 43.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.75, \dur: 0.0, \midinote: 43.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.05, ),
	(\absTime: 1.75, \dur: 0.25, \midinote: 43.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.375, \midinote: 40.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 2.375, \dur: 0.375, \midinote: 40.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 2.75, \dur: 0.5, \midinote: 42.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.25, \dur: 0.25, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.5, \dur: 0.25, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.75, \dur: 0.25, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

RandDelayNetwork('deldefault').make('rdn', "4-RAR3-5I9F");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.2436974789916,
	'gain', 3.0981397213296,
	'fb', 0.0001,
	'delay', 1,
	'delay2', 1e-06,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', BusDef(\distamp),
	'pitchlag', 0.125,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.98319327731092,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

KitTimeline(\beru).postChain = Pbind(\lag, 0.04)
KitTimeline(\beru).postChain = nil
BusDef(\distamp).asMap.class
(
);

KitTimeline(\beru).play;
NoteTimeline(\berubass, Param(Pdef(\bass), \midinote)).edit
NoteTimeline(\berubass, Param(Pdef(\bass), \midinote)).presetCompileString.editorInsert
(
);

	(
	);
(
Pdef(\bass, Pbind(
	\instrument, \distbass,
	\degree, Pseq([0,2b,0,1],inf).stutter(Pseq([4,4],inf)) + [0,4],
	\ctranspose, 2,
	\legato, Pseq([
		3,0,0,0,3,0,0,0,
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, Pseq([3,5],inf)/4,
	\dur, 1/4,
	\amp, 0.2
)).play;
);

ProtoDef(\rdn).edit
ProtoDef(\rdn).presetCompileString.editorInsert;
(
// cool dist
RandDelayNetwork('deldefault').make('rdn', "4-R6GK-8E8Q");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.60084033613445,
	'gain', 1.7435855820224,
	'fb', 0.0001,
	'delay', 0.00001,
	'delay2', 0.05021683753109874,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 40,
	'pitchlag', 0.125,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.98319327731092,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(

);


KitTimeline(\beru).play
KitTimeline(\beru).edit


(
SynthDef(\modenv, { arg out=0, amp=0.1, gate=1;
	var sig;
	sig = EnvGen.kr(\env.kr(Env([1,2,1],[0.1,0.8])), gate, doneAction:2);
	Out.kr(out, sig);
}).add;
SynthDef(\freqshift, { arg out=0, amp=0.1, gate=1;
	var sig = In.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = FreqShift.ar(sig, \shift.kr(0)) + sig;
	sig = sig / 2;
	//sig = sig + LFSaw.ar(200 * ( 1 + ( SinOsc.kr(2*~t) * 1 )), mul:0.1);
	EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\sender, { arg out=0, amp=0.1, gate=1;
	var sig = In.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = sig + LFSaw.ar(200 * ( 1 + ( SinOsc.kr(2*~t) * 1 )), mul:0.1);
	EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig * \value.kr(0).poll);
}).add;
)


Ndef(\rdn).unmap(\delay)

Ndef(\rdn).edit
(
GroupDef(\synth);
GroupDef(\fx, GroupDef(\synth), \addAfter);
ProtoDef(\rdn).play;
3.do { arg x; TrackDef(\grid1).childAt(x).mixer.play; };
Ndef(\rdn).map(\distamp, BusDef(\distamp, \control).asMap);
Ndef(\rdn).map(\delay, BusDef(\delay, \control).asMap);
TrackDef(\grid1).childAt(1).mixer.proxy.set(\send0, BusDef(\fx1send0, \control).asMap);
Pdef(\main, 
	Pseq([
		Ppar([
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\distamp, \control),
				\env, [ Env([1,10,1],[1/5,1]/~t) ],
				\dur, Pseq([16],inf),
			)),
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\delay, \control),
				\env, [ Env([0.0001,0.4,0.001],[15,1]/~t, 4) ],
				\dur, Pseq([16],inf),
			)),
			//Pfindur(16,Pbind(
			//	\instrument, \modenv,
			//	\out, BusDef(\fxshift, \control),
			//	\env, [ Env([1,120,0],[15,1]/~t, 1) ],
			//	\dur, Pseq([16],inf),
			//)),
			//Pfindur(16,Pbind(
			//	\instrument, \freqshift,
			//	\shift, BusDef(\fxshift).asMap,
			//	\inbus, TrackDef(\grid1).childAt(1).mixer.inbus,
			//	\out, Pkey(\inbus),
			//	\group, GroupDef(\fx),
			//	\dur, Pseq([16],inf),
			//)),
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\fx1send0, \control),
				\env, [ Env([0,1,0],[15,1]/~t, 1) ],
				\dur, Pseq([16],inf),
			)),
			//Pfindur(16,Pbind(
			//	\instrument, \modenv,
			//	\out, BusDef(\fxsend, \control),
			//	\env, [ Env([0,1,0],[15,1]/~t, 1) ],
			//	\dur, Pseq([16],inf),
			//)),
			//Pfindur(16,Pbind(
			//	\instrument, \sender,
			//	\value, BusDef(\fxsend).asMap,
			//	\inbus, TrackDef(\grid1).childAt(1).mixer.inbus,
			//	\out, BusDef(\sendbus0),
			//	\group, GroupDef(\fx),
			//	\dur, Pseq([16],inf),
			//)),
			Pfindur(15, KitTimeline(\beru).asPattern),
			Pfindur(16, NoteTimeline(\berubass).asPattern),
		]),
		Ppar([
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\distamp, \control),
				\env, [ Env([1,100,1],[15,1]/~t) ],
				\dur, Pseq([16],inf),
			)),
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\delay, \control),
				\env, [ Env([0.0001,0.2,0.001],[15,1]/~t, 4) ],
				\dur, Pseq([16],inf),
			)),
			Pfindur(15, KitTimeline(\beru).asPattern),
			Pfindur(16, NoteTimeline(\berubass).asPattern),
		]),
		Ppar([
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\distamp, \control),
				\env, [ Env([1,100,1],[0.1,1.0]/~t) ],
				\dur, Pseq([1],inf),
			)),
			Pfindur(16,Pbind(
				\instrument, \modenv,
				\out, BusDef(\delay, \control),
				\env, [ Env([0.2001,0.4,0.001],[15,1]/~t, 4) ],
				\dur, Pseq([16],inf),
			)),
			Pfindur(16, KitTimeline(\beru).asPattern),
			Pfindur(15, NoteTimeline(\berubass).asPattern),
		])
		
	],inf)
).play;
)

Ndef(\rdn).objects.indices
(
Ndef(\rdn).put(11, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig + HPF.ar(in, 2500);
	sig = sig + HPF.ar(in, 7500);
	//sig = sig + BPF.ar(in, MouseX.kr(40,300),0.1, mul:MouseY.kr(0.01,20));
	sig;
	
})
)

(
TrackDef(\grid1, TrackDef(\playergrid));
TrackDef(\grid1).source = [
	[
		ProtoDef(\rdn),
		nil
	],
	[
		KitTimeline(\beru),
		nil
	],
	[
		NoteTimeline(\berubass),
	],
];
);


TrackDef(\grid1).edit;
WindowDef(\multigrid).front;
