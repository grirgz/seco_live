
// in this file, i will write the prototypes of the three base timeline classes
// - ClipTimeline(name)
// - NoteTimeline(name, param)
// - EnvTimeline(name, param)

Pdef(\plop).asParamGroup.edit
\adsr.asSpec

(
/////////////////////////////////////////////////////////////////
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;
~el = nil;
/////////////////////////////////////////////////////////////////
//)
//(

/////////////////////

	Ndef(\siner, { arg freq=200, pan=0, amp=0.1;
		var sig;
		sig = SinOsc.ar(freq.lag(0.01) * [1,1.001]);
		sig = sig.tanh(SinOsc.kr([1,2,3,4]).abs);
		sig = Pan2.ar(sig, pan, amp).flop.mean;
	});
	//Ndef(\siner).set(\freq, BusDef(\freq, \control).asMap);
	Ndef(\siner).free;

	Ndef(\siner2, { arg freqx=400, lpfac=1, rq= 0.5, pan=0, amp=0.1;
		var sig;
		var freq = freqx;
		sig = LFSaw.ar(freq * [1,1.001] * lpfac.clip(0.5,10));
		lpfac.poll(label:"lpfac");
		//sig = RLPF.ar(sig, freq * lpfac.clip(0.5,10), rq);
		//sig = sig.tanh(SinOsc.kr([1,2,3,4]).abs);
		sig = Pan2.ar(sig, pan, amp).flop.mean;
	});
	//Ndef(\siner).set(\freq, BusDef(\freq, \control).asMap);
	Ndef(\siner2).free;
	//Ndef(\siner2).play;


	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;

	Pdef(\plop, Pbind(
		\instrument, \plop,
		\isRest, false,
		\dur, 1/8,
		\degree, Pseq((0..24),inf),
	));
	Spec.add(\adsr, XEnvSpec.adsr);
	Pdef(\plop).addHalo(\instrument, \plop);

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 2000,
		\dur, 1/8,
		\degree, Pseq((0..24)+10,inf),
	));

	Pdef(\plop3, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 4000,
		\dur, 1/6,
		\degree, Pseq([1,2,3,4]*2,inf),
	));


	if(~el.isNil) {

		~midinote_eventlist = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				//\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				//\midinote, Pseq((10..60)+40,1),
				\midinote, Pseq((0..5)*3+60,1),
				\dur, 1/1,
				\amp, 0.3
			);
		);

		~env_eventlist = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				//\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				//\midinote, Pseq((10..60)+40,1),
				\midinote, Pseq([
					Pseq((0..15)*3+40,1),
					Pseq(0-(0..15)*3+45,1),
				],1),
				\dur, 1/8,
				\amp, 0.3
			);
		);

		~env_lpfac = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				//\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				//\midinote, Pseq((10..60)+40,1),
				\lpfac, Pseq([
					Pseq((0..15)/3,1),
					Pseq(0-(0..15)/3+6,1),
				],1),
				\dur, 1/8,
				\amp, 0.3
			);
		);

		~el = XEventList.newFrom( 
			
				Pseq([
					~mkevent.((
						proto: ~event_type_eventlist,
						//nodeType: \eventlist,
						nodeType: \eventenv,
						freddy_brin_dacier: "oui mon pote",
						eventlist: ~env_eventlist,
						sustain: 6.5,
						midinote: 1,
						dur: 7,
					)),
					~mkevent.((
						proto: ~event_type_eventlist,
						//nodeType: \eventlist,
						freddy_brin_dacier: "oui mon pote",
						eventlist: ~midinote_eventlist,
						sustain: 6.5,
						midinote: 0,
						dur: 7,
					)),
				],1)

		);

		XEventLoop(\pdef).list = ~el;
		XEventLoop(\midinote).list = ~midinote_eventlist;
		XEventLoop(\env).list = ~env_eventlist;
		XEventLoop(\lpfac).list = ~env_lpfac;
	};



	////////////////////////////////////// Tests

	~nt = ~noteTimeline.new(\note, Param(Pdef(\plop), \midinote));

	~pt = ~clipTimeline.new(\clip);
	~pt.edit;

	~ct2 = ~clipTimeline.new(\miniclip);

	~et = ~envTimeline.new(\lpfac, Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)));
)
	~ct2.edit;

	~nt.edit;
	~et.edit;

~noteTimeline.all
	~pt = ~noteTimeline.new(\note, Param(Pdef(\plop2), \midinote));
	~pt.edit;
	~pt.param = Param(Pdef(\plop2), \midinote)

	TimelineEnvView.o
	~tp = TimelinePreview_Env.new
	~tp.mapEventList(~et.eventList)
	~tp.mapParam(~et.param)
	~et.param
	WindowLayout({ ~tp.view })

~pt.eventList.totalDur
~pt.eventPlay
~pt.edit.new
~pt.eventList.print
~pt.proxy.source
~pt.xasPattern.play
~pt.init
~pt.cursor.startPosition = 1
~pt.cursor.startPosition
~pt.cursor.changed(\refresh)
~pt.cursor.changed(\startPosition)
~view = ~pt.edit
~view.cursor.startPosition
(proxy:4).proxy

~pt.xasPattern
~str = ~pt.xasPattern.asStream;
~str.next(Event.default)

Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)).get.asBus.get(_.debug("get"))
Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)).get.asBus.set(2)

Pdef(\plop).play
~pt.eventList[1].pattern
~pt.eventList[1][\pattern].asCompileString
(pattern:3).pattern

Ndef(\siner2).play
Ndef(\siner2).edit
Ndef(\siner2).clear

(
)

3.6

(


~pat = ~pattern_to_envpattern.(
	Pbind(
		\instrument, \env_segment,
		\level, Pseq([1,5,2,3],2),
		\dur, 1,
		\legato, 1,
		\time, Pkey(\sustain),
		\out, BusDef(\test, \control),
		\amp, 0.1
	);
);

//~pat.play;
Pseq([~pat, ~pat]).play;


)


Ndef(\siner2).set(\lpfac, BusDef(\test).asMap).play




play{a = PMOsc;b= SinOsc;d=440; a.ar(b.kr(0.1,d),d/2+b.kr(d*0.01,pi  ),1,a.ar(4,2,1,0,a.ar(d*0.01,2,1)),b.kr(0.1))}// #supercollider

play{a = PMOsc;b= SinOsc;d=440; a.ar(b.kr(0.1,d),d/2+b.kr(d*0.01,pi  ),1,a.ar(4,2,1,0,a.ar(d*0.01,2,1)),b.kr(0.1)) ! 2}// #supercollider

play{a = PMOsc;b= SinOsc;d=440; a.ar(b.kr(0.1 * [1,2],d),d/2+b.kr(d*0.01,pi  ),1,a.ar(4,2,1,0,a.ar(d*0.01,2,1)),b.kr(0.1))}// #supercollider


