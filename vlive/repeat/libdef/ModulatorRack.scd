
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
	sig = DC.ar(bias);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
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
	addModulator: { arg self;
		var idx = self.nextFreeIndex;
		self.childAt(idx).instrument = \modsin;
		self.childAt(idx).outBus = BusDef((\amodbus++idx).asSymbol, \audio, 1);
		self.changed(\children);
	},

	removeModulator: { arg self, idx;
		self.childAt(idx).clearPart;
		self.changed(\children)
	}, 
));
TrackTemplateDef(\ModulatorRackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	instrument_: { arg self, instr;
		var outbus;
		outbus = self.outBus;
		self[\instrument] = instr;
		self.changed(\instrument);
		//self.base = Pbindef(( \mod++self.index ).asSymbol, \bla, 1);
		self.source = Pdef(( \modsource++self.index ).asSymbol, Pmono(instr));
	   	self.outBus = outbus;
		
	},

	stopInternal: { arg self;
		// this is called when another child start playing
		// can be overridden when parentTrack.proxy should not be stopped, like in FileCodeTrack
		//self.stop;
		
	},
));

WindowDef(\ModulatorRack, { arg def, model;
	var modview = View.new;
	var scrollview = ScrollView.new;
	scrollview.canvas = modview;

	modview.followChange(model, \children, {


		modview.removeAll;

		modview.layout = VLayout(*
			model.existingChildren.asArray.collect { arg child, idx;
				var scope = View.new;
				var entry = View.new;
				var pgview = View.new;
				pgview.followChange(model, \instrument, {
					pgview.removeAll;
					if(child.source.notNil) {
						pgview.layout = child.source.asParamGroup.selectSynthDefParams.rejectByKey([\out,\adsr]).asView;
					}
				});
				pgview.minWidth = 300;

				scope = WindowDef(\ScopeView).asView(Param(Message(child), \outBus).get);
				scope.maxHeight = 80;
				scope.followChange(child, \play, {
					scope.restart;
				});

				entry.layout = HLayout (
					VLayout (
						PlayerWrapper(child).asView,
						Param(Message(child), \instrument, TagSpecDef(\SynthDef_keys)).asPopUpMenu,
						Param(child.source, \out).asPopUpMenu.addAction({
							scope.inBus = Param(child.source, \out).get;
						}),
						nil
					),
					pgview,
					scope,
				);
				entry.background = Color.grey(0.8);
				entry.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
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
				model.addModulator;
			}),
			BasicButton.new.string_("ParamRouter").action_({
				ProtoDef(\ParamRouter).edit;
			}),
		),
		scrollview,
	)
	
});


BusDef(\amodbus1, \audio, 1);
BusDef(\amodbus2, \audio, 1);
BusDef(\amodbus3, \audio, 1);
BusDef(\amodbus4, \audio, 1);
TrackDef(\ModulatorRack, TrackTemplateDef(\ModulatorRack));
)

// END
//////////////////////////////////////////

TrackTemplateDef(\ModulatorRack).edit;

Buffer.alloc(s,1024,1)
TrackTemplateDef(\ModulatorRack).childAt(0).isEmpty
TrackTemplateDef(\ModulatorRack).childAt(0).parent
TrackTemplateDef(\ModulatorRack).childAt(0).proxy.outBus
TrackTemplateDef(\ModulatorRack).childAt(0).outBus
TrackTemplateDef(\ModulatorRack).clearTrack
\lofreq.asSpec.default
Param( TrackTemplateDef(\ModulatorRack).childAt(0).source, \freq ).get

PatKitDef(\bla)
KitTimeline(\bla).edit
(

);


(
)
BusDef(\abus1,\audio,1).index
BufDef(\ScopeView_abus1).clear

/////////////////////////////////////////




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
