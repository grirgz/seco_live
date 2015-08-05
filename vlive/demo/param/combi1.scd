
~pc = ParamCombinator(Param(Pdef(\param), \freq, \freq));
~pc.setBusMode(true);

(
Pdef(\plop, Pdef(\param, Pbind()) <> Pbind(
	\instrument, \default,
	\freq, Pseq([500],inf),
	\dur, 1,
	\amp, 0.1
)).play;




Ndef(\lfo1, { SinOsc.kr(2.5).unipolar  });
//~pc.edit
WindowLayout({
	var dragSink_size = 15@15;
	var modknob;

	var sourcelayout;
	var knoblayout = 
		VLayout(
			modknob = ModKnob.new
				//.range1_(0.4)
				//.range2_(-0.3)
				//.range3_(0.5)
				.mouse_edit_pixel_range_(1000);
					~pc.mapModKnob(modknob);
					modknob.view.minSize_(30@30),
				HLayout(*
					3.collect({ arg idx;
						DragSink.new
							.string_((idx+1).asString)
							.mouseDownAction_({ arg view, x, y, mod, but;
								view.addHalo(\DragSink, \y, y);
								view.addHalo(\DragSink, \range, modknob.get_range(idx));
								[x, y, mod, but].debug("downc");
							})
							.mouseMoveAction_({ arg view, x, y, mod, but;
								var refy = view.getHalo(\DragSink, \y);
								var range = view.getHalo(\DragSink, \range);
								var val;
								range.debug("rnage");
								val = (refy - y).clip(-200,200)/200 + range;
								//modknob.set_range(idx, (refy - y).clip(-200,200)/200 + range);
								val.debug("VAL");
								~pc.rangeParam.at(idx).set(val);
								//~pc.ranges.changed(\set);
								//~pc.rangeParam.target.changed(\set);
								modknob.refresh;
								x.debug("XXXX");
								y.debug("YYYY");
								mod.debug("MOD");
								[x, "X", y, "Y", mod, but].debug("xymodbut move");
							})
							.receiveDragHandler_({ arg view; ~pc.inputParam.at(idx).set(View.currentDrag) })
							.minSize_(dragSink_size);
					})
				)
		);
		
		sourcelayout = HLayout(
			DragSource.new
				.object_(Ndef(\lfo1)),
			DragSource.new
				.object_(Ndef(\lfo2)),
			DragSource.new
				.object_(Ndef(\lfo3)),
		);

		HLayout(
			sourcelayout,
			knoblayout,

		)

})
)

~pc.inputParam.at(0).edit
~pc.rangeParam.edit
~pc.ranges.changed(\set)

~pc.ranges
~pc.rangeParam.target
~pc.rangeParam.get

~a = [1]
~a.addHalo(\DragSink, \range, 1)
~a.getHalo(\DragSink, \range)

Ndef(\default).get(\inputs)
Ndef(\default).set(\inputs, Ndef(\lfo1, { SinOsc.kr(2).range(1,10)  }))

~pc.targetParam.target.set(~pc.targetParam.property, Ndef(\lfo1, { SinOsc.kr(2).range(1,10)  }))
~pc.inputs
~pc.setBusMode(true)
~pc.targetParam.target.map(~pc.targetParam.property, Ndef(\lfo1, { SinOsc.kr(2).range(1,10)  }))
~pc.targetParam.property


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freqs.kr([200,500,1300]));
	//sig = SinOsc.ar(freq ! 3);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

{ SinOsc.ar(200) ! 2 * 0.1}.play;

Ndef(\plop).set(\freqs, [300,320,5400])
Ndef(\lfo1, { SinOsc.kr(2).range(1000,210)  })
Ndef(\plop).set(\freqs, [Ndef(\lfo1),320,5400])

Param(Ndef(\plop), \freqs, XArraySpec(\freq!3)).at(0).set(Ndef(\lfo1))
Param(Ndef(\plop), \freqs, XArraySpec(\freq!3)).edit

~pc.inputs
~pc.rangeParam.set(~pc.rangeParam.get)
~pc.rangeParam.get
~pc.rangeParam
~pc.rangeParam.set([1,0,0])
~pc.rangeParam

Ndef(\default)
Ndef(\default).get(\inputs)
Ndef(\default).set(\inputs)
Ndef(\default).get(\ranges)
Param(Ndef(\default), \inputs, XArraySpec(\unipolar!3)).at(0).edit
Param(Ndef(\default), \ranges, XArraySpec(\bipolar!3)).at(0).edit
Param(Ndef(\default), \base, \freq).edit

(
Pdef(\plop, Pdef(\param, Pbind()) <> Pbind(
	\instrument, \default,
	\freq, Pseq([500],inf),
	\dur, 1,
	\amp, 0.1
)).play;

		Ndef(\default, {
			var inputs, ranges;
			var fval;
			var targetParamspec = \freq.asSpec;
			var rangeSize = 3;
			fval = \base.kr(0);
			fval = targetParamspec.unmap(fval);
			inputs = \inputs.kr(0!rangeSize);
			ranges = \ranges.kr(0!rangeSize);
			inputs.poll;
			ranges.poll;

			fval.poll(label:"fval before");
			inputs.do { arg in, x;
				fval = fval + (in * ranges[x])
			};
			fval.poll(label:"fval");
			targetParamspec.map(fval).poll(label:"final");
		});

		Pdef(\param).set(\freq, Ndef(\default).asMap);

		ParamGroup([
			Param(Ndef(\default), \inputs, XArraySpec(\unipolar!3)).at(0),
			Param(Ndef(\default), \ranges, XArraySpec(\bipolar!3)).at(0),
			Param(Ndef(\default), \base, \freq)

		]).edit

)
Ndef(\lfo1, { SinOsc.kr(2).unipolar  })
Ndef(\default).set(\inputs, [Ndef(\lfo1),0,0])

Param(Ndef(\default), \inputs, XArraySpec(\unipolar!3)).at(0).set(Ndef(\lfo1))

Pdef(\param).map(\freq, Ndef(\lfo1))
Pdef(\param).get(\freq)
Pdef(\param).set(\freq, Ndef(\lfo1).asMap)
Pdef(\param).set(\freq, Ndef(\lfo1))
Pdef(\param).set(\freq, 800)

Ndef(\default).get(\inputs)
Ndef(\default).set(\inputs, [1,0,0])
Ndef(\default).set(\ranges, [1,0,0])
Ndef(\default).get(\ranges)
Ndef(\default).get(\base)

(
	)

Param(Ndef(\default), \inputs, XArraySpec(\unipolar!3)).at(0).edit
Param(Ndef(\default), \ranges, XArraySpec(\bipolar!3)).at(0).edit
Param(Ndef(\default), \base, \freq).edit

Ndef(\default).s
