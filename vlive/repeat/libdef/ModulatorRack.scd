// TODO:
// - stepseq modulator
// - paramtimeline modulator
// - stepseq modulator but with slopes

(
FileSystemProject.loadOnce("libdef/CustomTrackList.scd");
FileSystemProject.loadOnce("libdef/ScopeView.scd");
FileSystemProject.loadOnce("libdef/ParamRouter.scd");

SynthDef(\modsin, { arg out=0, gate=1, gain=1, freq=2;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamAudioBusSpec(TagSpecDef(\BusDef_audio_mono)),
	freq: \lofreq,
))).add;

SynthDef(\modsaw, { arg out=0, gate=1, gain=1, freq=2;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamAudioBusSpec(TagSpecDef(\BusDef_audio_mono)),
	freq: \lofreq,
))).add;

SynthDef(\modconst, { arg out=0, gate=1, gain=1, bias=0;
	var sig;
	sig = K2A.ar(bias);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	bias: \bipolar.asSpec,
	out: ParamAudioBusSpec(TagSpecDef(\BusDef_audio_mono)),
	freq: \lofreq,
))).add;

TrackTemplateDef(\ModulatorRack, (
	parent: TrackTemplateDef(\PlayerWrapperTrack),
	childClass: { TrackTemplateDef(\ModulatorRackPart) },
	edit: { arg self;
		WindowDef(\ModulatorRack).front(self);
	},
	nextFreeIndex: { arg self;
		var next = self.children.size;
		self.children.do { arg item, idx;
			if(item.isNil or: item.isEmpty) {
				next = idx;
			}
		};
		next
	},
	addModulator: { arg self, trackTemplate;
		var idx = self.nextFreeIndex;
		if(trackTemplate.notNil) {
			self.childAt(idx).trackTemplate = trackTemplate;
		};
		self.childAt(idx).makeScore;
		self.childAt(idx).outBus = BusDef((\amodbus++idx).asSymbol, \audio, 1);
		self.changed(\children);
		self.childAt(idx);
	},

	removeModulator: { arg self, idx;
		self.childAt(idx).clearPart;
		self.changed(\children)
	}, 
));

TrackTemplateDef(\ModulatorRackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),

	modulatorType: \SynthDef,

	makeScore: { arg self;
		self.instrument = \modsin;
	},

	instrument_: { arg self, instr;
		var outbus;
		outbus = self.outBus;
		self[\instrument] = instr;
		//self.base = Pbindef(( \mod++self.index ).asSymbol, \bla, 1);
		self.source = Pdef(( \modsource++self.index ).asSymbol, Pmono(instr));
		//self.source = Pdef(( \modsource++self.index ).asSymbol, Pmono(instr));
		//self.source.envir[\freq] = nil;  // do not work, it is in parent
		self.source.set(\freq, Param.getSynthDefDefaultValue(\freq, instr)); // erase ~freq function to use synthdef default value
		self.source.get(\freq).asCompileString.debug("pdef freq");
		outbus.debug("outbus");
		//self.outBus = outbus;
		self.changed(\instrument);
		
	},

	outBus: { arg self;
		if(self.source.notNil) { Param(self.source, \out).get } ?? { self.parentTrack.outBus };
	},

	outBus_: { arg self, val;
		Param(self.source, \out).set(val);
	},

	asPreview: { arg self;
		if(self.source.notNil) {
			self.source.asParamGroup.selectSynthDefParams.rejectByKey([\out,\adsr]).asView;
		} {
			StaticText.new.string_("Empty")
		}
	},

	stopInternal: { arg self;
		// this is called when another child start playing
		// can be overridden when parentTrack.proxy should not be stopped, like in FileCodeTrack
		//self.stop;
		
	},
));
TagSpecDef(\ModulatorTemplate).addUnique(\SynthDef -> TrackTemplateDef(\ModulatorRackPart));

TrackTemplateDef(\ParamTimelineModulator, (
	parent: TrackTemplateDef(\ModulatorRackPart),

	modulatorType: \ParamTimeline,

	instrument_: {
		// NOOP
	},

	makeScore: { arg self;
		self.source = ParamTimeline(( self.trackKey++\_mod ).asSymbol);
	},

	outBus: { arg self;
		if(self.source.notNil) { 
			self.source.outBus;
		} ?? { self.parentTrack.outBus };
	},

	outBus_: { arg self, val;
		if(self.source.notNil) {
			self.source.outBus = val;
		};
	},


	asPreview: { arg self;
		if(self.source.notNil) {
			HLayout([ self.source.asPreview.minSize_(800@100), align:\top ]).spacing_(0).margins_(0)
		} {
			StaticText.new.string_("Empty")
		}
	},

));
TagSpecDef(\ModulatorTemplate).addUnique(\ParamTimeline -> TrackTemplateDef(\ParamTimelineModulator));

TrackTemplateDef(\StepSeqModulator, (
	parent: TrackTemplateDef(\ModulatorRackPart),

	modulatorType: \StepSeq,

	outRate: \audio,
	defaultValue: 0,
	defaultSize: 8,

	instrument_: {
		// NOOP
	},

	makeScore: { arg self;
		if(self.outRate == \control) {
			self.source = Pbindef(
				( self.trackKey++\_mod ).asSymbol, 
				\type, \bus,
				\array, PstepSeq(self.defaultValue!self.defaultSize,inf)
			);
			self.stepseqParam = Param(self.source, \array -> \stepseq, \unipolar);
		} {
			self.baseProxy = Pbindef(
				( self.trackKey++\_mod ).asSymbol, 
				\instrument, \modconst,
				\bias, PstepSeq(self.defaultValue!self.defaultSize,inf)
			);
			self.baseProxy.debug("baseproxy");
			self.source.debug("source1");
			self.source = EventPatternProxy(Pmono(\modconst) <> self.baseProxy);
			self.source.debug("source2");
			self.stepseqParam = Param(self.baseProxy, \bias -> \stepseq, \unipolar);
			self.source.debug("source3");
		};
	},

	outBus: { arg self;
		if(self.baseProxy.notNil) { 
			Param(self.baseProxy, \out -> \source).get
		} ?? { self.parentTrack.outBus };
	},

	outBus_: { arg self, val;
		if(self.baseProxy.notNil) {
			Param(self.baseProxy, \out -> \source).set(val)
		};
	},


	asPreview: { arg self;
		if(self.stepseqParam.notNil) {
			VLayout (
				self.stepseqParam.asView,
				Param(self.baseProxy, \dur -> \source).asView,
			)
		} {
			StaticText.new.string_("Empty")
		}
	},

));
TagSpecDef(\ModulatorTemplate).addUnique(\StepSeq -> TrackTemplateDef(\StepSeqModulator));


// gui

WindowDef(\ModulatorRack, { arg def, model;
	var modview = View.new;
	var scrollview = ScrollView.new;
	scrollview.canvas = modview;

	modview.followChange(model, \children, {


		modview.removeAll;

		Log(\Param).debug("ModulatorRack view: xx0");
		modview.layout = VLayout(*
			model.existingChildren.asArray.collect { arg child, idx;
				var scope = View.new;
				var entry = View.new;
				var pgview = View.new;
				var playbut;
				var playbloc;
				Log(\Param).debug("ModulatorRack view: 0");
				pgview.followChange(child, \instrument, {
					"followChange instrument".debug;
					pgview.removeAll;
					pgview.layout = child.asPreview;
				});
				pgview.minWidth = 300;

				Log(\Param).debug("ModulatorRack view: 1");
				if(child.modulatorType != \ParamTimeline) {

					scope = WindowDef(\ScopeView).asView(child.outBus);
					scope.maxHeight = 80;
					scope.followChange(child, \play, {
						scope.restart;
					});
				};

				Log(\Param).debug("ModulatorRack view: 2");
				playbloc = VLayout();
				playbut = PlayerWrapper(child).asView;
				playbloc.add(playbut);
				if(child.modulatorType == \SynthDef) {
					playbloc.add(
						Param(Message(child), \instrument, TagSpecDef(\SynthDef_keys)).asPopUpMenu,
					)
				};
				playbloc.add(
					Param(Message(child), \outBus, ParamBusSpec()).asPopUpMenu.addAction({
						scope.inBus = child.outBus;
					}),
				);
				playbloc.add(nil);
				entry.layout = HLayout (
					playbloc,
					pgview,
				);
				if(scope.notNil) {
					entry.layout.add(scope)
				};
				Log(\Param).debug("ModulatorRack view: 3");
				entry.background = Color.grey(0.8);
				playbut.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					if(buttonNumber == 1) {
						Menu(
							MenuAction("Remove", { model.removeModulator(child.index) })
						).front
					}
				});

				entry;
			} ++ [nil];
		)
	});
	VLayout (
		HLayout (
			BasicButton.new.string_("Add").action_({
				Menu(*
					TagSpecDef(\ModulatorTemplate).list.collect { arg asso, idx;
						MenuAction(asso.key, {
							model.addModulator(asso.value);
						})
					}
				).front
			}),
			BasicButton.new.string_("ParamRouter").action_({
				ProtoDef(\ParamRouter).edit;
			}),
		),
		scrollview,
	)
	
});


BusDef(\zeromono, \audio, 1);
BusDef(\amodbus0, \audio, 1);
BusDef(\amodbus1, \audio, 1);
BusDef(\amodbus2, \audio, 1);
BusDef(\amodbus3, \audio, 1);
BusDef(\amodbus4, \audio, 1);
TrackDef(\ModulatorRack, TrackTemplateDef(\ModulatorRack));
)

// END
//////////////////////////////////////////

TrackDef(\ModulatorRack).edit;
TrackDef(\ModulatorRack).existingChildren
TrackDef(\ModulatorRack).childAt(0).asPreview
TrackDef(\ModulatorRack).childAt(0).clear
TrackDef(\ModulatorRack).childAt(0).keys
TrackDef(\ModulatorRack).childAt(0).proxy.play
TrackDef(\ModulatorRack).childAt(0).proxy
TrackDef(\ModulatorRack).childAt(0).baseProxy.play
TrackDef(\ModulatorRack).childAt(0).baseProxy
TrackDef(\ModulatorRack).childAt(0).source
TrackDef(\ModulatorRack).childAt(0).source = nil
TrackDef(\ModulatorRack).childAt(0).makeScore
TrackDef(\ModulatorRack).childAt(0)[\source_].asCompileString
TrackDef(\ModulatorRack).childAt(0)[\proxy_].asCompileString
SynthDesc(\modconst).outputs.first.type
SynthDesc(\saw).outputs
IODesc
TrackDef(\ModulatorRack).childAt(1).makeScore
TrackDef(\ModulatorRack).childAt(1).
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.kr(0, SinOsc.kr(freq) );
	Out.ar(out, sig);
}).add;
);

Buffer.alloc(s,1024,1)
TrackTemplateDef(\ModulatorRack).childAt(0).isEmpty
TrackTemplateDef(\ModulatorRack).childAt(0).parent
TrackTemplateDef(\ModulatorRack).childAt(0).proxy.outBus
TrackTemplateDef(\ModulatorRack).childAt(0).outBus
TrackTemplateDef(\ModulatorRack).clearTrack
\lofreq.asSpec.default
Param( TrackTemplateDef(\ModulatorRack).childAt(0).source, \freq ).get
TrackTemplateDef(\ModulatorRack).childAt(0).proxy

PatKitDef(\bla)
KitTimeline(\bla).edit

ParamTimeline(\azer).edit

BusDef(\abus1,\audio,1).index
BufDef(\ScopeView_abus1).clear

/////////////////////////////////////////

FileSystemProject.load("libdef/PbindefEditor.scd")

(
Pdef(\popo, 
	Pbind(
		\instrument, \saw,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\popo).edit
Pdef(\popo).clear
Pdef(\popo).envir.clear
Pdef(\popo).addHalo(\ParamCombinator_lpfr, nil)

/////////////////////////////////////////

FileSystemProject.load("libdef/CustomTrackList.scd")
TrackDef(\myc, \CustomTrackList).editGrid

~playbut.model.label


().label
/////////////////////////////////////////

entryo
~v = ParamValue()
Param(~v)
~v.asParam.wrapper


Param(TrackDef(\ModulatorRack).childAt(0).source, \freq).default
Param(TrackDef(\ModulatorRack).childAt(0).source, \freq).getBus
Param(TrackDef(\ModulatorRack).childAt(0).source, \freq).get
Param(TrackDef(\ModulatorRack).childAt(0).source, \freq).wrapper
Param(TrackDef(\ModulatorRack).childAt(0).source, \freq).accessor
Param(TrackDef(\ModulatorRack).childAt(0).source, \blabla).set(10)
TrackDef(\ModulatorRack).childAt(0).source.get(\freq).asCompileString
TrackDef(\ModulatorRack).childAt(0).source.get(\freq)
TrackDef(\ModulatorRack).childAt(0).source.getVal(\freq)
TrackDef(\ModulatorRack).childAt(0).source.envir
TrackDef(\ModulatorRack).childAt(0).source.set(\bla, 10)
TrackDef(\ModulatorRack).childAt(0).source
TrackDef(\ModulatorRack).childAt(0).source
TrackDef(\ModulatorRack).childAt(0).proxy
TrackDef(\ModulatorRack).childAt(0)[\source_].asCompileString
TrackDef(\ModulatorRack).childAt(0)[\proxy_].asCompileString
TrackDef(\ModulatorRack).childAt(0).outBus = nil
TrackDef(\ModulatorRack).addModulator

Pdef(\hoh, Pbind())
Pdef(\aze, Pmono(\modsin))
Pdef(\aze).get(\freq)
PlayerWrapper(Pdef(\aze))
Pdef(\hoh).get(\freq)
Param(Pdef(\hoh), \freq).get

//////////////
SynthDesc(\modsin).asParamGroup(Pdef(\bla)).edit

WindowDef(\win, { arg def;
	var scope = ScopeView();
	scope.buffer = BufDef(\scope1, 1024, 2);
	scope.server = Server.default;
	scope.bus = j
	
}).front;


/////////////////////////////////////////
(
f = Buffer.alloc(s,1024,2);
//b = Bus.audio(s,1);
b = BusDef(\abus1, \audio, 1);

w = Window.new.front;
w.onClose = { // free everything when finished
    c.stop; a.free; d.free; f.free; b.free;
    "SynthDefs, busses and buffers have all been freed.".postln;
};
c = ScopeView(w.view);
c.bufnum = f.bufnum;
c.server = s; // Important: one must assign the ScopeView to a server
)

(
// listening to the bus, using ScopeOut2 to write it to the buffer
a = SynthDef("monoscope", { arg bus, bufnum;
    var z;
    z = In.ar(bus, 2);

    ScopeOut2.ar(z, bufnum);
    Out.ar(0, z);
}).play(
    target: RootNode(s),
    args: [\bus, b.index, \bufnum, f.bufnum],
    addAction: \addToTail // make sure it goes after what you are scoping
);

// making noise onto the buffer
d = SynthDef("noise", { arg bus;
    var z;
    z = LFSaw.ar(SinOsc.kr(0.1).range(300,1000),[0,1]*pi) * 0.1;
    Out.ar(bus, z);
}).play(
    s,
    [\bus,b.index]
);
c.start; // Tell the ScopeView to start
CmdPeriod.doOnce({w.close});
)


c.style = 0; // vertically spaced
c.style = 1; // overlapped
c.style = 2; // x/y

(
s.waitForBoot({
    var func, sdef1, sdef2, syn1, syn2,startButton ;
    f = Buffer.alloc(s,1024,2);
    b = Bus.audio(s,1);

    w = Window("Scope", Rect(150, Window.screenBounds.height-500,790,400)).front;
    c = ScopeView(w,Rect(10,10,380,380)); // this is SCScope
    c.bufnum = f.bufnum;

    // IMPORTANT
    c.server = s;

    v = CompositeView(w,Rect(400,10,380,380)).background_(Color.rand(0.7));
    v.decorator = n = FlowLayout(v.bounds, margin: 0@0, gap: 5@5);

    a = StaticText(v, Rect(20, 70, 90, 20)).string_(" xZoom = 1").background_(Color.rand);
    m = Slider(v, Rect(20, 60, 285, 20)).background_(a.background).action_({func.value}).value_(0.5);
    d = StaticText(v, Rect(20, 70, 90, 20)).string_(" yZoom = 1").background_(Color.rand);
    g = Slider(v, Rect(20, 60, 285, 20)).background_(d.background).action_({func.value}).value_(0.5);

    h = StaticText(v, Rect(20, 70, 90, 20)).string_(" x = 0").background_(Color.rand);
    i = Slider(v, Rect(20, 60, 285, 20)).background_(h.background).action_({func.value}).value_(0.5);

    Button(v, Rect(0,0,380, 20))
    .states_([["waveColors = [ Color.rand, ... ]",Color.black,Color.rand]])
    .action_({c.waveColors = [Color.rand,Color.rand]});

    Button(v, Rect(0,0,380, 20))
    .states_([[" background = Color.rand(0.1,0.3) ",Color.black,Color.rand]])
    .action_({c.background = Color.rand(0.1,0.3) });

    t = Button(v, Rect(0,0,380, 20))
    .states_([["Current style is 0",Color.black,Color.rand],
        ["Current style is 1",Color.black,Color.rand],
        ["Current style is 2",Color.black,Color.rand]])
    .action_({func.value});

    func = {
        c.xZoom = ([0.25, 10, \exp, 1/8, 1].asSpec.map(m.value)); a.string = " xZoom = %".format(c.xZoom);
        c.yZoom = ([0.25, 10, \exp, 1/8, 1].asSpec.map(g.value)); d.string = " yZoom = %".format(c.yZoom);
        c.x = ([ -1024,1024, \linear, 1/8, 1].asSpec.map(i.value)); h.string = " x = %".format(c.x);
        c.style=t.value
    };

    startButton = Button.new(v, Rect(0,0,380, 50))
    .states_([["Start Sound",Color.black,Color.green],["Stop Sound",Color.black,Color.red]]).action_({});


    startButton.action_{
        (startButton.value==1).if{
            syn1 = SynthDef("test1", { arg bus, bufnum;
                var z;
                z = In.ar(bus,2);
                // ScopeOut2 writes the audio to the buffer
                // IMPORTANT - ScopeOut2, not ScopeOut
                ScopeOut2.ar(z, bufnum);
                Out.ar(0,z);
            }).play(
                RootNode(s),
                [\bus,b.index, \bufnum, f.bufnum] ,
                \addToTail // make sure it goes after what you are scoping
            );

            // making noise onto the buffer
            syn2 = SynthDef("test2", { arg bus;
                var z;
                z = PMOsc.ar([300,250],*SinOsc.ar([0.027,0.017])*pi) * 0.1;
                Out.ar(bus, z);
            }).play(s,[\bus,b.index]);

        }{syn1.free; syn2.free};
    };

    // IMPORTANT
    c.start;

    w.onClose={syn1.free; syn2.free; b.free; f.free};
    CmdPeriod.doOnce({w.close});
})
)

/////////

(
WindowDef(\win, { arg def;
	var view;
	view = View.new;
	view.layout = VLayout([ ParamTimeline(\bla).asPreview.minSize_(800@200), align:\top ]);
	view.background = Color.green;
	
}).front;
)
