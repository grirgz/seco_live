// TODO:
// - integrate popupmenu with Param
//	- not an easy one because the popup could interpret the value as an index or as a label (popup.items)
//	- need a way to tell MIDIMap that he should not compare the non-normalised values

Pseq([])EventSeq.new

(
EventSeq[
	a:3,
	b:5,

]
)

~eq.asPattern.asStream.nextN(10)
~eq.asPattern.pattern
(
~eq = EventSeq.new;
~ss = StepList[1,2,3,4];
~eq.degree = ~ss;
Pdef(\plop, 
	~eq.asPattern.trace <>

	Pbind(
	\instrument, \default,
	//\degree, ~ss.asPattern,
	\dur, 1,
	\amp, 0.1
)).play;
);

~ss = StepList[1,2,3,4];
~ss2 = StepList[4,4,4,5,6];
~ss.edit
~ssv = StepSeqView.new
~ssv.view
~ssv.mapStepSeq(~ss);
~ssv.mapStepSeq(~ss2);
~ss
WindowLayout({ VLayout( ~ssv.view )})
WindowLayout({ VLayout( StepSeqView(~ss).view )})

(a:3,b:5).size
().size

(
~make = {
	~win = Window.new;
	~layout = VLayout(
		~but = XSimpleButton.new.label_(145512.rand.asString)
	
	);
	~win.layout = ~layout;
	//window.alwaysOnTop = true;
	~win.front;
}.value
)

~layout.removeAll
~layout.dump
~win.layout = ~layout = VLayout( ~but = XSimpleButton.new.label_(145512.rand.asString) );
~win.view
~win.view.removeAll

(
	~make_eventseqview = (
		new: { arg self;
			self = self.deepCopy;
		
			
		
			self;
		},

		makeLayout: {
			var stepseqview = StepSeqView.new;
			HLayout(
				stepseqview.view,
				PopUpMenu.new;
			)
		}
	)
)


(
~es = EventSeq.new;
~sl = StepList[1,2,3,4];
~sl2 = StepList[4,4,4,5,6,7];
~es.degree = ~sl;
~es.pan = ~sl2;
~esv = EventSeqView.new
)
~es2 = EventSeq.new;
~esv
~esv.mapEventSeq(~es)
~es[\isRest]
~esv.mapEventSeq(~es2)
List.perform(\new)
~esv.removeAll
WindowLayout({ VLayout( ~esv.view )})
~sl.addSpec(\list, ControlSpec(0,10,\lin))
nil ?? { 3 }
~es
~sl

ParamGroup(~es.collect(_.asParam)).edit

~es.valuesollect


(
WindowLayout({ 
	var lay = GridLayout.rows(*
		~es.collect({ arg step, key;
			[
				StaticText.new.string_(key),
				ListParamLayout.knob(step.asParam)
			]
		}).values.debug("what")
		++ [  
			[
				StaticText.new,
			ListParamLayout.cursor(~es[~es.keys.asArray.[0].debug("first")].asParam)
			]
		]
	);
	lay
})
)

(
WindowLayout({ 
	var lay = GridLayout.rows(*
		~es.collect({ arg step, key;
			[ StaticText.new.string_(key) ]
			++ ListParamLayout.knob(step.asParam).viewlist
		}).values.debug("what")
		++ [  
			[ StaticText.new, ]
			++ ListParamLayout.cursor(~es[~es.keys.asArray[1].debug("first")].asParam).viewlist
		]
	);
	lay
})
)

(
WindowLayout({ 
	var lay = GridLayout.rows(*
		~es.collect({ arg step, key;
			[ StaticText.new.string_(key) ]
			++ ListParamLayout.knob(step.asParam).viewlist.do({ arg view, x; 
				ListParamLayout.addCursor(x, view, step.asParam.at(x), { 
					var color = view.color;
					color[0] = Color.yellow;
					view.color = color;
				}, {
					var color = view.color;
					color[0] = Color.white;
					view.color = color;
				}) 
			})
		}).values.debug("what")
	);
	lay
})
)

(
WindowLayout({ 
	ListParamLayout.cursor(~es[\degree].asParam);
})
)

(
Pdef(\plop, 
	~es.asPattern.trace <>

	Pbind(
	\instrument, \default,
	//\degree, ~ss.asPattern,
	\dur, 1/4,
	\amp, 0.1
)).play;
);



(
	a = (    pattern: Pbind(\note, Pgeom(1, 1.1, { 20.rand }), \dur, 0.05),    embedInStream: { |event, inevent| event[\pattern].embedInStream(inevent) });
	b = (note: [3, 5]);c = (freq: 402, dur: 0.3);Prand([a, b, c], inf).trace.play;
)

(
Pdef(\plop, 
	
	Pdict([
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],1),
			\dur, 1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([1],1),
			\dur, 1,
			\amp, 0.1
		),
	], Pseq([0,1],inf))

).play;
);
(
Pdef(\plop, 
	
	Pdict(Dictionary[
		0 -> Pbind(
			\instrument, \default,
			\degree, Pseq([0],4),
			\dur, 1,
			\amp, 0.1
		),
		1 -> Pbind(
			\instrument, \default,
			\degree, Pseq([1],4),
			\dur, 1,
			\amp, 0.1
		),
	], Pseq([0,1],inf))

).play;
);




b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
	Ndef(\granu, { arg pitch_stretch=1, time_stretch=1, grain_rate=40, grain_dur=0.5;
		var pos;
		var pan=0;
		var dur, clk;
		var sig;
		pos = LFSaw.kr(1/BufDur.kr(b) * time_stretch, pi).range(0, BufDur.kr(b));
		clk = Impulse.kr(grain_rate);
		dur = grain_dur;

		sig = TGrains.ar(2, clk, b, pitch_stretch, pos, dur, pan, 1);
		sig = sig * 0.1;

	
}).play;
Ndef(\granu).addSpec(\time_stretch, ControlSpec(1/8,8,\exp));
Ndef(\granu).addSpec(\pitch_stretch, ControlSpec(1/8,8,\exp));
)

Ndef(\granu).edit


~p = Param(currentEnvironment, \plop, \freq)
~p.get
~p.set("hey")
~p.normGet
~p.edit

//////////////////////////////////// dict


[\bla, \rah].keys

~bl

(
~bl = BankList.newFrom(6.collect({ StepList.new[1,2,3] }));
//~dsl = DictStepList.newFrom([0,4,2,3]).dict_(~bl);
//~dsl = DictStepList.newFrom([0,4,2,3]);
~dsl = DictStepList.new;
Window.new.layout_({ HLayout(DictStepListView.new(~dsl).view) }.value).alwaysOnTop_(true).front;
)
~dsl.addAll([1,2,3,4,5])
~dsl[0] = 4
~dsl.changed(\set)
~dsl.changed(\refresh)
~dsl.dict = ~bl
~dsl
Param(~dsl, \list).target


Window.new.layout_({ DictStepListView.new(~dsl).view }.value).front


(
	~ma
)
{BankList.new}! 4
