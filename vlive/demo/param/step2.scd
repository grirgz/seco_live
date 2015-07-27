
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
		}).values.debug("what");
	);
	lay
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
