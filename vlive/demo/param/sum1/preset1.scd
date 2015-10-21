
////////// some API design


// sequencer

// preset

StepEvent

PresetEvent


(
Pdef(\plop, 
	
	PresetEventDef(\yep) <>
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1
	)
).play;
);


ModulatorEvent
<> CurveEvent
<> NotePattern (NoteTimeline | StepNoteEvent)
<> StepEvent
<> PresetEvent

WindowLayout({

	
});


StepEvent <> PresetEvent


WindowLayout({
	VLayout(
		PresetEvent.asView,
		StepEvent.asView,
	)
});


PresetEventView.knob
PresetEventView.slider



~presetEvent

SpecGroup

(
	SynthDef(\sinn, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(freq);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	~presetEvent = PresetEvent.new;
	~presetEvent[\instrument] = \sinn;

)
~presetEvent.asParamGroup.edit
~presetEvent.asParamGroup[1].default
~presetEvent.asParamGroup[1].wrapper
~x = ~presetEvent.asParamGroup[1]
~x.target
~x.wrapper.class
~presetEvent

Pn(~presetEvent).play

Pdef(\bla, Pn(~presetEvent)).play

(
WindowLayout({
	VLayout(
		PlayerWrapper(Pdef(\bla)).asView,
		ParamGroupLayout.two_panes(~presetEvent.asParamGroup, \property),
		nil,
	)
});
)



(

	~sequencer = (
		new: { arg self, instr;
			self = self.deepCopy;
		
			
			self.presetEvent = PresetEvent.new;
			self.presetEvent[\instrument] = instr;
			self.stepEvent = StepEvent.new;
			self.stepEvent.addHalo(\instrument, instr);
			self.playerProxy = EventPatternProxy.new;
			self.playerProxy.source = self.as_pattern;
		
			self;
		},

		as_pattern: { arg self;
			(Plazy({ self.stepEvent.asPattern })  <> Plazy({ self.presetEvent }).loop).loop;
		},

		makeLayout: { arg self;
			VLayout(
				PlayerWrapper(self.playerProxy).label_("yep").asView,
				ParamGroupLayout.two_panes(self.presetEvent.asParamGroup, \property),
				~stepEventView.new(self.stepEvent, self.presetEvent.asParamGroup).makeLayout,
			)
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
			
		},

	);

	SynthDef(\sinn, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(freq);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	~seq = ~sequencer.new(\sinn);
	~seq.makeWindow;

)

(
	// test stepEventView

	~stepEvent = StepEvent.new;
	~stepEvent.addHalo(\instrument, \sinn);

	~sev = ~stepEventView.new(~stepEvent);
	~sev.makeWindow;

)

~stepEvent.asParamGroup



///////////////////////////////////// preset + ?
