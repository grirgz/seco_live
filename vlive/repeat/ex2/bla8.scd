
(
ProtoDef(\recorder).fxbus = \sendbus0;
Ndef(\fx2).set(\inbus, BusDef(\sendbus0, \audio));
SynthDef(\note1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, osclo=1, oscmid=1, oschi=1, gain=1;
	var sig;
	//sig = LFSaw.ar(freq * [1, 1+(\diff.kr(1)/100)]);
	freq = freq*[1/4,1/2,1,2,4] ;

	sig = LFSaw.ar(freq + [0, (\diff.kr(1)/1)].flop).flop.sum;
	sig.debug("sig1");
	sig = SinOsc.ar(freq) + sig; 
	sig = sig * ( [osclo, osclo+oscmid/2, oscmid, oscmid+oschi/2, oschi]);
	sig = sig.fold2( SinOsc.kr(1/15 * [1,1.2].flop).range(0.4,1) ).flop.sum;
	sig.debug("sig2");
	sig = RLPF.ar(sig, freq*\lpfr.kr(1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * gain;
	Out.ar(out, sig);
}).add;

Pdef(\note1, Pbind(
	\instrument, \note1,
	\degree, 0,
	\dur, 1,
	//\amp, 0.1
));

Pdef(\noteseq, 
	Pfindur(4,
		Pbind(
			\instrument, \note1,
			\degree, Pstep(Pseq([3,1,2],inf), Pseq([2,1,1],inf)),
			//\legato, 0.1,
			//\dur, 1/2,
			\amp, 0.1
		)
	).loop
);
NoteTimeline(\note1, Param(Pdef(\note1), \midinote));
NoteTimeline(\note2, Param(Pdef(\note1), \midinote));

/////////////////////////// // mapping
~note = Pdef(\noteseq);
MIDIMap(\apk1, Param(~note, \diff, ControlSpec(0,5,\lin)).setBusMode);
MIDIMap(\apk2, Param(~note, \lpfr, ControlSpec(0.5,4,\exp)).setBusMode);
MIDIMap(\apk3, Param(~note, \rq).setBusMode);
MIDIMap(\apk4, Param(Pdef(\mod1), \stutgain, ControlSpec(0.01,1,\exp)));

~osceq = ControlSpec(0.001,4,\exp);
MIDIMap(\apk5, Param(~note, \osclo, ~osceq).setBusMode);
MIDIMap(\apk6, Param(~note, \oscmid, ~osceq).setBusMode);
MIDIMap(\apk7, Param(~note, \oschi, ~osceq).setBusMode);

MIDIMap(\apk8, Param(Pdef(\mod1), \msustain, ControlSpec(1/4,2,\exp)));

MIDIMap(\apk9, Param(~note, \gain).setBusMode);

~fxkey = \fx2;
MIDIMap(\aps1, Param(Ndef(~fxkey), \mix));
MIDIMap(\aps2, Param(Ndef(~fxkey), \fb));
MIDIMap(\aps3, Param(Ndef(~fxkey), \delay));
MIDIMap(\aps4, Param(Ndef(~fxkey), \delay2));
MIDIMap(\aps5, Param(Ndef(~fxkey), \distamp));


MIDIMap(\aps6, Param(Ndef(~fxkey), \deltran1));
MIDIMap(\aps7, Param(Ndef(~fxkey), \deltran2));
MIDIMap(\aps8, Param(Ndef(~fxkey), \deltran3));

MIDIMap(\apb1, { Ndef(~fxkey).play });
MIDIMap(\apb4, { ProtoDef(\recorder).genfx });

MIDIMap(\aps9, Param(Ndef(~fxkey), \gain));

//~perc = PlayerWrapper(KitTimeline(\smp2));
~perc = Pdef(\main);
MIDIMap(\applay, { ~perc.play });
MIDIMap(\apstop, { ~perc.stop });

MIDIdef.noteOn(\piano_on, { arg ... args;
	var midi = args[1];
	args.debug("args on");
	NoteTimeline(\note1).eventFactory.childAt(midi).play;
}, nil, 1, 1572865).permanent_(true);
MIDIdef.noteOff(\piano_off, { arg ... args;
	var midi = args[1];
	args.debug("args off");
	NoteTimeline(\note1).eventFactory.childAt(midi).stop;
}, nil, 1, 1572865).permanent_(true);

~noteseq = Pdef(\noteseq);
MIDIMap(\apa1, { ~noteseq.set(\legato, 1) });
MIDIMap(\apa2, { ~noteseq.set(\legato, 1/2) });
MIDIMap(\apa3, { ~noteseq.set(\legato, 1/4) });
MIDIMap(\apa4, { ~noteseq.set(\legato, 1/8) });

MIDIMap(\apa5, { ~noteseq.set(\dur, 1) });
MIDIMap(\apa6, { ~noteseq.set(\dur, 1/2) });
MIDIMap(\apa7, { ~noteseq.set(\dur, 1/4) });
MIDIMap(\apa8, { ~noteseq.set(\dur, 1/8) });

MIDIMap(\aphome, Param(Pdef(\mod1), \mutemid, \unipolar));
MIDIMap(\apleft, { Pdef(\mod1).set(\stutgain, 0); });
MIDIMap(\apright, { Pdef(\mod1).set(\stutgain, 1/2) });
MIDIMap(\apend, { Pdef(\mod1).set(\stutgain, 1) });

~patstutter = { arg pat, stutampkey=\stutgain, ampkey=\gain;
	Prout { arg in;
		var str = pat.asStream;
		var ev = str.next(in);
		var count = 0;
		while( { ev.notNil } ) {
			var evc = ev.copy;
			if(evc[\mutemid] == 1) {
				if(thisThread.clock.beats % 1 != 0 ) {
					evc[\isRest] = true;
				};
			} {
				evc[\delta] = ev[\delta]/2;
				in = evc.yield;
				evc[ampkey] = ( ev[stutampkey].value ? 0 ) * ( ev[ampkey] ? 1 );
			}; 
			in = evc.yield;
			ev = str.next(in);
			count = count + 1;
		};
		nil;
	};
};
)

// END
///////////////////////////////////////////////////

Pdef(\note1).set(\out, BusDef(\fx1))


~kit1.reboot
Pdef(\noteseq).play
Pdef(\noteseq).set(\out, 0)

Pdef(\noteseq).asParamGroup.edit
(
Pdef(\noteseq, 
		Pbind(
			\instrument, \note1,
			\degree, Pstep(Pseq([3,1,2],inf), Pseq([2,1,1],inf)),
			//\legato, 0.1,
			//\dur, 1/2,
			\amp, 0.1
		)
);
)


NoteTimeline(\note1).edit
NoteTimeline(\note1).eventFactory.childAt(70).stop

Ndef(\fx2).play
Ndef(\fx2).stop
ProtoDef(\recorder).genfx
ProtoDef(\recorder).edit
Pdef(\src).clear
Ndef(\fx2).clear

MKtl.find
NoteTimeline(\note1)
NoteTimeline(\note2).edit
		KitTimeline(\smp2).play
		KitTimeline(\smp).edit;
		KitTimeline(\smp).outBus = BusDef(\fx1, \audio)

(
Pdef(\main, Pseq([
	Ptask({
		Ndef(\fx2).play(0);
	}),
	Pfindur(32,Ppar([
		NoteTimeline(\note1).asPattern,
		KitTimeline(\smp2).asPattern,
	])),
	Pfindur(32,Ppar([
		 NoteTimeline(\note2).asPattern,
		Pbind(\sustain, Pkey(\sustain) * 2/4) <> KitTimeline(\smp2).asPattern,
	])),
	Pfindur(32,Ppar([
		Pbind(\sustain, Pkey(\sustain) * 1/4) <> NoteTimeline(\note1).asPattern,
		Pbind(\sustain, Pkey(\sustain) * 8/4) <> KitTimeline(\smp2).asPattern,
	])),
	Pfindur(32,Ppar([
		Pbind(\sustain, Pkey(\sustain) * 2/4) <> NoteTimeline(\note1).asPattern,
		Pbind(\sustain, Pkey(\sustain) * 8/4) <> KitTimeline(\smp2).asPattern,
	])),

],1)).play;
)

Pdef(\note1).asParamGroup.edit

(

)
MIDIdef(\piano).clear
MIDIdef.trace
~ampp.edit
~ampp.normSet(0.5)
~ampp = ;

~perc.play
NoteTimeline(\note1).play


(
Pdef(\main, Ppar([
	Pdef(\mod1, Pbind(\sustain, Pkey(\sustain) * Pkeyd(\msustain,1))) <> KitTimeline(\smp2).asPattern,
	Pdef(\noteseq),
])).play
)

~kit3


/////////////////////////



(
)
Pdef(\noteseq).set(\out, BusDef(\fx1))
Pdef(\noteseq).set(\out, 0)
Pdef(\noteseq).play
Pdef(\noteseq).get(\out)

(
)


KitTimeline(\smp2).asPattern.asStream.nextN(2,())
KitTimeline(\smp2).edit
KitTimeline(\smp).edit
MKtl.find
k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\pad).elAt(0).elAt(0).action = { "0 on pushed".postln; };
k.elAt(\pad).elAt(0).elAt(1).action = { "0 off pushed".postln; };
k.postElements;
k.elAt(\pad).elAt(0).elAt(0).value = 0.05;

k = MKtl('icon', "icon-icontrols");
k[\kn].collect({ arg k; k })
k[\kn][0]
k[\bt][0][0][0].value = 114
k.postElements;

~param = Param(Pdef(\mod1), \msustain)
~param.edit
MKtl(\icon)[\sl][0].action = { arg x; ~param.normSet(x.value) }

(
Pdef(\main,
	Ptpar([
		0,KitTimeline(\smp).asPattern,
		0, Pseq([~patstutter.(
			Pdef(\mod1, Pbind(\sustain, Pkey(\sustain) * Pkeyd(\msustain,1))) 
			<>
			KitTimeline(\smp2).asPattern
		)])
	]),
).play;
)
(
Pdef(\main,
	Ppar([
		KitTimeline(\smp).asPattern,
		KitTimeline(\smp2).asPattern,
	]),
).play;
)

KitTimeline(\smp2).proxy.set(\stutgain, nil)
KitTimeline(\smp2).edit

(
Pdef(\plop,
	KitTimeline(\smp2).asPattern 
).play;
)

	KitTimeline(\smp2).presetCompileString.editorInsert
(
KitTimeline('smp2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.5, \kitIndex: 5.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.25, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.5, \kitIndex: 3.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.25, \dur: 0.5, \kitIndex: 5.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 4.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 7.5, \dur: 0.5, \kitIndex: 3.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.75, \dur: 0.25, \kitIndex: 6.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 11.5, \dur: 0.5, \kitIndex: 3.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 12.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.5, \dur: 0.25, \kitIndex: 6.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 13.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 6.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 15.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 15.5, \dur: 0.5, \kitIndex: 3.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 16.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 16.25, \dur: 0.5, \kitIndex: 5.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 16.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 17.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 18.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 18.25, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 18.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 19.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 19.5, \dur: 0.5, \kitIndex: 3.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 20.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.25, \dur: 0.5, \kitIndex: 5.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 20.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 21.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 23.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 23.5, \dur: 0.5, \kitIndex: 3.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 24.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 25.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.75, \dur: 0.25, \kitIndex: 6.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 27.5, \dur: 2.5, \kitIndex: 3.0, \midinote: 0, \playDur: 2.5, \relDur: 2.5, \sustain: 0.25, ),
	(\absTime: 30.0, \dur: 0.5, \kitIndex: 2.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 30.5, \dur: 0.25, \kitIndex: 2.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.75, \dur: 0.5, \kitIndex: 2.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 31.25, \dur: 0.25, \kitIndex: 2.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.5, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.75, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 32.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
~wrapper = { arg pat, stutampkey=\stutgain, ampkey=\gain;
	Prout { arg in;
		var str = pat.asStream;
		var ev = str.next(in);
		var count = 0;
		while( { ev.notNil } ) {
			var evc = ev.copy;
			evc[\delta] = ev[\delta]/2;
			in = evc.yield;
			evc[ampkey] = ( ev[stutampkey].value ? 0 ) * ( ev[ampkey] ? 1 );
			in = evc.yield;
			ev = str.next(in);
			count = count + 1;
		};
		nil;
	};
};
)
(
)
(
~wrapper = { arg pat, stutampkey=\stutgain, ampkey=\gain;
	Prout { arg in;
		var str = pat.asStream;
		var ev = str.next(in);
		var count = 0;
		while( { ev.notNil } ) {
			var evc = ev.copy;
			var evc2;
			evc2 = evc.copy;
			evc[\delta] = 0;
			if(thisThread.clock.beats % 1 != 0) {
				evc[\isRest] = true;
				evc2[\isRest] = true;
			}; 
			evc2[\delta] = ev[\delta];
			evc2[\lag] = 1/4 / ~t;
			in = evc2.yield;
			evc[ampkey] = ( ev[stutampkey].value ? 0 ) * ( ev[ampkey] ? 1 );
			in = evc.yield;
			ev = str.next(in);
			count = count + 1;
		};
		nil;
	};
};
)




//////////////////////////////////



TrackDef(\grid1).clear
TrackDef(\grid1, TrackDef(\playergrid))
(
TrackDef(\grid1).source = [
	[
		KitTimeline(\smp)
	],
	[
		KitTimeline(\smp2)
	],
	[
		NoteTimeline(\note1),
		NoteTimeline(\note2),
		Pdef(\noteseq),
	],
]
)

TrackDef(\grid1).edit
		KitTimeline(\smp2).preChain
		~kit3.postChain = nil

~kit4 = ~kit4 ?? {~parPlayerGroup.new({ nil } ! 16)};
KitTimeline(\smp3, ~kit4).edit;

~kit4.asPresetCompileString.editorInsert
(
~ppg.targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('snare2'), pos: 0.04, sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('kick'), pos: 1.5673469387755, sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('kick3'), pos: 0.081632653061224, sustain: 1)),
	StepEvent.newFrom((pos: 3.1167792021677, instrument: 'playersec', gain: 0.11251254782968, bufnum: BufDef('amen'), sustain: 1)),
	StepEvent.newFrom((gain: 0.085625097543585, pos: 4.9191609977324, speed: -1, instrument: 'playersec', bufnum: BufDef('amen'), sustain: 1)),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
];
);




///////////////////////////////////////////



(
Ndef(\ota, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fac = 1/SelectX.kr( SinOsc.kr(1/113).range(0,6), [1/2,1,2,4,8,64,128] )/8;

	freq = XLine.kr(1,1/2,2) * freq;

	env1 = EnvGen.ar(Env([42,21,42,30,84],[4,4,7.5,0.5]/fac).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]/4).circle, 1);
	env3 = XLine.kr(1,0.1,2*1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	//freq.debug.shape.debug("freq");
	sig = SinOsc.ar( freq / [1,2,4]);
	//sig.shape.debug("sig1");
	sig = sig.collect({ arg isig, x;
		isig = SelectX.ar( SinOsc.kr(x+1/34).range(0,1), [isig, isig.fold2(env3)]);
		isig = SelectX.ar( SinOsc.kr(1/223, 3pi/2).range(0,1), [isig, ( isig * SinOsc.kr(1/48 * ( x + 1 )).range(1,100) ).tanh]);
	});
	//sig.shape.debug("sig2");
	sig1 = sig.flop[1];
	sig = sig.flop[0];
	//sig.debug("sig");
	sig1 = Pan2.ar(sig1, SinOsc.ar(sig1.size.collect({ arg x; SinOsc.kr(x/10+1.2).range(0,8) })) * SinOsc.kr(1/48).range(0,1), amp).mean;
	sig = Pan2.ar(sig, SinOsc.ar(sig.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,8) })) * SinOsc.kr(1/58).range(0,1), amp).mean;
	sig = sig + sig1;
	sig = sig / 1.0;
	sig = LPF.ar(sig, 1999);
	sig;
}).play(BusDef(\recbus).index, 2);
);
ProtoDef(\recorder).recbus = BusDef(\recbus)
ProtoDef(\recorder).recbus.key

ProtoDef(\recorder).edit
KitTimeline(\smp).edit
KitTimeline(\smp2).edit
KitTimeline(\smp2).asPattern.asStream.nextN(4,())
KitTimeline(\smp2).proxy.get(\out)
KitTimeline(\smp2).postChain
KitTimeline(\smp2, ~kit2)
KitTimeline(\smp2).postChain = Pbind(\out, Pfunc({ KitTimeline(\smp2).outBus }))
~kit2.postChain = nil

~kit2.edit
~kit1.edit
~kit1.postChain = nil

TrackDef(\grid1).childAt(1).mixer.proxy.edit
TrackDef(\grid1).edit

ProtoDef(\recorder).edit

Ndef(\fx2).edit

~kit4 = ~kit4 ?? {~parPlayerGroup.new({ nil } ! 16)};
~kit4.edit
BusDef.all[BusDef.all.keys.asArray[10]] = nil
KitTimeline(\kit4, ~kit4).edit


///////////////////////////////////////////////



(
~drawme = { arg me, areasize;
	areasize.debug("drawme: drawFunc: areasize");
	areasize.y.do { arg py;
		//[this.gridPointToPixelPoint(Point(0,py)),this.gridPointToPixelPoint(Point(areasize.x, py))].debug("line");
		if(py%32 >= 16) {

			Pen.width = 1;
			Pen.color = Color.gray(alpha:0.7);
			Pen.fillRect(
				Rect.fromPoints(
					me.gridPointToPixelPoint(Point(0,py)),
					me.gridPointToPixelPoint(Point(areasize.x, py+1))
				)
			);
		};
		if(py % 4 == 0) {
			Pen.width = 1;
			Pen.color = Color.black;
		} {
			Pen.width = 1;
			Pen.color = Color.gray;
		};
		Pen.line(me.gridPointToPixelPoint(Point(0,py)),me.gridPointToPixelPoint(Point(areasize.x, py)));
		Pen.stroke;
	};
};
KitTimeline(\bla).edit
)
