
// now integrated in FixedEnvelopeView class with setMouseHooks
(
WindowDef(\win, { arg def;
	var env = Env.adsr(0.1,0.1,0.8,0.1);
	var envview;
	var xthis;
	var nodeIndexFromPixelPoint = { arg point; 
		var beatx = point.x/xthis.bounds.width * xthis.totalDur;
		xthis.valueXY.first.detectIndex { arg i; i > beatx } ?? { xthis.size  } - 1;
	};
	envview = FixedEnvelopeView.new.value_(env)
		.rightClickZoomEnabled_(true)
		.drawLines_(true)
		.selectionColor_(Color.red)
		.drawRects_(true)
		.totalDur_(1/2)
		.step_(0)
		.thumbSize_(10)
		.elasticSelection_(false)
		.keepHorizontalOrder_(true)
	;

	xthis = envview;
	envview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

		~p = Point(x, y);
		[ ~p.x/~envview.bounds.width,~envview.envDur, ~envview.totalDur, ~envview.envDur/~envview.totalDur, (~p.x/~envview.bounds.width * (~envview.totalDur ) ) ].debug("calc");
		~envview.valueXY.first.detectIndex { arg i; i.debug("i") > (~p.x/~envview.bounds.width * ~envview.totalDur ) }.debug("node index") ;
		if(buttonNumber == 1) {
			view.addHalo(\mouseDownPosition, Point(x, y));
			view.addHalo(\mouseDownTotalDur, view.totalDur);
			view.addHalo(\elasticSelection, xthis.elasticSelection); 
			xthis.elasticSelection = true;
		};
		if(buttonNumber == 0) {
			var selidx;
			var xy;
			if(view.index < 0) {
				selidx = nodeIndexFromPixelPoint.(Point(x,y));
				//view.index = idx;
			} {
				selidx = view.index;
			};
			//sel = view.index;
			selidx.debug("sel");
			view.addHalo(\mouseDownIndex, selidx);
			view.addHalo(\mouseDownPosition, Point(x, y));
			xy = xthis.valueXY;
			view.addHalo(\mouseDownInverse, xy[1][selidx] > xy[1][selidx + 1] );
			if(modifiers.isShift) {
				if(view.curves.isSequenceableCollection.not) {
					view.addHalo(\mouseDownCurve, view.curves);
				} {
					view.addHalo(\mouseDownCurve, view.curves[selidx]);
				};
			}

		};
	}).mouseMoveAction_({ arg view, x, y, modifiers;
		var delta;
		[view, x, y, modifiers].debug("mouseMoveAction");
			if(view.getHalo(\mouseDownPosition).notNil and: { view.getHalo(\mouseDownTotalDur).notNil }) {
				delta = x - view.getHalo(\mouseDownPosition).x / 500;
				view.totalDur = view.getHalo(\mouseDownTotalDur) + delta;
			};
			if(modifiers.isShift) {
				if(view.getHalo(\mouseDownPosition).notNil and: {view.getHalo(\mouseDownCurve).notNil  }) {
					var selidx = view.getHalo(\mouseDownIndex) ?? { view.index };
					var inv = if(view.getHalo(\mouseDownInverse) == true) { -1 } { 1 };
					delta = y - view.getHalo(\mouseDownPosition).y / 10;
					if(view.curves.isSequenceableCollection.not) {
						view.curves = view.curves ! view.value.size;
					};
					view.curves[selidx] = view.getHalo(\mouseDownCurve) + ( delta * inv );
					view.curves[selidx].debug("added curve delta %".format(delta));
					view.curves = view.curves; // update
					//view.totalDur = view.getHalo(\mouseDownTotalDur) + delta;
				}

			}

	}).mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(buttonNumber == 1) {
			xthis.elasticSelection = view.getHalo(\elasticSelection); 
		};
		view.addHalo(\mouseDownCurve, nil);
		view.addHalo(\mouseDownIndex, nil);
		view.addHalo(\mouseDownInverse, nil);
		view.addHalo(\mouseDownPosition, nil);
		view.addHalo(\mouseDownTotalDur, nil);
		view.addHalo(\elasticSelection, nil);
		if(Halo.lib[view].isEmpty) {
			Halo.lib.removeAt(view)
		};
	});
	~envview = envview;
	envview;

}).front;
);


Halo.lib.dictionary.asPairs[1].isEmpty
Halo.lib.removeAt(Halo.lib.dictionary.asPairs[2])
Halo.lib
~envview.selection
~envview.value.size
~envview.curves
~envview.curves
~envview.valueXY
~envview.totalDur
~envview.envDur
~envview.value.size
~envview.size = 4
~p = Point(347,83)
~p/~envview.bounds.extent
~envview.envDur/~envview.totalDur 
~p.x/~envview.bounds.width
~p.x/~envview.bounds.width * (~envview.envDur/~envview.totalDur );

~envview.valueXY.first.detectIndex { arg i; i.debug("i") > (~p.x/~envview.bounds.width * (~envview.envDur/~envview.totalDur ) ) } 
~envview.selection


/// test integration

~t = 1.2; TempoClock.default.tempo = ~t;
(

SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pbindef(\zed, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;

Spec.add(\adsr, ParamEnvSpec.adsr);

WindowDef(\win, { arg def;
	Param(Pbindef(\zed), \adsr).asView;
}).front;
);
