
(
Spec.add(\mididetune, ControlSpec(-24,24,\lin));
SynthDef(\fx, { arg out=0, amp=0.1, doneAction=2, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var detune1, detune2;
	var lpfratio, hpfratio;
	var freq;
	var pan;
	var stereodetune;
	var rq1, rq2;

	freq = \freq.kr(200);
	detune1 = \detune1.kr(0).midiratio;
	detune2 = \detune2.kr(0.1).midiratio;
	lpfratio = \lpfratio.kr(0).midiratio;
	hpfratio = \hpfratio.kr(1).midiratio;
	pan = \pan.kr(0);
	stereodetune = \stereodetune.kr(0.01);
	rq1 = \rq1.kr(0.4);
	rq2 = \rq2.kr(0.4);

	freq = freq * ( 1 + ( stereodetune * [1, -1] ) );

	sig1 = LFSaw.ar( freq*detune1 );
	sig2 = LFPulse.ar(freq*detune2);

	sig = sig1 + sig2;

	sig = RLPF.ar(sig, freq * lpfratio, rq1);
	sig = RHPF.ar(sig, freq * hpfratio, rq2);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);

	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	stereodetune: ControlSpec(0.00001,1,\exp),
	lpfratio: \mididetune,
	hpfratio: \mididetune,
	detune1: \mididetune,
	detune2: \mididetune,
	spread: \unipolar,
))).add;

Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
Spec.add(\adsr, XEnvSpec.adsr);
~padsr = Param(Pdef(\fx), \adsr);
Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
~pg = Pdef(\fx).asParamGroup(\fx, false, [\gate, \freq, \out, \doneAction]);
)



(
	Pdef(\plop, 

		Pseq([
			Psync(Pbind(
				\instrument, \fx,
				\degree, Pseq([0,1,4,3, Prand([1,2,5],Pwhite(-1,5,1))],inf),
				\dur, Pseq([1/4,1/5,Pn(1/8,4), Prand([1/4,1,1/2])],inf),
				\amp, 0.1
			), 3,3),
			Psync(Pbind(
				\instrument, \fx,
				\degree, Pseq([Pwhite(-1,5,1).stutter(4)],inf),
				\dur, Pseq([1/4],inf),
				\amp, 0.1
			), 1,1),
		],inf)
		<> Pdef(\fx) 
	).play;
);

(
	~make_paramgroup_view = { arg pg;
		var win = Window.new;
		var layout;
		var gridlayout;
		var biglayout;
		var scalarlist, biglist;

		scalarlist = pg.select({ arg param; 
			param.type == \scalar;
		});
		biglist = pg.select({ arg param;
			param.type != \scalar;
		});

		gridlayout = GridLayout.rows(*
			scalarlist.collect({ arg param;
				[
					param.asStaticTextLabel,
					param.asSlider.orientation_(\horizontal),
					param.asTextField,
				]
			})
		);
		gridlayout.setColumnStretch(1,1);

		biglayout = VLayout(*
			biglist.collect({ arg param;
				VLayout(
					param.asStaticTextLabel,
					param.asView,
					param.asTextField,
				)
			})
		);

		layout = HLayout(
			gridlayout,
			biglayout
		);
		layout;

	};

	~make_save_preset_layout = { arg pg, save_callback;
		var layout;
		var preset_name_field, preset_list_view;
		var save_button;
		preset_name_field = TextField.new;
		save_button = XSimpleButton.new
			.label_("Save preset")
			.action_({
				if(preset_name_field.string != "") {
					pg.save(preset_name_field.string.asSymbol);
					save_callback.(preset_name_field.string.asSymbol);
				};
			});
		preset_list_view = ListView.new;
		preset_list_view.items = pg.presets.keys.asArray.sort;
		preset_list_view.action = { arg view;
			preset_name_field.string_(view.items[view.value])
		};
		preset_list_view.value = nil;
		layout = VLayout.new(
			preset_name_field,
			save_button,
			preset_list_view,
		);
		layout;
	};

	~make_save_preset_window = { arg pg, ok_callback, cancel_callback;
		var win = Window.new;
		var pglayout;
		var layout = ~make_save_preset_layout.(pg, { arg name; 
			win.onClose = {ok_callback.(name)}; 
			win.close;
		});
		win.onClose = cancel_callback;
		win.layout = layout;
		win.front;
	};

	~make_preset_selector_gui = { arg pg;
		var layout;
		var left_button, popup_menu, right_button;
		var preset_list;
		var refresh_menu;
		var menu_current_index, menu_old_index;
		var menu_previous_index;
		var menu_walk;

		refresh_menu = {
			var index = popup_menu.value ? 1;
			preset_list =  pg.presets.keys.asArray.sort;
			popup_menu.items = [
				"Save preset",
				"-----------",
			] ++ preset_list;
			popup_menu.value = index;
		};

		left_button = XSimpleButton.new
			.action_({
				if( menu_previous_index <= 2) {
					popup_menu.value = popup_menu.items.size - 1;
				} {
					popup_menu.value = popup_menu.value - 1;
				};
				menu_previous_index = popup_menu.value;
				pg.load(preset_list[popup_menu.value-2]);
			})
			.label_("<");

		popup_menu = PopUpMenu.new;

		right_button = XSimpleButton.new
			.action_({
				if( menu_previous_index == ( popup_menu.items.size - 1 )) {
					popup_menu.value = 2;
				} {
					popup_menu.value = popup_menu.value + 1;
				};
				menu_previous_index = popup_menu.value;
				pg.load(preset_list[popup_menu.value-2]);
			})
			.label_(">");

		refresh_menu.();

		//menu_current_index = popup_menu.value.debug("cur first");
		menu_previous_index = popup_menu.value;
		popup_menu.action = { arg menu;
			if(menu.value < 2) {
				if(menu.value == 0) {
					~make_save_preset_window.(pg, { arg name;
						refresh_menu.();
						popup_menu.value = popup_menu.items.detectIndex({ arg x; x.debug("x") == name.debug("name")}).debug("detected index");
						menu_previous_index = menu.value;
					}, {

					});
					popup_menu.value = menu_previous_index.debug("old index");
				};
			} {
				pg.load(preset_list[menu.value-2]);
			};
			menu_previous_index = menu.value;
		};
		
		layout = HLayout(
			left_button,
			[popup_menu, stretch:1],
			right_button,
		);
		layout;

	};

	~makegui = { arg pg;
		
		var win = Window.new;
		var pglayout;
		var layout = VLayout.new;
		var preset_selector = ~make_preset_selector_gui.(pg);
		pglayout = ~make_paramgroup_view.(pg);
		layout.add(preset_selector);
		layout.add(pglayout);
		win.layout = layout;
		win.front;
	};
	~makegui.(~pg);
)

~pg.save(\preset1)
~pg.save(\preset2)
