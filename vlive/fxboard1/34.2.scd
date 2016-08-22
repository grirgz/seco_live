
RandDelayNetwork(\default).make(~name+++\fx, "5--");
Veco(~namex).response_mode = \exec;
(
Veco.do { arg name;
	{
		WindowDef(\win+++name, { Ndef(name.debug("yep")+++\fx).asParamGroup.asView }).front;
	}.defer;
};
);

// END

Integer
Ndef(~name+++\fx).edit
RandDelayNetwork(\default).define_specs
RandDelayNetwork(\default).getPbindCompileString(~name+++\fx)
RandDelayNetwork(\default).code
(
RandDelayNetwork(\default).make(~name+++\fx, "5-QGAC-KJD9"); // good disto reverb
Ndef(~name+++\fx).put(10, \set -> 
	Pbind(
		'wet10', 0.85858585858586,
		'fb', 0.00013797374497215,
		'delay', 0.058570208180567,
		'delay2', 0.097700995729923,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 0.14475623289455,
		'pitchlag', 1.0,
		'pitchmix', 0.5959595959596,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'fbdistamp', 17.82437824762,
		'fbdistmix', 1.0,
		'postlpf', 19314.278105932,
		'posthpf', 20.0,
		'wetamp', 0.67601952842179,
		'wet20', 1.0,
		'mamp', 1.3318671525419,
		'gain', 0.95177020082612,
	).keep(1)
)
)
(
Ndef(~name+++\fx).put(100, \set -> 
	Pbind(
		'wet10', Pseq([
			0,1,0,0, 1,0,1,1,
			1,1,1,1, 0,0,1,0,
			0,1,0,0, 1,0,1,1,
			1,1,0,0, 1,0,1,0,
			0,1,0,0, 1,0,1,1,
			0,0,0,0, 1,1,1,1,
		],inf),
		\dur, 1/1,
	)
)
)

(
Ndef(~name+++\fx).put(101, \set -> 
	Pbind(
		'wet10', Pseq([
			Pseq([
				1,0,1,0, 0,0,1,1,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,0,0,0,
				0,1,0,0, 1,1,1,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,1,1,1,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
			],1),
		],inf)+0.5,
		\dur, 1/4,
	)
)
)

(
Ndef(~name+++\fx).put(100, \set -> 
	Pbind(
		'fb', Pseq([
			Pseq([
				1,0,1,0, 0,0,1,1,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,0,0,0,
				0,1,0,0, 1,1,1,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,1,1,1,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
			],1),
		],inf)/2,
		\dur, 1/1,
	)
)
)

Ndef(~name+++\fx).unset(\wet10)
Ndef(~name+++\fx).unset(\fb)



				Ndef(~name+++\fx).addSpec(\shift, ControlSpec(-5,5,\lin));
				Ndef(~name+++\fx).addSpec(\shift2, ControlSpec(-5,5,\lin));
				\shift.asSpec
				Ndef(~name+++\fx).getSpec(\shift)
				Ndef(~name+++\fx).getHalo(\spec)




(
w = Window.new.front; w.addFlowLayout;

    // direct, using bit field
Button(w, Rect(0,0,390,50)).states_([["hold shift/alt keys and click"]])
    .action_ { |but, mod|
        if (mod & 131072 == 131072) { "shift key was pressed.".postln; };
        if (mod & 524288 == 524288) { "alt key was pressed.".postln; };
    };

    // using helper methods
Button(w, Rect(0,0,390,50)).states_([["hold any mod keys and click"]])
    .action_ { |but, mod|
        if(mod.isCaps) { "mod pressed: Caps.".postln };
        if(mod.isShift) { "mod pressed: Shift.".postln };
        if(mod.isCtrl) { "mod pressed: Ctrl.".postln };
        if(mod.isAlt) { "mod pressed: Alt.".postln };
        if(mod.isNumPad) { "mod pressed: NumPad.".postln };
        if(mod.isHelp) { "mod pressed: Help.".postln };
        if(mod.isFun) { "mod pressed: Fun.".postln };
    };

    // collecting all modifiers
Button(w, Rect(0,0,390,50)).states_([["hold any mod keys and click"]])
    .action_ { |but, mod|
        var pressed;
        #[\isCaps, \isShift, \isCtrl, \isAlt, \isCmd, \isNumPad, \isHelp, \isFun].do { |x|
            if(mod.perform(x)) { pressed = pressed.add(x) }
        };
        pressed.postln;
    };
)

1.asFloat
