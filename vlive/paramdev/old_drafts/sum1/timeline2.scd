
// in this file, i will test the "play selected area" feature (see ~noteTimeline.xasPattern)
ParamProto.init(true);
(
ParamProto.init;
SynthDef(\doc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * SinOsc.kr(1/4).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = HPF.ar(sig, 100);
	sig = BRF.ar(sig, 1500);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\miss, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * SinOsc.kr(1/4).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\gris, Pbind(
	\instrument, \doc,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
));

Pdef(\bleu, Pbind(
	\instrument, \miss,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
));


Ndef(\bird, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/4).range(2,1)) * 1 ));
	sig = SinOsc.ar(freq * [1,2,4]);
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/4).exprange(1.01,1),1.1) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, SinOsc.ar(1/4 * [1,2,3]) , amp).flop;
});

Ndef(\bird2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/4).range(2,1)) * 1 ));
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,2,4]);
	//sig = SelectX.ar( XLine.kr(0.001,1.0,4).poll, [sig, sig1]);
	sig = SelectX.ar( SinOsc.kr(1/16).range(0,1), [sig, sig1]);
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/4).exprange(1.01,1),1.1) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, SinOsc.ar(1/4 * [1,2,3]) , amp).flop;
});
);
~noteTimeline.new(\ver, Param(Pdef(\gris), \midinote))
~noteTimeline.new(\ver).edit
~noteTimeline.new(\ver).eventPlay
~noteTimeline.new(\ver).xcl
~noteTimeline.new(\ver).xclear
~noteTimeline.new(\ver).editor.save_timeline_properties
~noteTimeline.new(\ver).asArchiveData.asCompileString
~bla = ~noteTimeline.new(\ver).asArchiveData.asCompileString.interpret
~bla.dump
~bla[\load].asCompileString
~noteTimeline.new_load(~bla)

ParamProto.init(true);
~noteTimeline.new(\ver).all.save
~noteTimeline.new(\ver).eventList.reorder
~noteTimeline.new(\ver).eventList.print
~noteTimeline.all[\ver]
~noteTimeline.all.save
~noteTimeline.all.loadIfNotInitialized
~noteTimeline.all.load
~noteTimeline.all.keys
p
(bla: Ndef(\bird2)).asCompileString.interpret
~clipTimeline.new(\bla1).edit
~clipTimeline.new(\bla1).eventList.print
~clipTimeline.new(\bla1).asArchiveData.eventlist.print
// TODO: write PlayerWrapper.asCompileString
~clipTimeline.all.save
~clipTimeline.all.keys
~clipTimeline.all.load
~clipTimeline.all.loadIfNotInitialized

~envTimeline.new(\cut, Param(Pdef(\gris), \lpf, \freq.asSpec))
~envTimeline.new(\cut).edit
~envTimeline.all.save
~envTimeline.all.load
~envTimeline.all[\cut] = nil

(
Pdef(\xxx, 
	
	~noteTimeline.new(\ver).xasPattern <>

	Pbind(
	\instrument, \doc,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
)).play;
)

ParamProto.init(true);

~clipTimeline.new(\rubi2).edit
~clipTimeline.new(\rato).xclear
~clipTimeline.new(\ruby7)
~clipTimeline.new(\rubi8).editor.timeline.selNodes.collect({ arg x; x.model.debug("x") })
~clipTimeline_clipboard = ~clipTimeline.new(\rubi8).editor.timeline.selNodes.collect({ arg x; x.model.debug("x") })
~clipTimeline_clipboard

~clipTimeline.new(\rato4).edit
~modStepTimeline.new(\hell).drumrack_(DrumRack(\yep))


(
~first = ~clipTimeline_clipboard.as(Array).inject(nil, { arg a, b; 
	if(a.isNil) {
		b
	} {
		if(a[\absTime] < b[\absTime]) {
			a
		} {
			b
		}
	};
});
)

~clipTimeline.new(\rato).xclear
~s = Set.new
~s.add(4)
~s.remove(4)
~s.includes(nil)
~s
s.quit

(

	~pat = Prout({ arg inev;
		inev.collect({ arg ev;
			ev[\type] = \bla;
			ev.yield
		})
		
	})
	<>
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
);

~pat.trace.play;

)



ParamProto.init(true);

~modStepTimeline.new(\gigo6).edit
~modStepTimeline.new(\gigo6).drumrack = DrumRack(\yep)

~modStepTimeline.new(\gigo1).eventList[1].stepseq_page.lines[0][\isRest].getHalo(\seqstyle)
~sl = ~modStepTimeline.new(\gigo1).eventList[1].stepseq_page.lines[0][\isRest]
~sl.getHalo(\seqstyle)
~sl.clone.getHalo(\seqstyle)
~modStepTimeline.new(\gigo1).eventList[3].stepseq_page.lines[0][\isRest].getHalo(\seqstyle)
~modStepTimeline.new(\gigo1).eventList[3].stepseq_page.lines[0][\isRest].getSpec(\list)
~modStepTimeline.new(\gigo1).eventList[1]
~sp = ~stepseq_page.new
~sp.edit

~se = ~modStepTimeline.new(\gigo1).eventList[1].stepseq_page.lines[0]
~se[\isRest].getHalo(\seqstyle)
~se.clone[\isRest].getHalo(\seqstyle)

~page = ~modStepTimeline.new(\gigo2).eventList[1].stepseq_page
~page.lines[0][\isRest].getHalo(\seqstyle)
~page.clone.lines[0][\isRest].getHalo(\seqstyle)

~clipTimeline.new(\fuu).edit




(
	~bus = Bus.control(s, 1);
	~bus.set(200);
	~pat = Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~bus.asMap,
			\legato, 0.5,
			\dur, 1,
			\amp, 0.1
		),
		Pbind(
			\type, \bus,
			\out, ~bus,
			\array, Pseq([100,200,300,500],inf),
			\dur, 1/4,
		)
	]);
	~pat.play;
)


~no
