
//ParamProto.init
ClipTimeline(\bla).edit
ParamViewToolBox.color_light;
(
	// try to find more clear grid drawing
~mygridx = { arg factor, x, oidx, idx;
	[factor, x, oidx, idx].debug("f, x, oi, i");

	Pen.lineDash = FloatArray[1];
	if( oidx % 16 == 0 ) { 
		Pen.alpha = 0.6;
		Pen.width = 2;
	} { 
		if(oidx % 4 == 0) {
			Pen.alpha = 0.4;
			Pen.width = 1;

		} {
			Pen.alpha = 0.4;
			Pen.width = 1;
			Pen.lineDash = FloatArray[2.0,2.0];
		}
	};


}
)
