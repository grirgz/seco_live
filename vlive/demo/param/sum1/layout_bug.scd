
///////////// cell width


// OK
WindowLayout({
	var size = 8;
	VLayout(
		HLayout (
			*size.collect({
				Button.new
			}),
		),
		HLayout (
			*size.collect({
				Knob.new
			}),
		),
	)
})

// OK
WindowLayout({
	var size = 8;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! size);
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				param.asButton;
			}),
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob;
			}),
		),
	)
})

(
// NOT OK
WindowLayout({
	var size = 16;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! ( 8 ));
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				param.asButton.fixedWidth_(30);
			})
			++ [ nil ],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob.fixedWidth_(30);
			})
			++ [ nil ],
		),
	)
})
)

(
// OK
WindowLayout({
	var size = 8;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				param.asButton;
			}),
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob;
			}),
		),
	)
})
)

(
// NOT OK
WindowLayout({
	var size = 8;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				param.asButton;
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob;
			}) ++ [nil],
		),
	)
})
)

(
// NOT OK
WindowLayout({
	var size = 8;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	var width = 50;
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				param.asButton.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob.fixedWidth_(width);
			}) ++ [nil],
		),
	)
})
)

(
// OK
//////////////////////// this one is the workaround!!!
WindowLayout({
	var size = 8;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	var width = 30;
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				View.new.layout_(HLayout(param.asButton).margins_(0)).fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob.fixedWidth_(width);
			}) ++ [nil],
		),
	)
})
)

(
// NOT OK
WindowLayout({
	var size = 8;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	var width = 50;
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				View.new.layout_(HLayout(param.asButton));
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob;
			}) ++ [nil],
		),
	)
})
)

(
// test with other widgets
// OK
WindowLayout({
	var size = 32;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	var width = 30;
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				View.new.layout_(HLayout(param.asButton).margins_(0)).fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asTextField.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asTextField.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asKnob.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asNumberBox.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asPopUpMenu.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asStaticText.fixedWidth_(width);
			}) ++ [nil],
		),
	)
})
)

(
// test with GridLayout widgets
// NOT OK
WindowLayout({
	var size = 32;
	var but = List.newFrom(0 ! size);
	var knob = List.newFrom(0 ! 16);
	var width = 30;
	~b = Param(but, \list, \unipolar);
	~k = Param(knob, \list, \unipolar);
	VLayout(
		HLayout (
			* ~b.collect({ arg param;
				View.new.layout_(HLayout(param.asButton).margins_(0)).fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asKnob.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~k.collect({ arg param;
				param.asTextField.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asTextField.fixedWidth_(width);
			}) ++ [nil],
		),
		GridLayout.rows (
			~b.collect({ arg param;
				param.asKnob.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asNumberBox.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asPopUpMenu.fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				View.new.layout_(HLayout(param.asStaticText).margins_(0)).fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				View.new.layout_(HLayout(param.asPopUpMenu).margins_(0)).fixedWidth_(width);
			}) ++ [nil],
		),
		HLayout (
			* ~b.collect({ arg param;
				param.asStaticText.fixedWidth_(width);
			}) ++ [nil],
		),
	)
})
)
