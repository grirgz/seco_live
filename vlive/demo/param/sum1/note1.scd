

(
"~/code/sc/seco/vlive/demo/param/lib/timeline.scd".standardizePath.load;

	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

~presetEvent = PresetEvent.new;
~presetEvent[\instrument] = \rlpf;
~presetEvent[\dur] = 1/4;

~nt = ~noteTimeline.new(\yepy, Param(~presetEvent), \midinote);
//~nt.asView
//~noteTimelinePanelView.newView(~nt).makeLayout
~nt.composeParamPattern = false;

Pdef(\main,
	~nt.xasPattern.loop 
	//<> Prout({ arg ev; ev[\freq] = Event.default[\freq]; ev })
	//<> Prout({ arg ev; ev })
	<> Pn(~presetEvent).collect({ arg ev; ev[\freq] = Event.default[\freq]; ev })
);

WindowLayout({

	VLayout (
		PlayerWrapper(Pdef(\main)).asView,
		~presetEvent.asView,
		~noteTimelinePanelView.newView(~nt).make_header_(nil).makeLayout,
		nil,
	)
});



)

~nt.xasPattern.asStream.nextN(10,Event.default)
~nt.xasPattern.asStream
~nt.eventlist
~nt.param.target
~nt.param.wrapper
