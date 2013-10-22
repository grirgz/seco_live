Pdef(~name +++ \pre, Sdef(~name, \mypreset).pbind.trace <> Pbind(
	\freq, 100,
));

// END

(
Pdef(~name +++ \pre, Sdef(~name, \mypreset3).pbind.trace <> Pbind(
	\freq, 100,
));
)

"~/seco/seco/veco/sdef.scd".standardizePath.load;
Sdef(~name, \mypreset, \preset, ~name);
Sdef(~name, \mypreset).get(0).edit;
Sdef(~name, \mypreset).edit;
Sdef(~name, \mypreset).save_data
Sdef(~name, \mypreset)
64*64*64
64*64
EnvSpec
Sdef(~name, \mypreset).pbind
Sdef(~name, \mypreset).get(0).build_pbind

~class_score_preset.new(Veco(~name),0)

Sdef(~name, \mypreset2, \preset, ~name);
Sdef(~name, \mypreset2);
Sdef(~name, \mypreset2).get(0);
Sdef(~name, \mypreset).get(0).edit;
~synthdef_name_to_specs.(~name)
nil ?? 1

Sdef(~name, \mypreset3, \preset, ~name);
Sdef(~name, \mypreset3);
Sdef(~name, \mypreset3).get(0);
Sdef(~name, \mypreset3).get(0).edit;


(
// use shift-click to keep a node selected
w = Window("envelope", Rect(150 , Window.screenBounds.height - 250, 250, 100)).front;
w.view.decorator = FlowLayout(w.view.bounds);

b = EnvelopeView(w, Rect(0, 0, 230, 80))
    .drawLines_(true)
    .selectionColor_(Color.red)
    .drawRects_(true)
	.grid_(0.05)
	.gridOn_(true)
    .resize_(5)
    .step_(0.05)
    .action_({arg b; 
		[b.index, b.value].postln;
		//b.value = [[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]];
	})
    .thumbSize_(10)
	.keepHorizontalOrder_(true)
    .value_([[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]]);
w.front;
)
b.value

// show grid
b.gridOn_(true);

// show Env
b.setEnv(Env.asr(0.5,1, 0.2));

// make the first point unmoveable
(
b.setEditable(0,false);
)
