

(
	~load_quickpad = { arg name;
		var codepad;
		codepad = ~veco.quickpad_controller.get_codepad(Point(1,0));
		codepad.payload = { arg self;
			"my quickpad !!!!!! plop!!!!!!!".debug;
		};
		[1/8,1/4,1/2,1,  2,4,8,16].do { arg quant, y;
			codepad = ~veco.quickpad_controller.get_codepad(Point(0,y));
			codepad.payload = { arg self;
				quant.debug("setting Pdef.defaultQuant to");
				Pdef.defaultQuant = quant;
			};

		}

	};
	~load_quickpad.();
)
