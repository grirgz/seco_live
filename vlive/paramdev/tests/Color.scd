
(
WindowDef(\win, { arg def;
	var color, colorcomp, co, colorcursor, colorcursor2;
	color = ParamViewToolBox.color_ligth;
	colorcomp = ParamViewToolBox.color_ligth.complementary;
	co = Color.red;
	co = ParamViewToolBox.color_ligth.complementary;
	colorcursor = colorcomp.add(co, 0.95);
	colorcursor2 = colorcomp.add(co, 0.5);
	VLayout (
		StaticText.new.string_("O").background_(color),
		StaticText.new.string_("O").background_(colorcomp),
		StaticText.new.string_("O").background_(colorcursor),
		StaticText.new.string_("O").background_(colorcursor2),
	)
	
}).front;
)
