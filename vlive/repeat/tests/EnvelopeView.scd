

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\saw, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Param(Pdef(\saw), \adsr, ParamEnvSpec.adsr).edit
beginDrag

(
WindowDef(\win, { arg def;
	var env;
	
	env = Param(Pdef(\saw), \adsr, ParamEnvSpec.adsr).asEnvelopeView;
	env.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(buttonNumber == 1) {
			view.addHalo(\mouseDownPosition, Point(x, y));
			view.addHalo(\mouseDownTotalDur, view.totalDur);
		};
	}).mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		var delta;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(view.getHalo(\mouseDownPosition).notNil) {
			delta = x - view.getHalo(\mouseDownPosition).x / 500;
			view.totalDur = view.getHalo(\mouseDownTotalDur) + delta;
		}
	}).mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(buttonNumber == 1) {
			view.addHalo(\mouseDownPosition, nil);
		};
	});
	env;
}).front;
)

(
m = Menu(
    a = MenuAction("Option A"),
    b = MenuAction("Option B")
).title_("Event Example");
f = {
    |action, what, value|
    "MenuAction '%' sent event %, value = %".format(action.string, "\\" ++ what, value).postln;
    if (what == \hovered) { "Hovering over: %".format(action).postln };
    if (what == \triggered) { "Action triggered: %".format(value).postln; m.destroy };
};
a.addDependant(f);
b.addDependant(f);
m.onClose_({ a.removeDependant(f); b.removeDependant(f) }).front;
)
